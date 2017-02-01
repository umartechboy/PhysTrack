function transformedPoints = TransformCart2Cart(points, newAxes)
if nargin < 2
    error('Not enough arguments');
end
if isstruct(points)
    vars = fieldnames(points);
    isTpStruct = false;
    for ii = 1:length(vars)
        if ~isempty(find(strcmp(vars, 'tp1')))
            isTpStruct = true;
            break;
        end
    end
    if isTpStruct        
        ansStr = '';
        for ii = 1:100
            if ~isempty(find(strcmp(vars, ['tp', num2str(ii)])))
                if length(ansStr) > 0
                    ansStr = [ansStr, ', '];
                end
                ansStr = [ansStr, '''tp', num2str(ii),''', transPts', num2str(ii)];
                eval(['transPts', num2str(ii),' = PhysTrack.TransformCart2Cart(points.tp',num2str(ii),', newAxes);']);
            end
        end
        eval(['transformedPoints = struct(', ansStr, ');']);
        return;
    else
        vars = fieldnames(points);
        if ~isempty(find(strcmp(vars, 'xy')))
            points_ = points.xy;
        elseif ~isempty(find(strcmp(vars, 'x'))) && ~isempty(find(strcmp(vars, 'y')))
            if size(points.x, 2) == 1
                points_ = [points.x, points.y];
            else
                points_ = [points.x; points.y]';
            end
        end
    end
else
    points_ = points;
end
%axes in terms of points
p1= newAxes(1,:);
p2= newAxes(2,:);
p3= newAxes(3,:);

%C_p2 in translated coordinates
p2_(1:2) = p2(1:2) - p1(1:2);

%C-polygon in translated coordinates
ppl_(:,1) = points_(:,1) - p1(1);
ppl_(:,2) = points_(:,2) - p1(2);


%P_polygon in translated coordinates
[ppl_p(:, 1), ppl_p(:, 2)]  = cart2pol(ppl_(:,1), ppl_(:,2));

%P_p2 in translated coordinates
p2_p = cart2pol(p2_(1), p2_(2));

%P_polygon in translated, rotated coordinates
ppl__p = ppl_p(:,1) - p2_p(1);
ppl__p(:,2) = ppl_p(:,2);

%C_polygon in translated, rotated coordinates
[ppl__c(:, 1), ppl__c(:, 2)]  = pol2cart(ppl__p(:,1), ppl__p(:,2));

%C_polygon in translated, rotated coordinates, Fixed Y Sign
if sign((p2(1) - p1(1)) * (p3(2) - p1(2)) - (p2(2) - p1(2)) * (p3(1) - p1(1))) < 0
    ppl__c(:,2) = ppl__c(:,2) * -1;
end;

%Rename Result
transformedPoints = ppl__c;

if isstruct(points)
    points.xy = transformedPoints;
    points.x = transformedPoints(:,1);
    points.y = transformedPoints(:,2);
    transformedPoints = points;
end
end
