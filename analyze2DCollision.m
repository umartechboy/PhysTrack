questdlg('Define a reference coordinate system.', '', 'OK', 'OK');
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);
obs = PhysTrack.GetObjects(vro);
[trPt_, vro] = PhysTrack.KLT(vro, obs);
trajectories = trPt_;
[cenA, radA, cenB, radB] = PhysTrack.Get2Circles(vro);
objA = PhysTrack.StitchObjectToPoints([cenA; [cenA(1), cenA(2) + radA]], trajectories.tp1, trajectories.tp2);
objB = PhysTrack.StitchObjectToPoints([cenB; [cenB(1), cenB(2) + radB]], trajectories.tp3, trajectories.tp4);
radA = radA / ppm; radB = radB / ppm;
objA = PhysTrack.TransformCart2Cart(objA, rwRCS);
objB = PhysTrack.TransformCart2Cart(objB, rwRCS);
objA = PhysTrack.StructOp(objA, ppm, './');
objB = PhysTrack.StructOp(objB, ppm, './');

trajectories = PhysTrack.TransformCart2Cart(trajectories, rwRCS);
trajectories = PhysTrack.StructOp(trajectories, ppm, './');

% make index guess for IoC

t = PhysTrack.GenerateTimeStamps(vro);
IoC = 0; minDist = inf;
for ii = 1:length(t)  
    dist = sqrt((objA.tp1.x(ii) - objB.tp1.x(ii))^2 + (objA.tp1.y(ii) - objB.tp1.y(ii))^2);
    if dist < minDist
        minDist = dist;
        IoC = ii;
    end
end
objAfit1 = PhysTrack.lsqCFit(objA.tp1.x(1:IoC - 1), objA.tp1.y(1:IoC - 1),'y', 'm*x+c', 'x');
objAfit2 = PhysTrack.lsqCFit(objA.tp1.x(IoC:end),   objA.tp1.y(IoC:end),'y', 'm*x+c', 'x');
% objBfit1 = lsqFun3(objB.tp1.x(1:IoC - 1), objB.tp1.y(1:IoC - 1),'y', 'm*x+c', 'x');
objBfit2 = PhysTrack.lsqCFit(objB.tp1.x(IoC:end),   objB.tp1.y(IoC:end),'y', 'm*x+c', 'x');
    
dAngA = PhysTrack.GetAngDispFrom2DtrackPoints(objA.tp1, objA.tp2);
dAngB = PhysTrack.GetAngDispFrom2DtrackPoints(objB.tp1, objB.tp2);
dLinA = sqrt((objA.tp1.x - objA.tp1.x(1)).^2 + (objA.tp1.y - objA.tp1.y(1)).^2);
dLinB = sqrt((objB.tp1.x - objB.tp1.x(1)).^2 + (objB.tp1.y - objB.tp1.y(1)).^2);

%calculate velocities of obj 1 at the 4 points
%first, get x and y displacements
objAd1x = objA.tp1.x(1:IoC-1)- objA.tp1.x(1);
objAd1y = objA.tp1.y(1:IoC-1)- objA.tp1.y(1);
%make disp = 0 just after collision
objAd2x = objA.tp1.x(IoC:end)- objA.tp1.x(IoC);
objAd2y = objA.tp1.y(IoC:end)- objA.tp1.y(IoC);

%get displacements
objAd1 = sqrt(objAd1x.^2 + objAd1y.^2);
objAd2 = sqrt(objAd2x.^2 + objAd2y.^2);
%trim Time Stamps
objAt1 = t(1:IoC - 1);
objAt2 = t(IoC:end);
%get velocity
[objAtv1, objAv1]  = PhysTrack.deriv(objAt1,objAd1,1);
[objAtv2, objAv2] = PhysTrack.deriv(objAt2,objAd2,1);
%fit the velocities
objAv1Fit = PhysTrack.lsqCFit(objAtv1,objAv1,'v', 'vi + a * t', 't');
objAv2Fit = PhysTrack.lsqCFit(objAtv2,objAv2,'v', 'vi + a * t', 't');
%get velocities from fit for the 4 events
objAvi = objAv1Fit.vi + objAv1Fit.a * t(1);
objAvbc = objAv1Fit.vi + objAv1Fit.a * t(IoC -1);
objAvac = objAv2Fit.vi + objAv2Fit.a * t(IoC);
objAvf = objAv2Fit.vi + objAv2Fit.a * t(end);

%calculate velocities of obj 2 at the 2 points
%first, get x and y displacements
objBdx = objB.tp1.x(IoC:end)- objB.tp1.x(IoC);
objBdy = objB.tp1.y(IoC:end)- objB.tp1.y(IoC);
%get displacements
objBd = sqrt(objBdx.^2 + objBdy.^2);
%trim Time Stamps
objBt = t(IoC:end);
%get velocity
[objBtv, objBv]  = PhysTrack.deriv(objBt,objBd,1);
%fit the velocities
objBvFit = PhysTrack.lsqCFit(objBtv,objBv,'v', 'vi + a * t', 't');
%get velocities from fit for the 2 events
objBvi = objBvFit.vi + objBvFit.a * objBtv(1);
objBvf = objBvFit.vi + objBvFit.a * objBtv(end);

figHandle = figure;
whitebg([1,1,1]);
set(figHandle, 'Position', [200, 200, 800, 800]);
%raw preview
hold on;
plot(objA.tp1.x,objA.tp1.y, '+', 'Color',[0.5,0.1,0.1]);
viscircles(objA.tp1.xy(1, :), radA , 'LineWidth', 1, 'EdgeColor', 'red');
viscircles(objA.tp1.xy(IoC, :), radA , 'LineWidth', 1, 'EdgeColor', 'red', 'LineStyle' , '-.');
viscircles(objA.tp1.xy(end, :), radA , 'LineWidth', 1, 'EdgeColor', 'red', 'LineStyle' , '--');

plot(objB.tp1.x,objB.tp1.y, '+','Color',[0.5,0.5,0.5])
viscircles(objB.tp1.xy(IoC, :), radB , 'LineWidth', 1, 'EdgeColor', 'blue');
viscircles(objB.tp1.xy(end, :), radB , 'LineWidth', 1, 'EdgeColor', 'blue', 'LineStyle' , '--');

legend('Obj 1 Track', 'Obj 2 at Track')
title ('Positins and trcks of objects as captured from video');
xlabel('x-Coordinates (meters)')
ylabel('y-Coordinates (meters)')

axis equal

figHandle = figure;
set(figHandle, 'Position', [200, 200, 800, 800]);
%raw preview
hold on;
plot(trajectories.tp1.x,trajectories.tp1.y, '-', 'Color', PhysTrack.GetColor('Maroon')/255);
plot(trajectories.tp2.x,trajectories.tp2.y, '-', 'Color', PhysTrack.GetColor('DarkGreen')/255);
plot(trajectories.tp3.x,trajectories.tp3.y, '-', 'Color', PhysTrack.GetColor('Maroon')/255);
plot(trajectories.tp4.x,trajectories.tp4.y, '-', 'Color', PhysTrack.GetColor('DarkGreen')/255);
viscircles(objA.tp1.xy(1,:), radA , 'LineWidth', 1, 'EdgeColor', 'red');
viscircles(objA.tp1.xy(IoC, :), radA , 'LineWidth', 1, 'EdgeColor', 'red', 'LineStyle' , '-.');
viscircles(objA.tp1.xy(end, :), radA , 'LineWidth', 1, 'EdgeColor', 'red', 'LineStyle' , '--');

title ('Trajectory of original tracked points');
xlabel('x-Coordinates (meters)')
ylabel('y-Coordinates (meters)')

viscircles(objB.tp1.xy(IoC, :), radA , 'LineWidth', 1, 'EdgeColor', 'red', 'LineStyle' , '-.');
viscircles(objB.tp1.xy(end, :), radA , 'LineWidth', 1, 'EdgeColor', 'red', 'LineStyle' , '--');

whitebg([0,0,0])
axis equal

figHandle = figure;
set(figHandle, 'Position', [200, 200, 800, 800]);
hold on;

%obj 1
%initial before col
objAI1 = objA.tp1.xy(1, :);
%final before col
objAF1 = objA.tp1.xy(IoC + 1, :);
%final w/o col expected
objAFe1 = objA.tp1.xy(end, :);
%initial after col
objAI2 = objA.tp1.xy(IoC + 1, :);
%final after col
objAF2 = objA.tp1.xy(end, :);

objBI = objB.tp1.xy(IoC, :);
objBF = objB.tp1.xy(end, :);

objAI1(2) = objAfit1.m * objAI1(1) + objAfit1.c;
objAF1(2) = objAfit1.m * objAF1(1) + objAfit1.c;
objAI2(2) = objAfit2.m * objAI2(1) + objAfit2.c;
objAF2(2) = objAfit2.m * objAF2(1) + objAfit2.c;
objAFe1(2) = objAfit1.m * objAFe1(1) + objAfit1.c;

isx = (objAfit1.c - objBfit2.c)/(objBfit2.m - objAfit1.m);
isy = objAfit1.m * isx + objAfit1.c;

objBI(2) = objBfit2.m * objBI(1) + objBfit2.c;
objBF(2) = objBfit2.m * objBF(1) + objBfit2.c;


plot([objAI1(1),objAF1(1)], [objAI1(2),objAF1(2)], 'Color', [0,1,0.5]);
plot([objAI2(1),objAF2(1)], [objAI2(2),objAF2(2)], 'b');
plot([objBI(1),objBF(1)], [objBI(2),objBF(2)],'r');
thet1 = PhysTrack.angleDimDraw(objAI2, objAfit2.m, objAfit1.m, 0.3, [1,0,1]);
thet2 = PhysTrack.angleDimDraw([isx,isy], objAfit1.m, objBfit2.m, 0.3, [1,1,0]);
legend(...
    strcat('Object 1 before Collision; v_i = ', num2str(objAvi), ';v_f = ', num2str(objAvbc)), ...
    strcat('Object 1 after Collision; v_i = ', num2str(objAvac), ';v_f = ', num2str(objAvf)), ...
    strcat('Object 2 after Collision; v_i = ', num2str(objBvi), ';v_f = ', num2str(objBvf)), ...
    strcat('\theta_1 = ', num2str(thet1)), ...
    strcat('\theta_2 = ', num2str(thet2)))
plot([objAF1(1),objAFe1(1)], [objAF1(2),objAFe1(2)],'--' ,'Color', [0,1,0.5]);
plot([isx, objBI(1)], [isy, objBI(2)],'--' ,'Color', [1,0,0]);
viscircles([objAI1(1),objAI1(2)], radA, 'LineWidth', 1, 'EdgeColor', 'red');
viscircles([objAF1(1),objAF1(2)], radA, 'LineWidth', 1, 'EdgeColor', 'red', 'LineStyle' , '-.');
viscircles([objAF2(1),objAF2(2)], radA, 'LineWidth', 1, 'EdgeColor', 'red', 'LineStyle' , '--');
viscircles([objBI(1),objBI(2)], radB, 'LineWidth', 1, 'EdgeColor', 'blue', 'LineStyle' , '-.');
viscircles([objBF(1),objBF(2)], radB, 'LineWidth', 1, 'EdgeColor', 'blue', 'LineStyle' , '--');

whitebg([0,0,0])
axis equal
PhysTrack.cascade;

% dxA = dxA - dxA(1);
% xB = xB - xB(1);
cenA = objA.tp1.xy;
ppA = objA.tp2.xy;
cenB = objB.tp1.xy;
ppB = objB.tp2.xy;

% temp variables
clear isx isy mn mnx mny mx mxx mxy objAd1 objAd1x objAd1y objAd2 objAd2x objAd2y objBd objBdx objBdy 
clear kd kdx kdy ans answer defaultValues dlg_title figHandle lastValidFID num_lines options prompt 
clear objA objB

% result variables
clear objAF1 objAF2 objAFe1 objAfit1 objAfit2 objAI1 objAI2 objAt1 objAt2 objAtv1 objAtv2 objAv1 objAv1Fit objAv2 objAv2Fit trPt_ trPt
clear objAvac objAvbc objAvf objAvi objBF objBfit1 objBfit2 objBI objBt objBtv objBv objBvf objBvFit objBvi thet1 thet2
