PhysTrack.Wizard.MarkSectionStart('Load file');
% Create a video reader object. 
vro = PhysTrack.VideoReader2(true, false);

% generate thime stamps
t = PhysTrack.GenerateTimeStamps(vro);

PhysTrack.Wizard.MarkSectionStart('Define coordinate system');
questdlg('Define a reference coordinate system where x-coordinate is aligned horizontally acording to the scene and the mass moves along the y-axis.', '', 'OK', 'OK');
% we need a static coordinate system to be placed on the horizontal
% surface. coordinate system is stored in rwRCS and the pixels per meter
% constant in ppm.
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);

PhysTrack.Wizard.MarkSectionStart('Mark pendulum');
% let the user select the object needed to be tracked. The user will select
% a single point on the pendulum.
obs = PhysTrack.GetObjects(vro);


PhysTrack.Wizard.MarkSectionStart('Track Pendulum');
% call the automatic object tracker now and give it the video and the
% objects from the first frame. It will track these objects throughout the
% video.
% trPt_ will contain the trajectories
% vro on the left of equal sign is used to sync it with the vro being
% returned from the tracker because the out frame might change during the
% tracking process.
[trajectory, vro] = PhysTrack.KLT(vro, obs, 200);

% transform our trajectory to real world coordinates (units are still pixels)
trajectory = PhysTrack.TransformCart2Cart(trajectory.tp1, rwRCS);
% convert pixels to meters.
trajectory = PhysTrack.StructOp(trajectory, ppm, './');

% convert the coordinates to displacement. (Final - initial value)
dx  = trajectory.x - trajectory.x(1);
dy = trajectory.y - trajectory.y(1);
% get the velocity from the displacement.
[tvy, vy] = PhysTrack.deriv(t,dy,1);

% close all open figures and windows
close all;

dy = dy - mean(dy);
% create a Figure
dispH = figure;
% change the background color to white
whitebg([1,1,1]);

% plot the vertical Deiplacement
plot(t, dy, 'Color', [0,0,0],'MarkerSize', 5);
grid on;
title('Vertical Displacement with time');
xlabel('time - t (second)');
ylabel('Vertical displacement (mm)');


PhysTrack.Wizard.MarkSectionStart('FFT analysis');
% do the FFT
[freqAxis, amplitudes] = PhysTrack.FFT(dy, 30);
fftH = figure; hold on;
plot(freqAxis, amplitudes);
set(gca,'xtick', [0:0.25:15]);
xlim([0,1.8]);
title('Fast Fourier Transform (FFT) of displacement data');
xlabel('Frequency (Hz)');
ylabel('Amplitude');
uiwait(msgbox('Mark the peak for f1 and f2'));
[f1] = ginput(1);
[f2] = ginput(1);
f1 = f1(1);
f2 = f2(1);
plot([f1, f1], [min(amplitudes), max(amplitudes)], 'r--');
plot([f2, f2], [min(amplitudes), max(amplitudes)], 'g--');
legend('FFT', ['f1 = ', num2str(f1)], ['f2 = ', num2str(f2)]);

PhysTrack.cascade;

if strcmp(questdlg('Do you want to save this data?', '', 'Yes', 'No', 'Yes'), 'Yes')
    
    [dirpath] = [uigetdir(),'\'];
    if ~exist('PendulumTag')
        PendulumTag = '';
    end
    PendulumTag = PhysTrack.askValue('For data structuring, you should tag this pendulum.', PendulumTag, 'Tag this pendulum');
    imwrite(PhysTrack.read2(vro, 1), [dirpath, PendulumTag, ' snapshot.jpg']);
    
    eval(['fp1(', num2str(PendulumTag - 'A' + 1), ') = f1;']);
    eval(['fp2(', num2str(PendulumTag - 'A' + 1), ') = f2;']);
    saveas(fftH, [dirpath, PendulumTag, ' FFT.fig']);
    saveas(dispH, [dirpath, PendulumTag, ' Displacement.fig', '']);
    saveas(fftH, [dirpath, PendulumTag, ' FFT.jpg']);
    saveas(dispH, [dirpath, PendulumTag, ' Displacement.jpg']);
    save([dirpath, PendulumTag, ' Workspace.mat'])
   
end
    
% clear the workspace. This may contain some useless script too. but it
% won't be n issue.
clear('ans', 'dgof', 'lastValidFID', 'obs', 'fftH', 'dispH', 'dirpath', 'tag',  'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt', 'trPt', 'trPt_');
