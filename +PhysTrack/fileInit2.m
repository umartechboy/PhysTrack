[fileName, rootPath, filterIndex] = uigetfile({'*.mp4;*.avi;*.mov','Common Video File Types';'*.*','All Files'}, 'Select a video file for image processing');
fullPath = strcat(rootPath,fileName);
global vro enableFastPlayback
enableFastPlayback = true;
vro = VideoReader(fullPath);
vfr = vision.VideoFileReader(fullPath);
vFrames = vro.NumberofFrames - 1;
preMag = 1;
h = vidTrimToolOld;
uiwait(h)
close all;
clear('normalSpeedVideo', 'playingNow', 'fileName', 'filterIndex', 'fullPath','h', 'rootPath', 'vFrames', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx','kdy','num_lines','options','prompt');
saveRes = false; % save results flag.
umpp = PhysTrack.askValue('Enter the \mu~m/pixel calibration constant: ', 0.2051983624, 'Distance Calibration');
close all;
whitebg([1,1,1]);
for ii = 1:3
    h = figure;
    whitebg([1,1,1]);
    plot(objectTrack.Objects(ii).x, objectTrack.Objects(ii).y)
    axis equal;
    title(['Track of object ', num2str(ii)]);
    xlabel('x-coordinates (\mum)');
    ylabel('y-coordinates (\mum)');
    if saveRes
        saveas(h, ['track', num2str(ii),'.jpg']);
    end
end

for ii = 1:3
    h = figure;
    plot(objectTrack.TimeStamps, objectTrack.Objects(ii).rp2)
    title(['r_p^2 of object ', num2str(ii)]);
    xlabel('Time (seconds)');
    ylabel('r_p^2 (\mum^2)');
    if saveRes
        saveas(h, ['rp', num2str(ii),'.jpg']);
    end
end

validObjects = [];
for ii = 1:size(objectTrack.AllObjects, 2)
    if objectTrack.AllObjects(ii).validity == 1
        validObjects(end+1,:) = selObjects(ii,:);
    end
end

ti = read(vro,ifi);
ti = drawCrossHairMarks(ti, validObjects / double(cPreMag) + repmat([cropRect(1:2), 0], size(validObjects, 1), 1) , [0, 0, 0], 0.2);
h = figure;
ti = insertShape(ti, 'Rectangle', uint16(cropRect), 'LineWidth', 2, 'Color', [0,0,0], 'Opacity', 0.5);

for ii = 1:size(validObjects,1)
    ti = insertText(ti, [validObjects(ii,1) / double(cPreMag) + cropRect(1) + 20, validObjects(ii,2) / double(cPreMag) + cropRect(2) + 30], num2str(ii), 'FontSize', 30, 'boxOpacity', 0);
end
imshow(ti);
if saveRes
    imwrite(ti,'cropRect.jpg');
end
clear ti

h = figure;
fit = lsqFun3(objectTrack.TimeStamps, objectTrack.rn2, 'rn2', 'm*t + c', 't');
plot(objectTrack.TimeStamps, objectTrack.rn2)
hold on;
plot(objectTrack.TimeStamps, fit.m*objectTrack.TimeStamps + fit.c,'r')
title('r_n^2 of the objects');
xlabel('Time (seconds)');
ylabel('r_n^2 (\mum)^2');
if saveRes
    saveas(h, 'rn2.jpg');
end

h = figure;
if ~exist('temperature') temperature = 298.13; end
if ~exist('sphereDia') sphereDia = 2e-6; end
if ~exist('viscosity') viscosity = 1.005e-3; end
temperature = askValue('Enter the tmperature of the fluid in Kelvins: ', temperature);
sphereDia = askValue('Enter the dia of microspheres in \mum: ', sphereDia * 1e6)* 1e-6;
viscosity = askValue('Enter the Viscosity of fluid in N s/m^2): ', viscosity);
kb = (6 / 4 * pi * viscosity * sphereDia / 2 / temperature * ((fit.m*1e20 + fit.c) * 1e-12)) ./ 1e20;
plot([0,max(objectTrack.TimeStamps)], [kb, kb], '--r');
legend(['Boltzman Constant kb = ', num2str(kb)], ' N m^2 s^-1 K^-1');
hold on; plot(objectTrack.TimeStamps, (6 / 4 * pi * viscosity * sphereDia / 2 / temperature * ((fit.m*objectTrack.TimeStamps + fit.c) * 1e-12)) ./ objectTrack.TimeStamps);

hold on;
title('Boltzman Constant');
xlabel('Time (seconds)');
ylabel('Boltzman Constant');
if saveRes
    saveas(h, 'kb.jpg');
end

if saveRes
    save('workspace.mat');
end
cascade;
clear prompt dlg_title defaultValues options answer num_lines enableFastPlayback vidPrev