vro = PhysTrack.VideoReader2;
questdlg('Define a reference coordinate system where x-coordinate is aligned horizontally acording to the scene and the mass moves along the y-axis.', '', 'OK', 'OK');
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);
obs = PhysTrack.GetObjects(vro);
[trPt_, vro] = PhysTrack.KLT(vro, obs);
trajectory = PhysTrack.TransformCart2Cart(trPt_.tp1, rwRCS);
trajectory = PhysTrack.StructOp(trajectory, ppm, './');

%th_ = PhysTrack.askValue('Kindly givr the preset value of launch angle.',45);

t = PhysTrack.GenerateTimeStamps(vro);
dx  = trajectory.x;
dy = trajectory.y;

[tvy, vy] = PhysTrack.deriv(t,dy,1);

close all;
mxx = max(abs(trajectory.x))*1.2;
mxy = max(abs(trajectory.y))*1.2;
figure;
whitebg([1,1,1]);
plot(trajectory.x, trajectory.y, '+', 'Color', [0,0,0],'MarkerSize', 5);
grid on;
axis equal
xlabel('x-coordinates of traced points');
ylabel('y-coordinates of traced points');
title('Trace of Oscilating Mass (units = meter)');

figure;
plot(t,dy, '+', 'Color', [0,0,0],'MarkerSize', 5);
grid on;
title('Vertical Displacement');
xlabel('time - t (second)');
ylabel('Vertical displacement (meter)');


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

vyFit = PhysTrack.lsqCFit(tvy, vy, 'vy',  'a0 + a1*sin(w*t_ + phase)', 't_', [0 0 0.5 10]);
hold on;
plot(tvy, vyFit(tvy), 'r');
legend({'vy (real)', 'a0 + a1*sin(w*t_ + phase)'}, 'Interpreter', 'none');
PhysTrack.cascade;
    
clear('ans', 'dgof', 'lastValidFID', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt', 'trPt', 'trPt_');
