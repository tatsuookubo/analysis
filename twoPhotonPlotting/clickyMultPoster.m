function [roiData] = clickyMultPoster(greenMov,redMov, Stim, frameTimes,metaFileName,figSuffix,varargin)

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
saveFolder = [flyPath,'\Figures\',figSuffix,'\'];

%% Calculate pre-stim frame times 
preStimFrameLog = frameTimes < Stim.startPadDur;

%% Calculate stim frame times
postStartPadFrames = find(Stim.startPadDur < frameTimes) ;
preEndPadFrames = find(frameTimes < (Stim.startPadDur + Stim.stimDur));
stimFrames = intersect(postStartPadFrames,preEndPadFrames);

%% Get mean movies
meanGreenMov = mean(greenMov,4);
meanRedMov = mean(redMov,4);

%% Create reference image
refimg = mean(meanGreenMov, 3);

%% Set colors
colorindex = 0;
ColorSet = distinguishable_colors(20,'b');
purple = [97 69 168]./255;

%% See if ROIs already exist
numLoops = 1000;
lastRoiNum = getpref('scimPlotPrefs','lastRoiNum');
currRoiNum = getpref('scimSavePrefs','roiNum');
if getpref('scimPlotPrefs','newRoi')
    disp('New ROI');
    useOldRois = 'n'; 
else
    prevBlockNum = num2str(blockNum-1,'%03d');
    roiFileName = [saveFolder,'roiNum',num2str(roiNum,'%03d'),'_blockNum',prevBlockNum,'_rois.mat'];
    oldRoi = getpref('scimPlotPrefs','roi');
    close all
%     figure
%     imshow(refimg, [], 'InitialMagnification', 'fit')
%     hold on
%     set(gca, 'ColorOrder', ColorSet);
%     order = get(gca,'ColorOrder');
%     for oldRoiNum = 1:length(oldRoi)
%         currcolor = order(oldRoiNum,:);
%         roiMat = cell2mat(oldRoi(oldRoiNum));
%         xv = roiMat(:,1);
%         yv = roiMat(:,2);
%         plot(xv,yv, 'Linewidth', 1,'Color',currcolor);
%     end
    useOldRois = 'y'; 
    %         useOldRois = input('Use these Rois?','s');
    
end

%% Plot ref image for future save plot
figure
figSize = setFigSize(8,10);
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');

subplot(3,1,1);
imshow(refimg, [], 'InitialMagnification', 'fit')
hold on
title(roiDescription)




%% Plot stimulus
h(1) = subplot(3,1,2);
myplot(Stim.timeVec,Stim.stimulus,'Color',purple)
ylabel('Stimulus (V)')
set(gca,'xtick',[])
set(gca,'XColor','white')
set(gca,'FontSize',14);


%% Get image details
nframes = size(meanGreenMov, 3);
[ysize, xsize] = size(refimg(:,:,1));

%% Get ROIs
nroi = 1;
roiData.greenCountMat = {};
roiData.redCountMat = {};
[x, y] = meshgrid(1:xsize, 1:ysize);
numTrials = size(greenMov,4);
for j = 1:numLoops
    
    subplot(3,1,1)
    %% Draw the ROI
    if strcmp(useOldRois,'y')
        if j == (length(oldRoi) + 1)
            break
        else
            roiMat = cell2mat(oldRoi(j));
            xv = roiMat(:,1);
            yv = roiMat(:,2);
        end
    else
        [xv, yv] = (getline(gca, 'closed'));
        if size(xv,1) < 3  % exit loop if only a line is drawn
            break
        end
    end
    
    %% Generate the mask
    inpoly = inpolygon(x,y,xv,yv);
    
    %% Draw the bounding polygons and label them
    currcolor = order(nroi,:);
    plot(xv, yv, 'Linewidth', 1,'Color',currcolor);
    text(mean(xv),mean(yv),num2str(nroi),'Color',currcolor,'FontSize',12);
    
    %% Calculate the mean trace within the polygon
    meanGreenFCount = squeeze(sum(sum(meanGreenMov.*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
    meanRedFCount = squeeze(sum(sum(meanRedMov.*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
    for i = 1:numTrials
        greenFCount(i,:) = squeeze(sum(sum(squeeze(greenMov(:,:,:,i)).*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
        redFCount(i,:) = squeeze(sum(sum(squeeze(redMov(:,:,:,i)).*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
    
        greenPreStimBaselineST(i,:) = mean(greenFCount(i,preStimFrameLog));
        greenDeltaFST(i,:) = 100.*((greenFCount(i,:) - greenPreStimBaselineST(i,:))./greenPreStimBaselineST(i,:));
    
        redPreStimBaselineST(i,:) = mean(redFCount(i,preStimFrameLog));
        redDeltaFST(i,:) = 100.*((redFCount(i,:) - redPreStimBaselineST(i,:))./redPreStimBaselineST(i,:));
    
    end
    
    %% Calculate deltaF/F for mean traces 
    greenPreStimBaseline = mean(meanGreenFCount(preStimFrameLog));
    greenDeltaF = 100.*((meanGreenFCount - greenPreStimBaseline)./greenPreStimBaseline);
    greenBaselineLegend{j} = num2str(greenPreStimBaseline); 
    
    redPreStimBaseline = mean(meanRedFCount(preStimFrameLog));
    redDeltaF = 100.*((meanRedFCount - redPreStimBaseline)./redPreStimBaseline);
    redBaselineLegend{j} = num2str(redPreStimBaseline); 
    
    
    %% Store traces
    roiData.greenCountMat{nroi} =  greenFCount';
    roiData.redCountMat{nroi} = redFCount';
    roiData.greenDeltaFMat{nroi} = greenDeltaF;
    roiData.greenStd{nroi} = std(greenDeltaFST);
    roiData.deltaFInt{nroi} = sum(greenDeltaF(stimFrames));
    
    %% Plot traces 
    % Plot the green trace
    h(2) = subplot(3,1,3);
    hold on
    myplot(frameTimes,greenDeltaF,'Color',currcolor,'Linewidth',2);
    if numTrials > 1
        myplot(frameTimes,greenDeltaFST,'Color',currcolor,'Linewidth',1,'LineStyle','--');
    end
    colorindex = colorindex+1;
    ylabel('dF/F')
    xlabel('Time (s)')
    title('Green Channel')    
    set(gca,'FontSize',14);
    
    %% Store the rois
    roiData.roi{nroi} = [xv, yv];
    nroi = nroi + 1;
end

% subplot(3,1,3)
% legend(greenBaselineLegend{:},'Location','Best','FontSize',8)
% legend boxoff
% set(gca,'FontSize',14);

%% Figure formatting
spaceplots
linkaxes(h(:),'x')
set(gca,'FontName','Calibri')
set(0,'DefaultFigureColor','w')

%% Save Figure
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
fileStem = char(regexp(fileName,'.*(?=_trial)','match'));
saveFileName = [saveFolder,fileStem,'.pdf'];
mySave(saveFileName,figSize);

%% Close figure


