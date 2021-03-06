close all

filename = 'male_a.wav';

fs= Fs*0.1; %100�s = 0.1s is the Sampling frequency or sampling rate
%% M7
%Amplitude Spectrum as f(dB)=Hz
      fs = length(male_a);
fft_male = fft(male_a);
      fft_male = fft_male(1:fs/2+1);
      freq = 0:fs/length(male_a):fs/2;
%       subplot(2, 1, 2)
      plot(freq, 20+20*log10(abs(fft_male)));
      title('Male Speech Amplitude Spectrum and LPC Filter Response, p=[2,15,25]')
      xlabel('Frequency in Hz')
      ylabel('Magnitude in dB')
      grid on;
      axis tight
hold on

i = [2, 15, 25] ;
leg =[":g", "-.k", "-r"];
for v = 1:3
[lpc_coef,g] = lpc(male_a, i(v));
%Plot Frequency response of digital filter
[h,f] = freqz(10, lpc_coef, fs);
f= 1:1:fs;
      plot(f/2, 20*log10(abs(h)), leg(v), 'LineWidth', 2);
      hold on
end
      
      
      