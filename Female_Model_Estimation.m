clear all
close all

LPC_Order= 20;
filename = 'female_a.wav';

[female_a,Fs] = audioread(filename);
sound(female_a, Fs)
info= audioinfo(filename); % # of samples: 240, sample rate(Fs): 24000
plot(female_a)
title('Female Vowel ??')

fs= Fs*0.1; %100µs = 0.1s is the Sampling frequency or sampling rate
%Which means 240 samples for 0.1 second
%T is the time distance between waves( x-axis).
%T = 1/freq because freq is in Hertz/sec.
%Freq = is the number of waves per second. So, Freq= 1/T

% Model Estimation
% AR modelling with lpc to estimate the LPC coefficients that provide a 
% least-squares error fit to the speech waveform.

%% M1: LPC Coefficients Estimation
%[a,g] = lpc(a_f,p) with p: order, a: coefficient, g: variance of prediction error.
[lpc_coef,g] = lpc(female_a, LPC_Order);


%% M2: Plot frequency of lpc filter response + and speech amplitude spectrum dB=f(Fs)

%Plot Frequency response of digital filter
      figure()
[h,f] = freqz(10, lpc_coef, fs);
      plot(f, 20*log10(abs(h)), 'LineWidth', 2);
      title('Frequency of LPC filter response')
      hold on
      
      figure()
      subplot(2, 1, 1)    
freqz(10, lpc_coef, fs);
      title('Female Frequency of LPC filter response')
      hold on
    
%Amplitude Spectrum as f(dB)=Hz
      fs = length(female_a);
fft_female = fft(female_a);
      fft_female = fft_female(1:fs/2+1);
      freq = 0:fs/length(female_a):fs/2;
      subplot(2, 1, 2)
      plot(freq, 10+20*log10(abs(fft_female)));
      title('Magnitude response of the audio signal')
      xlabel('Frequency in Hz')
      ylabel('Magnitude in dB')
      grid on;
      axis tight
         
% %Frequency Domaine Analysis: Magnitude and Phase of lpc filter response.
% NFFT = length(female_a);
% freq = 0:fs/NFFT;
% X = ((0:fs/NFFT:fs-fs/2)).';
% Y = fft(female_a, NFFT);
% 
% magnitudeY = abs(Y);
% phaseY = unwrap(angle(Y));
% 
% figure()
% plot(X(1:NFFT/2), 20*log10(magnitudeY(1:NFFT/2)));
% title('Magnitude response of the audio signal')
% xlabel('Frequency in Hz')
% ylabel('dB')
% grid on;
% axis tight

%-------------------------------------------------------------------------------%
%frequency of lpc filter response + and speech amplitude spectrum dB=f(Fs)
% fs = length(est_female_a); %NFFT: length or #of samples of the signal.
% Y = fft(est_female_a, fs);
% X = ((0:1/fs:1-1/fs)*fs).';
% plot(1:fs/2, log10(abs(Y(1:fs/2))), 'b')

%Compute the prediction error and the  autocorrelation sequence of the prediction error. Plot the autocorrelation.
%The prediction error is approximately white Gaussian noise, as expected for a third-order AR input process.
% error = female_a-est_female_a;
% [acs,lags] = xcorr(error,'coeff');
% 
% figure()
% plot(lags,acs)
% grid
% xlabel('Lags')
% ylabel('Normalized Autocorrelation')
% ylim([-0.1 1.1])

%Compare Actual and PRedicted Signals
% cla
% stem([female_a(2:end),est_female_a(1:end-1)])
% xlabel('Sample time')
% ylabel('Signal value')
% legend('Female "A" vowel','Signal estimate from LPC predictor')
% axis([0 100 -1 1])
% grid on
% title('Compare original and predicted signal')


%% M3: 3 First Formant Frequency Estimation.
rts = roots(lpc_coef);
rts = rts(imag(rts)>=0);
angz = atan2(imag(rts),real(rts));
[frqs,indices] = sort(angz.*(fs/(2*pi)));
bw = -1/2*(fs/(2*pi))*log(abs(rts(indices)));

% Plot #2: the poles with Roots
figure()
zplane(rts);
xlabel('Real')
ylabel('Imaginary')
title('Female Poles Unit Circle')

%Use the criterion that formant frequencies should be greater than 90 Hz
% to determine the formants.
formants = sort(frqs(frqs > 90));
formants = formants(2:4);
formatSpec = 'The 3 Formants Frequencies are %1.3f, %2.3f and %3.3f\n';
fprintf(formatSpec,formants)

%% M4: Mean Fundamental Frequency Estimation.

f_mean = mean(pitch(female_a,Fs))

%% ------> Synthesis