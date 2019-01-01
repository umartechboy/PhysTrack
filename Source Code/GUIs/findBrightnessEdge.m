function ind = findBrightnessEdge(vr2o, ROI, startInd, skipping, msg)
% searches for a sharp brightness change in the specified region and
% returns the index in which the change occures.
    wbh = waitbar(0, msg);
    ind = startInd;
    lastWhite = -1;
    if skipping == 0 
        skipping = 1;
    end
    for ii = startInd:skipping:vr2o.obj.NumberOfFrames
        waitbar((ii - startInd) / (vr2o.obj.NumberOfFrames - startInd), wbh);
        I = PhysTrack.read2(vr2o, ii, true, true);
        I = imcrop(I, ROI);
        I = rgb2gray(I);
        white = mean(mean(I));
        
        if lastWhite ~= -1
            if abs((white - lastWhite) / lastWhite) > 0.2
                if abs((white - lastWhite) / lastWhite) > 0.2
                    ind = ii;
                    break;
                end
            end
        end
        lastWhite = white;
    end
    close(wbh);
end
