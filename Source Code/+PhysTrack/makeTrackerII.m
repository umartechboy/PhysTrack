%Initialize the tracker and related variables
% requires global definitions, ii, pointsN (eigenFeatures) and iiFrame
inS = num2str(ii);
eval(['tracker', inS, ' = vision.PointTracker(''NumPyramidLevels'',4,''MaxBidirectionalError'', 10, ''MaxIterations'', 10);']);
eval(['initialize(tracker', inS, ', points', inS, '.Location, iiFrame)']);
evalin('base', ['global klt_trackPoints_00_', inS]);
evalin('base', ['global klt_PointsValidity_00_', inS]);
eval(['global klt_trackPoints_00_', inS]);
eval(['global klt_PointsValidity_00_', inS]);