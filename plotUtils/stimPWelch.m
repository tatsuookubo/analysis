function stimPWelch(stim) 

FS = stim.sampleRate; 
t = [0:stim.totalDur*stim.sampleRate-1] / FS;
sig = stim.stimulus;
 
figure;
[P1,m1] = pwelch( sig, 4096, 4000, 4096, FS );
P1 = 10*log10(P1);
 
 
hold on;
plot( m1, P1, 'b' );
xlabel('Freq (Hz)');
legend('Signal', 'Response');
xlim([0 1000]);

end