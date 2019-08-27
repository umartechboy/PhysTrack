%KLTMPT KLT MultiPointTracker
%   This tracker is based on KLT algorithm. It uses the in-built KLT
%   tracker to track multiple objects simultaneously.

    set(handles.beginB, 'Enable', 'off');
    global klt_gui_00_vr2o klt_gui_00_objs klt_gui_00_previewDownSample
    vr2o = klt_gui_00_vr2o;
    vr2o_bkp = vr2o;
    objs = klt_gui_00_objs;
    previewDownSample = klt_gui_00_previewDownSample;
    warning off;
    sceneFrame = PhysTrack.read2(vr2o, 1, false, true, false, vr2o.TrackInReverse);
    for kk = 1: size(objs, 1);
        eval(['points',num2str(kk),' = detectMinEigenFeatures(rgb2gray(sceneFrame), ''ROI'', objs(kk,:));']);
    end
    
    %Display the detected points.
    pointImage = sceneFrame;
    offsets = [];
    for kk = 1: size(objs, 1);
        eval(['pointImage = insertMarker(pointImage, points',num2str(kk),'.Location, ''+'', ''Color'', ''white'');']);
        offsets(kk, :) = [0, 0];
    end
    axes(handles.axes1);
    imshow(pointImage,'InitialMagnification',100);
    
    % initialize local and global variables
    evalin('base', 'global klt_tObs_00');
    evalin('base', 'global klt_vr2o_00');    
    global klt_tObs_00 klt_vr2o_00
    klt_vr2o_00 = vr2o;
    klt_tObs_00 = size(objs, 1);
    for ii = 1:klt_tObs_00
        iiFrame = sceneFrame;
        PhysTrack.makeTrackerII;
        eval(['klt_trackPoints_00_', inS, ' = [];']);
        eval(['klt_trail_00_', inS, ' = [];']);
        eval(['klt_PointsValidity_00_', inS, ' = [];']);
    end
    broken = false;
    ff = 0;
    framesDone = 0;
    avgSpeed = -1;
    tic;
    speedStr = '';
    abort = false;
    while ff < klt_vr2o_00.TotalFrames
        ff = ff + 1;
        framesDone = framesDone + 1;
        frame = PhysTrack.read2(klt_vr2o_00, ff, false, true, false, klt_vr2o_00.TrackInReverse);
        if rem(ff, previewDownSample) == 0
            out = frame;
        end
        for kk = 1: size(objs, 1);
            inS = num2str(kk);
            eval(['[tPoints, validity] = step(tracker', inS, ', frame);']);
            

            lastValidFID = ff;
            if mean(validity) < 0.000001 || abort %track was lost
                canResume = false;
                if ~abort 
                    canResume = strcmp(questdlg('Validity of one of the track points has dropped below critical level. Do you want to select the object again?', 'Track point was lost', 'Yes', 'No', 'Yes'), 'Yes');
                end
                if canResume
                    tPoints = [];
                    PhysTrack.tryToResumeTrack;
                    if ~canResume
                        klt_vr2o_00.TotalFrames = lastValidFID - 1;
                        klt_vr2o_00.ofi = klt_vr2o_00.ifi + klt_vr2o_00.TotalFrames - 1;
                        broken = true;
                    else            
                        framesDone = 0;
                        tic;
                        offsets(kk, :) = thisOffset;
                    end
                else
                    klt_vr2o_00.TotalFrames = lastValidFID - 1;
                    klt_vr2o_00.ofi = klt_vr2o_00.ifi + klt_vr2o_00.TotalFrames - 1;
                    broken = true;
                    break;
                end
            end
            tPoints = [tPoints(:, 1) + offsets(kk, 1), tPoints(:, 2) + offsets(kk, 2)];
                        
            % make the tPoints and array set dimensions consistent
            if  eval(['size(klt_trackPoints_00_', inS, ', 1)']) > 0
                if size(tPoints, 1) > eval(['size(klt_trackPoints_00_', inS, ', 1)'])
                    xmax = size(tPoints, 1);
                    ymax = eval(['size(klt_trackPoints_00_', inS, ', 2);']);
                    zmax = eval(['size(klt_trackPoints_00_', inS, ', 3);']);
                    eval(['klt_trackPoints_00_', inS, '(xmax, ymax, zmax) = 0;']);
                    eval(['klt_PointsValidity_00_', inS, '(xmax, zmax) = 0;']);
                elseif size(tPoints, 1) < eval(['size(klt_trackPoints_00_', inS, ', 1)'])                        
                    xmax = eval(['size(klt_trackPoints_00_', inS, ', 1);']);
                    tPoints(xmax, 2) = 0;
                    validity(xmax) = 0;
                end
            end

            ind = ff;
            eval(['klt_trackPoints_00_', inS, '(:,:, ',num2str(ind),') = tPoints;']);
            eval(['klt_PointsValidity_00_', inS, '(:,',num2str(ind),') = validity;']);
            eval(['tPointsForResume_', inS,' = tPoints(validity, :);']);
            if rem(ff, previewDownSample) == 0
                mp = mean(tPoints(validity, :), 1);
                if get(handles.showAllPointsCB, 'Value')
                    eval(['out = insertMarker(out, tPoints(validity, :), ''o'', ''Size'', 12, ''Color'', PhysTrack.GetColor(',inS,'));']);                        
                else          
                    out = insertMarker(out, mp, 'o', 'Size', 15, 'Color', PhysTrack.GetColor(kk));
                end

                thisObj = objs(kk, :);
                objToShow = [mp(1)-thisObj(3)/2, mp(2)-thisObj(4)/2, thisObj(3), thisObj(4)];
                eval(['out = insertShape ( out , ''rectangle'', objToShow , ''LineWidth'' , 5 , ''Color'' , PhysTrack.GetColor(',inS,'));']);


                if get(handles.showTrailCB, 'Value')
                    eval(['klt_trail_00_', inS, '(end + 1, :) = mean(tPoints(validity, :), 1);']);
                    if size(eval(['klt_trail_00_', inS]), 1 ) > 10
                        eval(['klt_trail_00_', inS, '(1, :) = [];']);
                    end
                    eval(['out = insertMarker(out, ', 'klt_trail_00_', inS, ', ''*'', ''Size'', 15, ''Color'', PhysTrack.GetColor(',inS,'));']);
                end
                
                out = insertText(out, [10 10 ], ['Frame: ', num2str(ff)], 'FontSize',40);
            end
        end
        
        if framesDone >= 20
            speed = framesDone / toc;
            if avgSpeed == -1
                avgSpeed = speed;
            else
                avgSpeed = speed * 0.01 + avgSpeed * 0.99;                
            end
            remainingTime = round((klt_vr2o_00.TotalFrames - ff) / avgSpeed);
            minStr = '';
            mins = 0;
            while remainingTime >= 60
                mins = mins + 1;
                remainingTime = remainingTime - 60;
            end
            if mins > 0
                minStr = [num2str(mins), ' m, '];
            end
            speedStr = ['(', minStr, num2str(remainingTime),' s remaining)'];
            tic;
            framesDone = 0;
        end
        if rem(ff, previewDownSample) == 0            
            if  strcmp(get(handles.abortB, 'Enable'), 'off')
               abort = true;
            end
            if  get(handles.autoUpdateCB, 'Value')
                imshow(out,'InitialMagnification',200);
            end
            drawnow;
            %h = waitbar(0, 'Creating trajectory of track pointer');
            % ['Creating trajectory of track pointer: ', num2str(round(double(ff)/double(vr2o.TotalFrames)*100)), '% ', speedStr]);
            set(handles.progressL, 'String', [num2str(round(double(ff)/double(vr2o.TotalFrames)*100)), '% ']);
            set(handles.remainingL, 'String',speedStr);
        end
        if broken 
            break;
        end
    end
%     
%     for kk = 1: klt_tObs_00
%         eval(['klt_trackPoints_00_', num2str(kk), '(:,:,1) = [];']);
%         eval(['klt_PointsValidity_00_', num2str(kk), '(:,1) = [];']);
%     end


    % filter out track pointer
    if ~abort
        if strcmp(questdlg('Do you want to filter out some wrong track points?', 'Refine your results', 'Yes', 'No', 'Yes'), 'Yes')
            KLTFilterTool;
        end
    end
    
    for jj = 1: klt_tObs_00
        inS = num2str(jj);
        remInds = [];
        for kk = 1:eval(['size(klt_PointsValidity_00_', inS, ',1)'])
            if eval(['mean(klt_PointsValidity_00_', inS, '(kk,:)) < 0.000000001'])
                remInds(end + 1) = kk;
            end
        end
        if ~isempty(remInds)
            % eval(['klt_PointsValidity_00_', inS, '(remInds,:) = [];']);
            eval(['klt_trackPoints_00_', inS, '(remInds,:,:) = [];']);
            eval(['klt_PointsValidity_00_', inS, '(remInds,:) = [];']);
        end
    end
    
    
    % find min sized object
    minFrames = size(klt_trackPoints_00_1, 3);
    for kk = 1: klt_tObs_00
        inS = num2str(kk);   
        if eval(['size(klt_trackPoints_00_', inS, ', 3)']) < minFrames
            minFrames = eval(['size(klt_trackPoints_00_', inS, '3']);
        end
    end
    tFrames = minFrames;
    % squeeze the arrays. Its for an  old glitch removal
    for kk = 1: klt_tObs_00
        inS = num2str(kk);        
        eval(['finalPoints_', inS, ' = zeros(tFrames, 2);']);
        for ff = 1:tFrames
            try
                allPointsAtff = eval(['klt_trackPoints_00_', inS, '(:,:,',num2str(ff),')']);
                validityAtff = eval(['klt_PointsValidity_00_', inS, '(:,',num2str(ff),')']);
                validPointsAtff = allPointsAtff(validityAtff > 0, :);
                eval(['finalPoints_', inS, '(ff, :) = mean(validPointsAtff, 1);']);
            catch
                error 'asdasd'
            end
        end
    end
    for kk = 1:klt_tObs_00
        eval(['objStr', num2str(kk), '= struct(',...
            '''x'', finalPoints_', num2str(kk) ,'(end:-1:1,1), '...
            '''y'', finalPoints_', num2str(kk) ,'(end:-1:1,2), '...
            '''xy'', finalPoints_', num2str(kk) ,'(end:-1:1,:)'...
            ');']);
    end
    trajStr = 'struct(';    
    for kk = 1: klt_tObs_00
        trajStr = [trajStr, '''tp', num2str(kk), ''', objStr', num2str(kk)];
        if kk < size(objs, 1)
            trajStr = [trajStr, ','];
        end
    end
    trajStr = [trajStr, ');'];
    trajectories = eval(trajStr);
    % clean-up
    for kk = 1: klt_tObs_00
        evalin('base', ['clear klt_PointsValidity_00_', num2str(kk)]);
        evalin('base', ['clear klt_trackPoints_00_', num2str(kk)]);
        eval(['clear klt_trail_00_', num2str(kk)]);
    end
    evalin('base', 'clear ans klt_vr2o_00 klt_tObs_00');
    
    klt_vr2o_00.TotalFrames = tFrames;
    klt_vr2o_00.ofo = klt_vr2o_00.ofi + klt_vr2o_00.TotalFrames - 1;
    vr2o_new = klt_vr2o_00;
    
    %if ~abort 
        evalin('base', 'global klt_trajectories_00 klt_vr2o_new_00');
        global klt_trajectories_00 klt_vr2o_new_00
        klt_trajectories_00  = trajectories;
        klt_vr2o_new_00 = vr2o_new;
        % extract vr2o_new trajectories
    %else
     %   klt_trajectories_00 = [];
     %   klt_vr2o_new_00 = vr2o_bkp;
    %end