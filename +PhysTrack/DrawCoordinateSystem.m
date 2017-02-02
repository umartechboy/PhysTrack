function [ RefCoord, PixelsPerUnit] = DrawCoordinateSystem( vr2o, CurrentRefCoord)
%DRAWCOORDINATESYSTEM defines a coordinate system by manually drawing on
%the screen. If a value is given for cs_, it will be used as the starting
%value.

%try
    RefCoord = [];
    if nargin == 0
        error 'Provide a video reader 2 object for conversion.'
    end
    evalin('base','global vtt_vr2o_00 vtt_rw_00 vtt_curDir_00 vtt_ppm_00 vtt_ppmPoints_00');
    assignin('base', 'vtt_vr2o_00', vr2o);
    assignin('base', 'vtt_ppm_00', vr2o.CropRect(3) / 2);
    assignin('base', 'vtt_ppmPoints_00', []);
    addpath([pwd,'\GUIs']);
    if ~PhysTrack.vr2oExists
        RefCoord = [];
        return;
    end
    
    evalin('base', 'global vtt_rw_00');
    if nargin == 1
        assignin('base', 'vtt_rw_00' ,[0,0; vr2o.CropRect(4)*.8, 0; 0, vr2o.CropRect(4)*.4] + 1);
    else
        assignin('base', 'vtt_rw_00' ,CurrentRefCoord);
    end
    CoordinateSystemTool;
    global vtt_rw_00 vtt_ppm_00
	RefCoord = vtt_rw_00;
    PixelsPerUnit = vtt_ppm_00;
    if nargin == 2 && ~isstruct(vtt_rw_00)
        if strcmp(questdlg('Do you want to accept these changes?', 'Confirm changes.', 'Yes', 'No', 'Yes'), 'No')
            RefCoord = CurrentRefCoord;
        end
    end
%catch
%end
evalin('base', 'clear vtt_vr2o_00 vtt_thresh_00 vtt_rw_00 vtt_curDir_00 vtt_ppm_00 vtt_ppmPoints_00');
end
