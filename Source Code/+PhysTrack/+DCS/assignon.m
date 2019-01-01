function assignon(address, port, variablename__, value)
% assigns the value to the specified variable on the specified address on
% DCN.
    import java.net.Socket
    import java.io.*
    makeVro = false;
    PhysTrack.DCS.MakeServer;
    try
        if nargin >= 5
            error 'Forced to assign using mat file sharing';
        end
        % special case for vr2 objects
        if isstruct(value)
            if isfield(value, 'obj')
                if strcmp(class(value.obj), 'VideoReader')
                    value = rmfield(value, 'obj');
                    makeVro = true;
                end
            end
        end
        comData = PhysTrack.DCS.hlp_serialize(value)';        
        if length(comData) > 100000
            error 'The data is too big to be sent using sockets.'
        end
        try                
            output_socket = Socket(address, port);
            output_stream   = output_socket.getOutputStream;
            comData = [uint8(length(variablename__)), uint8(variablename__), uint8(comData)];
            PhysTrack.DCS.writeData(output_stream, comData, 2);            
            output_socket.close;
        catch
        end
    catch
        if ~PhysTrack.DCS.NodeAvailable(address, port)
            error 'Node not available'
        end
        eval([variablename__, ' = value;']);
        save('tSave.mat', variablename__);
        PhysTrack.DCS.copyfile3(address, port, 'tSave.mat', 'tSave.mat');
        delete('tSave.mat');
        td = PhysTrack.DCS.getvariable(address, port, 'TempDir');
        PhysTrack.DCS.evalon(address, port, ['load(''', td,'\tSave.mat'')']);
    end
    if makeVro
        PhysTrack.DCS.evalon(address, port, [variablename__, ' = PhysTrack.DCS.MakeVr2oObj(', variablename__,');']);
    end
end

