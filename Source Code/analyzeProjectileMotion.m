% This function does nothing. It only tells the wizard to set a section
% start here
PhysTrack.Wizard.MarkSectionStart('Open Video File');
% Create a video reader object.
vro = PhysTrack.VideoReader2(true, false, 240);

PhysTrack.Wizard.MarkSectionStart('Define Reference Coordinate System');
% we need a static coordinate system to be placed on the horizontal
% surface. coordinate system is stored in rwRCS and the pixels per meter
% constant in ppm.
questdlg('Define a reference coordinate system where x-coordinate is aligned horizontally acording to the scene and y-axis is pointing upwards.', '', 'OK', 'OK');
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);

PhysTrack.Wizard.MarkSectionStart('Mark projectile');
% let the user select the object needed to be tracked.
% the user will select the whole flying bob as the object
obs = PhysTrack.GetObjects(vro);

PhysTrack.Wizard.MarkSectionStart('Track projectile');
% call the automatic object tracker now and give it the video and the
% objects from the first frame. It will track these objects throughout the
% video.
% trPt_ will contain the trajectories
% vro on the left of equal sign is used to sync it with the vro being
% returned from the tracker because the out frame might change during the
% tracking process.
[trPt_, vro] = PhysTrack.KLT(vro, obs);
% transform our trajectory to real world coordinates (units are still pixels)
trajectory = PhysTrack.TransformCart2Cart(trPt_.tp1, rwRCS);
% convert pixels to meters.
trajectory = PhysTrack.StructOp(trajectory, ppm, './');

% % for a comparison of the launch velocity calculated from video tracking
% % and the Verniew projectile launcher, we need to identify the location of
% % the point of launch in the video.
% questdlg('Identify the location of the first photogate on VPL.', '', 'OK', 'OK');
% % display the first frame
% imshow(PhysTrack.read2(vro,1));
% % get input from user.
% pg1 = ginput(1);
% % transform and convert the point to real worl coordinates because all
% % other data is in that frame.
% pg1 = PhysTrack.TransformCart2Cart(pg1, rwRCS) / ppm;

% generate thime stamps
t = PhysTrack.GenerateTimeStamps(vro);
% convert the coordinates to displacement. (Final - initial value)
dx = trajectory.x - trajectory.x(1);
dy = trajectory.y - trajectory.y(1);

% get the velocity from the displacement.
[tvx, vx] = PhysTrack.deriv(t,dx,1);
[tvy, vy] = PhysTrack.deriv(t,dy,1);


PhysTrack.Wizard.MarkSectionStart('Plot Data');
% create a Figure
figure;
whitebg([1,1,1]);
grid on;
% plot the trajectory
plot(trajectory.x, trajectory.y, '+', 'Color', [0,0,0],'MarkerSize', 5);
xlabel('x-coordinates of traced points');
ylabel('y-coordinates of traced points');
axis equal
title('Trace of Projectile (units = meter)');

% create a Figure
figure;
% plot the horizontal displacement
plot(t,dx, '+', 'Color', [0,0,0],'MarkerSize', 5);
grid on;
title('Horizontal Displacement');
xlabel('time - t (second)');
ylabel('Horizontal displacement (meter)');

% create a Figure
figure;
% plot the vertical Disp
plot(t,dy, '+', 'Color', [0,0,0],'MarkerSize', 5);
grid on;
title('Vertical Displacement');
xlabel('time - t (second)');
ylabel('Vertical displacement (meter)');

% create a Figure
figure;
% plot the horizontal velocity
plot(tvx,vx, 'Color', [0,0,1],'MarkerSize', 4);
grid on;
title('Horizontal velocity (calculated by 4-point differentiation)');
xlabel('time - t (second)');
ylabel('Horizontal velocity (meters per second)');

% create a Figure
figure;
% plot the vertical velocity
plot(tvy,vy, 'Color', [0,0,1],'MarkerSize', 4);
grid on;
title('Vertical velocity (calculated by 4-point differentiation)');
xlabel('time - t (second)');
ylabel('Vertical velocity (meters per second)');

% create a Figure
figure;
% plot the vertical velocity again 
plot(tvy,vy, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
grid on;
title('Curve Fitting for Vertical Velocity');
xlabel('time - t (seconds)');
ylabel('Vertical Velocity (meters per second)');
% fit vertical velocity to a model (first equation of motion by newton)
[vyFit, dgof] = PhysTrack.lsqCFit(tvy, vy, 'vy',  'vyi + g * t_', 't_' );
hold on;
% plot the fit output for all the time stamps
plot(tvy,vyFit(tvy), 'r');
legend('vy (real)', 'vy = vy_i + g * t');

% cascade the figures
PhysTrack.cascade;

% % lets now calculate the launch velocity and leave it in the workspace.
% % for that, we first calculate the time the y component of ball equals the
% % x of photogate specified by the user.
% % usng that time, we can calculate the velocty.
% th_ = double(PhysTrack.askValue('Kindly identify the manually measured value of the launch angle in degrees.',45));
% % get the velocity at the first photogate
% vyFit = PhysTrack.lsqCFit(tvy, vy, 'y',  'c0 + c1 * t_', 't_' );
% tyFit = PhysTrack.lsqCFit(t, trajectory.y, 'y',  'b0 + b1 * t_ + b2 * t_^2', 't_');
% % time of launch
% tl = (-tyFit.b1 + sqrt(tyFit.b1^2 - 4 * (tyFit.b0 - pg1(2)) * tyFit.b2) ) / (2 * tyFit.b2);
% vi = vyFit(tl)/ sin (th_ * pi / 180);
% photoGate = pg1;
%clear temporary data
clear('ans', 'dgof', 'lastValidFID', 'traceValidity', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
%clear tvx tvy vx vy  vyFit vyFunc t_ vyFuncStr tyFit
