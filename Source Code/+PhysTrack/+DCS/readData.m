function [data, packetID] = readData(stream, timeout)
import java.net.Socket
import java.io.*
if nargin == 1
    timeout = -1;
end
%READDATA Packetized data from a stream.
d_input_stream = DataInputStream(stream);
data =[];
packetID = -1;
tic;
while stream.available < 8
    if toc * 1000 > timeout && timeout > 0
        break;
    end
    pause(0.03);
end
if stream.available < 8
    return;
end
bytes = PhysTrack.DCS.readBytes(d_input_stream, 4, timeout);
if length(bytes) < 4
    data = [];
    packetID = -1;
    return;
end
packetID = typecast(uint8(bytes), 'uint32');
bytes = PhysTrack.DCS.readBytes(d_input_stream, 4, timeout);
if length(bytes) < 4
    data = [];
    packetID = -1;
    return;
end
len = typecast(uint8(bytes), 'uint32');
bytes = PhysTrack.DCS.readBytes(d_input_stream, len, timeout);
if length(bytes) < len
    data = [];
    packetID = -1;
    return;
end
data = uint8(bytes);
end

