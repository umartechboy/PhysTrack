function VidPlot2(vro, trajectory, previewRender)
    
if (nargin == 2)
    previewRender = true;
end
    vars = fieldnames(trajectory);
    str = 'lines = struct(';
    for ii = 1:length(vars)
        eval(['x = trajectory.', vars{ii}, '.x;'])
        eval(['y = trajectory.', vars{ii}, '.y;'])
        str = [str, '''',vars{ii}, '''', ', [x(1), y(1), x(1), y(1)]'];
        if (ii + 1 <= length(vars))
            str = [str, ', '];
        end
    end
    str = [str, ');']
    eval(str);
    ink = PhysTrack.read2(vro, 1) * 0;
    mask = ink + 1;

    if nargin == 3
        previewRender = true;
    end
    saveRender = true;
    frameStep = 1;
    jj = 2;
    for ii = 2:frameStep:length(x)        
        for kk = 1:length(vars)
            eval(['x = trajectory.', vars{kk}, '.x;'])
            eval(['y = trajectory.', vars{kk}, '.y;'])
            eval(['lines.', vars{kk}, '(end + 1, :) = [x(ii), y(ii), x(ii - 1), y(ii - 1)];'])
        end
        jj = jj + 1;
    end
    if saveRender
        [fileName, rootPath, filterIndex] = uiputfile({'*.avi','Audio Video Interleaved (AVI)'}, 'Select a file name for saving the video');
        fullPath = strcat(rootPath,fileName);
        vwo = VideoWriter(fullPath);
        vwo.FrameRate = vro.obj.FrameRate;
        open(vwo);
    end

    h = waitbar(0, 'Rendering Video...');
    jj = 2;
    for ii = 2:frameStep:length(x)
        hue_ = ii/length(x)*3;
        while hue_ > 1
            hue_ = hue_ - 1;
        end;     
        for kk = 1:length(vars)
            eval(['line = lines.', vars{kk}, ';']);
            ink = insertShape(ink, 'Line', line(jj - 1: jj,:), 'LineWidth', 4, 'Color', hsv2rgb([hue_,1,1])*255);   
            mask = insertShape(mask, 'Line', line(jj - 1:jj,:), 'LineWidth', 3, 'Color',  [0,0,0]);
        end
        img = PhysTrack.read2(vro, ii) .* mask + ink;
        if previewRender
            warning off;
            imshow(img);
            warning on;
        end
        if saveRender
            writeVideo(vwo,img);
        end
        waitbar(ii/length(x),h, strcat('Rendering Video...', strcat(num2str(round(ii/length(x)*100)),'%')));

        jj = jj + 1;
    end
    close(h);
    if saveRender
        close(vwo);
    end

    close(vwo);
    close all;
end