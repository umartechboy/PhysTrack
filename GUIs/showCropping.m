function [out, cropRect] = showCropping(I, cropRect, transparency)
%SHOWCROPPING returns an image which displays the crop region alongwith the
%original image
cropRect = round(cropRect);
cropRect(find(cropRect < 1)) = 1;
if cropRect(3) > (size(I, 2) - cropRect(1) + 1)
    cropRect(3) = (size(I, 2) - cropRect(1) + 1);
end
if cropRect(4) > (size(I, 1) - cropRect(2) + 1)
    cropRect(4) = (size(I, 1) - cropRect(2) + 1);
end
if cropRect(3) < 1
    cropRect(3) = 1;
end
if cropRect(4) < 1
    cropRect(4) = 1;
end
    if nargin == 2
        transparency = 0.2;
    end
    I2 = I(cropRect(2):(cropRect(2) + cropRect(4)) - 1, cropRect(1):(cropRect(1) + cropRect(3) - 1), :);
    out = uint8(I * transparency);
    out(cropRect(2):(cropRect(2) + cropRect(4)) - 1, cropRect(1):(cropRect(1) + cropRect(3) - 1), :) = I2;
end

