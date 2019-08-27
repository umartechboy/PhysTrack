canResume = false;
failedFrame = ff;
resumeFrom = ff - 1;
if resumeFrom < 1
    questdlg('The tracker could not be rewinded', '', 'OK', 'OK');
    canResume = false;
else
    % kk is obj Num
    % ff is frame num
    tPoints2 = eval(['tPointsForResume_', inS]);
    mp2 = mean(tPoints2, 1);
    lastMeanX = mp2(1);
    lastMeanY = mp2(2);
    thisObj = objs(kk, :);
    newObj = [lastMeanX-thisObj(3)/2, lastMeanY-thisObj(4)/2, thisObj(3), thisObj(4)];
    while true
        canResume = true;
        relocatedObj = PhysTrack.GetObjects(vr2o, resumeFrom, newObj);
        if length(relocatedObj) ~= 4
            questdlg('Kindly select an object', '', 'OK', 'OK');
            continue;
        end
        
        iiFrame = PhysTrack.read2(vr2o, resumeFrom, false, true, false, vr2o.TrackInReverse);
        eval(['points',num2str(kk),' = detectMinEigenFeatures(rgb2gray(iiFrame), ''ROI'', relocatedObj);']);
        ii = kk;
        PhysTrack.makeTrackerII;
        imshow(iiFrame);
        drawnow;
        pause(1);
        hold on;
        
        for ll = 1:2
            frame = PhysTrack.read2(klt_vr2o_00, resumeFrom + ll - 1, false, true, false, vr2o.TrackInReverse);
            out = frame;
            eval(['[tPoints, validity] = step(tracker', inS, ', frame);']);
            eval(['out = insertMarker(out, tPoints(validity, :), ''o'', ''Size'', 5, ''Color'', PhysTrack.GetColor(',inS,'));']);
            imshow(out,'InitialMagnification',200);
            drawnow;
            pause(1);
            if (ll == 1)                
                thisMeanX = mean(tPoints(:,1));
                thisMeanY = mean(tPoints(:,2));
                thisOffset_t = [lastMeanX - thisMeanX, lastMeanY - thisMeanY];
            end
        end
        
        if mean(validity) < 0.00001            
            if strcmp(questdlg('The new object could not be tracked either. Do you want to select the object again?', '', 'Yes', 'No', 'Yes'), 'Yes')
               continue;
            else
                canResume = false;
            break;
            end
        end
        break;
    end
    thisOffset = [0, 0];
    if canResume
        thisOffset = thisOffset_t;
    end
end