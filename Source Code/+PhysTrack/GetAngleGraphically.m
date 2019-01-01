function angle = GetAngleGraphically(vro, rwRCS)
    notOK = true;
    angle = [];
    while notOK    
        figure; hold on;
        h = imshow(PhysTrack.read2(vro, 1));hold on;
        title('Draw a Line on the horzontal surface followed by the "Enter" key.');
        [px py] = getline();
        p = PhysTrack.TransformCart2Cart([px(1:2),py(1:2)], rwRCS);
        line = [(p(2,1) - p(1,1)),(p(2,2) - p(1,2))];
        plot(px(1:2), py(1:2), 'Color', PhysTrack.GetColor('Pink')/255, 'LineWidth', 2);
        th = cart2pol(line(1), line(2));
        if th < 0
        th = 2 * pi + th;
        end
        if (th > pi)
        th = th - pi;
        end
        angle = th;
        if strcmp(questdlg('Do you wish to continue with this input?','Confirmation', 'Yes', 'No', 'Yes'), 'Yes')
            notOK = false;
        end
    end
    PhysTrack.closeAll;
end