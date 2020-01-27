clear all
%Read and Play audio file
filename='had_m.wav';
[had_m,Fs] = audioread(filename);
sound(had_m,Fs);
%Get infos
info= audioinfo(filename);
whos had_m;
% Use the spectogram to identify the voice section
segmentlen = 100;
noverlap = 90;
NFFT = 128;
spectrogram(had_m,segmentlen,noverlap,NFFT,Fs,'yaxis')
title('Signal Spectrogram')
%Cut segment of 100ms (0.1s) in length from each vowel
dt = 1/Fs;
I0 = round(0.05/dt);
Iend = round(0.150/dt);
samples=[I0,Iend];
[male_a,Fs] = audioread(filename,samples);
sound(male_a,Fs);
audiowrite('male_a.wav',male_a,Fs);
%Get infos
info= audioinfo(filename);
