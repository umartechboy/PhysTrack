% % Create a video reader object. 
% vro = PhysTrack.VideoReader2;
% % we need a static coordinate system to be placed on the slanted plane
% % surface. coordinate system is stored in rwRCS and the pixels per meter
% % constant in ppm.
% 
% questdlg('Define a reference coordinate system where x-coordinate is aligned with the inclined plane and the object moves along the positive side of the axis', '', 'OK', 'OK');
% [rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);
% % let the user select the object needed to be tracked. The user will select
% % a single point on sliding object.
% obs = PhysTrack.GetObjects(vro);
% call the automatic object tracker now and give it the video and the
% objects from the first frame. It will track these objects throughout the
% video.
% trPt_ will contain the trajectories
% vro on the left of equal sign is used to sync it with the vro being
% returned from the tracker because the out frame might change during the
% tracking process.
[trPt_, vro] = PhysTrack.KLT(vro, obs);
% lets extract tp1 from the traj after transformation. We don't want to
% write tp1 with trajectory evey time. Sloth...
trajectory = PhysTrack.TransformCart2Cart(trPt_.tp1, rwRCS);
trajectory = PhysTrack.StructOp(trajectory, ppm, './');

questdlg('To get the inclination of board, draw a horizontal line.', '', 'OK', 'OK');
th = PhysTrack.GetAngleGraphically(vro, rwRCS);
% adjust the value according to our needs. we need an angle which is
% lesser than 90 and bigger than 0;
if th >= pi /2 && th <= pi
    th = pi - th;
elseif th >= pi && th <= pi * 3 / 2
        th = th - pi;
elseif th >= pi * 3 / 2 && th <= 2 * pi
        th = 2*pi - th;
end

% generate thime stamps
t = PhysTrack.GenerateTimeStamps(vro);
% convert the coordinates to displacement. (Final - initial value)
dx = trajectory.x - trajectory.x(1);
dy = trajectory.y - trajectory.y(1);
g = 9.812;
% combine the both components of displacement
d = (dx.^2 + dy.^2).^0.5;
% get the velocity from the displacement.
[tv, v] = PhysTrack.deriv(t,d,1);

% close all open figures and windows
close all;
% create a Figure
figure; hold on;
% change the background color to white
whitebg([1,1,1]);
% plot the displacement
plot(t, d, '.', 'Color', [0,0,0],'MarkerSize',2);
grid on;
title('Displacement along the inclined plane');
xlabel('time - t (second)');
ylabel('displacement (meter)');
axis equal;

% create a Figure
figure;
% plot the velocity
plot(tv,v, '+', 'Color', [0,0,0],'MarkerSize',4);
grid on;
title('Velocity along the inclined plane (calculated by 4-point differentiation)');
xlabel('time - t (second)');
ylabel('velocity (meters per second)');

% create a Figure
figure; hold on;
% plot the displacement first
plot(t, d, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
grid on;
title('Curve Fitting for Displacement (along the inclined plane)');
xlabel('time - t (seconds)');
ylabel('Displacement (meters per second)');
% now fit the displacement in some model
[dFit, dgof] = PhysTrack.lsqCFit(t, d, 'd', 'b0 + b1 * t_ + b2 * t_.^2', 't_');
% plot the fit output for all the time stamps
plot(t,dFit(t), 'r');
legend({'v (real)', 'd = b0 + b1 * t_ + b2 * t_.^2'}, 'Interpreter', 'none');


% create a Figure
figure; hold on;
% first plot the raw velocity
plot(tv, v, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
grid on;
title('Curve Fitting for Velocity (along the inclined plane)');
xlabel('time - t (seconds)');
ylabel('Velocity (meters per second)');
% now fit the velocity to a model
[vFit, dgof] = PhysTrack.lsqCFit(tv, v, 'v', 'b0 + b1 * t_', 't_');
% plot the fit output for all the time stamps
plot(tv,vFit(tv), 'r');
legend({'v (real)', 'v = b0 + b1 * t_'}, 'Interpreter', 'none');

% lets find out the constant of friction and leave it in the workspace.
uk_ = tan(th) - vFit.b1 / g / cos(th);
str = strcat('coefficient of sliding friction uk: vFit.uk = ',char(vpa(uk_,3)));
questdlg(str, '', 'OK', 'OK');
PhysTrack.cascade;
clear('ans', 'vFuncStr', 'tpt1',  'vyFuncStr', 'model', 'str', 'dgof', 'lastValidFID', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
clear ('t_', 'v', 'vFit', 'vFunc', 'vFit', 'tv');
