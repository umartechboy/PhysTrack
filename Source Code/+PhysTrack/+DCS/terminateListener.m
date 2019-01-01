function terminateListener(address, port)
% terminates listner side terminate loop
    import java.net.Socket
    import java.io.*
    output_socket = Socket(address, port);
    output_stream   = output_socket.getOutputStream;
    PhysTrack.DCS.writeData(output_stream, [], 6);
end

