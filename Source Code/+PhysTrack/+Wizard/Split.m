function  sections = Split(script)
sections = struct('Title', '', 'Code', '');
funcs = PhysTrack.Wizard.SupportedFunctions;
AllInds = [];
for ii = 1:length(funcs)
    inds = strfind(script, ['PhysTrack.Wizard.', funcs{ii}]);
    if length(inds) > 0
        AllInds(end + 1:end + length(inds)) = inds;
    end
end
if length(AllInds) == 0
    return
end
AllInds = sort(AllInds);
for ii = 1:length(AllInds)
    thisI = AllInds(ii);
    if ii < length(AllInds)
        nextI = AllInds(ii + 1);
    else
        nextI = length(script);
    end
    [args, ci] = PhysTrack.Wizard.ReadWizardMarker(script, thisI);
    code = script(ci:nextI-1);
    code = PhysTrack.Wizard.trimends(code, char(10,13, ' '));
    
    
    if length(strfind(args, '''')) > 0
        args(strfind(args, '''')) = [];
    end
    section = [];
    section.Title = args;
    section.Code = code;
    sections(end + 1) = section;
end
sections(1) = [];
end

