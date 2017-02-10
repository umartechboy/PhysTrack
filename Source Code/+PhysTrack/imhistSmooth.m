function  [img, histo, thresh, bkIsBright] = imhistSmooth(img, currentThresh, updateThresh)
gCropped = rgb2gray(img);
bkIsBright = [];
height = 185;
vals = unique(gCropped);
freq = histc(gCropped(:),vals);

zto255 = zeros(256,1);
zto255Freq = zeros(256,1);
for i = 0:255
    zto255(i + 1) = i;
    if size(find(vals == i)) == [1,1]
        tInd = find(vals == i);
        zto255Freq(i + 1) = freq(tInd);
    end
end
zto255Freq = zto255Freq/max(zto255Freq) * height;
freq = zto255Freq;
for i = 3:254
    freq (i) = (zto255Freq(i - 1)+ zto255Freq(i - 2) + zto255Freq(i + 1) + zto255Freq(i + 2) + zto255Freq(i)) / 5;
end
freq (2) = (zto255Freq(1)+ zto255Freq(2) + zto255Freq(3)) / 3;
freq (255) = (zto255Freq(254)+ zto255Freq(255) + zto255Freq(256)) / 3;

histImg = uint8(zeros(height, 256));
for i = 1:256
    for j = 1:height
        if freq(i) < j
            histImg(height + 1 - j,i) = 255;
        else
            histImg(height + 1 - j, i) = 0;
        end
    end
end
img =  cat(3, histImg, histImg, histImg);
histo = freq;

if updateThresh 
    [currentThresh, bkIsBright] = PhysTrack.blobPrep_getBinThreshold(freq);
    currentThresh = uint8(round(currentThresh));
    currentThresh = currentThresh + 1;
end

if currentThresh >=0
   for j = 1:height
        img(height + 1 - j,currentThresh, :) = [255,0,0];
   end 
end
thresh = currentThresh;
end