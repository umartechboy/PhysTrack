% pFinal = 'No';
% rwRCS = [0,0;1,0;0,1];
% ppm = 1;
% while strcmp(pFinal, 'No')
%     [tpt1, traceValidity, lastValidFID] = md_5(vro, ifi, ofi, fps, rwRCS, ppm, preMag); 
%     pFinal = questdlg('Do you want to proceed with this trace?', '', 'Yes', 'No', 'Cancel', 'Yes');
% end
% 
% if strcmp(pFinal, 'Cancel')
%     clear ('p1', 'pFinal');
%     error('The process was aborted by the user.');
% end
% 
% whitebg([1,1,1]);
% circCenter = circleFit(tpt1);
% setCoordinateSystem;
% tpt1 = transformCart2Cart(tpt1,rwRCS);
% CoR = transformCart2Cart([circCenter(1),circCenter(2)],rwRCS);
% CoR = CoR/ppm;
% if ofi ~= lastValidFID
%     questdlg('The video will be trimmed automatically to fit the result of trace', '', 'OK', 'OK');
%     ofi = lastValidFID;
% end

t = md_5_generateTimeStamps(ifi, ofi, fps);
d = getAngDispFrom2DtrackPoints(tpt1);
dx = tpt1(:,1);
dy = tpt1(:,2);
[tw, w] = deriv(t,d,1);
[ta, a] = deriv(t,d,2);



if ~exist('noExample')
    noExample = false;
end
if ~noExample
    close all;
    figure;
    mxx = max(abs(tpt1(:,1)))*1.2;
    mxy = max(abs(tpt1(:,2)))*1.2;
    mxx = max(mxx,mxy);
    grid on;
    plot(tpt1(:,1), tpt1(:,2), '+', 'Color', [1,0,0],'MarkerSize', 5);
    hold on;
    grid on;
    plot(CoR(1), CoR(2), '+', 'Color', [0,0,1],'MarkerSize', 5);
    axis([-mxx,mxx,-mxx,mxx]);
    xlabel('x-coordinates of traced points');
    ylabel('y-coordinates of traced points');
    legend('trace of path', 'meanCenter');
    title('Trace of travelled Path (units = meter)');
    axis square

    figure;
    plot(t,dx, '.', 'Color', [1,0,0],'MarkerSize', 5);
    hold on;
    plot(t,dy, '.', 'Color', [0,0,1],'MarkerSize', 5);
    hold on;

    grid on;
    title('x and y coordinates over time');
    xlabel('time t (second)');
    ylabel('Linear Displacement of point');
    legend('x-coordinates', 'y-coordinates');

    figure;
    plot(t,d, '.', 'Color', [0,0,0],'MarkerSize', 1);
    grid on;
    title('Angular Displacement');
    xlabel('time (second)');
    ylabel('Angular displacement (radians)');

    figure;
    plot(tw,w, 'Color', [0,0,1],'MarkerSize', 4);
    grid on;
    title('Angular velocity (calculated by 5-point differentiation)');
    xlabel('time t (second)');
    ylabel('Angular velocity (radians per second)');

    figure;
    plot(tw,w, '+', 'Color', [0.5,0.5,0.5],'MarkerSize', 3);
    grid on;
    title('Curve Fitting for Angular Velocity');
    xlabel('time t (seconds)');
    ylabel('Angular Velocity (radians per second)');

    [wFit, dgof] = lsqFun3(tw, w, 'w',  'wi + a * t_', 't_' );
    hold on;
    syms t_;
    wFunc = wFit.wi + wFit.a * t_;
    hold on;
    plot(tw,vpa(subs(wFunc, tw)), 'r');
    wFuncStr = strcat(['w = ', char(vpa(wFunc , 3))]);
    legend('w (real)', wFuncStr);
    clear wFuncStr;
    warning off;
    cascade
    warning on;
end
centerOfRot = [CoR(1),CoR(2)];
clear('circCenter', 'ans', 'dgof', 'lastValidFID', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
clear tpt1 traceValidity
