function polyObjTrack = StitchObjectToPoints(pointsToStich_, trackPoints1, trackPoints2)
    %ang disp
    if nargin == 2 % we may have a tp struct
        if ~PhysTrack.IsTpStruct(trackPoints1)
            error 'To trajectories are required for this operation'
        end
        trackPoints1 = PhysTrack.StructToArr(trackPoints1);
        trackPoints2 = zeros(size(trackPoints1,1),2);
    end
    trackPoints1 = PhysTrack.StructToArr(trackPoints1);
    trackPoints2 = PhysTrack.StructToArr(trackPoints2);
    pointsToStich_ = PhysTrack.StructToArr(pointsToStich_);
    th = PhysTrack.GetAngDispFrom2DtrackPoints(trackPoints1,trackPoints2)';
    cen = (trackPoints1 + trackPoints2) / 2; 
    cenAxis = cen(1,:);
    %lin disp
    cen(:,1) = cen(:,1) - cen(1,1);
    cen(:,2) = cen(:,2) - cen(1,2);
    
    mAxis = [cenAxis; [cenAxis(1) + 1, cenAxis(2)]; [cenAxis(1), cenAxis(2) + 1]];
    polyObjTrack = zeros(size(trackPoints1,1), 2, size(pointsToStich_,1));
    %coordinates of object points acording to the first mAxis. because
    %mAxis was calculated from first point of track
    allObjPoints = PhysTrack.TransformCart2Cart(pointsToStich_, mAxis);
    for ii = 1:length(th)
        %clone points
        cObjPoints = allObjPoints;
        %convert to polar
        [cObjPoints(:,1),cObjPoints(:,2)]  = cart2pol(cObjPoints(:,1), cObjPoints(:,2));
        %apply the rotation
        cObjPoints(:,1) = cObjPoints(:,1) + th(ii);
        %convert back to cart
        [cObjPoints(:,1),cObjPoints(:,2)]  = pol2cart(cObjPoints(:,1), cObjPoints(:,2));
        
        %apply translation
        cObjPoints(:,1) = cObjPoints(:,1) + cen(ii, 1);
        cObjPoints(:,2) = cObjPoints(:,2) + cen(ii , 2);
        %transform back from mAxis points to imAxis
        cObjPoints = PhysTrack.InverseTransformCart2Cart(cObjPoints, mAxis);
        polyObjTrack(ii, 1,:) = cObjPoints(:,1);
        polyObjTrack(ii, 2,:) = cObjPoints(:,2);
    end
    if size(polyObjTrack, 3) > 1
        polyObjTrack = PhysTrack.ArrToStr(polyObjTrack);
    end
end