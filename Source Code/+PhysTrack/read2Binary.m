function I = read2Binary(vr2o, frameInd, indIsAbsolute)
%READ2BINARY Summary of this function goes here
%   Detailed explanation goes here

    if ~isa(vr2o.BinaryThreshold, 'cfit')
        warning 'The selected video does not contain any binary conversion information.'
        return;
    end
    I = PhysTrack.read2(vr2o, frameInd, indIsAbsolute); 
end

