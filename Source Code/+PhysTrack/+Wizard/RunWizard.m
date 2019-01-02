function [success] = RunWizard(scriptFileName)
% This function takes a filename of a WizardEncoded file, creates a
% simple GUI wizard out of it and executes the resulting wizard. 
if nargin == 0% this gets a file first and tries to run it like a wizard
    [fileName, rootPath, filterIndex] = uigetfile({'*.m','Matlab Script File';'*.*','All Files'}, 'Select a Matlab Script File');
    scriptFileName = strcat(rootPath,fileName);
    PhysTrack.Wizard.RunWizard(scriptFileName);
    clear fileName rootPath filterIndex     
end
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