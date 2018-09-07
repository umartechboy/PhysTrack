function obs = GetObjects(vr2o, resumeFromInd, lastObj)
%GETOBJECTS gets objects in the first frame of the video reader object. It
%will show a GUI tool to manually define objects. The tool can also
%detect object on the basis of binary threshold and movement detection.
%
%    See also PhysTrack.KLT, PhysTrack.BOT, PhysTrack.VideoReader2

    obs = [];
    if nargin == 0
        error 'Provide a video reader 2 object to detect the objects in.'
    end
    if nargin <= 1
        resumeFromInd = 1;    
    end
    if nargin <= 2
        lastObj = [0,0,0,0];    
    end
    evalin('base','global vtt_vr2o_00 vtt_obs_00');
    assignin('base', 'vtt_vr2o_00', vr2o);
    addpath([pwd,'\GUIs']);
    if ~PhysTrack.vr2oExists
        obs = [];
        return;
    end
    % present the GUI
    global vtt_obs_00 vtt_resumeFromInd_00 vtt_lastObj_00
    vtt_resumeFromInd_00 = resumeFromInd;
    vtt_lastObj_00 = lastObj;
    objectSelecter;
    if ~isempty(vtt_obs_00)
        obs = vtt_obs_00;
    end
    evalin('base', 'clear vtt_vr2o_00 vtt_thresh_00 vtt_obs_00 vtt_resumeFromInd_00');
end

