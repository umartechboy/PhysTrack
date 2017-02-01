function RGB=drawCrossHairMarks(RGB, objects, color, opacity)

    if islogical(RGB)
        RGB = uint8(RGB) * 255;
        RGB = cat(3, RGB, RGB,  RGB);
    end
    if ~exist('opacity')
        opacity = 1;
    end
    cl = size(RGB, 2) / 18; % crossHairLength
    ch = size(RGB, 2) / 2000; % crossHairWidth
    mxx = size(RGB, 2);
    mxy = size(RGB, 1);
    for i = 1:+1:size(objects,1)    
        hx1 = max(uint16(objects(i, 1) - cl/2),1);
        hx2 = min(uint16(objects(i, 1) + cl/2),mxx);
        hy1 = max(uint16(objects(i, 2) - objects(i,3)/2 * ch),1);
        hy2 = min(uint16(objects(i, 2) + objects(i,3)/2 * ch),mxy);
        vx1 = max(uint16(objects(i, 1) - objects(i,3)/2 * ch),1);
        vx2 = min(uint16(objects(i, 1) + objects(i,3)/2 * ch),mxx);
        vy1 = max(uint16(objects(i, 2) - cl/2),1);
        vy2 = min(uint16(objects(i, 2) + cl/2),mxy);

        for jj = 1:3
            RGB(vy1:vy2, vx1:vx2, jj) = RGB(vy1:vy2, vx1:vx2, jj)*(1 - opacity) + color(jj)*opacity;
            RGB(hy1:hy2, hx1:hx2, jj) = RGB(hy1:hy2, hx1:hx2, jj)*(1 - opacity) + color(jj)*opacity;
        end     
    end
end