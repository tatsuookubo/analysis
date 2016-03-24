function plotBallDataDiffStimSameFig(prefixCode,expNum,flyNum,flyExpNum)

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
%         figure
%         set(0,'DefaultFigureWindowStyle','normal')
%         setCurrentFigurePosition(1);
%         subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
%         set(0,'DefaultFigureColor','w')
close all
fvTemp = [];
lvTemp = [];

%% Calculate title
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');
fileStem = char(regexp(path,'.*(?=flyExpNum)','match'));
saveFolder = [fileStem,'Figures\'];
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
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
uniqueStim = unique(groupedData.stimNum);
colorSet = distinguishable_colors(length(uniqueStim),'w');



%% Rotate all trials
refVect = [0; -1];
if sum(groupedData.trialsToInclude) == 0
    return
end
trialNums = 1:length(groupedData.stimNum);
allFastTrials = trialNums(groupedData.trialsToInclude);
xDispAFT = [groupedData.midChunk.xDisp{allFastTrials}];
yDispAFT = [groupedData.midChunk.yDisp{allFastTrials}];
trialVect = [mean(xDispAFT(1,:));mean(yDispAFT(1,:))];
rotAng = acos(dot(trialVect,refVect)/(norm(trialVect)*norm(refVect)));
if trialVect(1) > 0
    R = [cos(rotAng) sin(rotAng);-sin(rotAng) cos(rotAng)];
elseif trialVect(1) <= 0
    R = [cos(rotAng) -sin(rotAng);sin(rotAng) cos(rotAng)];
end

%% Plot for each stim Num
for i = 1:length(uniqueStim)
    
    if mod(i,2)
        currColor = 'b';
        figure
        set(0,'DefaultFigureWindowStyle','normal')
        setCurrentFigurePosition(1);
        subplot = @(m,n,p) subtightplot (m, n, p, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
        set(0,'DefaultFigureColor','w')
    else
        currColor = 'r';
    end
    
    %% Select the trials for this stimulus
    trialsToIncludeNums = trialNums(groupedData.trialsToInclude);
    stimNumIndNotSelected = find(groupedData.stimNum == uniqueStim(i));
    stimNumInd = intersect(trialsToIncludeNums,stimNumIndNotSelected);
    
    %% Rotate each of these trials
    count = 0;
    for j = stimNumInd
        count = count+1;
        rotVel(count,:,:) = R*[groupedData.xVel{j}';groupedData.yVel{j}'];
        rotDisp(count,:,:) = R*[groupedData.xDisp{j}';groupedData.yDisp{j}'];
    end
    
    rotXDisp = squeeze(rotDisp(:,1,:));
    rotYDisp = squeeze(rotDisp(:,2,:));
    rotXVel = squeeze(rotVel(:,1,:));
    rotYVel = squeeze(rotVel(:,2,:));
    
    %% Find the mean and std of these trials
    meanXDisp = mean(rotXDisp);
    meanYDisp = mean(rotYDisp);
    meanXVel = mean(rotXVel);
    meanYVel = mean(rotYVel);
    stdXDisp = std(rotXDisp);
    stdYDisp = std(rotYDisp);
    stdXVel = std(rotXVel);
    stdYVel = std(rotYVel);
    
    %% Plot stimulus
    sph(1) = subtightplot (7, 2, 1, [0.01 0.05], [0.1 0.01], [0.1 0.01]);
    mySimplePlot(groupedData.stimTimeVect{i},groupedData.stim{i})
    set(gca,'XTick',[])
    ylabel({'Stim';'(V)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    set(gca,'XColor','white')
    
    %% Plot data
    sph(2) = subplot(7,2,3);
    hold on
    mySimplePlot(groupedData.dsTime{i},meanXVel,'Color',currColor,'Linewidth',2)
    %     mySimplePlot(groupedData.dsTime,meanXVel+stdXVel,'Color',colorSet(i,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanXVel-stdXVel,'Color',colorSet(i,:),'Linewidth',0.5)
    set(gca,'XTick',[])
    ylabel({'Lateral Vel';'(mm/s)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    moveXAxis(groupedData,i)
    shadestimArea(groupedData,i)
    symAxisY
    
    sph(3) = subplot(7,2,5);
    hold on
    mySimplePlot(groupedData.dsTime{i},meanYVel,'Color',currColor,'Linewidth',2)
    mySimplePlot(groupedData.dsTime{i},rotYVel,'Color',currColor,'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanYVel+stdYVel,'Color',colorSet(i,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanYVel-stdYVel,'Color',colorSet(i,:),'Linewidth',0.5)
    set(gca,'XTick',[])
    ylabel({'Forward Vel';'(mm/s)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    shadestimArea(groupedData,i)
    moveXAxis(groupedData,i)
    symAxisY
    
    sph(4) = subplot(7,2,7);
    hold on
    mySimplePlot(groupedData.dsTime{i},meanXDisp,'Color',currColor,'Linewidth',2)
    %     mySimplePlot(groupedData.dsTime,meanXDisp+stdXDisp,'Color',colorSet(i,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanXDisp-stdXDisp,'Color',colorSet(i,:),'Linewidth',0.5)
    %
    %     shadedErrorBar(groupedData.dsTime,mean(groupedData.xDisp(stimNumInd,:)),std(groupedData.xDisp(stimNumInd,:)))
    set(gca,'XTick',[])
    ylabel({'X Disp';'(mm)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    shadestimArea(groupedData,i)
    moveXAxis(groupedData,i)
    symAxisY
    
    sph(5) = subplot(7,2,9);
    hold on
    mySimplePlot(groupedData.dsTime{i},meanYDisp,'Color',currColor,'Linewidth',2)
    %     mySimplePlot(groupedData.dsTime,meanYDisp+stdYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
    %     mySimplePlot(groupedData.dsTime,meanYDisp-stdYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
    ylabel({'Y Disp';'(mm)'})
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    hold on
    line([groupedData.dsTime{i}(1),groupedData.dsTime{i}(end)],[0,0],'Color','k')
    shadestimArea(groupedData,i)
    xlabel('Time (s)')
    linkaxes(sph(1:5),'x')
    symAxisY
    
    sph(6) = subtightplot (7, 2, 11, [0.1 0.05], [0.1 0.01], [0.1 0.01]);
    hold on
    bins = -10:0.5:40;
    fvTemp = [fvTemp;rotYVel(:)];
    hist(fvTemp,bins);
    xlim([-10 40])
    xlabel('Forward velocity (mm/s)')
    ylabel('Counts')
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    box off;
    set(gca,'TickDir','out')
    axis tight
    
    sph(7) = subtightplot (7, 2, 13, [0.1 0.05], [0.1 0.01], [0.1 0.01]);
    hold on
    bins = -10:0.5:40;
    lvTemp = [lvTemp;rotXVel(:)];
    hist(lvTemp,bins);
    xlim([-10 40])
    xlabel('Lateral velocity (mm/s)')
    ylabel('Counts')
    set(get(gca,'YLabel'),'Rotation',0,'HorizontalAlignment','right')
    box off;
    set(gca,'TickDir','out')
    axis tight
    
    sph(8) = subplot(7,2,2:2:6);
    hold on
    line([rotXDisp(:,pipStartInd),rotXDisp(:,indBefore)]',[rotYDisp(:,pipStartInd),rotYDisp(:,indBefore)]','Color','k');
    line([rotXDisp(:,pipStartInd),rotXDisp(:,indAfter)]',[rotYDisp(:,pipStartInd),rotYDisp(:,indAfter)]','Color',currColor);
    axis tight
%     xlim([-5 5])
    ylabel('Y displacement (mm)')
    
    
    sph(9) = subtightplot (7, 2, 8:2:14, [0.1 0.05], [0.1 0.01], [0.1 0.01]);
    hold on
    plot(meanXDisp,meanYDisp,'Color',currColor,'Linewidth',2)
    %     plot(meanXDisp+stdXDisp,meanYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
    %     plot(meanXDisp-stdXDisp,meanYDisp,'Color',colorSet(i,:),'Linewidth',0.5)
    axis tight
%     xlim([-5 5])
    xlabel('X displacement (mm)')
    ylabel('Y displacement (mm)')
    if i == 2
        legend({'Left','Right'},'Location','NorthEastOutside')
        legend('boxoff')
    end
    
    clear rotVel rotDisp
    
    if ~mod(i,2)
        suptitle(sumTitle)
        saveFileName = [saveFolder,'flyExpNum',num2str(exptInfo.flyExpNum,'%03d'),'_stim',num2str(i-1,'%03d'),'_to_',num2str(i,'%03d'),'.pdf'];
        mySave(saveFileName,[5 5]);
        close all
    end
    
    
end


end

function shadestimArea(groupedData,stimNum)
hold on
gray = [192 192 192]./255;
pipStarts = groupedData.stimStartPadDur{stimNum};
pipEnds = pipStarts + groupedData.stimDur{stimNum};
Y = ylim(gca);
X = [pipStarts,pipEnds];
line([X(1) X(1)],[Y(1) Y(2)],'Color',gray);
line([X(2) X(2)],[Y(1) Y(2)],'Color',gray);
colormap hsv
alpha(.1)
end

function moveXAxis(groupedData,stimNum)
set(gca,'XColor','white')
hold on
line([groupedData.dsTime{stimNum}(1),groupedData.dsTime{stimNum}(end)],[0,0],'Color','k')
end