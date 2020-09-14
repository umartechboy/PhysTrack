function VideoDecoder(vroOrFileName, saveName)
% This function simply converts a compressed video to raw AVI. When using a
% compressed video, the whole process is slowed down because of the way
% video reading functino works. To fetch any frame N in a video sequence,
% the video reader function has to convert all the preceding frames first
% because in a compressed video, no frame is independent  of its previous
% frames. This is resolved by converting the whole video into raw AVI which
% stores a BitmapImage for every frame, independent  of the history. This
% could have been done on the RAM but for bigger vidfeo, the memory
% requirements are so enormous that its better to wait for the video
% conversion than to fill the whole RAM space with giant Bitmap data
% arrays.
%
%    Example
%    PhysTrack.VideoDecoder;
%    Presents a file selection and save dialogue to decide the source and
%    destination files and converts the video to RAW while showing the
%    progress in a waitbar.

% its a vro   
    if nargin >= 1
        useVro = isstruct(vroOrFileName);
    else
        useVro =  strcmp(questdlg('Do you want to be able to trim and crop the video? Note that this may slow down the conversion process', '', 'Yes', 'No', 'No'), 'Yes');
    end

    if nargin < 1
        if useVro        
            vroOrFileName = PhysTrack.VideoReader2();
        else 
             [fileName, pathname] = uigetfile({ ...
                '*.avi', 'Uncompressed AVI (*.avi)';...
                '*.*', 'All Files';...
                },'Select a source video file');
                vroOrFileName = [pathname, fileName];
        end
    end
    makeSequence =  strcmp(questdlg('Do you want create an image sequence instead of a video file??', '', 'Yes', 'No', 'No'), 'Yes');
    ext = [];
    if nargin <= 1
        if (makeSequence)            
            [saveName, pathname] = uiputfile({ ...
            '*.jpg;*.bmp;*.png', 'Common Image File Types (*.jpg,*.bmp,*.png)';...
            '*.*', 'All Files';...
            },'Select an output seed file name.');
            [~,fileName, ext] = fileparts(saveName); 
            saveName = [pathname, fileName];
        else
            [saveName, pathname] = uiputfile({ ...
            '*.avi', 'Uncompressed AVI (*.avi)';...
            '*.*', 'All Files';...
            },'Select a destination for saving the decompressed video');
            [~,fileName, ext] = fileparts(saveName); 
            saveName = [pathname, fileName];
        end
    end
    skippedValue = double(round(PhysTrack.askValue('Kindly enter the number of frames to be skipped after every decoded frame.', 0.0))) + 1;
    if  ~useVro
        vro = VideoReader(vroOrFileName);
        newFPS = double(round(PhysTrack.askValue('What should be the frame rate of the decoded vide while playing.', vro.FrameRate/skippedValue)));
        vfr = vision.VideoFileReader(vroOrFileName);
        vwo = PhysTrack.VideoWriter2(saveName, ext, makeSequence);
        vwo.FrameRate = newFPS;
        PhysTrack.videoWriterOpen2(vwo);
        h = waitbar(0, '');        
        for ii = 1:vro.NumberOfFrames
            I = step(vfr);
            if rem(ii, skippedValue) == 0
                PhysTrack.writeVideo2(vwo, I);
            end
            waitbar(double(ii) / double(vro.NumberOfFrames), h, ...
                ['Converted frame ',num2str(ii), ' of ', num2str(vro.NumberOfFrames), ', (',num2str(round(ii / double(vro.NumberOfFrames) * double(100))), '%)']);
        end
        close(h);
    else
        newFPS = double(round(PhysTrack.askValue('What should be the frame rate of the decoded vide while playing.', vroOrFileName.FPS/skippedValue)));
        vwo = PhysTrack.VideoWriter2(saveName, ext, makeSequence);
        vwo.FrameRate = newFPS;
        PhysTrack.videoWriterOpen2(vwo);
        h = waitbar(0, '');
        for ii = 1:skippedValue:vroOrFileName.TotalFrames
            vwo = PhysTrack.writeVideo2(vwo, PhysTrack.read2(vroOrFileName, ii));
            waitbar(double(ii) / double(vroOrFileName.TotalFrames), h, ...
                ['Converted frame ',num2str(ii), ' of ', num2str(vroOrFileName.TotalFrames), ', (',num2str(round(double(ii) / double(vroOrFileName.TotalFrames) * double(100))), '%)']);
        end
        close(h);
    end
end

