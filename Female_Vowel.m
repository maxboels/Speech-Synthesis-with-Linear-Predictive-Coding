clear all
%Read and Play audio file
filename='had_f.wav';
[had_f,Fs] = audioread(filename);
sound(had_f,Fs);
%Get infos
info= audioinfo(filename);
whos had_f;
% Use the spectogram to identify the voice section
segmentlen = 100;
noverlap = 90;
NFFT = 128;
spectrogram(had_f,segmentlen,noverlap,NFFT,Fs,'yaxis')
title('Signal Spectrogram')
%Cut segment of 100ms (0.1s) in length from each vowel
dt = 1/Fs;
I0 = round(0.05/dt);
Iend = round(0.150/dt);
samples=[I0,Iend];
[female_a,Fs] = audioread(filename,samples);
sound(female_a,Fs);
audiowrite('female_a.wav',female_a,Fs);
%Get infos
info= audioinfo(filename);


