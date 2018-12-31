function handle = GetNewProcessHandle(address, port)
% Acquires a new process handle from the specified DCS node. Returns zero
% if the noe doesn't respond.
try
    processHandles = PhysTrack.DCS.getvariable(address, port, 'processHandles', 1000);
catch
    handle = -1;
    return;
end
hinds = [];
for ii = 1:length(processHandles)
    hinds(end + 1) = processHandles(ii).Index;
end
handle = max(hinds)+1;
if isempty(handle)
    handle = 1;
end
end

