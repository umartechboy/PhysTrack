% This script closes all the figures and spares Wizard
figHandles = findobj('Type', 'figure');
for ii = 1:length(figHandles)
    if ~strcmp(figHandles(ii).Name, 'Wizard')
        close(figHandles(ii));
    end
end
clear figHandles