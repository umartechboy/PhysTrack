function [xd,yd] = deriv(xdata, ydata, order)
    h = xdata(2) - xdata(1);
    if order == 1
        yd = (2*ydata(4:end)-9*ydata(3:end - 1)+18*ydata(2:end - 2)- 11*ydata(1:end - 3))/(6*h);
    end
    if order == 2
         yd = (-1*ydata(4:end)+4*ydata(3:end-1)-5*ydata(2:end-2)+2*ydata(1:end-3))/(h^2);
    end
    if order == 3
        yd = (ydata(4:end)      - 2 * ydata(3:end - 1) + 2 * ydata(2:end - 2) - ydata(1:end - 3))  / 2 / (xdata(2) - xdata(1))^3;        
    end
    if order == 4
        yd = (ydata(5:end)      - 4 * ydata(4:end - 1) + 6 * ydata(3:end - 2) - 4 * ydata(2:end - 3) + ydata(1:end - 4))  / (xdata(2) - xdata(1))^4;        
    end
    
    if order ~= 4
        xd = (xdata(2) - xdata(1)) * 1.5 + xdata(1:end - 3);
    else
        xd = xdata(3:end - 2);  
    end
end

