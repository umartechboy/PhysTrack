function KLTGUI( vr2o, objs, previewDownSample )
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

KLTGUI;
end

