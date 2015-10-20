function blockPlot(greenMov,Stim, frameTimes,metaFileName,figSuffix,numBlocks,varargin)

% Lets you select ROIS by left clicking to make a shape then right clicking
% to finish that shape.
% Then plots the fluorescence trace for that ROI
% You can select mutliple ROIs.
% A second right click prevents stops further ROIs from being drawn.

%% Calculate title
[pathName,fileName] = fileparts(metaFileName);
flyPath = char(regexp(pathName,'.*(?=\\roi)','match'));
cd(flyPath)
exptInfoFile = dir('*exptInfo.mat');
load(exptInfoFile.name)
load(metaFileName)
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');
roiNum = trialMeta.roiNum;
blockNum = trialMeta.blockNum;
probePos = trialMeta.probePos;
roiDescription = trialMeta.roiDescrip;
sumTitle = {dateAsString;exptInfo.prefixCode;['ExpNum ',num2str(exptInfo.expNum)];['FlyNum ',num2str(exptInfo.flyNum)];...
    ['RoiNum ',num2str(roiNum)];['BlockNum ',num2str(blockNum)];['probe ',probePos];'';''};
saveFolder = [flyPath,'\Figures\',figSuffix,'\'];

%% Format figure
close all
figure
setCurrentFigurePosition(1)
colorindex = 0;
ColorSet = distinguishable_colors(20,{'b';'w'});
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');
purple = [97 69 168]./255;

oldRoi = getpref('scimPlotPrefs','roi');
numRois = length(oldRoi);

numPlots = ceil((numRois+2)/2); 


%% Plot ref image for future save plot
subplot(numPlots,2,1);
meanGreenMov = mean(greenMov,4);
refimg = mean(meanGreenMov, 3);
imshow(refimg, [], 'InitialMagnification', 'fit')
hold on
title(roiDescription)


%% Plot stimulus
h(1) = subplot(numPlots,2,2);
myplot(Stim.timeVec,Stim.stimulus,'Color',purple)
ylabel('Stimulus (V)')
set(gca,'xtick',[])
set(gca,'XColor','white')
title('Stimulus')

    
%% Draw the ROI
subplot(numPlots,2,1)
for j = 1:numRois; 
    roiMat = cell2mat(oldRoi(j));
    xv = roiMat(:,1);
    yv = roiMat(:,2);
    currcolor = order(j,:);
    plot(xv, yv, 'Linewidth', 1,'Color',currcolor);
    text(mean(xv),mean(yv),num2str(j),'Color',currcolor,'FontSize',12);
end


%% Plot traces
% Plot the green trace
% Calculate pre-stim frame times 
preStimFrameLog = frameTimes < Stim.startPadDur;
fileStem = char(regexp(fileName,'.*(?=blockNum)','match'));
for i = 1:numBlocks 
    dataFileName = [saveFolder,fileStem,'blockNum',num2str(i,'%03d'),'_rois.mat'];
    load(dataFileName)
    for j = 1:numRois
        h(2) = subplot(numPlots,2,j+2);
        hold on
        currcolor = order(i,:);
        myplot(frameTimes,roiData.greenDeltaFMat{j},'Color',currcolor,'Linewidth',2);
        greenTrace = roiData(1).greenDeltaFMat{j};
%         greenBaselineLegend{j} = num2str(mean(greenTrace(preStimFrameLog)));
    end
    title(['Block ',num2str(i)])
    if i == 1
        ylabel('dF/F')
    end
    if i == numBlocks 
        xlabel('Time (s)')
    end
    blockNumStr = cellstr(num2str([1:numBlocks]'));
    legend(blockNumStr{:},'Location','Best')
    legend boxoff
end


%% Figure formatting
% spaceplots
linkaxes(h(:),'x')
set(gca,'FontName','Calibri')
set(0,'DefaultFigureColor','w')

%% Add text description
h = axes('position',[0,0,1,1],'visible','off','Units','normalized');
hold(h);
pos = [0.01,0.6, 0.15 0.7];
ht = uicontrol('Style','Text','Units','normalized','Position',pos,'Fontsize',20,'HorizontalAlignment','left','FontName','Calibri','BackGroundColor','w');

% Wrap string, also returning a new position for ht
[outstring,newpos] = textwrap(ht,sumTitle);
set(ht,'String',outstring,'Position',newpos)

%% Save Figure
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
fileStem = char(regexp(fileName,'.*(?=_block)','match'));
saveFileName = [saveFolder,fileStem,'_summaryFig.pdf'];
figSize = [6 5]; 
mySave(saveFileName,figSize);




