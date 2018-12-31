function vr2o_dcs = VideoReader2(varargin)
%This function generates a video reader2 to be used for a remote DCS node. 
% VideoReader2 is called on the local machine and the userer creates the
% vr object on the local machine. These object can be sent over to the remote PC
% along with an instruction to copy the target video file from the shared
% network directory.
% The script prompts to copy the file to the remote PC local drive as well.
% in which case, the remote address will become the local address of the
% remote pc.


vr2o = PhysTrack.VideoReader2(varargin);
if isempty(vr2o)
    return;
end
vr2o_dcs = PhysTrack.DCS.PrepareVR2ObjForDCS(vr2o);

end

