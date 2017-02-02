function ShowImWithRef( vr2o, ind, rwRCS, forceRGB, ppmLine)
%GETIMWITHREF Internal Library function to draw Image with reference
%coordinate
    if isstruct(rwRCS) % is a floating ref
        rwRCS_ = [ ...
            rwRCS.tp1.xy(ind, :); ...
            rwRCS.tp2.xy(ind, :); ...
            rwRCS.tp3.xy(ind, :)];
    else
        rwRCS_ = rwRCS;
    end
    I = insertText(PhysTrack.read2(vr2o, ind, false, forceRGB), rwRCS_(2,:), 'X', 'BoxOpacity', 0.2, 'BoxColor', [255,255,255]);
    I = insertText(I, rwRCS_(3,:), 'Y', 'BoxOpacity', 0.2, 'BoxColor', [255,255,255]);
    if ~isempty(ppmLine)
        I = insertShape(I, 'Line', ppmLine, 'Color', PhysTrack.GetColor('Pink'), 'LineWidth',3);
    end
    imshow(I); hold on;    
    quiver(rwRCS_(1,1),rwRCS_(1,2),rwRCS_(2,1)-rwRCS_(1,1),rwRCS_(2,2)-rwRCS_(1,2),0,'r', 'LineWidth',2);
    quiver(rwRCS_(1,1),rwRCS_(1,2),rwRCS_(3,1)-rwRCS_(1,1),rwRCS_(3,2)-rwRCS_(1,2),0,'b', 'LineWidth',2);
    if isstruct(rwRCS)
        title('Preview of the coordinate system.');
    else
        title('Select an operation');
    end
end

