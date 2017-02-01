warning off
global vtt_vr2o_00 vtt_thresh_00
warning on
%histogram
set(handles.vtt, 'CurrentAxes', handles.histogramAxis);
[Ih, th, bkb] = getHistOnInd(vtt_vr2o_00, vtt_thresh_00, round(get(handles.slider1, 'Value')));
I = PhysTrack.read2(vtt_vr2o_00, round(get(handles.slider1,'Value')), false, true);
imshow(Ih);
%mainimage
set(handles.vtt, 'CurrentAxes', handles.mainAxis);
if get(handles.showRGB, 'Value')
    imshow(I);
else
    if get(handles.bkIsLight, 'Value')
        imshow(rgb2gray(I) < th);
    else
         imshow(rgb2gray(I) >= th);
    end
end
%keyframe bar
set(handles.vtt, 'CurrentAxes', handles.keyframesAxis);
imshow(getBinKeyFramesImage(vtt_vr2o_00, vtt_thresh_00));
drawnow;