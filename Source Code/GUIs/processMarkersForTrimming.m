function vr2o = processMarkersForTrimming(vr2o, inFrameMaker, outFrameMarker )
%Processes the given vr20 and the trimming markers (can be []) for sudden
%changes in the brightness. If the markers are valid and a significant
%brightness change is detected, the relevant frame will be marked in-out
%depending upon a sanity rule.

skipping = 30;
if length(inFrameMaker) == 4
    inInd = findBrightnessEdge(vr2o, inFrameMaker, 1, skipping, 'Finding In-Frame (coarse)');
    if inInd > 1 % refine the search
        inInd = findBrightnessEdge(vr2o, inFrameMaker, inInd - skipping, 1, 'Finding In-Frame (Fine)');
    else
        inInd = vr2o.ifi;
    end
else
    inInd = vr2o.ifi;
end

if length(outFrameMarker) == 4
    outInd = findBrightnessEdge(vr2o, outFrameMarker, inInd, skipping, 'Finding Out-Frame (coarse)');
    if outInd > inInd % refine the search
        outInd = findBrightnessEdge(vr2o, outFrameMarker, outInd - skipping, 1, 'Finding Out-Frame (Fine)');
    else
        outInd = vr2o.ofi;
    end
else
    outInd = vr2o.ofi;
end
if outInd < inInd 
    outInd = inInd;
end
vr2o.ifi = inInd;
vr2o.ofi = outInd;
vr2o.TotalFrames = outInd - inInd + 1;

end

