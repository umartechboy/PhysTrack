function [ distance ] = DistanceBetween( p1, p2 )
%DISTANCEBETWEEN Returns the distance between two points. Points can also
%be in a collection.
    if size(p1, 2) == 3
        distance = sqrt(((p1(1) - p2(1)).^2 + (p1(2) - p2(2)).^2 + (p1(3) - p2(3)).^2));
    else
        distance = sqrt(((p1(1) - p2(1)).^2 + (p1(2) - p2(2)).^2));
    end
end

