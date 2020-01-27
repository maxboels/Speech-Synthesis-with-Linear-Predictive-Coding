%Synthesize
 close all
%% M5: Generate a periodic impulse with the same fundamental frequency and
% generate the speech synthesis.

%frequency of the impulse in Hz
mean_fund_freq=f_mean; %200 peaks per second, so for 0.1 sec 200/10= 20 peaks
fs=2400; % sample frequency
t=0:1/240:1; % time vector for 1 second
y=zeros(size(t));
y(1:fs/mean_fund_freq:end)=1; %Length/#of peaks/s= Period(T). 
plot(t,y);
title('Female Periodic impulse train')
xlabel('Time(second)')
ylabel('Amplitude')
sound(y)
%Speech Synthesis

synth_female = filter(1, lpc_coef, y);
sound(synth_female,2400);

audiowrite('female_synthesis_a.wav',synth_female,Fs);



