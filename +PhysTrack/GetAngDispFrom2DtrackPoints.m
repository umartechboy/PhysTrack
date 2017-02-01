function displacement = GetAngDispFrom2DtrackPoints(trackPoints1, trackPoints2)
%
% Based on the assumptions that the track point variables represent two
% different points on a pivoted rotating object, this function calculates
% Angular Displacement of the complete motion.
%   trackPoints :  is a list of positions of a single track point as
%                   captured throughout the video
%

trackPoints1 = PhysTrack.StructToArr(trackPoints1);
if ~exist('trackPoints2')
    trackPoints2 = zeros(size(trackPoints1,1),2);
end
trackPoints2 = PhysTrack.StructToArr(trackPoints2);

v_tp12 = trackPoints2 - trackPoints1;
v_tp12(end,3) = 0;
displacement = [0];
for ii = 1: size(v_tp12,1)-1
    [th,r] = cart2pol(v_tp12(ii:ii+1, 1), v_tp12(ii:ii+1, 2));
    cp = cross(v_tp12(ii,:,:), v_tp12(ii + 1,:,:));
    th12 = th(2) - th(1);
    if (cp(3) < 0) %CW Rot
        while th12 > 0
            th12 = th12 - 2 * pi;
        end        
    end
    if (cp(3) > 0) %CW Rot
        while th12 < 0
            th12 = th12 + 2 * pi;
        end        
    end    
    displacement(end + 1) = th12 + displacement(end);
    displacement = displacement';
end
end
