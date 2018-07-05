function filledStruct = FillDerivatives( trackPoints, t)
%FILLDERIVATIVES Computes first and second order dirivates for all the
%trajectories included and adds them in the original trajectories struct.

    if nargin < 2
        error('Not enough arguments');
    end
    if isstruct(trackPoints)
        if PhysTrack.IsTpStruct(trackPoints)
            vars = fieldnames(trackPoints);
            for ii = 1:length(vars)
                 eval(['filledStruct.', strjoin(vars(ii)), ' = PhysTrack.FillDerivatives(trackPoints.', strjoin(vars(ii)), ', t);'])
            end
            return;
        else % fill data here
            filledStruct.dx = trackPoints.x - trackPoints.x(1);
            filledStruct.dy = trackPoints.y - trackPoints.y(1);
            filledStruct.td = t;
            
            [tv, filledStruct.vx] = PhysTrack.deriv(t, filledStruct.dx, 1);
            [tv, filledStruct.vy] = PhysTrack.deriv(t, filledStruct.dy, 1);
            filledStruct.tv = tv;
            
            [ta, filledStruct.ax] = PhysTrack.deriv(t, filledStruct.dx, 2);
            [ta, filledStruct.ay] = PhysTrack.deriv(t, filledStruct.dy, 2);
            filledStruct.ta = ta;
        end
    else
        filledStruct = PhysTrack.FillDerivatives(PhysTrack.ArrToStr(trackPoints), t);
    end
    
% At this point, trajectory will be an array.
end

