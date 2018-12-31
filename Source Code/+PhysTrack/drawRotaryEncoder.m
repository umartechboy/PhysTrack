function drawRotaryEncoder(cx, cy, radius, lineThickness, data)
% draws a rotary encoder to represent a binary data array at a specified
% location

    resolution = 50;
    if length(data) > resolution / 2
        resolution = length(data) * 2;
    end
    for ii = 0:pi/resolution:2*pi
        dth = 2 * pi/resolution;
        dataii = round(ii / (2 * pi) * length(data));
        if dataii == 0
            dataii = length(data);
        end
        t = lineThickness;
        x = []; y = [];
        x = (radius + [-t/2, +t/2]) * cos(ii);
        y = (radius + [-t/2, +t/2]) * sin(ii);
        x(3:4) = (radius + [t/2, -t/2]) * cos(ii + dth);
        y(3:4) = (radius + [t/2, -t/2]) * sin(ii + dth);
        x = x + cx;
        y = y + cy;
        fill(x, y, [1 1 1] * (~data(dataii)), 'EdgeColor', 'None')
    end
    

end

