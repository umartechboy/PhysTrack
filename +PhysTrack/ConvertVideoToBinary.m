function vr2oOut = ConvertVideoToBinary(vr2o)
%CONVERTVIDEOTOBINARY Summary of this function goes here
%   Detailed explanation goes here


%try
    if nargin == 0
        error 'Provide a video reader 2 object for conversion.'
    end
    evalin('base','global vtt_vr2o_00 vtt_thresh_00');
    assignin('base', 'vtt_vr2o_00', vr2o);
    addpath([pwd,'\GUIs']);
    if ~PhysTrack.vr2oExists
        vr2oOut = [];
        return;
    end
    vr2oOut = vr2o;
    convertToBin;
    global vtt_vr2o_00 vtt_thresh_00
    if isstruct(vtt_vr2o_00)
        if strcmp(questdlg('Do you want to accept these changes?', 'Confirm changes', 'Yes', 'No', 'Yes'), 'Yes')
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
%catch
%end
evalin('base', 'clear vtt_vr2o_00 vtt_thresh_00');
end

