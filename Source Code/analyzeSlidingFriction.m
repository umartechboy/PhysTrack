vro = PhysTrack.VideoReader2;
questdlg('Define a reference coordinate system where x-coordinate is aligned with the inclined plane and the object moves along the positive side of the axis', '', 'OK', 'OK');
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);
obs = PhysTrack.GetObjects(vro);
[trPt_, vro] = PhysTrack.KLT(vro, obs);
trajectory = PhysTrack.TransformCart2Cart(trPt_.tp1, rwRCS);
trajectory = PhysTrack.StructOp(trajectory, ppm, './');

questdlg('To get the inclination of board, draw a horizontal line.', '', 'OK', 'OK');
th = PhysTrack.GetAngleGraphically(vro, rwRCS);
if th >= pi /2 && th <= pi
    th = pi - th;
elseif th >= pi && th <= pi * 3 / 2
        th = th - pi;
elseif th >= pi * 3 / 2 && th <= 2 * pi
        th = 2*pi - th;
end

t = PhysTrack.GenerateTimeStamps(vro);
dx = trajectory.x - trajectory.x(1);
dy = trajectory.y - trajectory.y(1);
g = 9.812;
d = (dx.^2 + dy.^2).^0.5;
[tv, v] = PhysTrack.deriv(t,d,1);

close all;
figure; hold on;
whitebg([1,1,1]);
plot(t,d, '.', 'Color', [0,0,0],'MarkerSize',2);
grid on;
title('Displacement along the inclined plane');
xlabel('time - t (second)');
ylabel('displacement (meter)');
axis equal;

figure;
plot(tv,v, '+', 'Color', [0,0,0],'MarkerSize',4);
grid on;
title('Velocity along the inclined plane (calculated by 4-point differentiation)');
xlabel('time - t (second)');
ylabel('velocity (meters per second)');

figure; hold on;
plot(t, d, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
grid on;
title('Curve Fitting for Displacement (along the inclined plane)');
xlabel('time - t (seconds)');
ylabel('Displacement (meters per second)');
[dFit, dgof] = PhysTrack.lsqCFit(t, d, 'd', 'b0 + b1 * t_ + b2 * t_.^2', 't_');
plot(t,dFit(t), 'r');
legend({'v (real)', 'd = b0 + b1 * t_ + b2 * t_.^2'}, 'Interpreter', 'none');


figure; hold on;
plot(tv, v, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
grid on;
title('Curve Fitting for Velocity (along the inclined plane)');
xlabel('time - t (seconds)');
ylabel('Velocity (meters per second)');
[vFit, dgof] = PhysTrack.lsqCFit(tv, v, 'v', 'b0 + b1 * t_', 't_');
plot(tv,vFit(tv), 'r');
legend({'v (real)', 'v = b0 + b1 * t_'}, 'Interpreter', 'none');

uk_ = tan(th) - vFit.b1 / g / cos(th);
str = strcat('coefficient of sliding friction uk: vFit.uk = ',char(vpa(uk_,3)));
questdlg(str, '', 'OK', 'OK');
PhysTrack.cascade;
clear('ans', 'vFuncStr', 'tpt1',  'vyFuncStr', 'model', 'str', 'dgof', 'lastValidFID', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
clear ('t_', 'v', 'uk_', 'vFit', 'vFunc', 'vFit', 'tv');
