questdlg('Define a reference coordinate system where x-coordinate is aligned horizontally acording to the scene and y-axis is pointing upwards.', '', 'OK', 'OK');
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);
obs = PhysTrack.GetObjects(vro);
[trPt_, vro] = PhysTrack.KLT(vro, obs);
trajectory = PhysTrack.TransformCart2Cart(trPt_.tp1, rwRCS);
trajectory = PhysTrack.StructOp(trajectory, ppm, './');

questdlg('Identify the location of the first photogate on VPL.', '', 'OK', 'OK');
imshow(PhysTrack.read2(vro,1));
pg1 = ginput(1);
pg1 = PhysTrack.TransformCart2Cart(pg1, rwRCS) / ppm;

t = PhysTrack.GenerateTimeStamps(vro);
dx = trajectory.x - trajectory.x(1);
dy = trajectory.y - trajectory.y(1);

[tvx, vx] = PhysTrack.deriv(t,dx,1);
[tvy, vy] = PhysTrack.deriv(t,dy,1);
close all;
figure;
whitebg([1,1,1]);
grid on;
plot(trajectory.x, trajectory.y, '+', 'Color', [0,0,0],'MarkerSize', 5);
xlabel('x-coordinates of traced points');
ylabel('y-coordinates of traced points');
axis equal
title('Trace of Projectile (units = meter)');

figure;
plot(t,dx, '+', 'Color', [0,0,0],'MarkerSize', 5);
grid on;
title('Horizontal Displacement');
xlabel('time - t (second)');
ylabel('Horizontal displacement (meter)');

figure;
plot(t,dy, '+', 'Color', [0,0,0],'MarkerSize', 5);
grid on;
title('Vertical Displacement');
xlabel('time - t (second)');
ylabel('Vertical displacement (meter)');


figure;
plot(tvx,vx, 'Color', [0,0,1],'MarkerSize', 4);
grid on;
title('Horizontal velocity (calculated by 4-point differentiation)');
xlabel('time - t (second)');
ylabel('Horizontal velocity (meters per second)');

figure;
plot(tvy,vy, 'Color', [0,0,1],'MarkerSize', 4);
grid on;
title('Vertical velocity (calculated by 4-point differentiation)');
xlabel('time - t (second)');
ylabel('Vertical velocity (meters per second)');

figure;
plot(tvy,vy, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
grid on;
title('Curve Fitting for Vertical Velocity');
xlabel('time - t (seconds)');
ylabel('Vertical Velocity (meters per second)');

[vyFit, dgof] = PhysTrack.lsqCFit(tvy, vy, 'vy',  'vyi + g * t_', 't_' );
hold on;
plot(tvy,vyFit(tvy), 'r');
legend('vy (real)', 'vy = vy_i + g * t');

% cascade the figures
PhysTrack.cascade;
th_ = double(PhysTrack.askValue('Kindly identify the manually measured value of the launch angle in degrees.',45));
% get the velocity at the first photogate
vyFit = PhysTrack.lsqCFit(tvy, vy, 'y',  'c0 + c1 * t_', 't_' );
tyFit = PhysTrack.lsqCFit(t, dy, 'y',  'b0 + b1 * t_ + b2 * t_^2', 't_');
tl = (-tyFit.b1 + sqrt(tyFit.b1^2 - 4 * (tyFit.b0 - pg1(2)) * tyFit.b2) ) / (2 * tyFit.b2);
vi = vyFit(tl)/ sin (th_ * pi / 180);
photoGate = pg1;
%clear temporary data
clear('ans', 'dgof', 'lastValidFID', 'traceValidity', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
clear tvx tvy vx vy  vyFit vyFunc t_ vyFuncStr tyFit
