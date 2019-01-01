function AssertNodeAvailable(address, port)
% check if the node is available. If not, produces an error;
if PhysTrack.DCS.NodeAvailable(address, port) == 0
    error 'Node not available';
end
end