function DCS_Fun_Handle = evaluateFunctionASync(nodeAddress, nodePort, funcStr, varargin)
% Evalutates the specified function on the specified remote node. The
% outputs are processed and stored on the remote node which can be querried
% by calling PhysTrack.DCS.AcquireResults and the handle returned by this
% function.
import java.net.Socket
import java.io.*
PhysTrack.DCS.MakeServer
handleInd = PhysTrack.DCS.GetNewProcessHandle(nodeAddress, nodePort);
if handleInd <= 0
    error 'The DCS node did not assign a process handle';
end

% make the handle
DCS_Fun_Handle.Index = handleInd;
DCS_Fun_Handle.Function = funcStr;
global DCSServer
for ii = 1: length(DCSServer)
    if strcmp(nodeAddress, DCSServer.Nodes(ii).Address) && nodePort == DCSServer.Nodes(ii).Port
        DCS_Fun_Handle.Node.Index = ii;
        break
    end
end
DCS_Fun_Handle.Node.Address = nodeAddress;
DCS_Fun_Handle.Node.Port = nodePort;
ph = PhysTrack.DCS.getvariable(nodeAddress, nodePort, 'processHandles');
if isempty(ph)
    PhysTrack.DCS.assignon(nodeAddress, nodePort, 'processHandles', DCS_Fun_Handle);
else
    PhysTrack.DCS.assignon(nodeAddress, nodePort, 'processHandles(end + 1)', DCS_Fun_Handle);
end


for ii = 1:1:length(varargin) % copy all the params to the remote pc
    PhysTrack.DCS.assignon(nodeAddress, nodePort, ['param', num2str(ii)], varargin{ii});
end

output_socket = Socket(nodeAddress, nodePort);
input_stream   = output_socket.getInputStream;
output_stream   = output_socket.getOutputStream;

PhysTrack.DCS.writeData(output_stream, [char(length(varargin)), funcStr], 11)
[data, id] = PhysTrack.DCS.readData(input_stream);
if id == 0
    warning off
    fprintf(['\n\n', char(data), '\n\n']);
    warning on
    DCS_Fun_Handle = [];
    return;
end
end

