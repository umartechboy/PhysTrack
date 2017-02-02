function isTpStruct = IsTpStruct(struct_)
%ISTPSTRUCT Summary of this function goes here
%   Detailed explanation goes here

    if ~isstruct(struct_)
        isTpStruct = false;
        return;
    end
    vars = fieldnames(struct_);
    isTpStruct = false;
    for ii = length(vars)
        if ~isempty(find(strcmp(vars, 'tp1')))
            isTpStruct = true;
            break;
        end
    end
end

