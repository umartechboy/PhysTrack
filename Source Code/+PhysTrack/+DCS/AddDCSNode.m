function AddDCSNode(remotePCAddresses, Ports)
% Adds the specified node to the global DCSServer object. If no ports are
% specified, the script scans on first 32 ports and tries to add all of the
% ports that succeed
    PhysTrack.DCS.MakeServer;
    if ischar(remotePCAddresses)
        remotePCAddresses = {remotePCAddresses};
    end
    if nargin == 1
        Ports = 32;
    end
    if length(Ports) == 1 && Ports(1) < 10000 % its the range of ports to be scanned   
        found = 0;
        for iia = 1:length(remotePCAddresses)            
            fprintf(['Scanning ports on ',remotePCAddresses{iia},'\n'])
            for ii = 10000:(10000+Ports-1)
                if PhysTrack.DCS.NodeAvailable(remotePCAddresses{iia}, ii)
                    PhysTrack.DCS.AddDCSNode(remotePCAddresses{iia}, ii);
                    found = found + 1;
                end
            end
        end
        fprintf(['Total DCS nodes found: ', num2str(found), '\n'])
    else
        % creates a DCS server on the ip addresses provided
            for ii = 1:length(remotePCAddresses)
                if length(DCSServer.Nodes) == 1
                    DCSServer.Nodes(1).Address = remotePCAddresses{ii};
                    DCSServer.Nodes(1).Port = Ports(ii);
                else
                    DCSServer.Nodes(end + 1).Address = remotePCAddresses{ii};
                    DCSServer.Nodes(end).Port = Ports(ii);
                end
            end
    end
end

