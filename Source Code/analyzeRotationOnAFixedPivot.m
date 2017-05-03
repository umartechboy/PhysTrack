% Create a video reader object. 
vro = PhysTrack.VideoReader2(true, false, 240);
% let the user select the object needed to be tracked. The user will select
% a track marker on the rotating disc.
obs = PhysTrack.GetObjects(vro);
% call the automatic object tracker now and give it the video and the
% objects from the first frame. It will track these objects throughout the
% video.
% trPt_ will contain the trajectories
% vro on the left of equal sign is used to sync it with the vro being
% returned from the tracker because the out frame might change during the
% tracking process.
[trPt_, vro] = PhysTrack.KLT(vro, obs);
% lets extract the first point here to avoid writing tp1 in every place.
trajectory = trPt_.tp1;

% using the trajectory, lets fit a circle to get the center of rotation
circCenter = PhysTrack.circleFit(trajectory.xy);
questdlg('Define a reference coordinate system where Origin is coinciding with the center of the disc.', '', 'OK', 'OK');
% we need a static coordinate system coordinate system is stored in rwRCS 
% and the pixels per meter constant in ppm.
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro, circCenter(1:2));
% transform the values.
trajectory = PhysTrack.TransformCart2Cart(trajectory, rwRCS);
% CoR = Center of rotation
CoR = PhysTrack.TransformCart2Cart([circCenter(1),circCenter(2)],rwRCS);
CoR = CoR/ppm;

% generate thime stamps
t = PhysTrack.GenerateTimeStamps(vro);
% work with angular velocity for this experiment
d = PhysTrack.GetAngDispFrom2DtrackPoints(trajectory.xy);

% lets calculate the elocity
[tw, w] = PhysTrack.deriv(t,d,1);
[ta, a] = PhysTrack.deriv(t,d,2);

close all;
% preview the result
% create a Figure
figure; hold on; grid on;
% preview the trajectory of point
plot(trajectory.x, trajectory.y, '+', 'Color', [1,0,0],'MarkerSize', 5);
plot(CoR(1), CoR(2), '+', 'Color', [0,0,1],'MarkerSize', 5);
axis equal
xlabel('x-coordinates of traced points');
ylabel('y-coordinates of traced points');
legend('trace of path', 'meanCenter');
title('Trace of travelled Path (units = meter)');

% create a Figure
figure; hold on; grid on;
plot(t,trajectory.x, '.', 'Color', [1,0,0],'MarkerSize', 5);
plot(t,trajectory.y, '.', 'Color', [0,0,1],'MarkerSize', 5);

title('x and y coordinates over time');
xlabel('time t (second)');
ylabel('Linear Displacement of point');
legend('x-coordinates', 'y-coordinates');

figure; grid on;
plot(t,d, '.', 'Color', [0,0,0],'MarkerSize', 1);
title('Angular Displacement');
xlabel('time (second)');
ylabel('Angular displacement (radians)');

figure; grid on;
plot(tw,w, 'Color', [0,0,1],'MarkerSize', 4);
title('Angular velocity (calculated by numerical differentiation)');
xlabel('time t (second)');
ylabel('Angular velocity (radians per second)');

figure; grid on; hold on;
plot(tw, w, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
title('Curve Fitting for Angular Velocity');
xlabel('time t (seconds)');
ylabel('Angular Velocity (radians per second)');

% fit the displacement to a function and display the result.
wFit = PhysTrack.lsqCFit(tw, w, 'w',  'wi + a * t_', 't_' );
plot(tw,wFit(tw), 'r');
legend('w (real)',  'wFit = wi + a * t');
PhysTrack.cascade
clear('circCenter', 'ans', 'dgof', 'lastValidFID', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
clear tpt1 traceValidity
