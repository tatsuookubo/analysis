function plotBallDataDiffStim_TO(prefixCode,expNum,flyNum,flyExpNum)
%%% take Data and plot the results according to trial type
%%% based on Alex's code
%%% Tatsuo Okubo
%%% 2016/05/15

%% Load group filename
dsFactor = 400;
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
fileName = [path,fileNamePreamble,'groupedData.mat'];
load(fileName);
struct(Data)
fileName = [path,fileNamePreamble,'exptData.mat'];
load(fileName);

firstTrialFileName = [path,fileNamePreamble,'trial',num2str(1,'%03d'),'.mat'];
load(firstTrialFileName);
%% Figure prep
close all
figure(1)
set(0,'DefaultFigureWindowStyle','normal')
%setCurrentFigurePosition(1);
subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
set(0,'DefaultFigureColor','w')

%% Calculate title
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');
fileStem = char(regexp(path,'.*(?=flyExpNum)','match'));
saveFolder = [fileStem,'Figures\'];
saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'.pdf'];
flyDataPreamble = char(regexp(fileNamePreamble,'.*(?=flyExpNum)','match'));
flyDataFileName = [fileStem,flyDataPreamble,'flyData'];
load(flyDataFileName);
if ~isfield(FlyData,'aim')
    FlyData.aim = '';
end
if ~isfield(exptInfo,'flyExpNotes')
    exptInfo.flyExpNotes = '';
end
sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),...
    ', FlyExpNum ',num2str(exptInfo.flyExpNum)];['Aim: ',FlyData.aim];['Expt Notes: ',exptInfo.flyExpNotes]};

%% Hardcoded paramters
timeBefore = 0.3;
pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1;
indBefore = pipStartInd - timeBefore*Stim.sampleRate/dsFactor;
indAfter = pipStartInd + timeBefore*Stim.sampleRate/dsFactor;

%% Plot stimulus
uniqueStim = unique(Data.stimNum); %TO DO: fix
colorSet = distinguishable_colors(length(uniqueStim),'w');

h(1) = subtightplot (7, 2, 1, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
mySimplePlot(Stim.timeVec,Stim.stimulus)
set(gca,'XTick',[])
ylabel({'Stim';'(V)'})
set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
set(gca,'XColor','white')

%% Rotate all trials 
refVect = [0; -1];
if sum(Data.trialsToInclude) == 0
    return
end
trialNums = 1:length(Data.stimNum);
allFastTrials = trialNums(Data.trialsToInclude);
xDispAFT = [Data.xDisp{allFastTrials}];
yDispAFT = [Data.yDisp{allFastTrials}];
trialVect = [mean(xDispAFT(1,:));mean(yDispAFT(1,:))];
rotAng = acos(dot(trialVect,refVect)/(norm(trialVect)*norm(refVect)));
if trialVect(1) > 0
    R = [cos(rotAng) sin(rotAng);-sin(rotAng) cos(rotAng)];
elseif trialVect(1) <= 0
    R = [cos(rotAng) -sin(rotAng);sin(rotAng) cos(rotAng)];
end

numTrials = size(Data.xDisp,2);
for j = 1:numTrials
    rotVel(j,:,:) = R*[Data.xVel{j},Data.yVel{j}]';
    rotDisp(j,:,:) = R*[Data.xDisp{j},Data.yDisp{j}]';
end

rotXDisp = squeeze(rotDisp(:,1,:));
rotYDisp = squeeze(rotDisp(:,2,:));
rotXVel = squeeze(rotVel(:,1,:));
rotYVel = squeeze(rotVel(:,2,:));

%% Plot for each stim Num
for i = 1:length(uniqueStim)
    trialsToIncludeNums = trialNums(Data.trialsToInclude);
    stimNumIndNotSelected = find(Data.stimNum == uniqueStim(i));
    stimNumInd = intersect(trialsToIncludeNums,stimNumIndNotSelected);
    
    meanXDisp = mean(rotXDisp(stimNumInd,:));
    meanYDisp = mean(rotYDisp(stimNumInd,:));
    meanXVel = mean(rotXVel(stimNumInd,:));
    meanYVel = mean(rotYVel(stimNumInd,:));
    stdXDisp = std(rotXDisp(stimNumInd,:));
    stdYDisp = std(rotYDisp(stimNumInd,:));
    stdXVel = std(rotXVel(stimNumInd,:));
    stdYVel = std(rotYVel(stimNumInd,:));
    
    h(2) = subplot(7,2,3);
    hold on
    mySimplePlot(Data.dsTime{1},meanXVel,'Color',colorSet(i,:),'Linewidth',2)
%     mySimplePlot(Data.dsTime,meanXVel+stdXVel,'Color',colorSet(i,:),'Linewidth',0.5)
%     mySimplePlot(Data.dsTime,meanXVel-stdXVel,'Color',colorSet(i,:),'Linewidth',0.5)
    set(gca,'XTick',[])
    ylabel({'Lateral Vel';'(mm/s)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    moveXAxis(Data)
    shadestimArea(Stim)
    symAxisY
    
    h(3) = subplot(7,2,5);
    hold on
    mySimplePlot(Data.dsTime{1},meanYVel,'Color',colorSet(i,:),'Linewidth',2)
%     mySimplePlot(Data.dsTime{1},meanYVel+stdYVel,'Color',colorSet(i,:),'Linewidth',0.5)
%     mySimplePlot(Data.dsTime{1},meanYVel-stdYVel,'Color',colorSet(i,:),'Linewidth',0.5)
    set(gca,'XTick',[])
    ylabel({'Forward Vel';'(mm/s)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    shadestimArea(Stim)
    moveXAxis(Data)
    symAxisY
    
    h(4) = subplot(7,2,7);
    hold on
    mySimplePlot(Data.dsTime{1},meanXDisp,'Color',colorSet(i,:),'Linewidth',2)
%     mySimplePlot(Data.dsTime{1},meanXDisp+stdXDisp,'Color',colorSet(i,:),'Linewidth',0.5)
%     mySimplePlot(Data.dsTime{1},meanXDisp-stdXDisp,'Color',colorSet(i,:),'Linewidth',0.5)
%     
    %     shadedErrorBar(Data.dsTime{1},mean(Data.xDisp(stimNumInd,:)),std(Data.xDisp(stimNumInd,:)))
    set(gca,'XTick',[])
    ylabel({'X Disp';'(mm)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    shadestimArea(Stim)
    moveXAxis(Data)
    symAxisY
    
    h(5) = subplot(7,2,9);
    hold on
    mySimplePlot(Data.dsTime{1},meanYDisp,'Color',colorSet(i,:),'Linewidth',2)
%     mySimplePlot(Data.dsTime{1},meanYDisp+stdYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
%     mySimplePlot(Data.dsTime{1},meanYDisp-stdYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
    ylabel({'Y Disp';'(mm)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    line([Data.dsTime{1}(1),Data.dsTime{1}(end)],[0,0],'Color','k')
    shadestimArea(Stim)
    xlabel('Time (s)')
    linkaxes(h(:),'x')
    symAxisY
    
    subtightplot (7, 2, 11, [0.1 0.05], [0.1 0.01], [0.1 0.01]);
    bins = -10:0.5:40;
    vTemp = rotYVel(:);
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
    vTemp =rotXVel(:);
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
    line([rotXDisp(stimNumInd,pipStartInd),rotXDisp(stimNumInd,indBefore)]',[rotYDisp(stimNumInd,pipStartInd),rotYDisp(stimNumInd,indBefore)]','Color','k');
    line([rotXDisp(stimNumInd,pipStartInd),rotXDisp(stimNumInd,indAfter)]',[rotYDisp(stimNumInd,pipStartInd),rotYDisp(stimNumInd,indAfter)]','Color',colorSet(i,:));
    symAxis
    ylabel('Y displacement (mm)')
    
    
    subtightplot (7, 2, 8:2:14, [0.1 0.05], [0.1 0.01], [0.1 0.01]);
    hold on
    plot(meanXDisp,meanYDisp,'Color',colorSet(i,:),'Linewidth',2)
%     plot(meanXDisp+stdXDisp,meanYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
%     plot(meanXDisp-stdXDisp,meanYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
    hold on
    symAxis
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
mySave(saveFileName,[5 5]);

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

function moveXAxis(Data)
set(gca,'XColor','white')
line([Data.dsTime{1}(1),Data.dsTime{1}(end)],[0,0],'Color','k')
end