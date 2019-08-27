function I = read2(vro, frameNumber, indIsAbsolute, forceRGB, cropPreviewOnly, reverseReading)

% READ2 This function has mnay working modes and depending upon the kind
% and types of arguments, can give differnet result. Basically, it is used
% to read an image frame from a PHYSTRACK.VIDEOREADER2 object. It will use 
% the trimming, cropping, rescaling and binary conversion information
% embedded in the video reader object and return a final frame after all
% operations. If a pre-processing function is assigned, it will then apply
% that function on the final frame and return the image.
%
% Some sample usage schemes are:
%    PhysTrack.read2(vro, 1) returns the first frame of the video reader after
%    performing all operations. It will return a binary image if the video
%    reader contains binary conversion data.
% 
%    PhysTrack.read2(vro, 1, 1) returns the first image of the video sequence
%    regardless of the trimming ifformation.
%
%    PhysTrack.read2(vro, 1, false, true) returns the first frame of the trimmed
%    video in RGB, regardless of the binary conversion data which may be
%    embedded in the video reader object.
%
%    The fourth argument, cropPreviewOnly isn't used in usual scenarios. It
%    is built to be used in the video reader 2 GUI tool only.
%
%    See also PHYSTRACK.VIDEOREADER2, PHYSTRACK.SETPREPROCESSINGFUNCTION,
%    PHYSTRACK.CONVERTVIDEOTOBINARY
    if ~exist('indIsAbsolute')
        indIsAbsolute = false;
    end
    if ~exist('forceRGB')
        forceRGB = true;
        if isa(vro.BinaryThreshold, 'cfit') % its a binary image
            forceRGB = false;
        elseif isnumeric(vro.BinaryThreshold) % its a binary image
            if vro.BinaryThreshold > 0
            forceRGB = false;
            end
        end
    end
    if ~exist('cropPreviewOnly')
        cropPreviewOnly = false;
    end
    if ~exist('reverseReading')
        reverseReading = false;
    end
    I = [];
    if ~indIsAbsolute
        if reverseReading
            frameNumber = vro.TotalFrames - frameNumber + 1;
        end
        if frameNumber + vro.ifi - 1 < 1 || frameNumber + vro.ifi - 1 > vro.obj.NumberOfFrames
            error 'The video file doesn''t contain the frame specified.';
        end

        if frameNumber + vro.ifi - 2 > vro.ofi || frameNumber  + vro.ifi - 1 < vro.ifi
            warning 'The requested frame is outside the trimmed bounds of the video.';
        end
        I = read(vro.obj, frameNumber + vro.ifi - 1);
        if vro.Rotation ~= 0
            I = imrotate(I, vro.Rotation);
        end
        if vro.PreMag == 1
            if cropPreviewOnly
                I = showCropping(I, vro.CropRect);
            else
                I = imcrop(I, vro.CropRect);
            end
        elseif vro.PreMag > 1
            if cropPreviewOnly
                I = showCropping(imresize(I, vro.PreMag), vro.CropRect);
            else
                I = imcrop(imresize(I, vro.PreMag), vro.CropRect);
            end
        else
            error 'The video reader 2 object seems to be damaged.'
        end
        if isa(vro.BinaryThreshold, 'cfit') && ~forceRGB % its a binary image
            if vro.BinaryBackgroundIsLight
                I = rgb2gray(I) >= vro.BinaryThreshold(frameNumber + vro.ifi - 1);
            else
                I = rgb2gray(I) < vro.BinaryThreshold(frameNumber + vro.ifi - 1);
            end
        elseif isnumeric(vro.BinaryThreshold) && ~forceRGB
            if vro.BinaryThreshold > 0
                if vro.BinaryBackgroundIsLight
                    I = rgb2gray(I) >= vro.BinaryThreshold;
                else
                    I = rgb2gray(I) < vro.BinaryThreshold;
                end
            end
        end
    else        
        if reverseReading
            frameNumber = vro.obj.NumberOfFrames - frameNumber + 1;
        end
        if frameNumber < 1 || frameNumber > vro.obj.NumberOfFrames
            error 'The video file doesn''t contain the frame specified.';
        end
        if vro.PreMag == 1
            I = read(vro.obj, frameNumber);
            if vro.Rotation ~= 0
                I = imrotate(I, vro.Rotation);
            end
            if cropPreviewOnly                
                I = showCropping(I, vro.CropRect);
            else
                I = imcrop(I, vro.CropRect);
            end
        elseif vro.PreMag > 1
            
            I = read(vro.obj, frameNumber);
            if vro.Rotation ~= 0
                I = imrotate(I, vro.Rotation);
            end
            
            if cropPreviewOnly
                I = showCropping(imresize(I, vro.PreMag), vro.CropRect);
            else
                I = imcrop(imresize(I, vro.PreMag), vro.CropRect);
            end
        else
            error 'The video reader 2 object seems to be damaged.'
        end 
        if isa(vro.BinaryThreshold, 'cfit') && ~forceRGB % its a binary image
            if vro.BinaryBackgroundIsLight
                I = rgb2gray(PhysTrack.read2(vr,1)) >= vro.BinaryThreshold(frameNumber);
            else 
                I = rgb2gray(PhysTrack.read2(vr,1)) < vro.BinaryThreshold(frameNumber);
            end
        elseif isnumeric(vro.BinaryThreshold) && ~forceRGB % its a binary image
            if vro.BinaryThreshold > 0
                if vro.BinaryBackgroundIsLight
                    I = rgb2gray(PhysTrack.read2(vr,1)) >= vro.BinaryThreshold;
                else 
                    I = rgb2gray(PhysTrack.read2(vr,1)) < vro.BinaryThreshold;
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