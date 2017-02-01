function [xd,yd] = deriv(xdata, ydata, order)
    if order == 1
        yd = (-ydata(4:end)  + 8 * ydata(3:end - 1) - 8 * ydata(2:end - 2) + ydata(1:end - 3))  / 12 / (xdata(2) - xdata(1));                        
    end
    if order == 2
         yd = (-ydata(5:end) + 16 * ydata(4:end - 1) - 30 * ydata(3:end - 2) + 16 * ydata(2:end - 3) - ydata(1:end - 4))  / 12 / (xdata(2) - xdata(1))^2;        
    end
    if order == 3
        yd = (ydata(4:end)      - 2 * ydata(3:end - 1) + 2 * ydata(2:end - 2) - ydata(1:end - 3))  / 2 / (xdata(2) - xdata(1))^3;        
    end
    if order == 4
        yd = (ydata(5:end)      - 4 * ydata(4:end - 1) + 6 * ydata(3:end - 2) - 4 * ydata(2:end - 3) + ydata(1:end - 4))  / (xdata(2) - xdata(1))^4;        
    end
    if order == 1 || order == 3
        xd = (xdata(2) - xdata(1)) * 1.5 + xdata(1:end - 3);
    else
        xd = xdata(3:end - 2);  
    end
end

