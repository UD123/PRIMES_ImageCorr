function DataObj = WEBCAM_ManageData(DataObj,Cmnd,Data,FigNum)
% WEBCAM_ManageData
% manages IMU data storage and reading from Disk

% Usage example:
% 1. Test data read/write and saving
% WEBCAM_ManageData([],'test1',200,0)

%-----------------------------------------------------
% Ver       Date        Who     What
%-----------------------------------------------------
% 0500      07.08.13    UD      created.
% 0402      13.05.13    UD      new interface with Dll. Multiple packet support.
% 0400      09.05.13    UD      intetgrating new Device data management
%-----------------------------------------------------

%%%%
% Parse Inputs
%%%%
if nargin < 1,          DataObj = [] ;      end;
if nargin < 2,          Cmnd = 'init' ;     end;
if nargin < 3,          Data = 0 ;          end;
if nargin < 4,          FigNum = 0 ;        end;

%if isempty(DataObj),    Cmnd = 'init' ;     end;

%%%%
% Params
%%%%
%FigNum                  = 1; % which figure to show


%%%%
% Commands
%%%%
switch Cmnd,
    case 'init',
        
        %%%%
        % Params
        %%%%
        DevId                 = Data;
        % assumes that we are calling this file from the top
        % check existence
        out = imaqfind;
        if ~isempty(out), 
            %delete(out); 
            vidobj = out;
            stop(vidobj);

        %    return;
        end;


        % check number of cameras
        vidobj             = imaqfind; %('Type', 'videoinput');
        if ~isempty(vidobj),
            %DevId = length(out);
            stop(vidobj);
            %delete(vidobj)
        end;


        % Access an image acquisition device.
        % Device Properties.
        switch DevId,
            case 1,
                % LifeCam
                adaptorName     = 'winvideo';
                deviceID        = DevId;
                %vidFormat       = 'RGB24_640x480';
                vidFormat       = 'RGB24_320x240';
            case 2,
                % MISUMI
                adaptorName     = 'winvideo';
                deviceID        = 2;
                vidFormat       = 'YUY2_640x480';
            otherwise
                error('Unsupported webcam type')
        end;

        vidobj          = videoinput(adaptorName, deviceID,  vidFormat);
        vidobj.ReturnedColorspace = 'rgb';
        %vidobj          = videoinput(out{DevId});

        % Open the preview window.
        %preview(vidobj)
        %snapshot        = getsnapshot(vidobj);

        % Display the frame in a figure window.
        %srgb            = ycbcr2rgb(snapshot);
        %imagesc(srgb)

        % Configure the object for manual trigger mode.
        %triggerconfig(vidobj, 'manual');
        %set(vidobj, 'FramesPerTrigger', inf)
        set(vidobj, 'FramesPerTrigger', 1);
        set(vidobj, 'TriggerRepeat', Inf);
        triggerconfig(vidobj,'manual')


        start(vidobj);
        trigger(vidobj);

        
        
        %%%%
        % Save 
        %%%%
        DataObj.srcType         = DevId;
        DataObj.vidobj          = vidobj;
        DataObj.imgData         = [];             
        
        
    case 'read', % read data from record
        
        DataObj.imgData        = getdata(DataObj.vidobj);

        % for the next time
        trigger(DataObj.vidobj)


    case 'close',
        
        vidobj  = DataObj.vidobj;
        
        % Stop the acquisition.
        stop(vidobj)

        %TH_WebCamFinish(vidobj);
        closepreview(vidobj);

        %delete(vidobj)
        clear vidobj;
        DataObj = [];


        % inform
        %msgstr          = 'Presentation is Finished.';
        % h               = warndlg(msgstr);
        % uiwait(h)
        %fprintf('%s\n',msgstr)        
        


    case 'test1', % testing storage to certain location
        % Sequence : 
        % 1. Init
        % 2. Write Data
        % 3. Save
        
        
        srcType         = Data;
        DataObj         = WEBCAM_ManageData(DataObj,'init',srcType,0);
        DataObj         = WEBCAM_ManageData(DataObj,'read',[],0);
        DataObj         = WEBCAM_ManageData(DataObj,'read',[],0);        
        DataObj         = WEBCAM_ManageData(DataObj,'close',srcType,0);


        
        
    otherwise
        error('Unknwon Cmnd ')
end;




if FigNum < 1, return; end;

%%%%
% Show
%%%%



return;
