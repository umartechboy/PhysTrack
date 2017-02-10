function timeStamps = GenerateTimeStamps(vro)
% Generates timestamps from the video reader object.
timeStamps = (double((1:vro.TotalFrames) - 1) / double(vro.FPS))';
end

