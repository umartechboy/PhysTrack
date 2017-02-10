function I = AdjustBrightnessContrast(I, contrast, brightness)
% ADJUSTBRIGHTNESSCONTRAST Adjusts brightness and contrast of an image. Correction factors' domain is [-1,+1]
%    AdjustBrightnessContrast(I, 0, 0), AdjustBrightnessContrast(I) returns the original image
%    AdjustBrightnessContrast(I, 1, 1) returns an image with maximum contrast
%    and brightness
%    AdjustBrightnessContrast(I, -1, -1) returns an image with minimum contrast and brightness
%    See also PhysTrack.CORRECTHSV, PhysTrack.SetPreProcessingFunction 
    
    if nargin == 1 % fixed correction
        contrast = 0;
        brightness = 0;
    end
    brightness = brightness + 1;
    contrast = contrast + 1;
    I = uint8(round(max(min(contrast * (double(I) - 128) + 128 + 255 * brightness - 255, 255), 0)));
end

