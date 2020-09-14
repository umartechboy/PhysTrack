function writer = VideoWriter2(fileNameSeed, ext, makeImageSequence)
if nargin == 1
    makeImageSequence = false;
end
if makeImageSequence
    writer.FileName = fileNameSeed;
    writer.FrameNumber = 1;
    writer.Extension = ext;
else
    writer = VideoWriter(fileNameSeed);
end
end

