function evalon(address, port, script)
    import java.net.Socket
    import java.io.*
    output_socket = Socket(address, port);
    output_stream   = output_socket.getOutputStream;
    PhysTrack.DCS.writeData(output_stream, script, 1);
    output_socket.close;
end