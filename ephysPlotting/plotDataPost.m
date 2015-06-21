function plotDataPost

uiopen; 

stimTime = [1/stim.sampleRate:1/stim.sampleRate:stim.totalDur]';
figure() 
h(1) = subplot(3,1,1); 
plot(stimTime,stim.stimulus) 
ylabel('Voltage (V)') 
title('Sound Stimulus') 

sampTime = [1/meta.inRate:1/meta.inRate:stim.totalDur]';
h(3) = subplot(3,1,2); 
plot(sampTime,data.voltage) 
title('Voltage') 
ylabel('Voltage (mV)')

h(2) = subplot(3,1,3); 
plot(sampTime,data.current)
xlabel('Time (s)') 
title('Current') 
ylabel('Current (pA)') 

linkaxes(h,'x') 
normVolt = data.voltage - mean(data.voltage); 
figure() 
plot(sampTime,normVolt) 
xlabel('Time (s)')
fftPlot(meta.inRate,data.voltage)

%% Plot average 
% find the start and end of each pip 
% Note that start includes a zero for ease 
logi = stim.stimulus ~= 0 ; 
logiStart = strfind(logi',[0 1]); 
logiStart = logiStart; 
logiEnd = strfind(logi',[1 0]); 

% Check that I chose the right start points 
% figure() 
% plot(logi,'r') 
% hold on 
% plot(stim.stimulus) 
% hold on 
% plot(logiStart,stim.stimulus(logiStart),'go')
% hold on 
% plot(logiEnd,stim.stimulus(logiEnd),'mo')

% Ignore the first and last pip 
logiStart(1)= []; 

% time 
stimTime = 1/stim.sampleRate:1/stim.sampleRate:10;
dataTime = 1/meta.inRate:1/meta.inRate:10;
stimTimeShort = stimTime(logiEnd(1):logiStart(1+1));

figure() 
h(1) = subplot(3,1,1); 
for i = 1:length(logiStart) - 1
    plot(stimTimeShort,stim.stimulus(logiEnd(i):logiStart(i+1)))
    hold on 
end
title('stimulus') 

for i = 1:length(logiStart) - 1
    volt(i,:) = data.voltage(logiEnd(i)/10:logiStart(i+1)/10);
    curr(i,:) = data.current(logiEnd(i)/10:logiStart(i+1)/10);
    hold on 
end
dataTimeShort = dataTime(logiEnd(1)/10:logiStart(1+1)/10);
h(2) = subplot(3,1,2); 
plot(dataTimeShort,mean(volt)) 
title('voltage') 

h(3) = subplot(3,1,3); 
plot(dataTimeShort,mean(curr))
title('current') 

linkaxes(h,'x') 

fftPlot(meta.inRate,mean(volt))
% find(logi>0,1,'first') 
% logiStart(1) 