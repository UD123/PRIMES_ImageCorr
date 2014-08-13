function TEST_ImageCrossProbing(hFig1,hFig2, Loc1,Loc2, MatchMtrx)
% TEST_ImageCrossProbing  - probing between matching pointsa
% on a figure
% Inputs:
%   hFig1       - scatter plot
%   UserData    - cell stracture with valid traces
%-----------------------------
% Ver	Date	 Who	Descr
%-----------------------------
% 07.00 18.06.14 UD     improve marking
% 06.00 04.08.13 UD     Two images side by side
% 04.00 15.04.13 UD     Coloring the highest value pixels
% 03.00 06.03.13 UD     Created to explore matching between figures
% 02.05 24.10.12 UD     Scaling the space according to coordinates
% 01.07 06.10.12 UD     Adding different statistics info
% 01.00 04.10.12 UD     Created from JN2

if nargin < 5, error('Must have 4 arguments'); end;

% check
[n1,m1] = size(Loc1);
[n2,m2] = size(Loc2);
[nn1,nn2] = size(MatchMtrx);
detectThr   = 0.75;
showMaxNum  = 5;  % show the best matches

if m1 ~= 2,      error('Loc1 must be 2 x N matrix'); end;
if m2 ~= 2,      error('Loc2 must be 2 x N matrix'); end;
if n1 ~= nn1,    error('Loc1 and MatchMtrx are not compatible'); end;
if n2 ~= nn2,    error('Loc2 and MatchMtrx are not compatible'); end;

showMaxNum      = min(showMaxNum,min(nn1,nn2));
myCmap          = hot(showMaxNum);

% find matches
[i1,i2]         = find(MatchMtrx > detectThr);


% Init scatter figure
figure(hFig1)
set(hFig1,'WindowButtonDownFcn',@hFig1_wbdcb)
%set(hFig1,'WindowButtonMotionFcn',@hFig1_wbdcb)
set(gca,'DrawMode','fast');
% get plot 
% [sv,si]         = max(MatchMtrx);
% [svs,sis]       = sort(sv,'descend');
% si              = si(sis(1:showMaxNum));
hold on;
plot(Loc1(i1,1),Loc1(i1,2),'.m','MarkerSize',12);
hold off;

% Init plot figure only we have a callback
figure(hFig2)
set(hFig2,'WindowButtonDownFcn',@hFig2_wbdcb)
%set(hFig2,'WindowButtonMotionFcn',@hFig2_wbdcb)
set(gca,'DrawMode','fast');

%MatchMtrx       = diag(1./(eps+sum(MatchMtrx,2)))*MatchMtrx;
% [sv,si]         = max(MatchMtrx');
% [svs,sis]       = sort(sv,'descend');
% si              = si(sis(1:showMaxNum));
hold on;
plot(Loc2(i2,1),Loc2(i2,2),'.m','MarkerSize',12);
hold off;




    %%%%%%%%%%%%%%
    % hFig1 - Callbacks
    %%%%%%%%%%%%%%
    function hFig1_wbdcb(src,evnt)
        
        if strcmp(get(src,'SelectionType'),'normal')
            
                        
            
            %%%%%
            % Select point on image 1
            %%%%%
            
             % return attention to figure 1
            figure(hFig1), 
            %set(src,'pointer','circle')
            cp      = get(gca,'CurrentPoint');
            xinit   = cp(1,1);
            %xinit   = round(xinit) + [1 1]*0;
            XLim    = get(gca,'XLim');        
            % check the point location
            if xinit(1) < XLim(1) || XLim(2) < xinit(1) , return; end;
            
            %yinit = [yinit yinit];
            yinit = cp(1,2);
            %yinit = round(yinit) + [1 1]*0;
            YLim = get(gca,'YLim');         
            if yinit(1) < YLim(1) || YLim(2) < yinit(1) , return; end;
            
            figure(hFig1),
            hold on;
            hcross      = plot(xinit,yinit,'sr','MarkerSize',16);
            hcross_old  = getappdata(hFig1,'hcross');
            if ~isempty(hcross_old),
                if ishandle(hcross_old),
                    delete(hcross_old); % delete previous cross
                end;
            end;
            setappdata(hFig1,'hcross',hcross);% store new
            hold off;
            
            % figure 2 delete
            hselect_old  = getappdata(hFig2,'hselect');
            if ~isempty(hselect_old),
                if ishandle(hselect_old),
                    delete(hselect_old); % delete previous cross
                end;
            end;
            
            
            % get data from the figure
            spreadX         = diff(XLim)^2;
            spreadY         = diff(YLim)^2;
            minDist         = 1;      % for selection       
            initDist        = sqrt((Loc1(:,1) - xinit).^2./spreadX + (Loc1(:,2) - yinit).^2./spreadY);
            [minV,minInd]   = min(initDist);
            
            % the point is too far
            if minV > minDist,
                title('No closest point selected','color','r')
                return;
            else
                title(['Selected point is : ',num2str(minInd)],'color','k')
                
            end;
            
            % matching point list
            matchInd        = find(MatchMtrx(minInd,:) > detectThr);
            
            
            %%%%%
            % show selected
            %%%%%
            figure(hFig2),             % open figure         
            if isempty(matchInd),
                title('No match found','color','r')
                return;
            end;
            
            
            hold on;
            hselect      = plot(Loc2(matchInd,1),Loc2(matchInd,2),'sr','MarkerSize',16);
            setappdata(hFig2,'hselect',hselect);% store new
            hold off;
            
            title(['Matches are : ',num2str(matchInd(:)')],'color','k')
            
            
            % return attention to figure 1
            figure(hFig1), 
          
        
        end
    end


    %%%%%%%%%%%%%%
    % hFig2 - Callbacks
    %%%%%%%%%%%%%%
    function hFig2_wbdcb(src,evnt)
        
        if strcmp(get(src,'SelectionType'),'normal')
            
                        
            
            %%%%%
            % Select point on image 1
            %%%%%
            
             % return attention to figure 1
            figure(hFig2), 
            %set(src,'pointer','circle')
            cp      = get(gca,'CurrentPoint');
            xinit   = cp(1,1);
            %xinit   = round(xinit) + [1 1]*0;
            XLim    = get(gca,'XLim');        
            % check the point location
            if xinit(1) < XLim(1) || XLim(2) < xinit(1) , return; end;
            
            %yinit = [yinit yinit];
            yinit = cp(1,2);
            %yinit = round(yinit) + [1 1]*0;
            YLim = get(gca,'YLim');         
            if yinit(1) < YLim(1) || YLim(2) < yinit(1) , return; end;
            
            figure(hFig2),
            hold on;
            hcross      = plot(xinit,yinit,'dm','MarkerSize',16);
            hcross_old  = getappdata(hFig2,'hcross');
            if ~isempty(hcross_old),
                if ishandle(hcross_old),
                    delete(hcross_old); % delete previous cross
                end;
            end;
            setappdata(hFig2,'hcross',hcross);% store new
            hold off;
            
            % delete previous cross of Fig 1
            hselect_old  = getappdata(hFig1,'hselect');
            if ~isempty(hselect_old),
                if ishandle(hselect_old),
                    delete(hselect_old); % delete previous cross
                end;
            end;
            
            
            % get data from the figure
            spreadX         = diff(XLim)^2;
            spreadY         = diff(YLim)^2;
            minDist         = 1;      % for selection       
            initDist        = sqrt((Loc2(:,1) - xinit).^2./spreadX + (Loc2(:,2) - yinit).^2./spreadY);
            [minV,minInd]   = min(initDist);
            
            % the point is too far
            if minV > minDist,
                title('No closest point selected','color','r')
                return;
            else
                title(['Selected point is : ',num2str(minInd)],'color','k')
                
            end;
            
            % matching point list
            matchInd        = find(MatchMtrx(:,minInd) > detectThr);
            
            
            %%%%%
            % show selected
            %%%%%
            figure(hFig1),             % open figure 
            if isempty(matchInd),
                title('No match found','color','r')
                return;
            end;
            
            hold on;
            hselect      = plot(Loc1(matchInd,1),Loc1(matchInd,2),'dm','MarkerSize',16);
            setappdata(hFig1,'hselect',hselect);% store new
            hold off;
            
            title(['Matches are : ',num2str(matchInd(:)')],'color','k')
            
            
            % return attention to figure 1
            figure(hFig2), 
          
        
        end
    end
        
        

end
%return;