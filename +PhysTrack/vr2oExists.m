function status  = vr2oExists(varName)
%CHECKVR2O Summary of this function goes here
%   Detailed explanation goes here
    if nargin == 0
        varName = 'vtt_vr2o_00';
    end
    recurs = true;
    while recurs
        recurs = false;
        status = evalin('base', ['exist(''', varName, ''')']);
        if status
            status = evalin('base', ['isstruct(', varName, ')']);
        end
        if ~status     
            if strcmp(questdlg(['A video reader object named ', varName, ' is needed which was not found in the base workspace. Do you want to create one now?'],'No video reader found','Yes', 'No', 'Yes'), 'Yes')
                evalin('base', ['global ', varName, '; ', varName, ' = PhysTrack.VideoReader2;']);
                recurs = true;
                continue;
            else
                status = false;
            end
        end
    end
end

