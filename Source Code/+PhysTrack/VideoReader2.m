function vro2Obj = VideoReader2(forceCropTrim, forceBinaryConvert, forceFPS)
%VIDEOREADER2 Gets a new video reader 2 object. In contrast to a usual
% video reader object from the image acquisition toolbox, the video reader2
% object embeds the cropping, trimming, pre-magnification and binary
% conversion information in a single object. This is necessary  to reduce
% the repetitive  process to be done to fetch every frame from the video
% file. 
%
% There are separate GUIs avaiable for each step of conversion, but
% PHYSTRACK.VIDEOREADER2 presents all these tools in sequence to allow the
% user to go through all the steps interactively. Finally, it returns a
% video reader 2 object.
%
% Trimming: In video tracking, we often use a high speed camera for
% capturing video. High speed implies that only a couple of seconds in real
% life will create hundreds of frames in the video file. So, just before
% and after the actual object motion, it becomes inevitable for the
% expreimenter to avoid the extra frames. We don't want to process those
% frames because it would impart a lot of load on the processor and more
% importantly, because in most cases, the data we need to analyze won't be
% useful if those extra frames are also included. So, in the VideoReader2,
% there are 3 variables called ifi, ofi and TotalNumberOfFrames. ifi is
% the In-Frame, at which the video actually should have started, Out-Frame
% is the last desirable frame and TotalNumberofFrames just gives the
% number of frames included in the trimmed section. So now after trimming,
% ifi will serve as the first frame of the whole video.
%
% Cropping :
% In video processing, to avoid processing extra pixels of a video frame,
% we often desire to define a region of interest. To incorporate thios
% cropping, there is a CropRect variable in the video reader 2 which
% conatins the cropping rectangle's coordinates and dimensions. So, now,
% the (1,1) pixel of a video frame is actually the top left pixel of the
% crop rectangle instead.
%
% Pre-magnification:
% Matlab imresize function not just increases the number of pixels in an
% image, it also interpolates to create new information. This process
% actually inhances the image quality artificially. To maintain a balance
% between quality and the memory requirements to handle big images, there
% is this variable PreMag, in video reader 2 objects which magnify the
% finally cropped frames.
%
% BinrayThreshold:
% To convert a grayscale to binary logical image, the practice is to define
% a gray level above or below which pixels are converted to white or black.
% Usually, the same threshoold is used for the whole video but in
% PhysTrack, we can assign different thresholds for different frames of the
% video. In this way, the system interpolates in between these KeyFrames to
% obtain another threshold. This is useful for processing those videos
% where lighting conditions don't remain the same throughout the video.
% Normally, this variable is empty but if a Nx2 array is defined, PhysTrack
% will consider (:,1) entries to be the frame numbers and (:, 2) there
% respective threshold. For interpolation, PhysTrack fits the points on
% polynomial functions of maximum possible degrees and fits the threshold
% into it.
%
%    See also PHYSTRACK.READ2, PHYSTRACK.TRIMVIDEO,
%    PHYSTRACK.CONVERTVIDEOTOBINARY

if iscell(forceCropTrim) && nargin == 1
    if length(forceCropTrim) == 3
         forceFPS = forceCropTrim{3};
    end
    if length(forceCropTrim) >= 2
         forceBinaryConvert = forceCropTrim{2};
    end
    if length(forceCropTrim) >= 1
         forceCropTrim = forceCropTrim{1};
    end
    if length(forceCropTrim) == 0
         clear forceCropTrim
    end
end
    if ~exist('forceCropTrim')
        forceCropTrim = true;
    end
    if ~exist('forceBinaryConvert')
        forceBinaryConvert = true;
    end
    [fileName, rootPath, filterIndex] = uigetfile({'*.mp4;*.avi;*.mov','Common Video File Types';'*.*','All Files'}, 'Select a video file for processing');
    fullPath = strcat(rootPath,fileName);
    if exist(fullPath, 'file') ~= 2
        vro2Obj = [];
        return;
    end
    vro = VideoReader(fullPath);
    preMag = max(1,round(1500 / vro.Height));
    if ~exist('forceFPS')
        forceFPS = round(vro.FrameRate);
    end
    fps = PhysTrack.askValue('Enter the number of frames shot per second by the camera: ', forceFPS, 'Video Frame rate', 'uint16');
    vro2Obj = struct('obj', vro, 'PreMag', preMag, 'FPS', fps, 'CropRect', [0,0, vro.Width * preMag, vro.height * preMag], 'ifi', 1, 'ofi', vro.NumberOfFrames, 'TotalFrames', vro.NumberOfFrames, 'BinaryThreshold', [], 'BinaryBackgroundIsLight', false , 'Rotation', 0, 'TrackInReverse', false);
    if (forceCropTrim)
        % In most of the cases, we would need trimming.
        %if strcmp(questdlg('Do you want to Crop and Trim the video?', '', 'Yes', 'No', 'Yes'), 'Yes')
            vro2Obj = PhysTrack.TrimVideo(vro2Obj, true);
        %end
    end
    if (forceBinaryConvert)
        if strcmp(questdlg('Do you want to convert this video to binary?', '', 'Yes', 'No', 'Yes'), 'Yes')
            vro2Obj = PhysTrack.ConvertVideoToBinary(vro2Obj);  
        end
    end
    global PreProcessingFunction
    if ~isstr(PreProcessingFunction) 
        clear PreProcessingFunction
    end
end