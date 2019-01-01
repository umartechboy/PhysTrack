% Create a video reader object. 
PhysTrack.Wizard.MarkSectionStart('Open File');
vro = PhysTrack.VideoReader2(true, false, 240);

PhysTrack.Wizard.MarkSectionStart('Draw coordinate system');
questdlg('Define a reference coordinate system where x-coordinate is aligned horizontally acording to the scene and the mass moves along the y-axis.', '', 'OK', 'OK');
% we need a static coordinate system to be placed on the horizontal
% surface. coordinate system is stored in rwRCS and the pixels per meter
% constant in ppm.
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);

PhysTrack.Wizard.MarkSectionStart('Get objects');
% let the user select the object needed to be tracked. The user will select
% a single point on the pendulum.
obs = PhysTrack.GetObjects(vro);

PhysTrack.Wizard.MarkSectionStart('Track objects');
% call the automatic object tracker now and give it the video and the
% objects from the first frame. It will track these objects throughout the
% video.
% trPt_ will contain the trajectories
% vro on the left of equal sign is used to sync it with the vro being
% returned from the tracker because the out frame might change during the
% tracking process.
[trajectory, vro] = PhysTrack.KLT(vro, obs);


% transform our trajectory to real world coordinates (units are still pixels)
trajectory = PhysTrack.TransformCart2Cart(trajectory.tp1, rwRCS);
% convert pixels to meters.
trajectory = PhysTrack.StructOp(trajectory, ppm, './');

% generate thime stamps
t = PhysTrack.GenerateTimeStamps(vro);
% convert the coordinates to displacement. (Final - initial value)
dx  = trajectory.x - trajectory.x(1);
dy = trajectory.y - trajectory.y(1);
% get the velocity from the displacement.
[tvy, vy] = PhysTrack.deriv(t,dy,1);

% close all open figures and windows
close all;

PhysTrack.Wizard.MarkSectionStart('Plot and analysis');
% create a Figure
figure;
% change the background color to white
whitebg([1,1,1]);

% plot the trajectory
plot(trajectory.x, trajectory.y, '+', 'Color', [0,0,0],'MarkerSize', 5);
grid on;
axis equal
xlabel('x-coordinates of traced points');
ylabel('y-coordinates of traced points');
title('Trace of Oscilating Mass (units = meter)');

% create a Figure
figure;
% plot the vertical velocity
plot(t,dy, '+', 'Color', [0,0,0],'MarkerSize', 5);
grid on;
title('Vertical Displacement');
xlabel('time - t (second)');
ylabel('Vertical displacement (meter)');


% create a Figure
figure;
% plot the vertical displacement
plot(tvy,vy, 'Color', [0,0,1],'MarkerSize', 4);
grid on;
title('Vertical velocity (calculated by 4-point differentiation)');
xlabel('time - t (second)');
ylabel('Vertical velocity (meters per second)');

% create a Figure
figure;
% first plot the raw velocity
plot(tvy,vy, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
grid on;
title('Curve Fitting for Vertical Velocity');
xlabel('time - t (seconds)');
ylabel('Vertical Velocity (meters per second)');

% now fit the velocity to a model
vyFit = PhysTrack.lsqCFit(tvy, vy, 'vy',  'a0 + a1*sin(w*t_ + phase)', 't_', [0 0 0.5 10]);
hold on;
% plot the fit output for all the time stamps
plot(tvy, vyFit(tvy), 'r');
legend({'vy (real)', 'a0 + a1*sin(w*t_ + phase)'}, 'Interpreter', 'none');
PhysTrack.cascade;
    
% clear the workspace. This may contain some useless script too. but it
% won't be n issue.
clear('ans', 'dgof', 'lastValidFID', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt', 'trPt', 'trPt_');
