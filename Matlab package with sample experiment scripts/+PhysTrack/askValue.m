function val = askValue(question, default, title, type)
    if nargin < 1
        question = 'Kindly enter a value for the required parameter';
    end
    if nargin < 2
        default = '';
    end
    if nargin < 3
        title = '';
    end
    if nargin < 4 % we need to set a default type
        if nargin == 1 % no default given
            type = 'string';
        else % default value given. make a hint for type.
            if isnumeric(default) && length(strfind(num2str(default), '.')) > 0 % its a double
                type = 'double';
            elseif isnumeric(default)
                type = 'int32';
            else
                type = 'string';
            end
        end
    end
    
    
    prompt = {question};
    dlg_title = title;
    num_lines = [1 50];
    defaultValues = {num2str(default)};
    options.Resize='on';
    options.WindowStyle='normal';
    options.Interpreter='tex';
    ans = default;
    answer = inputdlg(prompt, dlg_title, num_lines, defaultValues, options);
    if length(answer) == 0
        val = default;
    else
        [val] = answer{:};
    end
    if ~ischar(val)
        val = num2str(val);
    end
    type = lower(type);
    switch type
        case 'double'
            val = str2double(val); 
        case 'int8'
            val = int8(str2num(val));
        case 'int16'
            val = int16(str2num(val));
        case 'int32'
            val = int32(str2num(val));
        case 'uint8'
            val = uint8(str2num(val));
        case 'uint16'
            val = uint16(str2num(val));
        case 'uint32'
            val = uint32(str2num(val));
        case 'int'
            val = uint32(str2num(val));
    end
end