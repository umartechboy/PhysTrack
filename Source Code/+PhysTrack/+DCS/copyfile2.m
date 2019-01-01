function [ output_args ] = copyfile2(source, dest)
FileInfo = dir(source);
FileSize = FileInfo.bytes;
waitH    = waitbar(0, sprintf('Copying %.2f MB', FileSize/1e6);
inFID = fopen(source, 'r');
if inFID == -1
  error('Cannot open file for reading: %s', source);
end
outFID = fopen(dest, 'w');
if outFID == -1, 
  fclose(inFID);
  error('Cannot open file for writing: %s', dest);
end
chunk  = 1e6;
nChunk = ceil(FileSize / chunk);
iChunk = 0;
while ~feof(inFID)
  iChunk = iChunk + 1;
  waitbar(iChunk / nChunk, waitH);
  data = fread(inFID, chunk, '*uint8');
  fwrite(outFID, data, 'uint8');
end
fclose(inFID);
fclose(outFID);
end