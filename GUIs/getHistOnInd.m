function [I, th, bkIsBright] = getHistOnInd(vr, thresh, ind)
%GETBINIMG Summary of this function goes here
%   Detailed explanation goes here
thresh = double(thresh);
if size(thresh, 1) == 1 % no keyframes
    [I, histo, th, bkIsBright] = PhysTrack.imhistSmooth(PhysTrack.read2(vr, ind, false, true), thresh(2), false);
    return;
elseif size(thresh, 1) == 2 % no fitting needed
    [I, histo, th, bkIsBright] = PhysTrack.imhistSmooth(PhysTrack.read2(vr, ind, false, true), thresh(1,2), false);
    return;
else % fit the data
    threshFit = PhysTrack.lsqCFit(thresh(1:end-1,1), thresh(1:end-1,2), 'th', PhysTrack.getPolynomialFunction(size(thresh, 1) - 2), 'x');
    th = max(min(uint8(round(threshFit(ind))), 255), 1);
    [I, histo, th, bkIsBright] = PhysTrack.imhistSmooth(PhysTrack.read2(vr, ind, false, true), th, false);
    return;
end

end

