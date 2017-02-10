% Create a video reader object. 
vro = PhysTrack.VideoReader2;
% let the user select the object needed to be tracked. The user will select
% two points on the rolling cylinder.
obs = PhysTrack.GetObjects(vro);
% call the automatic object tracker now and give it the video and the
% objects from the first frame. It will track these objects throughout the
% video.
% trajUT will contain the untransformed trajectories
% vro on the left of equal sign is used to sync it with the vro being
% returned from the tracker because the out frame might change during the
% tracking process
trajUT = PhysTrack.KLT(vro, obs);
% there are three coordinate systems. One which is horizontal and fixed to
% the wooden plank. 
% The second one is simlar to first one but in the
% direction of the iclined plank. All the variables associated with it have
% similar names. Only a single underscore, "_", is used as suffix
% The third one is a moving coordinate system. It is stitched to the center
% of the object and moves automatically down the incline without changing
% orientatin.
% All the variables associated with it have
% similar names. A double underscore, "__", is used as suffix

% First, get the first coordinate system.
% we need a static coordinate system to be placed on the horizontal
% surface. coordinate system is stored in rwRCS and the pixels per meter
% constant in ppm.
questdlg('Define a reference coordinate system where x-axis is aligned along the horizontal board in the direction of the motion and y-axis is pointing upwards', '', 'OK', 'OK');
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);
% Then, get the 2nd coordinate system.
questdlg('Define a reference coordinate system where x-axis is aligned along the slanted board in the direction of the motion and y-axis is pointing upwards. Don''t define ppm.', '', 'OK', 'OK');
rwRCS_ = PhysTrack.DrawCoordinateSystem(vro);
% don't take the third system yet. we need to calculate the center of the
% rolling object for the automated stitching of
% coordinate system.

waitfor(msgbox('To detect the center of the disc, you need to identify the edges of the disc manually.'));
[cenUT, rad] = PhysTrack.Get1Circle(vro);
rad = rad / ppm;
% Lets also take a random peripheral point on the disc as well. This will
% be helpful in showing the rotation.
waitfor(msgbox('Also, kindly identify a peripheral point P to stitch be stitched to the rotating disc.'));
h = figure; imshow(PhysTrack.read2(vro, 1)); 
pointPUT = ginput(1);
close(h);

% traj variables will contain the trajectories of the track markers,
% cTraj variables will contain the trajectories of the centers
% pTraj variables will contain the trajectories of peripheral points

% stitch both points to the trajectories. Everthing is going in
% untransformed points yet.
cTrajUT = PhysTrack.StitchObjectToPoints(cenUT, trajUT.tp1, trajUT.tp2);
pTrajUT = PhysTrack.StitchObjectToPoints(pointPUT, trajUT.tp1, trajUT.tp2);

% lets do the transformation now.
% System 1
traj = PhysTrack.StructOp(PhysTrack.TransformCart2Cart(trajUT, rwRCS), ppm, '/');
cen = PhysTrack.TransformCart2Cart(cenUT, rwRCS)/ppm;
pointP = PhysTrack.TransformCart2Cart(pointPUT, rwRCS)/ ppm;
cTraj = PhysTrack.TransformCart2Cart(cTrajUT, rwRCS) / ppm;
pTraj = PhysTrack.TransformCart2Cart(pTrajUT, rwRCS) / ppm;

% System 2
traj_ = PhysTrack.StructOp(PhysTrack.TransformCart2Cart(trajUT, rwRCS_), ppm, '/');
cen_ = PhysTrack.TransformCart2Cart(cenUT, rwRCS_)/ppm;
pointP_ = PhysTrack.TransformCart2Cart(pointPUT, rwRCS_)/ ppm;
cTraj_ = PhysTrack.StitchObjectToPoints(cen_, traj_.tp1, traj_.tp2);
pTraj_ = PhysTrack.StitchObjectToPoints(pointP_, traj_.tp1, traj_.tp2);

% System 3
% but we havn't defined it yet. define it first using the tool
waitfor(msgbox('Draw a non rotating coordinate system centered on the disc center and moving with it.'));
% this will give as start, the center of the object. Center of the system
% will be placed automatically in that system. We only need to set the
% orientation manually on the screen. That can be done using the GUI
% controls
rwRCS__ = PhysTrack.DrawFloatingCoordinateSystemNonRotating(vro, cTrajUT, cenUT);

% Transformation is similar to the stationary systems...
traj__ = PhysTrack.StructOp(PhysTrack.TransformCart2Cart(trajUT, rwRCS__), ppm, '/');
cTraj__ = PhysTrack.TransformCart2Cart(PhysTrack.StitchObjectToPoints(cenUT, trajUT.tp1, trajUT.tp2), rwRCS__);
pTraj__ = PhysTrack.TransformCart2Cart(PhysTrack.StitchObjectToPoints(pointPUT, trajUT.tp1, trajUT.tp2), rwRCS__);


% now that we have the transformed trajectories, lets calulate individual
% coordinates and perform the analysis.
% first, get the time stamps.
t = PhysTrack.GenerateTimeStamps(vro);

% extract the coordinates
% coordinate system 1
x = cTraj(:,1);
y = cTraj(:,2);
xp = pTraj(:,1);
yp = pTraj(:,2);
% coordinate system 2
x_ = cTraj_(:,1);
y_ = cTraj_(:,2);
xp_ = pTraj_(:,1);
yp_ = pTraj_(:,2);
% coordinate system 3
x__ = cTraj__(:,1);
y__ = cTraj__(:,2);
xp__ = pTraj__(:,1);
yp__ = pTraj__(:,2);

% Get the velocities
% coordinate system 1
[dt, dx] = PhysTrack.deriv(t,x,1); % x velocity of center
[dt, dy] = PhysTrack.deriv(t,y,1); %  y velocity of center
[dt, dxp] = PhysTrack.deriv(t,xp,1); % x velocity of peripheral point
[dt, dyp] = PhysTrack.deriv(t,yp,1); % y velocity of peripheral point
% coordinate system 2
[dt, dx_] = PhysTrack.deriv(t,x_,1);
[dt, dy_] = PhysTrack.deriv(t,y_,1);
[dt, dxp_] = PhysTrack.deriv(t,xp_,1);
[dt, dyp_] = PhysTrack.deriv(t,yp_,1);
% coordinate system 3
[dt, dxp__] = PhysTrack.deriv(t,xp__,1);
[dt, dyp__] = PhysTrack.deriv(t,yp__,1);
[dt, dx__] = PhysTrack.deriv(t,x__,1);
[dt, dy__] = PhysTrack.deriv(t,y__,1);


% Get the accelerations
% coordinate system 1
[d2t, d2xp] = PhysTrack.deriv(t,xp,2);% x acceleration of center
[d2t, d2yp] = PhysTrack.deriv(t,yp,2); %  y acceleration of center
[d2t, d2x] = PhysTrack.deriv(t,x,2); % x acceleration of peripheral point
[d2t, d2y] = PhysTrack.deriv(t,y,2); %y acceleration of peripheral point

% coordinate system 2
[d2t, d2xp_] = PhysTrack.deriv(t,xp_,2);
[d2t, d2yp_] = PhysTrack.deriv(t,yp_,2);
[d2t, d2x_] = PhysTrack.deriv(t,x_,2);
[d2t, d2y_] = PhysTrack.deriv(t,y_,2);

% coordinate system 3
[d2t, d2xp__] = PhysTrack.deriv(t,xp__,2);
[d2t, d2yp__] = PhysTrack.deriv(t,yp__,2);
[d2t, d2x__] = PhysTrack.deriv(t,x__,2);
[d2t, d2y__] = PhysTrack.deriv(t,y__,2);


% Get the angle of inclination using the first and last positions of center
% of object.
th = atan2(y(1) - y(end), x(end) - x(1));

% fit the x displacement of body in 2nd Coordinate system
ft = PhysTrack.lsqCFit(t, x_, 'x_', 'c2 + c1 * t + 1/3*9.81*t^2 * sin(0.1341)', 't');

% phase of object in third Coordinate system
phi0 = atan2(yp__(1), xp__(1));
close all;

% basic Figures
figure; hold on; plot(t, x, 'r'); plot(t, y, 'b'); title('t x-y');
figure; hold on; plot(t, x_, 'r'); plot(t, y_, 'b'); title('t x_-y_');
%figure; hold on; plot(t, x__, 'r'); plot(t, y__, 'b'); title('t x__-y__');
figure; hold on; plot(t, xp, 'r'); plot(t, yp, 'b'); title('t xp-yp');
figure; hold on; plot(t, xp_, 'r'); plot(t, yp_, 'b'); title('t xp_-yp_');
figure; hold on; plot(t, xp__, 'r'); plot(t, yp__, 'b'); title('t xp__-yp__');
% 
figure; hold on; plot(dt, dx, 'r'); plot(dt, dy, 'b'); title('dt dx-dy');
figure; hold on; plot(dt, dx_, 'r'); plot(dt, dy_, 'b'); title('dt dx_-dy_');
%figure; hold on; plot(dt, dx__, 'r'); plot(dt, dy__, 'b'); title('dt dx__-dy__');
figure; hold on; plot(dt, dxp, 'r'); plot(dt, dyp, 'b'); title('dt dxp-dyp');
figure; hold on; plot(dt, dxp_, 'r'); plot(dt, dyp_, 'b'); title('dt dxp_-dyp_');
figure; hold on; plot(dt, dxp__, 'r'); plot(dt, dyp__, 'b'); title('dt dxp__-dyp__');
% 
% 
% The acceleration figures are so noisy  that they don't make any sense.
% figure; hold on; plot(d2t, d2x, 'r'); plot(d2t, d2y, 'b'); title('dt dx-dy');
% figure; hold on; plot(d2t, d2x_, 'r'); plot(d2t, d2y_, 'b'); title('dt dx_-dy_');
% figure; hold on; plot(d2t, d2x__, 'r'); plot(d2t, d2y__, 'b'); title('dt dx__-dy__');
% figure; hold on; plot(d2t, d2xp, 'r'); plot(d2t, d2yp, 'b'); title('dt d2xp-d2yp');
% figure; hold on; plot(d2t, d2xp_, 'r'); plot(d2t, d2yp_, 'b'); title('dt dxp_-dyp_');
% figure; hold on; plot(d2t, d2xp__, 'r'); plot(d2t, d2yp__, 'b'); title('dt dxp__-dyp__');
 
%plot angular Disp
figure;
w = PhysTrack.GetAngDispFrom2DtrackPoints(traj.tp1, traj.tp2);
plot(t,w);
title ('Angular displacement');
xlabel('time (seconds)')
ylabel('Angular Displacement (radians)')

PhysTrack.cascade;
clear('ans',  'mn', 'mx', 'mnx', 'mny','vyFuncStr', 'model', 'str', 'dgof', 'lastValidFID', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
clear figHandle obj1F1 obj1F2 obj1Fe1 obj1I1 obj1I2 obj2F obj2I