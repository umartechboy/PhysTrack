function [cen1, rad1] = Get1Circle(vro)
    figure;
    notOK = true;
    while notOK
        h = imshow(PhysTrack.read2(vro,1));
        hold on;
        title('Draw a circle around the object by giving three points');
        ctpt1(1,:) = ginput(1);
        plot(ctpt1(1,1), ctpt1(1,2),'w.','MarkerSize',8);
        plot(ctpt1(1,1), ctpt1(1,2),'b.','MarkerSize',6);
        ctpt1(2,:) = ginput(1);
        plot(ctpt1(2,1), ctpt1(2,2),'w.','MarkerSize',8);
        plot(ctpt1(2,1), ctpt1(2,2),'b.','MarkerSize',6);
        ctpt1(3,:) = ginput(1);
        plot(ctpt1(3,1), ctpt1(3,2),'w.','MarkerSize',8);
        plot(ctpt1(3,1), ctpt1(3,2),'b.','MarkerSize',6);
        [cen1, rad1] = PhysTrack.Circ3P(ctpt1(1,:),ctpt1(2,:),ctpt1(3,:));
        viscircles(cen1,rad1);
        if strcmp(questdlg('Do you want to continue with this circle?', 'Confirm drawing', 'Yes', 'No', 'Yes'), 'Yes')
            notOK = false;
        end
        PhysTrack.closeAll;
    end
end