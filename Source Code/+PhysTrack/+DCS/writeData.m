function writeData(stream, data, packetID)
import java.net.Socket
import java.io.*
if size(data, 1) > 1
    data = data';
end
%WRITEDATA writes packetized data on a stream
    d_output_stream = DataOutputStream(stream);
    dataToSend = [...
        typecast(uint32(packetID), 'uint8'),...
        typecast(uint32(length(data)), 'uint8'),...
        uint8(data)...
        ];
    
    d_output_stream.writeBytes(char(dataToSend));
end
