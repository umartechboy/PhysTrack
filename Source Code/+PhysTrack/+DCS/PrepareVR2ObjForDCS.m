function vr2o_dcs = PrepareVR2ObjForDCS(vr2o_dcs)
% Adds neccessary definitions to the given vr2o to be used with dcs.

if ~isfield(vr2o_dcs, 'RemoteFilePath')
    remotePath = ['\\',getenv('computername'), '\', vr2o_dcs.obj.Path(1), vr2o_dcs.obj.Path(3:end), '\', vr2o_dcs.obj.Name];
    remotePath = PhysTrack.askValue('Kindly confirm the shareable network address for this file.', remotePath, 'Network address');
    vr2o_dcs.RemoteFilePath = remotePath;
end

if ~isfield(vr2o_dcs, 'TargetNode')
    vr2o_dcs.TargetNode = [];
end

if isempty(vr2o_dcs.TargetNode)
    if strcmp(questdlg('Do you want to copy this file to a local directory on the remote machine?', 'Yes', 'No'), 'Yes')    
        [index, nodeAddress, nodePort] = PhysTrack.DCS.GetFreeNode();
        if index <= 0
            msgbox('No DCS nodes are currently available for this task.');
            return;
        end
        [success, targetAddress] = PhysTrack.DCS.copyfile3(nodeAddress, nodePort, remotePath, vr2o_dcs.obj.Name);
        if success
            vr2o_dcs.RemoteFilePath = targetAddress;  
            if isfield(vr2o_dcs, 'TargetNode')
                vr2o_dcs = rmfield(vr2o_dcs, 'TargetNode'); 
            end
            vr2o_dcs.TargetNode.Index = index;    
            vr2o_dcs.TargetNode.Address = nodeAddress;  
            vr2o_dcs.TargetNode.Port = nodePort;   
        end
    end
end
end

