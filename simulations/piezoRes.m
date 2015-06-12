close all 
clear all

fs = 1/1e4; 
time = fs:fs:1; 
freq = 800;

wave = 0.15*sin(time*freq*2*pi); 

res1 = 0.009155;
res2 = 0.027466;

wave1 = res1.*(round(wave./res1));
wave2 = res2.*(round(wave./res2));

figure()
plot(time,wave)
hold on 
plot(time,wave1,'r')
hold on 
plot(time,wave2,'b')

%% PSD
sampRate = 1/fs; 
 
figure;
[P1,m1] = pwelch(wave, 4096, 4000, 4096, sampRate);
P1 = 10*log10(P1);

[P1_resp,m1_resp] = pwelch(wave1, 2*4096, 2*4000, 2*4096, sampRate);
P1_resp = 10*log10(P1_resp);

[P1_resp2,m1_resp2] = pwelch(wave2, 2*4096, 2*4000, 2*4096, sampRate);
P1_resp2 = 10*log10(P1_resp2);

hold on;
plot( m1, P1, 'k' );
plot( m1_resp, P1_resp, 'r' );
plot( m1_resp2, P1_resp2, 'b' );
xlabel('Freq (Hz)');
legend('Signal', 'High res', 'Low res');
xlim([0 5000]);