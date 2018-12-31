function needToExit = ListenerHandler(tcpipServer)
needToExit = false;
tic
input_stream   = tcpipServer.getInputStream;
while(1)
    if input_stream.available >= 1
        [data, id] = PhysTrack.DCS.readData(input_stream);
        if id == 6
            needToExit = true;
            return;
        end
        PhysTrack.DCS.handleCommand(data, id, tcpipServer.getInputStream, tcpipServer.getOutputStream);
        return;
    end
    pause(0.1);
    if toc > 3
        fprintf('No activity on client.\n')
        return;
    end
end
end