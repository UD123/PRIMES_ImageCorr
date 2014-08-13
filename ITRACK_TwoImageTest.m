%function ITRACK_TwoImageTest(Im)
% This m-file test matching algorithm for 2 images only
% using Prime Sense random pattern

%-----------------------------------------------------
% Ver   Date        Who  What
%-----------------------------------------------------
% 0700  18.06.14    UD   Adding different feature number 
% 0500  01.08.13    UD   Matching using 3 points and back projection 
% 0400  30.03.13    UD   Matching using boosting ideas
% 0300  14.03.13    UD   Weighting and New features addition
% 0200  25.02.13    UD   Test patterns only
% 0100  18.02.13    UD   Prime Sense Random pattern test
%-----------------------------------------------------

% addpath '..\Src\';
% addpath '..\..\vlg';  % connect to vl tool
% 

%%%%%%%%%%%%%%
% Test Params
%%%%%%%%%%%%%%
Par.TestType            = 69;        % image type to load
Par.DetectType          = 3;        % corner detector 1 - test images, 2 - harris corner
Par.FeatNum             = 3;        % defines how many histogram to use with different features
Par.HistLen             = 32;       % defines histogram resolution
Par.Alpha               = 0.95;      % information sharing rate
Par.RepeatNum           = 3;        % how many times to repeat the process
FigNum                  = 1;        % show figure


% interesting case explore
if 1,
    defaultStream       = RandStream.getGlobalStream; % Matlab 2011 RandStream.getDefaultStream; 
    savedState          = defaultStream.State;
else
    defaultStream.State = savedState;
end;

%%%%%%%%%%%%%%
% Load Images
%%%%%%%%%%%%%%
[Im1,Im2]           = ITRACK_TwoImageLoad(Par.TestType, 0);


%%%%%%%%%%%%%%
% Find Points
%%%%%%%%%%%%%%
% analysis
Par.Set             = 1;
[Par,Loc1]          = ITRACK_FindPoints(Par,Im1, FigNum);    ax(1) = gca;
Par.Set             = 2;
[Par,Loc2]          = ITRACK_FindPoints(Par,Im2, FigNum);  ax(2) = gca;
linkaxes(ax)

%%%%%%%%%%%%%%
% Hashing and Distances and Angles
%%%%%%%%%%%%%%
Par.Set             = 1;
showFigNum          = 0; %FigNum + 4;
[Par,HistObj1]      = ITRACK_ProjectHist(Par,Loc1,showFigNum);
Par.Set             = 2;
[Par,HistObj2]      = ITRACK_ProjectHist(Par,Loc2,showFigNum);



%%%%%%%%%%%%%%
% Matching
%%%%%%%%%%%%%%
%Par.MaxMatchPoints  = MaxMatchPoints;
[Par,MatchProb]     = ITRACK_MatchingHist(Par,HistObj1,HistObj2,FigNum+9);

% install matching 
hFig1 = FigNum+1; hFig2 = FigNum+2;
TEST_ImageCrossProbing(hFig1,hFig2, Loc1,Loc2, MatchProb)



return

% init score matrix
