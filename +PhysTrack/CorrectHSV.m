function I = CorrectHSV(I, h, s, v)
%CORRECTHSV Applys correction factors on the Hue, Saturation and Vibrance
%Domain for each factor is [-1,+1]
if nargin == 1 % fixed correction
    h = 0;
    s = 0;
    v = 0;
end
s = s + 1;
v = v + 1;
if h > 0
    h = 1 - h;
end
h = h + 1;
I = double(rgb2hsv(I));
I(:, :, 1) = I(:, :, 1) * h;
I(:, :, 2) = I(:, :, 2) * s;
I(:, :, 3) = I(:, :, 3) * v;
I = hsv2rgb(I);
end

