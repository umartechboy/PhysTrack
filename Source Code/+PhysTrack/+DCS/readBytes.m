function bytes = readBytes(stream, count, timeout)
import java.net.Socket
import java.io.*
%READBYTES readBytes implementation of java socket stream
bytes = zeros(1, count);
ii = 1;
tic
while ii <= count
    if (stream.available)
        tic;
        bytes(ii) = stream.readByte;
        if bytes(ii) < 0
            bytes(ii) = bytes(ii) + 256;            
        end
        ii = ii + 1;
    end
    if toc*1000 > timeout && timeout > 0
        bytes(ii:end) = [];
        return;
    end
end
uint8(bytes);
end

