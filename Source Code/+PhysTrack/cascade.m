function cascade
%CASCADE Cascade existing figures so that they don't directly overlap.
%   CASCADE takes and returns no arguments.  This function will cascade as
%   many figures as will fit the height/width of the screen.  If there are
%   more figures than can cascade in a screen, those additional figures are
%   left in their original position.
%
%   Author: Isaac Noh
%   Copyright The MathWorks, Inc.
%   November 2007

% Find Existing Figures
figs = findobj(0,'Type','figure'); 
figs = sort(figs);

for n = 1:length(figs)
    if strcmp(figs(n).Name, 'Wizard')
        figs(n) = [];
        break;
    end
end
    
% Size of Entire Screen
ss = get(0,'ScreenSize'); 

set(figs,'Units','pixels')

curX = 10;
curY = ss(4) + 100;
maxWid = 0;
for n = 1:length(figs)
    pos = get(figs(n),'Position');
    curY = curY - 200 ;
    if curY < 300       
         curY = ss(4) - 100;
         curX = curX + 300;
    end
    set(figs(n),'Position',[curX (curY - pos(4))  pos(3:4)]);
    curX = curX + 60;
    figure(figs(n));
end