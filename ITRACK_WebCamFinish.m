function  TH_WebCamFinish(vidobj)
% TH_WebCamFinish - close video camera
% input:
%    vidobj - video object
% Usage:
%    vidobj = CB_WebCamInit;            % init
%    snapshot = getsnapshot(vidobj);
%    CB_WebCamFinish(vidobj)
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Ver   Who  Date     Changes
% --------------------------------------------------------
% 01    ud  04/05/10  Created
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Stop the acquisition.
stop(vidobj)

%TH_WebCamFinish(vidobj);


delete(vidobj)
clear vidobj



% inform
msgstr          = 'Presentation is Finished.';
h               = warndlg(msgstr);
uiwait(h)

