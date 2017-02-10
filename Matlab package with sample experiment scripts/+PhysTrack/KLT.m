function [trajectories, vr2o_new] = KLT(vr2o, objs)
%KLTMPT KLT MultiPointTracker
%   This tracker is based on KLT algorithm. It uses the in-built KLT
%   tracker to track multiple objects simultaneously.
    warning off;
    sceneFrame = PhysTrack.read2(vr2o, 1, false, true);
    for ii = 1: size(objs, 1);
        eval(['points',num2str(ii),' = detectMinEigenFeatures(rgb2gray(sceneFrame), ''ROI'', objs(ii,:));']);
    end
    
    %Display the detected points.
    pointImage = sceneFrame;
    for ii = 1: size(objs, 1);
        eval(['pointImage = insertMarker(pointImage, points',num2str(ii),'.Location, ''+'', ''Color'', ''white'');']);
    end
    figure;
    imshow(pointImage,'InitialMagnification',100);
    title('Preview of Detected interest points');
    
    % initialize local and global variables
    evalin('base', 'global klt_tObs_00');
    evalin('base', 'global klt_vr2o_00');    
    global klt_tObs_00 klt_vr2o_00
    klt_vr2o_00 = vr2o;
    klt_tObs_00 = size(objs, 1);
    for ii = 1: klt_tObs_00
        %Initialize the tracker and related variables
        inS = num2str(ii);
        eval(['tracker', inS, ' = vision.PointTracker(''NumPyramidLevels'',4,''MaxBidirectionalError'', 10, ''MaxIterations'', 10);']);
        eval(['initialize(tracker', inS, ', points', inS, '.Location, sceneFrame)']);
        evalin('base', ['global klt_trackPoints_00_', inS]);
        evalin('base', ['global klt_PointsValidity_00_', inS]);
        eval(['global klt_trackPoints_00_', inS]);
        eval(['global klt_PointsValidity_00_', inS]);
        eval(['klt_trackPoints_00_', inS, ' = [];']);
        eval(['klt_PointsValidity_00_', inS, ' = [];']);
    end
    h = waitbar(0, 'Creating trajectory of track pointer');
    broken = false;
    for ff = 1:(vr2o.TotalFrames)
        frame = PhysTrack.read2(vr2o, ff, false, true);
        out = frame;
        for ii = 1: size(objs, 1);
            inS = num2str(ii);
            eval(['[tPoints, validity] = step(tracker', inS, ', frame);']);

                eval(['out = insertMarker(out, tPoints(validity, :), ''o'', ''Size'', 5, ''Color'', PhysTrack.GetColor(',inS,'));']);

            lastValidFID = ff;
            if mean(validity) < 0.5 %track was lost
                vr2o.ofi = vr2o.ofi + lastValidFID - 1;
                vr2o.TotalFrames = vr2o.ofi - vr2o.ifi + 1;
                questdlg('Validity of track points has dropped below 50%. Tracking will stop now.', 'Track point was lost', 'OK', 'OK');
                broken = true;
                break;
            else 
                eval(['klt_trackPoints_00_', inS, '(:,:, end+1) = tPoints;']);
                eval(['klt_PointsValidity_00_', inS, '(:,end+1) = validity;']);
            end
        end
        waitbar(double(ff)/double(vr2o.TotalFrames), h, ['Creating trajectory of track pointer: ', num2str(round(double(ff)/double(vr2o.TotalFrames)*100)), '%']);
        imshow(out,'InitialMagnification',200);
        if broken 
            break;
        end
    end
    close(h);
    
    for ii = 1: klt_tObs_00
        eval(['klt_trackPoints_00_', num2str(ii), '(:,:,1) = [];']);
    end

    % filter out track pointer
    close all;
    if strcmp(questdlg('Do you want to filter out some wrong track points?', 'Refine your results', 'Yes', 'No', 'Yes'), 'Yes')
        KLTFilterTool;
    end
    
    for jj = 1: klt_tObs_00
        inS = num2str(jj);
        remInds = [];
        for ii = 1:eval(['size(klt_PointsValidity_00_', inS, ',1)'])
            if eval(['mean(klt_PointsValidity_00_', inS, '(ii,:)) < 0.5'])
                remInds(end + 1) = ii;
            end
        end
        if length(remInds) > 0
            % eval(['klt_PointsValidity_00_', inS, '(remInds,:) = [];']);
            eval(['klt_trackPoints_00_', inS, '(remInds,:,:) = [];']);
        end
    end
    close all;
    
    % squeeze the arrays. Its for an  old glitch removal
    for ii = 1: klt_tObs_00
        inS = num2str(ii);
        eval(['klt_trackPoints_00_', inS, ' = squeeze(mean(klt_trackPoints_00_', inS, ',1))'';']);
        eval(['klt_PointsValidity_00_', inS, ' = mean(klt_PointsValidity_00_', inS, ')'';']);
    end
    for ii = 1:klt_tObs_00
        eval(['objStr', num2str(ii), '= struct(',...
            '''x'', klt_trackPoints_00_', num2str(ii) ,'(:,1), '...
            '''y'', klt_trackPoints_00_', num2str(ii) ,'(:,2), '...
            '''xy'', klt_trackPoints_00_', num2str(ii) ,'(:,:), '...
            '''validity'', klt_PointsValidity_00_', num2str(ii), ');']);
    end
    trajStr = 'struct(';    
    for ii = 1: klt_tObs_00
        trajStr = [trajStr, '''tp', num2str(ii), ''', objStr', num2str(ii)];
        if ii < size(objs, 1)
            trajStr = [trajStr, ','];
        end
    end
    trajStr = [trajStr, ');'];
    trajectories = eval(trajStr);
    % clean-up
    for ii = 1: klt_tObs_00
        evalin('base', ['clear klt_PointsValidity_00_', num2str(ii)]);
        evalin('base', ['clear klt_trackPoints_00_', num2str(ii)]);
    end
    evalin('base', 'clear ans klt_vr2o_00 klt_tObs_00');
    vr2o_new = vr2o;
end

