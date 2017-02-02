function [floatingRwRCS, ppm] = DrawFloatingCoordinateSystem(vro, trajectory1, trajectory2, preferredCenterOrRwRCS)
% This function calls the ususal routine for creating a coordinate system.
% In addition, it stitches the coordinate system to the given track points.

    tp1 = PhysTrack.StructToArr(trajectory1);
    tp2 = PhysTrack.StructToArr(trajectory2);
    if nargin == 4
        if size(preferredCenterOrRwRCS, 1) == 1 % its a center
            preferredCenterOrRwRCS = [preferredCenterOrRwRCS;[preferredCenterOrRwRCS(1) + 100, preferredCenterOrRwRCS(2)];[preferredCenterOrRwRCS(1), preferredCenterOrRwRCS(2) + 50]];
        end

        [rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro, preferredCenterOrRwRCS);
    elseif nargin == 3 % no preferred point or rwRCS
        [rwRCS, ppm] = PhysTrack.DrawCoordinateSystem(vro);
    end
    floatingRwRCS = PhysTrack.StitchObjectToPoints(rwRCS, tp1, tp2);
    PhysTrack.DrawCoordinateSystem(vro, floatingRwRCS);
end

