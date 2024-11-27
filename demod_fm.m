clear;

%% Открытие файла, задание параметров сигнала
inputFile = 'file1EuropaPlus (1).bin';      
outputFile = 'outputFm.wav';   
fs = 500e3;                   
audioFs = 40e3;
fileId = fopen(inputFile);
signal = fread(fileId,'float32');

%% Формиование сигнала
I = signal(1:2:end);
Q = signal(2:2:end);
iqSignal = I + 1j*Q;

%% Обработка сигнала, извлечение фазы и вычисление частоты
phaseSignal = unwrap(angle(iqSignal));
fmSignal = diff(phaseSignal) ;

%% Фильтрация сигнала и пеенос на слышимую частоту
audioSignal = movmean(fmSignal, 11);
audioSignal = resample(audioSignal, audioFs, fs);

%% Избегание клиппинга 
audioSignal = audioSignal / max(abs(audioSignal));

%% Запись сигнала
audiowrite(outputFile, audioSignal, audioFs);
disp(['Демодуляция завершена. Файл: ', outputFile]);