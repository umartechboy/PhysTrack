[fileName, rootPath, filterIndex] = uigetfile({'*.mp4;*.avi;*.mov','Common Video File Types';'*.*','All Files'}, 'Select a video file for image processing');
fullPath = strcat(rootPath,fileName);
global vro fps
vro = VideoReader(fullPath);
vFrames = vro.NumberofFrames - 1;
preMag = max(1,round(1000 / vro.Height));
fps = PhysTrack.askValue('Enter the number of frames shot per second by the camera: ', 240, 'Video Frame rate');
h = MotionTrackerSetup;
uiwait(h)
close all;
clear('playingNow', 'fileName', 'filterIndex', 'fullPath','h', 'rootPath', 'vFrames', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx','kdy','num_lines','options','prompt');