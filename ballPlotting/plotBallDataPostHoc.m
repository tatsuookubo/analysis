function plotBallDataPostHoc(prefixCode,expNum,flyNum,flyExpNum)

%% Load group filename
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
fileName = [path,fileNamePreamble,'groupedData.mat'];
load(fileName);
fileName = [path,fileNamePreamble,'exptData.mat'];
load(fileName);

firstTrialFileName = [path,fileNamePreamble,'trial',num2str(1,'%03d'),'.mat'];
load(firstTrialFileName);
%% Figure prep
close all
figure(1)
set(0,'DefaultFigureWindowStyle','normal')
setCurrentFigurePosition(1);
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
set(0,'DefaultFigureColor','w')

%% Calculate title 
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');
sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),...
    ', FlyExpNum ',num2str(exptInfo.flyExpNum)];['Aim: ',exptInfo.aim]};
fileStem = char(regexp(path,'.*(?=flyExpNum)','match'));
saveFolder = [fileStem,'Figures\'];
saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'.pdf'];

%% Hardcoded paramters 
timeBefore = 0.3; 
pipStartInd = Stim.startPadDur*Stim.sampleRate + 1; 
indBefore = pipStartInd - timeBefore*Stim.sampleRate; 
indAfter = pipStartInd + timeBefore*Stim.sampleRate;

%% Decode
uniqueStim = unique(groupedData.stimNum);
colorSet = distinguishable_colors(length(uniqueStim),'w');

h(1) = subtightplot (7, 2, 1, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
mySimplePlot(Stim.timeVec,Stim.stimulus)
set(gca,'XTick',[])
ylabel({'Stim';'(V)'})
set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
set(gca,'XColor','white')

for i = 1:length(uniqueStim)
    
    stimNumInd = find(groupedData.stimNum == uniqueStim(i));
    
    h(2) = subplot(7,2,3);
    hold on
    mySimplePlot(Stim.timeVec,mean(groupedData.xVel(stimNumInd,:)),'Color',colorSet(i,:))
    set(gca,'XTick',[])
    ylabel({'Lateral Vel';'(mm/s)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    moveXAxis(Stim)
    shadestimArea(Stim)
    
    h(3) = subplot(7,2,5);
    hold on
    mySimplePlot(Stim.timeVec,mean(groupedData.yVel(stimNumInd,:)),'Color',colorSet(i,:))
    set(gca,'XTick',[])
    ylabel({'Forward Vel';'(mm/s)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    shadestimArea(Stim)
    moveXAxis(Stim)
    
    h(4) = subplot(7,2,7);
    hold on
    mySimplePlot(Stim.timeVec,mean(groupedData.xDisp(stimNumInd,:)),'Color',colorSet(i,:))
    set(gca,'XTick',[])
    ylabel({'X Disp';'(mm)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    shadestimArea(Stim)
    moveXAxis(Stim)
    
    h(5) = subplot(7,2,9);
    hold on
    mySimplePlot(Stim.timeVec,mean(groupedData.yDisp(stimNumInd,:)),'Color',colorSet(i,:))
    ylabel({'Y Disp';'(mm)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    line([Stim.timeVec(1),Stim.timeVec(end)],[0,0],'Color','k')
    shadestimArea(Stim)
    xlabel('Time (s)')
    linkaxes(h(:),'x')
    
    subtightplot (7, 2, 11, [0.1 0.05], [0.1 0.01], [0.1 0.01]);
    bins = -10:0.5:40;
    vTemp = groupedData.yVel(:);
    hist(vTemp,bins);
    xlim([-10 40])
    xlabel('Forward velocity (mm/s)')
    ylabel('Counts')
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    box off;
    set(gca,'TickDir','out')
    axis tight
    
    subtightplot (7, 2, 13, [0.1 0.05], [0.1 0.01], [0.1 0.01]);
    bins = -10:0.5:40;
    vTemp = groupedData.xVel(:);
    hist(vTemp,bins);
    xlim([-10 40])
    xlabel('Lateral velocity (mm/s)')
    ylabel('Counts')
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    box off;
    set(gca,'TickDir','out')
    axis tight
    
    subplot(7,2,2:2:6)
    hold on
    line([groupedData.xDisp(stimNumInd,pipStartInd),groupedData.xDisp(stimNumInd,indBefore)]',[groupedData.yDisp(stimNumInd,pipStartInd),groupedData.yDisp(stimNumInd,indBefore)]','Color','k');
    line([groupedData.xDisp(stimNumInd,pipStartInd),groupedData.xDisp(stimNumInd,indAfter)]',[groupedData.yDisp(stimNumInd,pipStartInd),groupedData.yDisp(stimNumInd,indAfter)]','Color',colorSet(i,:));
    axis tight 
    axis square
    ylabel('Y displacement (mm)')
    
    
    subtightplot (7, 2, 8:2:14, [0.1 0.05], [0.1 0.01], [0.1 0.01]);
    hold on
    plot(mean(groupedData.xDisp(stimNumInd,:)),mean(groupedData.yDisp(stimNumInd,:)),'Color',colorSet(i,:))
    hold on 
    axis tight
    axis square
    xlabel('X displacement (mm)')
    ylabel('Y displacement (mm)')
    if i == 2
    legend({'Left','Right'},'Location','NorthEastOutside')
    legend('boxoff')
    end
end

    
suptitle(sumTitle)

%% Save
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
mySave(saveFileName);

end

function shadestimArea(Stim)
gray = [192 192 192]./255;
pipStarts = Stim.startPadDur;
pipEnds = Stim.startPadDur + Stim.stimDur;
Y = ylim(gca);
X = [pipStarts,pipEnds];
line([X(1) X(1)],[Y(1) Y(2)],'Color',gray);
line([X(2) X(2)],[Y(1) Y(2)],'Color',gray);
colormap hsv
alpha(.1)
end

function moveXAxis(Stim)
set(gca,'XColor','white')
line([Stim.timeVec(1),Stim.timeVec(end)],[0,0],'Color','k')
end