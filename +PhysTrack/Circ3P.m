function [centre, radius] = Circ3P(pt1, pt2, pt3)
% Get a 3P Circle on graphically from an open image.
   
    pt1 = double(pt1);
    pt2 = double(pt2);
    pt3 = double(pt3);

    epsilon = 0.000000001;

    delta_a = pt2 - pt1;
    delta_b = pt3 - pt2;

    ax_is_0 = abs(delta_a(1)) <= epsilon;
    bx_is_0 = abs(delta_b(1)) <= epsilon;

    % check whether both lines are vertical - collinear
    if ax_is_0 && bx_is_0
        centre = [0 0];
        radius = -1;
        warning([mfilename ':CollinearPoints'],'Points are on a straight line (collinear).');    
        return
    end

    % make sure delta gradients are not vertical
    % swap points to change deltas
    if ax_is_0
        tmp = pt2;
        pt2 = pt3;
        pt3 = tmp;
        delta_a = pt2 - pt1;
    end
    if bx_is_0
        tmp = pt1;
        pt1 = pt2;
        pt2 = tmp;
        delta_b = pt3 - pt2;
    end

    grad_a = delta_a(2) / delta_a(1);
    grad_b = delta_b(2) / delta_b(1);

    % check whether the given points are collinear
    if abs(grad_a-grad_b) <= epsilon
        centre = [0 0];
        radius = -1;
        warning([mfilename ':CollinearPoints'],'Points are on a straight line (collinear).');    
        return
    end

    % swap grads and points if grad_a is 0
    if abs(grad_a) <= epsilon
        tmp = grad_a;
        grad_a = grad_b;
        grad_b = tmp;
        tmp = pt1;
        pt1 = pt3;
        pt3 = tmp;
    end

    % calculate centre - where the lines perpendicular to the centre of
    % segments a and b intersect.
    centre(1) = ( grad_a*grad_b*(pt1(2)-pt3(2)) + grad_b*(pt1(1)+pt2(1)) - grad_a*(pt2(1)+pt3(1)) ) / (2*(grad_b-grad_a));
    centre(2) = ((pt1(1)+pt2(1))/2 - centre(1)) / grad_a + (pt1(2)+pt2(2))/2;

    % calculate radius
    radius = norm(centre - pt1);
end

