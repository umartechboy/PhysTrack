function I = getBinKeyFramesImage( vr2o, thresh )
    I = uint8(ones(5, 255, 3)) * 255;
    for ii = 1: (size(thresh, 1) - 1)
        ind = min(max(round(((double(thresh(ii, 1))) * 255) / vr2o.TotalFrames), 1), 255);
        m = 254 / double(vr2o.TotalFrames - 1);
        c = 1 - m;
        ind = m * thresh(ii, 1) + c;
        I(:, ind, :) = 0;
    end
end

