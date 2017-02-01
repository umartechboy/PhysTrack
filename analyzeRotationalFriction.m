% 
% questdlg('Define a reference coordinate system where x-coordinate is aligned along the inclined plane and object moves along the positive side of the x-axis', '', 'OK', 'OK');
% setCoordinateSystem;
%  
% [tpt1, tpt2, obj, lastValidFID] = md_5_3(vro, ifi, ofi, preMag, rwRCS, ppm);
% 
% if ofi ~= lastValidFID
%     questdlg('The video will be trimmed automatically to fit the result of trace', '', 'OK', 'OK');
%     ofi = lastValidFID;
% end
% t = md_5_generateTimeStamps(ifi, ofi, fps);
% 
% trim = 0;
% obj = obj(1:end - trim,:,:);
% tpt2 = tpt2(1:end - trim, :);
% tpt1 = tpt1(1:end - trim, :);
% t = t(1:end - trim);
% 
% close all;
% rad = sqrt((obj(1,2,1) - obj(1,1,1)).^2 + (obj(1,2,2) - obj(1,1,2)).^2);
% objx = obj(:, 1,1);
% objy = obj(:, 1,2); 
% 
% w = getAngDispFrom2DtrackPoints(squeeze(obj(:,1,:)), squeeze(obj(:,2,:)));
% 
% % plot obj and periph point
% figHandle = figure;
% whitebg([1,1,1]);
% hold on;
% plot(obj(:,1,1),obj(:,1,2), '-', 'Color',[0.5,0.1,0.1]);
% plot(obj(:,2,1),obj(:,2,2), '-', 'Color',[0.1,0.6,0.3]);
% viscircles(squeeze(obj(1, 1, :))', rad , 'LineWidth', 1, 'EdgeColor', 'red');
% viscircles(squeeze(obj(end, 1, :))', rad , 'LineWidth', 1, 'EdgeColor', 'red', 'LineStyle' , '--');
% 
% legend('Center of circle', 'a Fixed Peripheral point');
% title ('Trajectory of center and a fixed peripheral point');
% xlabel('x-Coordinates (meters)')
% ylabel('y-Coordinates (meters)')
% 
% mnx = min(abs(obj(:,1,1)))*1.2;
% mxx = max(abs(obj(:,1,1)))*1.2;
% mny = min(abs(obj(:,1,2)))*1.2;
% mxy = max(abs(obj(:,1,2)))*1.2;
% mx = max(mxx,mxy) + rad * 1.5;
% mn = min(mnx,mny)- rad * 1.5;
% axis([mnx - rad * 3,mxx,mny - rad * 1.5,mxy + rad * 1.5]);
% axis equal
% 
% % plot trajectories
% 
% figHandle = figure;
% hold on;
% plot(tpt1(:,1),tpt1(:,2), '-', 'Color',[0.5,0.1,0.1], 'LineWidth', 2);
% plot(tpt2(:,1),tpt2(:,2), '-', 'Color',[0.1,0.6,0.3], 'LineWidth', 2);
% viscircles(squeeze(obj(1, 1, :))', rad , 'LineWidth', 2, 'EdgeColor', 'red');
% viscircles(squeeze(obj(end, 1, :))', rad , 'LineWidth', 2, 'EdgeColor', 'red', 'LineStyle' , '--');
% 
% legend('Center of circle', 'a Fixed Peripheral point');
% title ('Trajectory of track pointers');
% xlabel('x-Coordinates (meters)')
% ylabel('y-Coordinates (meters)')
% 
% mnx = min(abs(tpt1(:,1)))*1.2;
% mxx = max(abs(tpt1(:,1)))*1.2;
% mny = min(abs(tpt1(:,2)))*1.2;
% mxy = max(abs(tpt1(:,2)))*1.2;
% mx = max(mxx,mxy) + rad * 1.5;
% mn = min(mnx,mny)- rad * 1.5;
% axis([mnx - rad * 3,mxx,mny - rad * 1.5,mxy + rad * 1.5]);
% axis equal

x = obj(:,1,1);
y = obj(:,1,2);
xp = obj(:,2,1);
yp = obj(:,2,2);

x_ = transformCart2Cart(inverseTransformCart2Cart(obj(:,1,:) * ppm, rwRCS), rwRCS_) / ppm;
y_ = x_(:,2); x_(:,2) = [];
xp_ = transformCart2Cart(inverseTransformCart2Cart(obj(:,2,:) * ppm, rwRCS), rwRCS_) / ppm;
yp_ = xp_(:,2); xp_(:,2) = [];

x__ = [];
y__ = [];
xp__ = [];
yp__ = [];
ft = lsqFun3(x,y, 'y', 'm*x+c', 'x');

for ii = 1:length(t)
    p1 = [obj(ii,1,1), ft(obj(ii,1,1))];
    p2 = [obj(end,1,1) + .02, ft(obj(end,1,1) + .02)];
    rw = [inverseTransformCart2Cart([p1;p2] * ppm, rwRCS); [0,0]];
    rw (3, :) = inverseTransformCart2Cart([0,200],rw);
%     imshow(imresize(read(vro, ofi), preMag));
%     hold on; plot(rw([3,1,2],1), rw([3,1,2],2));
    x__ (end + 1, :) = transformCart2Cart(inverseTransformCart2Cart(obj(ii,1,:) * ppm, rwRCS), rw) / ppm;
    y__ (end + 1) = x__(end, 2); 
    xp__(end + 1, :) = transformCart2Cart(inverseTransformCart2Cart(obj(ii,2,:) * ppm, rwRCS), rw) / ppm;
    yp__(end + 1) = xp__(end,2);
    drawnow;
end
x__(:,2) = [];
xp__(:,2) = [];

[dt, dx] = deriv2(t,x,1);
[dt, dy] = deriv2(t,y,1);
[dt, dx_] = deriv2(t,x_,1);
[dt, dy_] = deriv2(t,y_,1);
[dt, dx__] = deriv2(t,x__,1);
[dt, dy__] = deriv2(t,y__,1);


[dt, dxp] = deriv2(t,xp,1);
[dt, dyp] = deriv2(t,yp,1);
[dt, dxp_] = deriv2(t,xp_,1);
[dt, dyp_] = deriv2(t,yp_,1);
[dt, dxp__] = deriv2(t,xp__,1);
[dt, dyp__] = deriv2(t,yp__,1);


[d2t, d2xp] = deriv2(t,xp,2);
[d2t, d2yp] = deriv2(t,yp,2);
[d2t, d2xp_] = deriv2(t,xp_,2);
[d2t, d2yp_] = deriv2(t,yp_,2);
[d2t, d2xp__] = deriv2(t,xp__,2);
[d2t, d2yp__] = deriv2(t,yp__,2);

[d2t, d2x] = deriv2(t,x,2);
[d2t, d2y] = deriv2(t,y,2);
[d2t, d2x_] = deriv2(t,x_,2);
[d2t, d2y_] = deriv2(t,y_,2);
[d2t, d2x__] = deriv2(t,x__,2);
[d2t, d2y__] = deriv2(t,y__,2);
th = atan2(y(1) - y(end), x(end) - x(1));
ft = lsqFun3(t, x_, 'x_', 'c2 + c1 * t + 1/3*9.81*t^2 * sin(0.1341)', 't');
phi0 = atan2(yp__(1), xp__(1));
R = rad;
close all;
% figure; hold on; plot(t, x, 'r'); plot(t, y, 'b'); title('t x-y');
% figure; hold on; plot(t, x_, 'r'); plot(t, y_, 'b'); title('t x_-y_');
% figure; hold on; plot(t, x__, 'r'); plot(t, y__, 'b'); title('t x__-y__');
figure; hold on; plot(t, xp, 'r'); plot(t, yp, 'b'); title('t xp-yp');
% figure; hold on; plot(t, xp_, 'r'); plot(t, yp_, 'b'); title('t xp_-yp_');
% figure; hold on; plot(t, xp__, 'r'); plot(t, yp__, 'b'); title('t xp__-yp__');
% 
%figure; hold on; plot(dt, dx, 'r'); plot(dt, dy, 'b'); title('dt dx-dy');
% figure; hold on; plot(dt, dx_, 'r'); plot(dt, dy_, 'b'); title('dt dx_-dy_');
% figure; hold on; plot(dt, dx__, 'r'); plot(dt, dy__, 'b'); title('dt dx__-dy__');
figure; hold on; plot(dt, dxp, 'r'); plot(dt, dyp, 'b'); title('dt dxp-dyp');
% figure; hold on; plot(dt, dxp_, 'r'); plot(dt, dyp_, 'b'); title('dt dxp_-dyp_');
% figure; hold on; plot(dt, dxp__, 'r'); plot(dt, dyp__, 'b'); title('dt dxp__-dyp__');
% 
% 
% figure; hold on; plot(d2t, d2x, 'r'); plot(d2t, d2y, 'b'); title('dt dx-dy');
% figure; hold on; plot(d2t, d2x_, 'r'); plot(d2t, d2y_, 'b'); title('dt dx_-dy_');
% figure; hold on; plot(d2t, d2x__, 'r'); plot(d2t, d2y__, 'b'); title('dt dx__-dy__');
figure; hold on; plot(d2t, d2xp, 'r'); plot(d2t, d2yp, 'b'); title('dt d2xp-d2yp');
% figure; hold on; plot(d2t, d2xp_, 'r'); plot(d2t, d2yp_, 'b'); title('dt dxp_-dyp_');
% figure; hold on; plot(d2t, d2xp__, 'r'); plot(d2t, d2yp__, 'b'); title('dt dxp__-dyp__');
plot(t, R)
cascade2;
%  
% %plot Disp
% figHandle = figure;
% plot(t,w);
% title ('Angular displacement');
% xlabel('time (seconds)')
% ylabel('Angular Displacement (radians)')
% 
% % plot moving coordinate
% orgCen = inverseTransformCart2Cart(obj(:,1,:) * ppm, rwRCS);
% orgPer = inverseTransformCart2Cart(obj(:,2,:) * ppm, rwRCS);
% cenFitP = lsqFun3(orgCen(:, 1), orgCen(:, 2), 'y', 'm*x + c', 'x');
% cenFitPoints = [orgCen(:, 1), cenFitP(orgCen(:, 1))];
% rws = [];
% for ii = 1: size(cenFitPoints, 1) - 1
%     rws(:,:, ii) = [cenFitPoints(ii,:); cenFitPoints(ii + 1,:); [0,2]];
% end
% nps = [];
% for ii = 1: size(cenFitPoints, 1) - 1
%     nps(ii, :) = transformCart2Cart(orgPer(ii, :), rws(:,:, ii)) / ppm * 1000;
% end
% figure; hold on; 
% plot(t(1:end-1), nps(1:end,1), 'r', 'LineWidth', 2);
% plot(t(1:end-1), nps(1:end,2), 'b', 'LineWidth', 2);
% xlabel('Time t (seconds)');
% ylabel('Distance (Millimeters)');
% legend('x-coordinates of C w.r.t moving coordinate system', 'y-coordinates of P w.r.t moving coordinate system');
% title('x and y coordniates C w.r.t a coordinate system moving with the object alligned in the direction of motion.')
% cascade;
% 
% figure;
% 
% imshow(imresize(read(vro, ofi - 1), preMag))
% hold on
% plot(orgCen([12,end], 1), orgCen([12,end], 2), 'LineWidth', 2);
% 
% plot(orgPer(1:end - 1, 1)-16, orgPer(1:end - 1, 2),'r' ,'LineWidth', 2);
% viscircles(orgCen([10,end], :) +0, [1,1] * rad *ppm * .95);

clear('ans',  'mn', 'mx', 'mnx', 'mny','vyFuncStr', 'model', 'str', 'dgof', 'lastValidFID', 'mxx', 'mxy', 'pFinal', 'wgof', 'answer', 'defaultValues', 'dlg_title', 'kd', 'kdx', 'kdy', 'num_lines','options','prompt');
clear figHandle obj1F1 obj1F2 obj1Fe1 obj1I1 obj1I2 obj2F obj2I