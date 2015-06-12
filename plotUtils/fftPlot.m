function fftPlot(sampRate,data)

T = 1/sampRate;                     % Sample time
numSamps = length(data);

NFFT = 2^nextpow2(numSamps); % Next power of 2 from length of data
Y = fft(data,NFFT)/numSamps;
f = sampRate/2*linspace(0,1,NFFT/2+1);

% Plot single-sided amplitude spectrum.
figure() 
plot(f,2*abs(Y(1:NFFT/2+1))) 
title('Single-Sided Amplitude Spectrum of data(t)')
xlabel('Frequency (Hz)')
ylabel('|Y(f)|')