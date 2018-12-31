function varargout = evaluateFunction(address, port, funcStr, varargin)
    import java.net.Socket
    import java.io.*
    for ii = 1:1:length(varargin) % copy all the params to the remote pc
        PhysTrack.DCS.assignon(address, port, ['param', num2str(ii)], varargin{ii});
    end
    
    output_socket = Socket(address, port);
    input_stream   = output_socket.getInputStream;
    
    output_stream   = output_socket.getOutputStream;
    PhysTrack.DCS.writeData(output_stream, [char(length(varargin)), funcStr], 7)
    [data, id] = PhysTrack.DCS.readData(input_stream);
    if id == 0
        warning off
        fprintf(['\n\n', char(data), '\n\n']);
        warning on
        varargout = cell(0,0);
        return;
    end
    varargout = cell(1, typecast(uint8(data), 'uint32'));
    for ii = 1:length(varargout)
        data = PhysTrack.DCS.hlp_deserialize(PhysTrack.DCS.readData(input_stream));
        varargout{ii} = data;
    end
end