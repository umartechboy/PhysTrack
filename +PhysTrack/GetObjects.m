function obs = GetObjects(vr2o)
%GETOBJECTS gets objects in the first frame of the video reader object. It
%will present with a GUI tool to manually define objects. The tool can also
%detect object on the basis of binary threshold and movement detection.

%try
    obs = [];
    if nargin == 0
        error 'Provide a video reader 2 object for conversion.'
    end
    evalin('base','global vtt_vr2o_00 vtt_obs_00');
    assignin('base', 'vtt_vr2o_00', vr2o);
    addpath([pwd,'\GUIs']);
    if ~PhysTrack.vr2oExists
        obs = [];
        return;
    end
    objectSelecter;
    global vtt_obs_00
    if ~isempty(vtt_obs_00)
        obs = vtt_obs_00;
    end
%catch
%end
evalin('base', 'clear vtt_vr2o_00 vtt_thresh_00 vtt_obs_00');
end

