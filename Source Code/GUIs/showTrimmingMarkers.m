function I = showTrimmingMarkers(I, inMarker, OutMarker)
    if length(inMarker) == 4
        I = insertShape(I, 'Rectangle', inMarker, 'Color', [255,0,0], 'LineWidth', 2);
    end
    if length(OutMarker) == 4
        I = insertShape(I, 'Rectangle', OutMarker, 'Color', [0,255,0], 'LineWidth', 2);
    end
end