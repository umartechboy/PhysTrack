function [trajectories, vr2o_new] = KLT( vr2o, objs, previewDownSample )
%KLTGUI Summary of this function goes here
%   Detailed explanation goes here

evalin('base', 'global klt_gui_00_vr2o klt_gui_00_objs klt_gui_00_previewDownSample')
global klt_gui_00_vr2o klt_gui_00_objs klt_gui_00_previewDownSample
klt_gui_00_vr2o = vr2o;
klt_gui_00_objs = objs;
if nargin == 2 
    klt_gui_00_previewDownSample = 3;
else
    klt_gui_00_previewDownSample = previewDownSample;
end

    h = KLTGUI;
    uiwait(h);
	global klt_trajectories_00 klt_vr2o_new_00
    trajectories = klt_trajectories_00;
    vr2o_new = klt_vr2o_new_00;
    
    evalin('base', 'clear ans klt_vr2o_00 klt_tObs_00 klt_gui_00_objs klt_gui_00_previewDownSample klt_gui_00_vr2o wizard_00_sections klt_trajectories_00 klt_vr2o_new_00');
end