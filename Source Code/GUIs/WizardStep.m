global wizard_00_sections
ii = get(hObject, 'Tag');
iis = ii(2:end);
ii = uint16(str2num(iis));
for jj = ii+1:8
    set(eval(['handles.b', num2str(jj)]), 'Enable', 'off');
end
%try
    evalin('base', wizard_00_sections(ii).Code);
    if ii < 8 && ii < length(wizard_00_sections)
        set(eval(['handles.b', num2str(ii + 1)]), 'Enable', 'on');
    end
% catch
%     errorStr = ['Error in code:\r\n', wizard_00_sections(ii).Code];
%     error(errorStr);
% end