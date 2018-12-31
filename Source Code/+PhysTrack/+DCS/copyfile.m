function copyfile(address, port, filename, targetname)
%COPYFILE copies the file specified at the specified address 
    import java.net.Socket
    import java.io.*
    output_socket = Socket(address, port);
    output_stream   = output_socket.getOutputStream;
    
    f = fopen(filename);
    comData = fread(f)';
    fclose(f);
    comData = [uint8(length(targetname)), uint8(targetname), uint8(comData)];
    PhysTrack.DCS.writeData(output_stream, comData, 5);
    output_socket.close;
end

