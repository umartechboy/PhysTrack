function [floatingRwRCS, ppm] = DrawFloatingCoordinateSystemNonRotating(vro, trajectory, preferredCenterOrRwRCS)
% This function calls the ususal routine for creating a coordinate system.
% In addition, it stitches the coordinate system to the given track point.
% The direction of the system won't change.

    tp1 = PhysTrack.StructToArr(trajectory);
    if nargin == 3
        if size(preferredCenterOrRwRCS, 1) == 1 % its a center
            preferredCenterOrRwRCS = [preferredCenterOrRwRCS;[preferredCenterOrRwRCS(1) + 100, preferredCenterOrRwRCS(2)];[preferredCenterOrRwRCS(1), preferredCenterOrRwRCS(2) + 50]];
        end

        [rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro, preferredCenterOrRwRCS);
    elseif nargin == 3 % no preferred point or rwRCS
        [rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);
    end
    for ii = 1:1:size(tp1,1)
        rw1(ii, :) = tp1(ii,:) + rwRCS(1, :) - tp1(1,:);
        rw2(ii, :) = tp1(ii,:) + rwRCS(2, :) - tp1(1,:);
        rw3(ii, :) = tp1(ii,:) + rwRCS(3, :) - tp1(1,:);
    end
    floatingRwRCS.tp1 = PhysTrack.ArrToStr(rw1);
    floatingRwRCS.tp2 = PhysTrack.ArrToStr(rw2);
    floatingRwRCS.tp3 = PhysTrack.ArrToStr(rw3);
    PhysTrack.DrawCoordinateSystem(vro, floatingRwRCS);
end