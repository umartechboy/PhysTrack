obs = PhysTrack.GetObjects(vro);
[trPt_, vro] = PhysTrack.KLT(vro, obs);
tpt1 = trPt_.tp1.xy;

circCenter = PhysTrack.circleFit(tpt1);
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro, circCenter(1:2));
tpt1 = PhysTrack.TransformCart2Cart(tpt1,rwRCS);
CoR = PhysTrack.TransformCart2Cart([circCenter(1),circCenter(2)],rwRCS);
CoR = CoR/ppm;

t = PhysTrack.GenerateTimeStamps(vro);
d = PhysTrack.GetAngDispFrom2DtrackPoints(tpt1);
dx = tpt1(:,1);
dy = tpt1(:,2);
[tw, w] = PhysTrack.deriv(t,d,1);
[ta, a] = PhysTrack.deriv(t,d,2);

close all;
figure; hold on; grid on;
plot(tpt1(:,1), tpt1(:,2), '+', 'Color', [1,0,0],'MarkerSize', 5);
plot(CoR(1), CoR(2), '+', 'Color', [0,0,1],'MarkerSize', 5);
axis equal
xlabel('x-coordinates of traced points');
ylabel('y-coordinates of traced points');
legend('trace of path', 'meanCenter');
title('Trace of travelled Path (units = meter)');

figure; hold on; grid on;
plot(t,dx, '.', 'Color', [1,0,0],'MarkerSize', 5);
plot(t,dy, '.', 'Color', [0,0,1],'MarkerSize', 5);

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
title('Angular velocity (calculated by 5-point differentiation)');
xlabel('time t (second)');
ylabel('Angular velocity (radians per second)');

figure; grid on; hold on;
plot(tw, w, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
title('Curve Fitting for Angular Velocity');
xlabel('time t (seconds)');
ylabel('Angular Velocity (radians per second)');

wFit = PhysTrack.lsqCFit(tw, w, 'w',  'wi + a * t_', 't_' );
plot(tw,wFit(tw), 'r');
legend('w (real)',  'wFit = wi + a * t');
PhysTrack.cascade
clear('circCenter', 'ans', 'dgof', 'lastValidFID', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
clear tpt1 traceValidity
