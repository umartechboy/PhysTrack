function KLT1(vr2o_dcs, objs, previewDownSample)
% This function executes KLT on a remote DCS node asynchronously. Returns a
% handle to the remote KLT instance which can later be used to acquire the
% data back from the remote node.
vr2o_dcs = PhysTrack.DCS.PrepareVR2ObjForDCS(vr2o_dcs);
exceptionList = [];
if isempty(vr2o_dcs.TargetNode) % no target specified yet
    
    [index, nodeAddress, nodePort] = PhysTrack.DCS.GetFreeNode();
    exceptionList = [];
    while PhysTrack.DCS.existon(nodeAddress, nodePort, 'klt2Pending')
        exceptionList(end + 1).Address = nodeAddress;
        exceptionList(end).Port = nodePort;
        [index, nodeAddress, nodePort] = PhysTrack.DCS.GetFreeNode(exceptionList);
    end
    
    if index <=0
        error 'No DCS node is available to do this process';
    end
    vr2o_dcs = rmfield(vr2o_dcs, 'TargetNode');
    vr2o_dcs.TargetNode.Index = index;
    vr2o_dcs.TargetNode.Address = nodeAddress;
    vr2o_dcs.TargetNode.Port = nodePort;
end
if nargin <= 2
    previewDownSample = 1;
end
    
KLT_DCS_Handle = PhysTrack.DCS.evaluateFunctionASync(vr2o_dcs.TargetNode.Address, vr2o_dcs.TargetNode.Port, 'PhysTrack.KLT1', vr2o_dcs, objs, previewDownSample, true);

end

