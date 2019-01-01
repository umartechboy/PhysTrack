function isavail = NodeAvailable(address, port)
%NODEAVAILABLE Connects and send a dummy command to see if the node is
%available;

    import java.net.Socket
    import java.net.SocketAddress
    import java.io.*
    try
        output_socket = Socket;        
        output_socket.connect(java.net.InetSocketAddress(address, port), 100)
    catch
        isavail = false;
        return
    end
    output_stream   = output_socket.getOutputStream;
    input_stream   = output_socket.getInputStream;
    PhysTrack.DCS.writeData(output_stream, [], 9);
    [data, id] = PhysTrack.DCS.readData(input_stream, 100);
    if id < 0
        isavail = false;
    else
        isavail = true;
    end
    
end

