function [kmeansData] = kmeansMult(greenMov,~, Stim, frameTimes,metaFileName,figSuffix,frameRate,varargin)

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

%% Get mean movies
meanGreenMov = mean(greenMov,4);

%% Get cluster data 
k = 4; 
if getpref('scimPlotPrefs','newRoi')
    [idx_img, traces, colorMat] = kmeansCorr(meanGreenMov,frameRate,k);
else
    idx_img = getpref('scimPlotPrefs','idx_img');
    colorMat = getpref('scimPlotPrefs','colorMat'); 
    for i = 1:k
        pix_idx = reshape( idx_img, [ size(idx_img,1)*size(idx_img,2) 1 ]);
        kmat = reshape(meanGreenMov, [size(meanGreenMov,1)*size(meanGreenMov,2) size(meanGreenMov,3)] );
        clustIdx = find(pix_idx == i);
        traces(i,:) = mean(kmat(clustIdx,:));
    end
end

%% Figure formatting
close all
figure
setCurrentFigurePosition(1)
colorindex = 0;
ColorSet = distinguishable_colors(20,'b');
purple = [97 69 168]./255;
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');


%% Plot kmeans clusters 
subplot(2,2,1);
imagesc(idx_img);
axis square
title('Kmeans clusters');
lutbar

%% Plot stimulus
h(1) = subplot(2,2,2);
myplot(Stim.timeVec,Stim.stimulus,'Color',purple)
ylabel('Stimulus (V)')
set(gca,'xtick',[])
set(gca,'XColor','white')
title('Stimulus')

%% Plot traces 
h(2) = subplot(2,2,4);
hold on 
for i = 1:size(traces,1)
    myplot(frameTimes, traces(i,:), 'color', colorMat(i,:) , 'DisplayName', ['Cluster: ' num2str(i)],'Linewidth',2);
end
xlabel('Time (s)')
title('Green Channel')
    
%% Save data 
kmeansData.idx_img = idx_img; 
kmeansData.colorMat = colorMat; 
kmeansData.traces = traces; 
kmeansData.k = k; 

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
fileStem = char(regexp(fileName,'.*(?=_trial)','match'));
saveFileName = [saveFolder,fileStem,'_kmeans.pdf'];
figSize = [6 5]; 
mySave(saveFileName,figSize);


