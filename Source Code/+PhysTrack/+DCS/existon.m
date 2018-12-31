function out = existon(address, port, varname)
%GETVARIABLE Retrieves a serialized variable from the specified address and
%deserializes it.
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
        out = 0;
    elseif id == 4
        out = 1;
    end
end