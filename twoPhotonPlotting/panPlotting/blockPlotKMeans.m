function blockPlotKMeans(greenMov,Stim, frameTimes,metaFileName,figSuffix,numBlocks,varargin)

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
blockDescription = trialMeta.blockDescrip;
roiDescription = trialMeta.roiDescrip;
sumTitle = {dateAsString;exptInfo.prefixCode;['ExpNum ',num2str(exptInfo.expNum)];['FlyNum ',num2str(exptInfo.flyNum)];...
    ['RoiNum ',num2str(roiNum)];['BlockNum ',num2str(blockNum)];blockDescription;'';''};
saveFolder = [flyPath,'\Figures\',figSuffix,'\'];

%% Format figure
close all
figure
setCurrentFigurePosition(1)
colorindex = 0;
ColorSet = distinguishable_colors(20,'b');
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');
purple = [97 69 168]./255;

fileStem = char(regexp(fileName,'.*(?=blockNum)','match'));
dataFileName = [saveFolder,fileStem,'blockNum',num2str(1,'%03d'),'_rois.mat'];
load(dataFileName)
numPlots = ceil((kmeansData.k+3)/2); 


%% Plot cluster image
subplot(numPlots,2,1);
idx_img = getpref('scimPlotPrefs','idx_img');
imshow(idx_img,[],'InitialMagnification', 'fit');
colormap jet;
axis square
title('Kmeans clusters');
lutbar
title(roiDescription)
freezeColors

%% Plot reference image
subplot(numPlots,2,3);
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


%% Plot traces
% Plot the green trace
% Calculate pre-stim frame times 
for i = 1:numBlocks 
    dataFileName = [saveFolder,fileStem,'blockNum',num2str(i,'%03d'),'_rois.mat'];
    load(dataFileName)
    for k = 1:kmeansData.k
        h(2) = subplot(numPlots,2,k+3);
        hold on
        currcolor = order(i,:);
        myplot(frameTimes, kmeansData.traces(k,:), 'color', currcolor , 'DisplayName', ['Cluster: ' num2str(k)],'Linewidth',2);
        title(['Cluster ',num2str(k)])
    end
    blockNumStr = cellstr(num2str([1:numBlocks]'));
    legend(blockNumStr{:},'Location','Best')
    legend boxoff
    if i == 1
        ylabel('Avg F count')
    end
    if i == numBlocks 
        xlabel('Time (s)')
    end
end


%% Figure formatting
spaceplots
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
saveFileName = [saveFolder,fileStem,'_kmeansSummaryFig.pdf'];
figSize = [6 5]; 
mySave(saveFileName,figSize);




