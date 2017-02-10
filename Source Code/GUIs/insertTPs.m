function I = insertTPs(frameInd, meanPoint)
%INSERTTPS library internal function to insert global track points on an
%Image. Required global initialization of klt_vr2o_00,
%klt_trackPoints_00_x ,klt_PointsValidity_00_x and klt_tObs_00
if nargin == 1
    meanPoint = true;
end
    global klt_vr2o_00 klt_tObs_00
    I = PhysTrack.read2(klt_vr2o_00, frameInd, false, true);
    % hook on the marker objects
    for ii = 1:klt_tObs_00
        inS = num2str(ii);
        eval(['global klt_trackPoints_00_', inS]);
        eval(['global klt_PointsValidity_00_', inS]);
        eval(['klt_PointsValidity_00_', inS, ' = logical(klt_PointsValidity_00_', inS, ');']);
        if meanPoint
            eval(['I = insertMarker(I, mean(klt_trackPoints_00_', inS, '(klt_PointsValidity_00_',inS,'(:, frameInd), :, frameInd), 1), ''o'', ''Size'', 5, ''Color'', PhysTrack.GetColor(',inS,'));']);
        else
            eval(['I = insertMarker(I, klt_trackPoints_00_', inS, '(klt_PointsValidity_00_',inS,'(:, frameInd), :, frameInd), ''o'', ''Size'', 5, ''Color'', PhysTrack.GetColor(',inS,'));']);
        end
    end
end

