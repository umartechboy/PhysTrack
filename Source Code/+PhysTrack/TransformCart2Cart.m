function transformedPoints = TransformCart2Cart(points, newAxes)
if nargin < 2
    error('Not enough arguments');
end
if isstruct(points)
    if PhysTrack.IsTpStruct(points)
        vars = fieldnames(points);
        for ii = 1:length(vars)
             eval(['transformedPoints.', strjoin(vars(ii)), ' = PhysTrack.TransformCart2Cart(points.', strjoin(vars(ii)), ', newAxes);'])
        end
        return;
    else
        points_ = PhysTrack.StructToArr(points);
    end
else
    points_ = points;
end
% determine the type of rwRCS

if isstruct(newAxes)
    isFloating = true;
    if size(newAxes.tp1.xy, 1) ~= size(points_, 1)
        error The duration of floating coordinate system must be equal to that of the total points.
    end
else
    isFloating = false;
end

%axes in terms of points
if isFloating
    p1 = newAxes.tp1.xy;
    p2 = newAxes.tp2.xy;
    p3 = newAxes.tp3.xy;
else
    p1= newAxes(1,:);
    p2= newAxes(2,:);
    p3= newAxes(3,:);
end

%C_p2 in translated coordinates
if isFloating
    p2_(:, 1:2) = p2(:, 1:2) - p1(:, 1:2);
else
    p2_(1:2) = p2(1:2) - p1(1:2);
end

%C-polygon in translated coordinates
if isFloating
    ppl_(:,1) = points_(:,1) - p1(:, 1);
    ppl_(:,2) = points_(:,2) - p1(:, 2);
else
    ppl_(:,1) = points_(:,1) - p1(1);
    ppl_(:,2) = points_(:,2) - p1(2);
end


%P_polygon in translated coordinates
[ppl_p(:, 1), ppl_p(:, 2)]  = cart2pol(ppl_(:,1), ppl_(:,2));

%P_p2 in translated coordinates
if isFloating
    p2_p = cart2pol(p2_(:,1), p2_(:,2));
else
    p2_p = cart2pol(p2_(1), p2_(2));
end

%P_polygon in translated, rotated coordinates
if isFloating
    ppl__p = ppl_p(:,1) - p2_p(:, 1);
else
    ppl__p = ppl_p(:,1) - p2_p(1);
end
ppl__p(:,2) = ppl_p(:,2);

%C_polygon in translated, rotated coordinates
[ppl__c(:, 1), ppl__c(:, 2)]  = pol2cart(ppl__p(:,1), ppl__p(:,2));

%C_polygon in translated, rotated coordinates, Fixed Y Sign
if isFloating
    for ii = 1:1:size(p1, 1)
        if sign((p2(ii, 1) - p1(ii, 1)) * (p3(ii, 2) - p1(ii, 2)) - (p2(ii, 2) - p1(ii, 2)) * (p3(ii, 1) - p1(ii, 1))) < 0
            ppl__c(ii, 2) = ppl__c(ii, 2) * -1;
        end
    end
else
    if sign((p2(1) - p1(1)) * (p3(2) - p1(2)) - (p2(2) - p1(2)) * (p3(1) - p1(1))) < 0
        ppl__c(:,2) = ppl__c(:,2) * -1;
    end
end

%Rename Result
transformedPoints = ppl__c;

if isstruct(points)
    points.xy = transformedPoints;
    points.x = transformedPoints(:,1);
    points.y = transformedPoints(:,2);
    transformedPoints = points;
end
end
