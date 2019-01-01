function [index, address, port] = GetFreeNode(exceptionList)
%GETFREENODE Summary of this function goes here
%   Detailed explanation goes here
    import java.net.Socket
    import java.io.*
    PhysTrack.DCS.MakeServer;
    index = 0;
    address = [];
    port = [];
    if nargin == 0
        exceptionList = [];
    end
    for ii = 1:length(DCSServer.Nodes)   
        for jj = 1:length(exceptionList)
            if exceptionList(jj).Address == DCSServer.Nodes(ii).Address &&...
               exceptionList(jj).Port == DCSServer.Nodes(ii).Port
                continue;
            end
        end
        if PhysTrack.DCS.NodeAvailable(DCSServer.Nodes(ii).Address, DCSServer.Nodes(ii).Port)
            address = DCSServer.Nodes(ii).Address;
            port = DCSServer.Nodes(ii).Port;
            index = ii;
            return;
        end
    end
end

