function [trajectories, vr2o_new] = BOTNew(vr2o, selObjects)
%BOTGUI Uses the code developed for BOT and runs it inside a GUI. Waits for
%the GUI to exit and then returns the results just like KLT. Can be used
%directly with the old BOT.

evalin('base', 'global bot_gui_00_vr2o bot_gui_00_objs')
global bot_gui_00_vr2o bot_gui_00_objs
bot_gui_00_vr2o = vr2o;
bot_gui_00_objs = selObjects;

    H = BOTGUI;
    uiwait(H);
	global bot_trajectories_00 bot_vr2o_new_00
    trajectories = bot_trajectories_00;
    vr2o_new = bot_vr2o_new_00;
    
    evalin('base', 'clear ans bot_vr2o_00 bot_tObs_00 bot_gui_00_objs bot_gui_00_vr2o wizard_00_sections bot_trajectories_00 bot_vr2o_new_00');
end
