function objs = bd_1(vro, ifi, ofi, cRect, cPreMag, thresh, selObjects, closeSize, umpp, saveAddress, posTol)    
    % cRect = cropRect; thresh = binThresh; saveAddress = 'output.avi';
    watchon;
    if ~exist('posTol')
        posTol = 4000;
    end
    if  size(selObjects, 1) == 0
        objs = struct('Objects', [], 'TimeStamps', [], 'ObjectsCount', 0, 'FramesCount', 0);
        return;
    end
    % check if we need to save the output
    if ~isempty(saveAddress)
        vwo = VideoWriter(saveAddress);
        vwo.FrameRate = vro.FrameRate;
        vwo.open();
    end
    % prepare the datatypes
    objs = struct('x', 0, 'y', 0, 'dx', 0, 'dy', 0, 'rp2', 0, 'validity', 0);
    for ii = 2:size(selObjects, 1)
        objs(end + 1) = struct('x', 0, 'y', 0, 'dx', 0, 'dy', 0, 'rp2', 0, 'validity', 0);
    end
    % open the video
    fileName = strcat(vro.Path, '\', vro.Name);
    vfr = vision.VideoFileReader(fileName);
    % skip the frames before ifi
    for jj= 1: ifi - 1
        step(vfr);
    end
    
    % some variables to be used in the loop
    se = strel('disk', closeSize);
    crsr = 0;    % used as a one based index in the loop
    lost = false; % used to set a flag that the tracking is lost
    fh = figure; % figure used to display the processing frame
    wbh = waitbar(0, 'Starting...'); % handle of waitbar used to show the progress
    for ii = ifi:ofi           
        crsr = crsr + 1; 
        % temporarily acquire the positions before appending them in the
        % final results
        sObs = [];
        % small frame. Also used for preparing the preview
        sFrame = uint8(imcrop(step(vfr), cRect)*256);
        % the main binary frame for processing
        frame =  imclose(rgb2gray(imresize(sFrame , cPreMag)) <= thresh, se);
        % extract the centroids
        fObs = regionprops(frame, {'centroid'});        
        
        % in case of first frame, just store the points in the first index
        % of result array. coz the values in selObjects is also calculated
        % using same method
        if ii == ifi            
            for jj = 1:size(selObjects,1)
                objs(jj).x = selObjects(jj, 1);
                objs(jj).y = selObjects(jj, 2);
                objs(jj).validity = 1;
            end
            continue;
        end
        % match the centroids with the selected centroids
        for jj = 1:size(selObjects,1)
            for kk = 1:size(fObs,1)                
                rhs = abs((fObs(kk).Centroid(1) - objs(jj).x(crsr - 1))^2 + (fObs(kk).Centroid(2) - objs(jj).y(crsr - 1))^2) / (posTol)*100;
                lhs = selObjects(jj,3) * 2; % dia of obj
                if lhs > rhs % object matched
                    sObs(end + 1, :) = [fObs(kk).Centroid(:); 1];
                    break;
                end
            end
            
            % check if a match was found for this centroid in the processed
            % frame
            if size(sObs, 1) < jj                
                sObs(end + 1, 1:3) = [objs(jj).x(end), objs(jj).y(end), 0];
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
            objs(jj).x(crsr) = sObs(jj, 1);
            objs(jj).y(crsr) = sObs(jj, 2);
            objs(jj).validity(crsr) = sObs(jj, 3);
            if sObs(jj, 3) == 0
                totalValid = totalValid - 1;
            end
            col = [0, 255, 255];
            if mean(objs(jj).validity) < 1
                col = [255, 0, 0];
            end
            sFrame = drawCrossHairMarks(sFrame, [sObs(jj,1:2), selObjects(jj,3)]/double(cPreMag), col);            
            
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
    for ii = 1:size(selObjects, 1)
        objs(ii).x = objs(ii).x(1:end-1) * umpp / double(cPreMag);
        objs(ii).y = objs(ii).y(1:end-1) * umpp / double(cPreMag);
        objs(ii).dx = objs(ii).x - objs(ii).x(1);
        objs(ii).dy = objs(ii).y(:) - objs(ii).y(1);
        objs(ii).rp2 = (objs(ii).x - objs(ii).x(1)).^2 + (objs(ii).y - objs(ii).y(1)).^2;  
        objs(ii).validity = mean(objs(ii).validity(1:end-1));
        rn2 = rn2 + objs(ii).rp2;        
    end
    rn2 = rn2/size(selObjects,1);
    % prepare time stamps
    tStamps = linspace(double(0), double(1 / vro.FrameRate * double(ofi-ifi)), length(objs(1).x)); 
    validObjects = [];
    objs2 = struct('x', 0, 'y', 0, 'dx', 0, 'dy', 0, 'rp2', 0);
    for ii = 1:size(objs,2)
        if objs(ii).validity == 1
            objs2(end + 1).x = objs(ii).x;
            objs2(end).y = objs(ii).y;
            objs2(end).dx = objs(ii).dx;
            objs2(end).dy = objs(ii).dy;
            objs2(end).rp2 = objs(ii).rp2;
            validObjects(end+1,:) = selObjects(ii,:);
        end
    end
    objs2(1) = [];
    
    % prepare the final result
    objs = struct('Objects', objs2, 'AllObjects', objs, 'rn2', rn2,'TimeStamps', tStamps, 'AllObjectsCount', size(selObjects,1), 'ValidObjectsCount', size(objs2, 2), 'FramesCount', size(tStamps,2));
   
    % clean up the workspace
    if ~isempty(saveAddress)
        vwo.close();
    end
    watchoff;
    close(wbh);
    close(fh);    
end