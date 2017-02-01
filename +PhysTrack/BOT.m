function traj = BOT(vro, obs, saveAddress)
%Binray object tracker tracks objects in a binary video.
if nargin == 2
    saveAddress = false;
end
if ~isstruct(vro.BinaryThreshold)
    error('The binary object tracker works on a binary video. This video reader object does not contain any binary conversion data.');
end
    watchon;
    if ~exist('posTol')
        posTol = 4000;
    end
    if  size(obs, 1) == 0
        retObs = [];
        return;
    end
    % prepare the datatypes
    objs = struct('x', 0, 'y', 0, 'dx', 0, 'dy', 0, 'rp2', 0, 'validity', 0);
    for ii = 2:size(selObjects, 1)
        objs(end + 1) = struct('x', 0, 'y', 0, 'dx', 0, 'dy', 0, 'rp2', 0, 'validity', 0);
    end
    % check if we need to save the output
    if ~isempty(saveAddress)
        vwo = VideoWriter(saveAddress);
        vwo.FrameRate = vro.FrameRate;
        vwo.open();
    end
    % some variables to be used in the loop
    se = strel('disk', 4);
    crsr = 0;    % used as a one based index in the loop
    lost = false; % used to set a flag that the tracking is lost
    fh = figure; % figure used to display the processing frame
    wbh = waitbar(0, 'Starting...'); % handle of waitbar used to show the progress
    for ii = 1:vro.TotalFrames    
        % temporarily acquire the positions before appending them in the
        % final results
        sObs = [];
        % the main binary frame for processing
        frame =  imclose(PhysTrack.read2(vro, ii), se);
        % extract the centroids
        fObs = regionprops(frame, {'centroid'});        
        
        % in case of first frame, just store the points in the first index
        % of result array. coz the values in selObjects is also calculated
        % using same method
        if ii == ifi            
            for jj = 1:size(obs,1)
                retObs(jj).x = obs(jj, 1);
                retObs(jj).y = obs(jj, 2);
                retObs(jj).validity = 1;
            end
            continue;
        end
        % match the centroids with the selected centroids
        for jj = 1:size(obs,1)
            for kk = 1:size(fObs,1)                
                rhs = abs((fObs(kk).Centroid(1) - retObs(jj).x(crsr - 1))^2 + (fObs(kk).Centroid(2) - retObs(jj).y(crsr - 1))^2) / (posTol)*100;
                lhs = obs(jj,3) * 2; % dia of obj
                if lhs > rhs % object matched
                    sObs(end + 1, :) = [fObs(kk).Centroid(:); 1];
                    break;
                end
            end
            
            % check if a match was found for this centroid in the processed
            % frame
            if size(sObs, 1) < jj                
                sObs(end + 1, 1:3) = [retObs(jj).x(end), retObs(jj).y(end), 0];
                % watchoff;
                % waitfor(msgbox('Tracking process was stopped because one or more of the selected objects were lost.'));
                % lost  = true;
                % break;
            end
        end
        % if lost
        %     break;
        % end
        % store the centroids in the resulting array
        totalValid  = size(sObs,1);
        for jj = 1:size(sObs,1)
            retObs(jj).x(crsr) = sObs(jj, 1);
            retObs(jj).y(crsr) = sObs(jj, 2);
            retObs(jj).validity(crsr) = sObs(jj, 3);
            if sObs(jj, 3) == 0
                totalValid = totalValid - 1;
            end
            col = [0, 255, 255];
            if mean(retObs(jj).validity) < 1
                col = [255, 0, 0];
            end
            sFrame = drawCrossHairMarks(sFrame, [sObs(jj,1:2), obs(jj,3)]/double(cPreMag), col);            
            
        end
        % preview the progress            
        warning off
        imshow(sFrame); 
        if ~isempty(saveAddress)
            writeVideo(vwo, sFrame);
        end
        waitbar(double(ii - ifi + 1) / double(ofi - ifi + 1), wbh, ...
            ['Total objects: ', num2str(totalValid), '/', num2str(size(sObs,1)),...
            ', Processed frame ', num2str(ii - ifi + 1), ' of ', num2str(ofi - ifi + 1), ...
            ' (', num2str(round(double(ii - ifi + 1) / double(ofi - ifi + 1) * 100)), '%)']);
    end   
    % prepare r^2
    rn2 = 0;
    for ii = 1:size(obs, 1)
        retObs(ii).x = retObs(ii).x(1:end-1) * umpp / double(cPreMag);
        retObs(ii).y = retObs(ii).y(1:end-1) * umpp / double(cPreMag);
        retObs(ii).dx = retObs(ii).x - retObs(ii).x(1);
        retObs(ii).dy = retObs(ii).y(:) - retObs(ii).y(1);
        retObs(ii).rp2 = (retObs(ii).x - retObs(ii).x(1)).^2 + (retObs(ii).y - retObs(ii).y(1)).^2;  
        retObs(ii).validity = mean(retObs(ii).validity(1:end-1));
        rn2 = rn2 + retObs(ii).rp2;        
    end
    rn2 = rn2/size(obs,1);
    % prepare time stamps
    tStamps = linspace(double(0), double(1 / vro.FrameRate * double(ofi-ifi)), length(retObs(1).x)); 
    validObjects = [];
    objs2 = struct('x', 0, 'y', 0, 'dx', 0, 'dy', 0, 'rp2', 0);
    for ii = 1:size(retObs,2)
        if retObs(ii).validity == 1
            objs2(end + 1).x = retObs(ii).x;
            objs2(end).y = retObs(ii).y;
            objs2(end).dx = retObs(ii).dx;
            objs2(end).dy = retObs(ii).dy;
            objs2(end).rp2 = retObs(ii).rp2;
            validObjects(end+1,:) = obs(ii,:);
        end
    end
    objs2(1) = [];
    
    % prepare the final result
    retObs = struct('Objects', objs2, 'AllObjects', retObs, 'rn2', rn2,'TimeStamps', tStamps, 'AllObjectsCount', size(obs,1), 'ValidObjectsCount', size(objs2, 2), 'FramesCount', size(tStamps,2));
   
    % clean up the workspace
    if ~isempty(saveAddress)
        vwo.close();
    end
    watchoff;
    close(wbh);
    close(fh);    

end

