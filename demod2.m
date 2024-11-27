clear;    
outputFile = 'output.wav';   
fs = 12e3;                   
audioFs = 48e3;

fileId = fopen('am_sound (1).dat');
signal = fread(fileId,'float32');

I = signal(1:2:end);
Q = signal(2:2:end);
iqSignal = I + 1j*Q;

realSignal = real(iqSignal);
realSignal(~isfinite(realSignal)) = 0;
amDemodulated = abs(realSignal);
amDemodulated = movmean(amDemodulated, 5);
amDemodulated = amDemodulated - mean(amDemodulated);

lowCutoff = 500;  
highCutoff = 5000; 
nyquistFreq = fs / 2; 


normalizedLow = lowCutoff / nyquistFreq;
normalizedHigh = highCutoff / nyquistFreq;
[b, a] = butter(5, [normalizedLow, normalizedHigh], 'bandpass');


filteredSignal = filter(b, a, amDemodulated);

audioSignal = resample(filteredSignal, audioFs, fs);
audioSignal = audioSignal + mean(audioSignal);
audioSignal = audioSignal / max(abs(audioSignal)); 
audiowrite(outputFile, audioSignal, audioFs);

disp(['Демодуляция завершена. Аудиофайл сохранен как ', outputFile]);