close all
figure();
x = 1:0.1:100;
numSamps = length(x); 
sin1 = sin(x); 
plot(x,sin1) 
modEnvelope = sawtooth(2*pi*[.25:1/(2*(numSamps-1)):.75],.5);
plot(x,modEnvelope)
modulatedSound = sin1.*modEnvelope; 
plot(x,modulatedSound)
demodulatedSound = modulatedSound.*sin1'; 
plot(x,demodulatedSound) 


% Then low-pass filter 