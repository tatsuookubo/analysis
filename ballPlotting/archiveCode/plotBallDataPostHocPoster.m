function plotBallDataPostHocPoster(prefixCode,expNum,flyNum,flyExpNum)

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
figSize = setFigSize(5,5);

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

for i = 1:length(uniqueStim)
    
    stimNumInd = find(groupedData.stimNum == uniqueStim(i));
    numTrials = size(groupedData.xDisp,1);
    stdX = std(groupedData.xDisp(stimNumInd,:))./sqrt(numTrials);
    hold on
    ph(i) = plot(mean(groupedData.xDisp(stimNumInd,:)),mean(groupedData.yDisp(stimNumInd,:)),'Color',colorSet(i,:),'LineWidth',3);
    hold on 
    plot(mean(groupedData.xDisp(stimNumInd,:))+stdX,mean(groupedData.yDisp(stimNumInd,:)),'Color',colorSet(i,:),'LineWidth',0.5)
    plot(mean(groupedData.xDisp(stimNumInd,:))-stdX,mean(groupedData.yDisp(stimNumInd,:)),'Color',colorSet(i,:),'LineWidth',0.5)
    axis tight
    axis square
    xlabel('X displacement (mm)')
    ylabel('Y displacement (mm)')
    if i == 2
    legend(ph(:),{'Left','Right'},'Location','NorthEastOutside')
    legend('boxoff')
    end
end

%% Save
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
mySave(saveFileName,figSize);

end
