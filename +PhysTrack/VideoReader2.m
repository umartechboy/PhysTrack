function vro2Obj = VideoReader2()
%OPENVIDEOFILE Gets a new VRO2 from the user.
%       Presents an open file dialogure. If the dialogue is
%       successfull, returns a Video Reader 2 object.
    [fileName, rootPath, filterIndex] = uigetfile({'*.mp4;*.avi;*.mov','Common Video File Types';'*.*','All Files'}, 'Select a video file for processing');
    fullPath = strcat(rootPath,fileName);
    if exist(fullPath, 'file') ~= 2
        vro2Obj = [];
        return;
    end
    vro = VideoReader(fullPath);
    preMag = max(1,round(1500 / vro.Height));
    fps = PhysTrack.askValue('Enter the number of frames shot per second by the camera: ', round(vro.FrameRate), 'Video Frame rate', 'uint16');
    vro2Obj = struct('obj', vro, 'PreMag', preMag, 'FPS', fps, 'CropRect', [0,0, vro.Width * preMag, vro.height * preMag], 'ifi', 1, 'ofi', vro.NumberOfFrames, 'TotalFrames', vro.NumberOfFrames, 'BinaryThreshold', [], 'BinaryBackgroundIsLight', false );
    if strcmp(questdlg('Do you want to Crop and Trim the video?', '', 'Yes', 'No', 'Yes'), 'Yes')
        vro2Obj = PhysTrack.TrimVideo(vro2Obj, true);
    end
    if strcmp(questdlg('Do you want to convert this video to binary?', '', 'Yes', 'No', 'Yes'), 'Yes')
        vro2Obj = PhysTrack.ConvertVideoToBinary(vro2Obj);
    end
    global PreProcessingFunction
    if ~isstr(PreProcessingFunction) 
        clear PreProcessingFunction
    end
end

