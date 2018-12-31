function [success] = EvalInFile(script)
fid = fopen('WizardTemp.m','wt');
s = 'hi';
fprintf(fid, s);
fclose(fid);
evalin('base', 'WizardTemp');
end

