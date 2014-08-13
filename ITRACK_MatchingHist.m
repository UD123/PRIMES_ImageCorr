function [Par,MatchProb] = ITRACK_MatchingHist(Par,HistObj1,HistObj2,FigNum)
%ITRACK_MatchingHist  - performs histogram matching to determine the
% best matching
%
% Input parameters :
%  Par          - Structure with different params
%  Loc          - N x 2 set of points position in 2D of image
%  HistObj1     - object with histograms of features and backward indexes  - im 1
%  HistObj2     - object with histograms of features and backward indexes  - im 2

% Output parameters :
%  Par          - Structure with different params
%  MatchProb    - N x M probability matching matrix

%-----------------------------------------------------
% Ver  Date        Who   What
%-----------------------------------------------------
% 0600  04.08.13    UD   New 2D hist. Features are independent
% 0400  30.03.13    UD   Matching based on Boosting idea
% 0300  14.03.13    UD   Weighting and New features addition
% 0100  20.02.13    UD   created
%-----------------------------------------------------



% prepare outputs
Par.MsgId               = 0;
Par.MsgTxt              = ' ';

% debug
if nargin < 4, FigNum   = 0; end;

fprintf('I : Hist matching started with %d repeats ...',Par.RepeatNum); tic;

%%%%%%%%%%%%%%
% Params
%%%%%%%%%%%%%%
RepeatNum           = Par.RepeatNum;    % number of pints in the same bin for search
%MaMatchNumThr       = (Par.HistLen);  % max number of points that fall into the same bin
MinBinProb          = (1/Par.HistLen)^2; % sanity check threshold - all the points in the same bin
%MinBinProb          = 1/Par.HistLen;    % designates probability that point does not belong to any bin 


%MaxMatchPoints      = Par.MaxMatchPoints;  % number of pints in the same bin for search
nPoints1            = size(HistObj1{1}.neighbInd,1);
nPoints2            = size(HistObj2{1}.neighbInd,1);
featNum             = length(HistObj1);
if featNum ~=  length(HistObj2),
    Par.MsgId               = 3;
    Par.MsgTxt              = 'Histograms do not have the same number of features ';
end;


% init score matrix - probability
matchMtrx           = ones(nPoints1,nPoints2)./nPoints1./nPoints2;
matchSize           = [nPoints1 nPoints2];
%matchMtrxTmp        = matchMtrx;


% % create info sharing matrices
% neighbInd           = HistObj1{1}.neighbInd';
% 
% fillOneInd          = [neighbInd(:,[1 2]);neighbInd(:,[1 3])];  % non symmetric matrix
% mtrxInd             = sub2ind([nPoints1,nPoints1],fillOneInd(:,2), fillOneInd(:,1));
% infoShareMtrx1      = zeros(nPoints1);
% infoShareMtrx1(mtrxInd) = (1-Alpha)/2;  % duplicates have the same value
% infoShareMtrx1      = infoShareMtrx1 + eye(nPoints1)*Alpha;
% 
% 
% neighbInd           = HistObj2{1}.neighbInd';
% fillOneInd          = [neighbInd(:,[1 2]);neighbInd(:,[1 3])];  % non symmetric matrix
% mtrxInd             = sub2ind([nPoints2,nPoints2],fillOneInd(:,2), fillOneInd(:,1));
% infoShareMtrx2      = zeros(nPoints2);
% infoShareMtrx2(mtrxInd) = (1-Alpha)/2;  % duplicates have the same value
% infoShareMtrx2      = infoShareMtrx2 + eye(nPoints2)*Alpha;



%%%%%%%%%%%%%%
% Matching
%%%%%%%%%%%%%%
% repeatting the process should make reprojection
% for debug
matchMtrxSave       = repmat(matchMtrx,[1,1,RepeatNum*featNum]);

for iter = 1:RepeatNum,
    
    % replicate the match matrix for both features
    matchMtrxFeat       = repmat(matchMtrx,[1,1,featNum]);
    
    % find minimal number of matches on distance
    for featInd = 1:featNum,
        
        % each feature works with its own matrix
        matchMtrx           = matchMtrxFeat(:,:,featInd);
        
        % take the probs
        %[sortProb,sortInd]  = sort(HistObj1{featInd}.prob .* HistObj2{featInd}.prob,'descend');
        
        % be sure to work with valid indeces
        %validInd            = find(sortProb > 0 .* HistObj1{featInd}.hist(sortInd) > 0 & HistObj2{featInd}.hist(sortInd) > 0);
        %validInd            = find(sortProb > MinBinProb);
        %binNum              = HistObj1{featInd}.hist + HistObj2{featInd}.hist;
        histProduct          = HistObj1{featInd}.hist .* HistObj2{featInd}.hist;
        validInd             = find(histProduct > 0);
        
        % start from singles
        [sV,sI]             = sort(histProduct(validInd),'ascend');
        validInd            = validInd(sI);
       
        % run over all bins
        for m = 1:numel(validInd),
            
            % get the points that match in the bin
            binInd          = validInd(m);
            
            % analyze the numbers if too big - quit
            pointInd1       = find(HistObj1{featInd}.indx == binInd);
%            pointNum1       = numel(pointInd1);
            pointInd2       = find(HistObj2{featInd}.indx == binInd);
%            pointNum2       = numel(pointInd2);
            
            % big numbers don't bother
            %if (pointNum1 + pointNum2) > MaMatchNumThr, continue; end;
            
%             % punish points that are associated to empty bins
%             if pointNum1 < 1, pointInd1 = (1:nPoints1); end;
%             if pointNum2 < 1, pointInd2 = (1:nPoints2); end;
            
            % take all the pairs
            [pointIndMesh1,pointIndMesh2] = meshgrid(pointInd1,pointInd2);
            
            % sum all the match probabilies that are in the same bin
            mtrxInd         = sub2ind(matchSize,pointIndMesh1(:),pointIndMesh2(:));
            matchSum        = sum(matchMtrx(mtrxInd)) + MinBinProb;
            
            % normalize each entry according to the sum
            matchMtrx(mtrxInd) = matchMtrx(mtrxInd)./matchSum;
            
            % normalize by mean
            %matchMtrx(mtrxInd) = matchMtrx(mtrxInd)./matchSum*(pointNum1*pointNum2);
            %matchMtrx(mtrxInd) = matchMtrx(mtrxInd)./matchSum;
            
            
        end;
        
        % relax probabilities
        infoShareMtrx1          = HistObj1{featInd}.infoMtrx;
        infoShareMtrx2          = HistObj2{featInd}.infoMtrx;
        matchMtrx               = infoShareMtrx1 * matchMtrx * infoShareMtrx2';
        
        
        % save
        matchMtrxFeat(:,:,featInd) = matchMtrx;
        
        
%         % normalize matrix
%         normValC                = (MinBinProb + sum(matchMtrx));
%         matchMtrx               = matchMtrx*diag(1./normValC);
%         normValR                = (MinBinProb + sum(matchMtrx,2));
%         matchMtrx               = diag(1./normValR)*matchMtrx;
        
        
        % save
        matchMtrxSave(:,:,(iter-1)*featNum + featInd) = matchMtrx;
        
        
%         % get max probabilities
%         [maxProb1,maxInd1]      = max(matchMtrx,[],2);
%         [maxProb2,maxInd2]      = max(matchMtrx,[],1);
%         
%         % share success and failures with participating nodes
%         maxProb1                = infoShareMtrx1 * maxProb1(:);
%         maxProb2                = infoShareMtrx2 * maxProb2(:);
        
        
    end; % feat
    
    % recover match matrix - best result from each feature
    %matchMtrx       = max(matchMtrxFeat,[],3);
    matchMtrx       = sum(matchMtrxFeat,3);
    
end; % repeat

% output
MatchProb = matchMtrx;

fprintf('Done in %4.3f sec\n', toc); 


if FigNum < 1, return; end;


% show
figure(FigNum)
imagesc(matchMtrx),colorbar, axis xy
xlabel('    Set 2'),ylabel('Set 1')
title('Matching Matrix after All iterations')
impixelinfo

% addpath C:\Uri\Code\Matlab\Utilities\Visualization3D\orthogonalslicer;
% %figure,
% orthogonalslicer(matchMtrxSave)

close(findobj('Name','Slice Viewer'))
SliceBrowser(matchMtrxSave)
return





