function [args, ii] = ReadWizardMarker(script, start)
    ii = start;
    step = 0;
    args = '';
    while ii < length(script)
        if script(ii) == 13
            break;
        end
        if step == 0
            if script(ii) == '('
                step = 1;
            end
        elseif step == 1
            if script(ii) == ')'
                ii = ii + 1;
                step = 2;
                continue;
            end
            args(end + 1) = char(script(ii));
        end
        ii = ii + 1;
    end
    
end

