function [thresh, bkIsBright] = blobPrep_getBinThreshold(frequency)

thresh = find(frequency == max(frequency));
if sum(frequency((end / 2):end)) > sum(frequency(1:(end/2))) % background is bright    
    bkIsBright = true;
    thresh = thresh(1) / 3 * 2;
else
    bkIsBright = false;
    thresh = thresh(1) + (255 - thresh(1)) /4;
end
    thresh = uint8(thresh);
end