function outvalue = getvariable(address, port, varname, timeout)
%GETVARIABLE Retrieves a serialized variable from the specified address and
%deserializes it.
    if nargin <= 3
        timeout = -1;
    end
    import java.net.Socket
    import java.io.*
    PhysTrack.DCS.MakeServer;
    output_socket = Socket(address, port);
    output_stream  = output_socket.getOutputStream;
    PhysTrack.DCS.writeData(output_stream, varname, 3);    
    input_stream  = output_socket.getInputStream;    
    [data, id] = PhysTrack.DCS.readData(input_stream, timeout);    
    output_socket.close;
    if id < 0
        error 'Couldn''t access the DCS node.';
    elseif id == 3
        str = ['Variable ''',varname, ''' does not exist on the DCS node'];
        error(str);
    elseif id == 4
        outvalue = PhysTrack.DCS.hlp_deserialize(data);
        return
    elseif id == 5
        PhysTrack.DCS.assignon(address, port, 'sharedDir', DCSServer.TempDir);
        PhysTrack.DCS.evalon(address, port, ['save([sharedDir, ''\tSave.mat''], ''', varname,''');']);
        tgt = PhysTrack.DCS.getvariable(address, port, 'TempDir');
        load([tgt, '\tSave.mat']);
        delete([DCSServer.TempDir, '\tSave.mat']);
        outvalue = eval(varname);
    end
    
end

