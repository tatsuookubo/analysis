function turnHistPlot(prefixCode,expNum,flyNum,flyExpNum)

%% Load group filename
dsFactor = 400;
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
saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'turnHist','.pdf'];

%% Hardcoded paramters 
timeBefore = 0.3; 
pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1; 
indBefore = pipStartInd - timeBefore*Stim.sampleRate/dsFactor; 
indAfter = pipStartInd + timeBefore*Stim.sampleRate/dsFactor;

%% Decode
uniqueStim = unique(groupedData.stimNum);
colorSet = distinguishable_colors(length(uniqueStim),'w');

for i = 1:length(uniqueStim)
    
    stimNumInd = find(groupedData.stimNum == uniqueStim(i));
    
%     h(i) = subplot(1,2,i);
%     hold on
%     line([groupedData.xDisp(stimNumInd,pipStartInd),groupedData.xDisp(stimNumInd,indBefore)]',[groupedData.yDisp(stimNumInd,pipStartInd),groupedData.yDisp(stimNumInd,indBefore)]','Color','k');
%     line([groupedData.xDisp(stimNumInd,pipStartInd),groupedData.xDisp(stimNumInd,indAfter)]',[groupedData.yDisp(stimNumInd,pipStartInd),groupedData.yDisp(stimNumInd,indAfter)]','Color',colorSet(i,:));
%     symAxis
%     ylabel('Y displacement (mm)')
    
    bins = -5:0.5:5;
    vTemp = groupedData.xDisp(stimNumInd,indAfter);
    hist(vTemp,bins);
    xlim([-10 40])
    xlabel('Lateral velocity (mm/s)')
    ylabel('Counts')
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    box off;
    set(gca,'TickDir','out')
    axis tight
    h = findobj(gca,'Type','patch');
    set(h,'FaceColor',colorSet(i,:),'EdgeColor','w','FaceAlpha',0.3);
    hold on 
    
    
end
% linkaxes(h(:))
% xlim([-2,2])
    
suptitle(sumTitle)

%% Save
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
mySave(saveFileName);

end
