I =  im2bw(rgb2gray(imread('sample.png')), 0.5);
I = bwareafilt(I,5);
stats = regionprops('table',I,'Centroid',...
    'MajorAxisLength','MinorAxisLength');
centers = stats.Centroid;
diameters = mean([stats.MajorAxisLength stats.MinorAxisLength],2);
radii = diameters/2;

hold on
imshow(I); hold on;
viscircles(centers,radii);
hold off