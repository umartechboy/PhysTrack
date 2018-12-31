function [success] = RunWizard(scriptFileName)
% This function takes a filename of a WizardEncoded file, creates a
% simple GUI wizard out of it and executes the resulting wizard. 
    evalin('base', 'clear all');
    close all force;
    clc;
    addpath('GUIs');
    if ~exist(scriptFileName, 'file')
        error ''
    end
    try
        script = fileread(scriptFileName);
    catch
        try
            script = fileread([scriptFileName, '.m']);
        catch
            error 'No Matlab script was found with this name.'
        end
    end
    sections = PhysTrack.Wizard.Split(script);
    if length(sections) > 0
        Wizard(sections);
    end
end

