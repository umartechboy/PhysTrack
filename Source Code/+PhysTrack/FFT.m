function [freqAxis, amplitudeAxis] = FFT(data, Fs, dataUnits, dataTitle)
if size(data,1) == 1
    data = data';
end

if nargin <=3
    dataUnits = 'the data';
end
meanData = data(:,1)-mean(data(:,1));
nearestPower = log2(length(data));
if nearestPower - floor(nearestPower) ~= 0 
    nearestPower = uint16(floor(nearestPower) + 1);
    lengthReq = 2^ nearestPower;
    meanData(lengthReq) = 0;
end
dataFFT = abs((fft(meanData))); %take the fourier transform of the position data
dataFFT = dataFFT * 1/length(meanData);
X_mag=abs(dataFFT);
N = double(length(meanData));
freqHz = (0:1:length(meanData)-1).*Fs./N;
 
%where Fs is your sampling rate (Hz) and N is your FFT block size (in your case N=length(x)).

%You can then plot the magnitude vs frequency as
X_mag = X_mag(1:round(length(freqHz)/2));
freqHz = freqHz(1:round(length(freqHz)/2));

if nargin > 2
    figure;
    plot(freqHz, X_mag);
    title(['Fast fourier transform (FFT) of ', dataTitle]);
    xlabel('Frequency (Hz)')
    ylabel(['Amplitude (', dataUnits,')']);
end
amplitudeAxis = X_mag;
freqAxis = freqHz;


end

