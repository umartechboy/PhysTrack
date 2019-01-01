function vr2oOut = TrimVideo(vr2o, silent)
%TRIMVIDEO interacts with the user using a GUI tool to obtain the trimming
% information for a given videoreader2 object. The usage of the GUI is
% extremely simple and self explanatory.

    if nargin == 0
        error 'Provide a video reader 2 object to be trimmed.'
    end
    if nargin == 1
        silent = false;
    end
    evalin('base','global vtt_vr2o_00');
    assignin('base', 'vtt_vr2o_00', vr2o);
    addpath([pwd,'\GUIs']);
    if ~PhysTrack.vr2oExists
        vr2oOut = [];
        return;
    end
    vr2oOut = vr2o;
    vidTrimTool;
    global vtt_vr2o_00
    if isstruct(vtt_vr2o_00)
        if silent
            vr2oOut = vtt_vr2o_00;
        elseif strcmp(questdlg('Do you want to accept these changes?', 'Confirm changes', 'Yes', 'No', 'Yes'), 'Yes')
            vr2oOut = vtt_vr2o_00;
        end
    end
    evalin('base', 'clear vtt_vr2o_00');
end

