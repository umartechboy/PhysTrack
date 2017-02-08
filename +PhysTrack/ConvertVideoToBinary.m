function vr2oOut = ConvertVideoToBinary(vr2o)
% CONVERTVIDEOTOBINARY To convert an existing RGB video reader 
% object to binary use this function to call the convertToBin 
% GUI. The GUI provides necessary tools to specify different 
% thresholds at different indices and color of background of 
% the frame.
%    See also PHYSTRACK.read2 PHYSTRACK.VIDEOREADER2


    if nargin == 0
        error 'Provide a video reader 2 object for conversion.'
    end
    % create the base variables
    evalin('base','global vtt_vr2o_00 vtt_thresh_00');
    assignin('base', 'vtt_vr2o_00', vr2o);
    % confirm that GUI is in the path
    addpath([pwd,'\GUIs']);
    if ~PhysTrack.vr2oExists
        vr2oOut = [];
        return;
    end
    % create a backup vr2o
    vr2oOut = vr2o;
    % now that the base variables are set, call the GUI
    convertToBin;
    % Hook to the global variables created by the GUI    
    
    % vtt_thresh_00 is a nx2 array. each point indicates a threshold at a
    % given index. if the index is 0, it means that this index is either
    % temporary or applies to the whole video if there are now other points
    % in vtt_thresh_00. If there is one none zero and one 0  index point in
    % vtt_thresh_00, the thrshold with non zero index will apply to the
    % whole video and zero index will be ignored.
    % if vtt_thresh_00 incldus mutliple non zero index points, curve fitting will be performed on all the nmon zero points with a matching order of polynomial equation. 
    
    global vtt_vr2o_00 vtt_thresh_00
    % check if the GUI saved some data
    if isstruct(vtt_vr2o_00)
        if strcmp(questdlg('Do you want to accept these changes?', 'Confirm changes', 'Yes', 'No', 'Yes'), 'Yes')
            % update our backup vro
            vr2oOut = vtt_vr2o_00;
            % check if the last point is empty
            if size(vtt_thresh_00, 1) > 1
                if vtt_thresh_00(end,1) == 0
                    vtt_thresh_00(end,:) = [];
                end
            end
            if size(vtt_thresh_00, 1) == 1
                vr2oOut.BinaryThreshold = vtt_thresh_00(1, 2);
            else
                thFit = PhysTrack.lsqCFit(double(vtt_thresh_00(:,1)), double(vtt_thresh_00(:,2)), 'th', PhysTrack.getPolynomialFunction(size(vtt_thresh_00, 1) - 1), 'x');
                vr2oOut.BinaryThreshold = thFit;
            end
        end
    end
    %clear the temporary variables.
    evalin('base', 'clear vtt_vr2o_00 vtt_thresh_00');
end

