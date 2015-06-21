function plotGroupedData

% (prefixCode,expNum,flyNum,flyExpNum)

close all

set(0,'DefaultAxesFontSize', 16)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

% exptInfo.prefixCode     = prefixCode;
% exptInfo.expNum         = expNum;
% exptInfo.flyNum         = flyNum;
% exptInfo.flyExpNum      = flyExpNum;

% [~, path, ~, idString] = getDataFileName(exptInfo);
% fileName = [path,idString,'groupedData.mat'];
% fileName = 'C:\Users\Alex\My Documents\Data\aPN2\expNum001\flyNum002\flyExpNum003\150116_aPN2_expNum001_flyNum002_flyExpNum003_groupedData.mat';
[file, path]= uigetfile;
fileName = [path,'\',file];
load(fileName);

numStim = length(GroupData);

% GroupData(4).voltage(4,:) = [];
% GroupData(4).current(4,:) = [];
% GroupData(7).voltage(4,:) = [];
% GroupData(7).current(4,:) = [];
% GroupData(9).voltage(4,:) = [];
% GroupData(9).current(4,:) = [];
% GroupData(10).voltage(5,:) = [];
% GroupData(10).current(5,:) = [];
% GroupData(11).voltage(5,:) = [];
% GroupData(11).current(5,:) = [];

gray = [192 192 192]./255;
count = 0;
speakers = {'Fly''s left','Fly''s middle','Fly''s right'};
for n = 1:numStim
    count = count + 1;
    
    fig = figure(n);
    
    setCurrentFigurePosition(2)
    
    h(1) = subplot(3,1,1);
    plot(GroupStim(n).stimTime,GroupStim(n).stimulus,'k')
    ylabel('Voltage (V)')
    title(['Stimulus = ',num2str(n),', ',char(speakers(count))])
    set(gca,'Box','off','TickDir','out','XTickLabel','')
    
    h(3) = subplot(3,1,2);
    plot(GroupData(n).sampTime,GroupData(n).voltage,'Color',gray)
    hold on
    plot(GroupData(n).sampTime,mean(GroupData(n).voltage),'k')
    % legend(strsplit(num2str(1:size(GroupData(n).voltage,1))))
    ylabel('Voltage (mV)')
    set(gca,'Box','off','TickDir','out','XTickLabel','')
    
    h(2) = subplot(3,1,3);
    plot(GroupData(n).sampTime,mean(GroupData(n).current),'k')
    xlabel('Time (s)')
    ylabel('Current (pA)')
    set(gca,'Box','off','TickDir','out')
    
    
    linkaxes(h,'x')
    
    saveFilename = ['C:\Users\Alex\My Documents\TempFigs\Figure_',num2str(n)];
    
    print(fig,'-dmeta',saveFilename,'-r300')
    clear fig
    
    if count == 3
        count = 0; 
    end
    
end