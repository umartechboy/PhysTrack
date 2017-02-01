function ShowImWithRef( vr2o, ind, rwRCS, forceRGB, ppmLine)
%GETIMWITHREF Internal Library function to draw Image with reference
%coordinate
    I = insertText(PhysTrack.read2(vr2o, ind, false, forceRGB), rwRCS(2,:), 'X', 'BoxOpacity', 0.2, 'BoxColor', [255,255,255]);
    I = insertText(I, rwRCS(3,:), 'Y', 'BoxOpacity', 0.2, 'BoxColor', [255,255,255]);
    if ~isempty(ppmLine)
        I = insertShape(I, 'Line', ppmLine, 'Color', PhysTrack.GetColor('Pink'), 'LineWidth',3);
    end
    imshow(I); hold on;    
    quiver(rwRCS(1,1),rwRCS(1,2),rwRCS(2,1)-rwRCS(1,1),rwRCS(2,2)-rwRCS(1,2),0,'r', 'LineWidth',2);
    quiver(rwRCS(1,1),rwRCS(1,2),rwRCS(3,1)-rwRCS(1,1),rwRCS(3,2)-rwRCS(1,2),0,'b', 'LineWidth',2);
    title('Select an operation');
end

