function [trackPoints, validity] = RefineKLTTrackPoints(vr2o, trackPoints, validity, lastValidFI)

%try
    if nargin < 4
        error 'Provide a video reader 2 object for conversion, tracked points struct, validity struct and last valid frame Index'
    end
    evalin('base','global vtt_vr2o_00 vtt_trackPoints_00 vtt_validity_00 vtt_lastValidFI_00');
    assignin('base', 'vtt_vr2o_00', vr2o);
    assignin('base', 'vtt_trackPoints_00', trackPoints);
    assignin('base', 'vtt_validity_00', validity);
    assignin('base', 'vtt_lastValidFI_00', lastValidFI);
    
    addpath([pwd,'\GUIs']);
    if ~PhysTrack.vr2oExists
        return;
    end
    KLTTrackPointRefiner; 
    global vtt_trackPoints_00 vtt_validity_00
    if strcmp(questdlg('Do you want to keep the refining result?', '', 'Yes', 'No', 'Yes'), 'Yes')
        trackPoints = vtt_trackPoints_00;
        validity = vtt_validity_00;
    end
%catch
%end
evalin('base', 'clear vtt_vr2o_00 vtt_thresh_00 vtt_obs_00');
end