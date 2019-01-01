function [trajectories, vr2o_new] = KLT2
%KLTMPT KLT MultiPointTracker (Part2: Filtration and beyond)
%   This tracker is based on KLT algorithm. It uses the in-built KLT
%   tracker to track multiple objects simultaneously.

    % filter out track pointer
    close all;
    if strcmp(questdlg('Do you want to filter out some wrong track points?', 'Refine your results', 'Yes', 'No', 'Yes'), 'Yes')
        KLTFilterTool;
    end
    global klt_tObs_00 klt_objs_00
    objs = klt_objs_00;
    
    for jj = 1: klt_tObs_00
        inS = num2str(jj);
        eval(['global klt_trackPoints_00_', inS]);
        eval(['global klt_PointsValidity_00_', inS]);
        inS = num2str(jj);
        remInds = [];
        for kk = 1:eval(['size(klt_PointsValidity_00_', inS, ',1)'])
            if eval(['mean(klt_PointsValidity_00_', inS, '(kk,:)) < 0.000001'])
                remInds(end + 1) = kk;
            end
        end
        if ~isempty(remInds)
            % eval(['klt_PointsValidity_00_', inS, '(remInds,:) = [];']);
            eval(['klt_trackPoints_00_', inS, '(remInds,:,:) = [];']);
            eval(['klt_PointsValidity_00_', inS, '(remInds,:) = [];']);
        end
    end
    close all;
    
    % squeeze the arrays. Its for an  old glitch removal
    for kk = 1: klt_tObs_00
        inS = num2str(kk);
        eval(['klt_trackPoints_00_', inS, ' = squeeze(mean(klt_trackPoints_00_', inS, ',1))'';']);
        eval(['klt_PointsValidity_00_', inS, ' = mean(klt_PointsValidity_00_', inS, ')'';']);
    end
    for kk = 1:klt_tObs_00
        eval(['objStr', num2str(kk), '= struct(',...
            '''x'', klt_trackPoints_00_', num2str(kk) ,'(:,1), '...
            '''y'', klt_trackPoints_00_', num2str(kk) ,'(:,2), '...
            '''xy'', klt_trackPoints_00_', num2str(kk) ,'(:,:), '...
            '''validity'', klt_PointsValidity_00_', num2str(kk), ');']);
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
    end
    evalin('base', 'clear ans klt_vr2o_00 klt_tObs_00 klt2Pending');
    
    klt_vr2o_00.TotalFrames = length(klt_trackPoints_00_1(:,1));
    vr2o_new = klt_vr2o_00;    
end

