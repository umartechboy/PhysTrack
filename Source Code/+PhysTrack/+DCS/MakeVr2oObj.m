function vr2o_dcs = MakeVr2oObj(vr2o_dcs)
%MAKEVR2OOBJ Confirms that the vr2 object contains an obj object by
%initializing a vro object over the remote file path provided.
if isfield(vr2o_dcs, 'obj')
    return;
end
if ~isfield(vr2o_dcs, 'RemoteFilePath')
    return;
end
vr2o_dcs.obj = VideoReader(vr2o_dcs.RemoteFilePath);
end

