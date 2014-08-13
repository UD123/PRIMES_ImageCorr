function vidobj = TH_WebCamInit(DevId)
% TH_WebCamInit - init video camera
% Input:
%    DevId - in case of multiple cameras - camera id
% Output:
%    vidobj - video object
% Usage:
%    vidobj = CB_WebCamInit;            % init
%    snapshot = getsnapshot(vidobj);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ver   Who  Date     Changes
% --------------------------------------------------------
% 01    ud  04/05/10  Created
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% check existence
out = imaqfind;
if ~isempty(out), 
    %delete(out); 
    vidobj = out;
    stop(vidobj);
    
%    return;
end;

if nargin < 1, DevId = 1; end;

% check number of cameras
vidobj             = imaqfind; %('Type', 'videoinput');
if ~isempty(vidobj),
    %DevId = length(out);
    stop(vidobj);
    %delete(vidobj)
end;


% Access an image acquisition device.
% Device Properties.
adaptorName     = 'winvideo';
deviceID        = DevId;
vidFormat       = 'RGB24_320x240';
%vidFormat       = 'RGB24_640x480';
% deviceID        = 1;
%vidFormat       = 'YUY2_320x240';
vidobj          = videoinput(adaptorName, deviceID,  vidFormat);
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



return;

%%%%%%%%%%%%%%%%%%%%%
% version 1

% Initiate the acquisition.
start(vidobj)

% Notice the number of frames in memory.
numAvail    = vidobj.FramesAvailable

% View the total number of frames that were logged before stopping.
numAcquired = get(vidobj, 'FramesAcquired')

% Retrieve all logged data.
imageData = getdata(vidobj, numAcquired);

% Display one of the logged frames.
for k =1:numAcquired,
    figure(1),imagesc(imageData(:,:,:,k)),title(num2str(k)),drawnow;
end;

% Stop the acquisition.
stop(vidobj)

delete(vidobj)
clear vidobj