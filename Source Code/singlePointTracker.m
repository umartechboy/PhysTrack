% Create a video reader object.
vro = PhysTrack.VideoReader2(true, false);
% we need a static coordinate system to be placed on the horizontal
% surface. coordinate system is stored in rwRCS and the pixels per meter
% constant in ppm.
questdlg('Define a real world reference coordinate system.', '', 'OK', 'OK');
[rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);
% let the user select the objects needed to be tracked.
% the user can select as many objects as required
obs = PhysTrack.GetObjects(vro);
% call the automatic object tracker now and give it the video and the
% objects from the first frame. It will track these objects throughout the
% video.
% trPt_ will contain the trajectories
% vro on the left of equal sign is used to sync it with the vro being
% returned from the tracker because the out frame might change during the
% tracking process.
[trPt_, vro] = PhysTrack.KLT(vro, obs);
% transform our trajectory to real world coordinates (units are still pixels)
trajectory = PhysTrack.TransformCart2Cart(trPt_, rwRCS);
% convert pixels to meters.
trajectory = PhysTrack.StructOp(trajectory, ppm, './');

% generate thime stamps
t = PhysTrack.GenerateTimeStamps(vro);
% Compute first and second order derivatives.
% dx, dy > x, y Displacement
% vx, vy > x, y Velocity
% ax, ay > x, y, Acceleration

% td > time stamps at which displacement is measured
% tv > time stamps at which velocity is measured
% ta > time stamps at which acceleration is measured

% Note: Derivation reduces the number of data samples. To plot the derived
% data against time, new time stamps are required. use td with dx and dy,
% tv with vx and vy and av with ax and ay.
derivatives = PhysTrack.FillDerivatives(trajectory, t);

clear('ans', 'dgof', 'lastValidFID', 'traceValidity', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
%clear tvx tvy vx vy  vyFit vyFunc t_ vyFuncStr tyFit
