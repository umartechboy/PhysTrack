function vwo = writeVideo2(vwo, I)
if isstruct(vwo)
    num = num2str(vwo.FrameNumber);
    while length(num) < 4
        num = ['0', num];
    end
    imwrite(I, [vwo.FileName, '_', num, vwo.Extension]);
    vwo.FrameNumber = vwo.FrameNumber + 1;
else
    writeVideo(vwo, I);
end
end

