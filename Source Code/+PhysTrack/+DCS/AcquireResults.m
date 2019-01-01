function varargout = AcquireResults(Handle)
%ACQUIRE Given the handle returned by evaluateFunctionASync, this function
%returns the computed return of the function on the associated DCS node.
% the returned output structure is identical to the original function's
% output.
import java.net.Socket
import java.io.*
PhysTrack.DCS.MakeServer
if ~PhysTrack.DCS.NodeAvailable(Handle.Node.Address, Handle.Node.Port)
    fprintf('The node is currently unavailable.')
    varargout = cell(0);
    return
end

output_socket = Socket(Handle.Node.Address, Handle.Node.Port);
input_stream   = output_socket.getInputStream;
output_stream   = output_socket.getOutputStream;
PhysTrack.DCS.writeData(output_stream, typecast(uint32(Handle.Index), 'uint8'), 12);
[data, id] = PhysTrack.DCS.readData(input_stream);
if id <= 0 
    error 'The DCS node is not rsponding'.
end
if data(1) == 0
    error 'The DCS node does not contain the result for this handle.'
end
[data, id] = PhysTrack.DCS.readData(input_stream);
if id <= 0
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
