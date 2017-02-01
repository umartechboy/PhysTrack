function I = getImgOnInd(vr2o, ind, showRgb, thresh, bkIsLight)
%IMTOSHOW Summary of this function goes here
%   Detailed explanation goes here

if showRgb
    I = PhysTrack.read2(vr2o, ind); 
    return;
else
    thresh(end,:) = [];
    if size(thresh, 1) == 0
        [hi, hi, th] = PhysTrack.imhistSmooth(PhysTrack.read2(vr2o, ind, false, true), 0, true);
    elseif size(thresh, 1) == 1
        th = thresh(1,2);
    else
        fit = PhysTrack.lsqFun3(thresh(:,1), thresh(:,2), 'th', PhysTrack.getPolynomialFunction(size(thresh, 1) - 1), 'x');
        th = max(min(uint8(round(fit(ind))), 255), 1);
    end
    if bkIsLight
        I = rgb2gray(PhysTrack.read2(vr2o, ind)) <= th;
        return;
    else
        I = rgb2gray(PhysTrack.read2(vr2o, ind)) > th;
        return;
    end
end
end

