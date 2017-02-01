function VideoDecompressor(fileName, saveName)
    % this function simply converts a compressed video to raw AVI.

    if nargin == 0
    [fileName, pathname] = uigetfile({ ...
        '*.mp4;*.mov;*.mpg;*.avi', 'Common Video File Types (*.mp4,*.mov,*.mpg,*.avi)';...
        '*.*', 'All Files';...
        },'Select a video file for conversion.');
        fileName = [pathname, fileName];
    end
    if nargin < 2
        [saveName, pathname] = uiputfile({ ...
        '*.avi', 'Uncompressed AVI (*.avi)';...
        '*.*', 'All Files';...
        },'Select a destination for saving the decompressed video');
        saveName = [pathname, saveName];
    end
    vro = VideoReader(fileName);
    vfr = vision.VideoFileReader(fileName);
    vwo = VideoWriter(saveName);
    vwo.FrameRate = vro.FrameRate;
    open(vwo);
    h = waitbar(0, '');
    for ii = 1:vro.NumberOfFrames
        writeVideo(vwo, step(vfr));
        waitbar(ii / double(vro.NumberOfFrames), h, ...
            ['Converted frame ',num2str(ii), ' of ', num2str(vro.NumberOfFrames), ', (',num2str(round(ii / double(vro.NumberOfFrames) * 100)), '%)']);
    end
    close(h);
end

