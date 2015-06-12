function plotGroupedDataBySpeaker(prefixCode,expNum,flyNum,flyExpNum)

close all

set(0,'DefaultAxesFontSize', 16)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;

[~, path, ~, idString] = getDataFileName(exptInfo);
fileName = [path,idString,'groupedData.mat'];
fileName = 'C:\Users\Alex\My Documents\Data\aPN2\expNum001\flyNum002\flyExpNum003\150116_aPN2_expNum001_flyNum002_flyExpNum003_groupedData.mat';
load(fileName);

numStim = length(GroupData);

GroupData(4).voltage(4,:) = [];
GroupData(4).current(4,:) = [];
GroupData(7).voltage(4,:) = [];
GroupData(7).current(4,:) = [];
GroupData(9).voltage(4,:) = [];
GroupData(9).current(4,:) = [];
GroupData(10).voltage(5,:) = [];
GroupData(10).current(5,:) = [];
GroupData(11).voltage(5,:) = [];
GroupData(11).current(5,:) = [];

Colors = {'r','g','b'};
count = 0; 
fig = figure();
gray = [192 192 192]./255; 
    speakers = {'Fly''s left','Fly''s middle','Fly''s right'};
for n = 1:numStim
    count = count+1; 
    if count == 4
        fig = figure();
        count = 1; 
    end
    setCurrentFigurePosition(2)
    
    h(1) = subplot(3,1,1);
    plot(GroupStim(n).stimTime,GroupStim(n).stimulus,Colors{count})
    hold on 
    ylabel('Voltage (V)')
%     title(['Stimulus = ',num2str(n),', ',char(speakers(count))])
    set(gca,'Box','off','TickDir','out','XTickLabel','')

    h(3) = subplot(3,1,2);
%     plot(GroupData(n).sampTime,GroupData(n).voltage,'Color',gray)
%     hold on 
    plot(GroupData(n).sampTime,mean(GroupData(n).voltage),Colors{count})
    hold on 
    ylabel('Voltage (mV)')
    set(gca,'Box','off','TickDir','out','XTickLabel','')
        legend left middle right

    legend('Location','SouthEast')

    
    
    h(2) = subplot(3,1,3);
    plot(GroupData(n).sampTime,mean(GroupData(n).current),Colors{count})
    hold on 
    ylim([-40 -20])
    xlabel('Time (s)')
    ylabel('Current (pA)')
    set(gca,'Box','off','TickDir','out')
    
    
    linkaxes(h,'x')
    
    if count == 3
        saveFilename = ['C:\Users\Alex\My Documents\TempFigs\GroupedFigure_',num2str(n)];
        print(fig,'-dmeta',saveFilename,'-r300')
    end
    

    
end