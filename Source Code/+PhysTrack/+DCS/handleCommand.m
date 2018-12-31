function handleCommand(data, id, inputStream, outputStream)
% Processes the specified command and send data back if neccessary.
% both stream are NOT data streams.
    if id == 1 % eval command
        str = ['eval: ', char(data)];
        str = ['\n', strrep(str,'\','\\')];
        fprintf(str);
        evalin('base', char(data));        
    elseif id == 2 % assignon
        len = uint32(data(1));
        name = char(data(2:(1+len)));
        fprintf(['\nassign: ', name]);
        value = PhysTrack.DCS.hlp_deserialize(data((len+2):end));
        assignin('base', 'tVar', value);        
        evalin('base', [name, ' = tVar;']);
    elseif id == 3 % get variable
        name = char(data);
        fprintf(['\nget variable: ', name]);
        if ~evalin('base', ['exist(''', name,''')'])            
            PhysTrack.DCS.writeData(outputStream, [], 3);
            return;
        end
        value = evalin('base', name);
        dataToSend = PhysTrack.DCS.hlp_serialize(value)';
        if length(dataToSend) > 100000
            PhysTrack.DCS.writeData(outputStream, [], 5);
        else
            PhysTrack.DCS.writeData(outputStream, dataToSend, 4);            
        end
    elseif id == 5 % copy file
        len = uint32(data(1));
        name = char(data(2:(1+len)));
        
        fprintf(['\ncopy file: ', name]);
        value = data((len+2):end);
        f = fopen(name, 'w');
        fwrite(f, value);
        fclose(f);
    elseif id == 7 % eval func
        argin = int16(data(1));
        func = char(data(2:end));        
        argout = nargout(func);
        if argout <= 0
            varargout = cell(0,0);
            retList = '';
        else
            varargout = cell(1, nargout(func));
            retList = '[ans1';
            for ii = 2:1:nargout(func)
                retList = [retList, ', ', 'ans', num2str(ii)];
            end
            retList = [retList, '] = '];
        end

        if argin <= 0
            paramList = '';
        else
            paramList = 'param1';
            for ii = 2:1:argin
                paramList = [paramList, ', ', 'param', num2str(ii)];
            end
            paramList = [paramList, ''];
        end
        
        evalStatement = [retList, func, '(', paramList, ');'];
        try 
            evalin('base', evalStatement);
        catch exception
            msg = getReport(exception);
            PhysTrack.DCS.writeData(outputStream, msg, 0);
            return;
        end
        PhysTrack.DCS.writeData(outputStream, typecast(uint32(nargout(func)), 'uint8'), 1);
        for ii = 1:nargout(func)
            val = evalin('base', ['ans', num2str(ii)]);
            PhysTrack.DCS.writeData(outputStream, uint8(PhysTrack.DCS.hlp_serialize(val)), ii);
        end
    elseif id == 9 % ping
        PhysTrack.DCS.writeData(outputStream, [], 9);
    elseif id == 10 % copy file local
        source = char(data(1:find(data == ';')-1));
        temproot = evalin('base', 'TempDir');
        target = [temproot, '\', char(data(find(data == ';')+1:end))];
        parts = strsplit(target, '\');
        targetDir = target(1:end-length(parts{end})-1);
        try
            warning off
            mkdir(targetDir);
            warning on
        catch
        end
        tempTarget = 'tempFile.dat';
        sFile = fopen(source);
        tFile = fopen(tempTarget, 'w');
        PhysTrack.DCS.writeData(outputStream, uint8([sFile >= 0, tFile >= 0, int8(target)]), 0);
        if sFile < 0 || tFile < 0
            if sFile > 0
                fclose(sFile);
            end
            if tFile > 0
                fclose(tFile);
            end
            return;
        end
        f = dir(source);
        totalToRead = f.bytes;
        totalRead = 0;
        lastProg = 0;
        toRead = 1024;
        [tRead, nBytes] = fread(sFile, toRead);
        while nBytes > 0
            fwrite(tFile, tRead);
            totalRead = totalRead + nBytes;
            prog = totalRead / totalToRead * 100;
            if prog - 2 > lastProg
                PhysTrack.DCS.writeData(outputStream, PhysTrack.DCS.hlp_serialize(prog/100), 1);
                lastProg = prog;
            end
            
            [tRead, nBytes] = fread(sFile, toRead);
        end
        PhysTrack.DCS.writeData(outputStream, [], 3);
        fclose(sFile);
        fclose(tFile);
        movefile(tempTarget, target);
        flcose('all');
    elseif id == 11 % eval function ASync
        argin = int16(data(1));
        func = char(data(2:end));        
        argout = nargout(func);
        if argout <= 0
            retList = '';
        else
            retList = '[ans1';
            for ii = 2:1:nargout(func)
                retList = [retList, ', ', 'ans', num2str(ii)];
            end
            retList = [retList, '] = '];
        end

        if argin <= 0
            paramList = '';
        else
            paramList = 'param1';
            for ii = 2:1:argin
                paramList = [paramList, ', ', 'param', num2str(ii)];
            end
            paramList = [paramList, ''];
        end
        
        evalStatement = [retList, func, '(', paramList, ');'];
        % tell the server that the function was tried.
        PhysTrack.DCS.writeData(outputStream, [], 1);
        try 
            evalin('base', evalStatement);
        catch
            evalin('base', 'processReturns{end + 1}.Handle = processHandles(end);');
            evalin('base', 'processReturns{end}.Complete = false;');
            return;
        end
        
        evalin('base', 'processReturns{end + 1}.Handle = processHandles(end);');
        evalin('base', 'processReturns{end}.Complete = true;');
        evalin('base', 'processReturns{end}.Handle = processHandles(end);');
        evalin('base', ['processReturns{end}.AnswerCount = ', num2str(nargout(func)), ';']);
        % process the data and save it the latest return address
        for ii = 1:nargout(func)
            evalin('base', ['processReturns{end}.Answers.ans', num2str(ii), ' = ', 'ans', num2str(ii), ';']);
        end
    elseif id == 12 % getAsync result        
        ind = typecast(data, 'uint32');
        pr = evalin('base', 'processReturns');
        hInd = -1;
        for ii = 1:length(pr)
            if pr{ii}.Handle.Index == ind
                hInd = ii;
                break;
            end
        end
        if hInd < 1
            PhysTrack.DCS.writeData(outputStream, 0, 12);
            return
        end
        PhysTrack.DCS.writeData(outputStream, 1, 12);
        argout = nargout(pr{hInd}.Handle.Function);
        if argout <= 0
            varargout = cell(0,0);
            retList = '';
        else
            varargout = cell(1, nargout(pr{hInd}.Handle.Function));
            retList = '[ans1';
            for ii = 2:1:nargout(pr{hInd}.Handle.Function)
                retList = [retList, ', ', 'ans', num2str(ii)];
            end
            retList = [retList, '] = '];
        end
        PhysTrack.DCS.writeData(outputStream, typecast(uint32(nargout(pr{hInd}.Handle.Function)), 'uint8'), 1);
        for ii = 1:nargout(pr{hInd}.Handle.Function)
            val = evalin('base', ['ans', num2str(ii)]);
            PhysTrack.DCS.writeData(outputStream, uint8(PhysTrack.DCS.hlp_serialize(val)), ii);
        end
    elseif id == 13 % existon
        name = char(data);
        fprintf(['\nget variable: ', name]);
        if ~evalin('base', ['exist(''', name,''')'])            
            PhysTrack.DCS.writeData(outputStream, [], 3);
        else
            PhysTrack.DCS.writeData(outputStream, [], 4);
        end
    end
end

