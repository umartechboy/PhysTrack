function I = read2(vr2o, frameNumber, indIsAbsolute, forceRGB, cropPreviewOnly)
    
    if ~exist('indIsAbsolute')
        indIsAbsolute = false;
    end
    if ~exist('forceRGB')
        forceRGB = true;
        if isa(vr2o.BinaryThreshold, 'cfit') % its a binary image
            forceRGB = false;
        elseif isnumeric(vr2o.BinaryThreshold) % its a binary image
            if vr2o.BinaryThreshold > 0
            forceRGB = false;
            end
        end
    end
    if ~exist('cropPreviewOnly')
        cropPreviewOnly = false;
    end
    I = [];
    if ~indIsAbsolute
        if frameNumber + vr2o.ifi - 1 < 1 || frameNumber + vr2o.ifi - 1 > vr2o.obj.NumberOfFrames
            error 'The video file doesn''t contain the frame specified.';
        end

        if frameNumber + vr2o.ifi - 2 > vr2o.ofi || frameNumber  + vr2o.ifi - 1 < vr2o.ifi
            warning 'The requested frame is outside the trimmed bounds of the video.';
        end

        if vr2o.PreMag == 1
            if cropPreviewOnly
                I = showCropping(read(vr2o.obj, frameNumber + vr2o.ifi - 1), vr2o.CropRect);
            else
                I = imcrop(read(vr2o.obj, frameNumber + vr2o.ifi - 1), vr2o.CropRect);
            end
        elseif vr2o.PreMag > 1
            if cropPreviewOnly
                I = showCropping(imresize(read(vr2o.obj, frameNumber + vr2o.ifi - 1), vr2o.PreMag), vr2o.CropRect);
            else
                I = imcrop(imresize(read(vr2o.obj, frameNumber + vr2o.ifi - 1), vr2o.PreMag), vr2o.CropRect);
            end
        else
            error 'The video reader 2 object seems to be damaged.'
        end
        if isa(vr2o.BinaryThreshold, 'cfit') && ~forceRGB % its a binary image
            if vr2o.BinaryBackgroundIsLight
                I = rgb2gray(I) >= vr2o.BinaryThreshold(frameNumber + vr2o.ifi - 1);
            else
                I = rgb2gray(I) < vr2o.BinaryThreshold(frameNumber + vr2o.ifi - 1);
            end
        elseif isnumeric(vr2o.BinaryThreshold) && ~forceRGB
            if vr2o.BinaryThreshold > 0
                if vr2o.BinaryBackgroundIsLight
                    I = rgb2gray(I) >= vr2o.BinaryThreshold;
                else
                    I = rgb2gray(I) < vr2o.BinaryThreshold;
                end
            end
        end
    else
        if frameNumber < 1 || frameNumber > vr2o.obj.NumberOfFrames
            error 'The video file doesn''t contain the frame specified.';
        end
        if vr2o.PreMag == 1
            if cropPreviewOnly                
                I = showCropping(read(vr2o.obj, frameNumber), vr2o.CropRect);
            else
                I = imcrop(read(vr2o.obj, frameNumber), vr2o.CropRect);
            end
        elseif vr2o.PreMag > 1
            if cropPreviewOnly
                I = showCropping(imresize(read(vr2o.obj, frameNumber), vr2o.PreMag), vr2o.CropRect);
            else
                I = imcrop(imresize(read(vr2o.obj, frameNumber), vr2o.PreMag), vr2o.CropRect);
            end
        else
            error 'The video reader 2 object seems to be damaged.'
        end 
        if isa(vr2o.BinaryThreshold, 'cfit') && ~forceRGB % its a binary image
            if vr2o.BinaryBackgroundIsLight
                I = rgb2gray(PhysTrack.read2(vr,1)) >= vr2o.BinaryThreshold(frameNumber);
            else 
                I = rgb2gray(PhysTrack.read2(vr,1)) < vr2o.BinaryThreshold(frameNumber);
            end
        elseif isnumeric(vr2o.BinaryThreshold) && ~forceRGB % its a binary image
            if vr2o.BinaryThreshold > 0
                if vr2o.BinaryBackgroundIsLight
                    I = rgb2gray(PhysTrack.read2(vr,1)) >= vr2o.BinaryThreshold;
                else 
                    I = rgb2gray(PhysTrack.read2(vr,1)) < vr2o.BinaryThreshold;
                end
            end
        end
    end
    if islogical(I)
        se = strel('disk', 10);
        I = bwareaopen(imclose(I, se), 10);
    end
    if evalin('base', 'exist(''PreProcessingFunction'')')
        if evalin('base', 'isstr(PreProcessingFunction)')
            if evalin('base', 'exist(PreProcessingFunction)')
            	I = eval([PreProcessingFunction,'(I)']);
            end
        end
    end
end