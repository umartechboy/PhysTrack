function I = medfilt3(I)
%MEDFILT3 the matlab medfilt function which works on RGB images
I = cat(3, medfilt2(I(:,:,1)), medfilt2(I(:,:,2)), medfilt2(I(:,:,3)));
end

