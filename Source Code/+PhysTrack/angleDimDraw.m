function th = angleDimDraw(center, m1, m2, r, col, showPlot)
if ~exist('showPlot')
    showPlot = true;
end;
a1 = atan(m1);
a2 = atan(m2);
if showPlot
    th = linspace(a1, a2, 100);
    x = r*cos(th) + center(1);
    y = r*sin(th) + center(2);
    plot(x,y, 'LineStyle', '-.', 'Color', col);
end;   
th = abs(a2 - a1) * 180 / pi;
end