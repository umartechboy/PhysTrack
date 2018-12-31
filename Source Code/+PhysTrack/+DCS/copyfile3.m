function [success, targetAddress] = copyfile3(address, port, source, target)
  import java.net.Socket
    import java.io.*
    PhysTrack.DCS.MakeServer;
    copyfile(source, [DCSServer.TempDir, '\', source]);
    source = [DCSServer.TempDir, '\', source];
    success = false;
    targetAddress = [];
    output_socket = Socket(address, port);
    output_stream   = output_socket.getOutputStream;
    input_stream = output_socket.getInputStream;
    PhysTrack.DCS.writeData(output_stream, [source,';',target], 10);
    openResp = PhysTrack.DCS.readData(input_stream);
    errStr1 = '';
    errStr2 = '';
    if openResp(1) <= 0
        errStr1 = ['The source file ''', source,''' could not be opened for reading.'];
    end
    if openResp(2) <= 0
         errStr2 = ['The target file ''', char(openResp(3:end)),''' could not be opened for writting.'];
    end
    if ~isempty(errStr1) || ~isempty(errStr2)
        msgbox({errStr1; errStr2});
        return;
    end
    targetAddress = char(openResp(3:end));
    wbh = waitbar(0, 'Copying file');
    while 1
        [data, id] = PhysTrack.DCS.readData(input_stream, 10000);
        if id == 1 % progress update
            waitbar(PhysTrack.DCS.hlp_deserialize(data), wbh);                    
        elseif id == 3 % completed
            waitbar(1, wbh);
            close(wbh);
            success = true;
            return;
        else % failed
            msgbox({'File copy failed:', char(data)});
            close(wbh);
            return;
        end
    end
end