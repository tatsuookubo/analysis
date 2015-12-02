function [outputRoi,roiData] = clickyMult(greenMov,redMov, Stim, frameTimes,metaFileName,figSuffix,analysisDataFileName,varargin)

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
if isfield(trialMeta,'probePost')
    probePos = trialMeta.probePost;
elseif isfield(trialMeta,'blockDescrip')
    probePos = trialMeta.blockDescrip;
else
    probePos = ''; 
end
roiDescription = trialMeta.roiDescrip;
sumTitle = {[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', ','FlyNum ',num2str(exptInfo.flyNum)];['RoiNum ',num2str(roiNum),', ','BlockNum ',num2str(blockNum),', ','probe position: ',probePos];roiDescription};
saveFolder = [flyPath,'\Figures\',figSuffix,'\'];

%% Calculate pre-stim frame times 
preStimFrameLog = frameTimes < Stim.startPadDur;

%% Get mean movies
meanGreenMov = mean(greenMov,4);
meanRedMov = mean(redMov,4);

%% Create reference image
refimg = mean(meanGreenMov, 3);

%% Set colors
colorindex = 0;
ColorSet = distinguishable_colors(20,{'b';'w'});
purple = [97 69 168]./255;

%% See if ROIs already exist
roiPath = char(regexp(pathName,'.*(?=\\block)','match'));
cd(roiPath)
numLoops = 1000;
if ~exist(analysisDataFileName,'file')
    useOldRois = 'n'; 
else
    useOldRois = 'y';
    load(analysisDataFileName) 
    oldRoi = analysisData.roi; 
    clear analysisData
end

%% Plot ref image for future save plot
figure
setCurrentFigurePosition(1)
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');

subplot(2,2,1);
imshow(refimg, [], 'InitialMagnification', 'fit')
hold on
title(sumTitle,'Fontsize',20)




%% Plot stimulus
h(1) = subplot(2,2,2);
myplot(Stim.timeVec,Stim.stimulus,'Color',purple)
ylabel('Stimulus (V)')
set(gca,'xtick',[])
set(gca,'XColor','white')
if isfield(Stim,'description')
    title(Stim.description,'Fontsize',20)
elseif isfield(trialMeta,'blockDescrip')
    title(trialMeta.blockDescrip,'Fontsize',20)
end

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
    
    subplot(2,2,1)
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
    
    redPreStimBaseline = mean(meanRedFCount(preStimFrameLog));
    redDeltaF = 100.*((meanRedFCount - redPreStimBaseline)./redPreStimBaseline);
    
    
    %% Store traces
    roiData.greenCountMat{nroi} =  greenFCount';
    roiData.redCountMat{nroi} = redFCount';
    roiData.greenDeltaFMat{nroi} = greenDeltaF;
    roiData.greenStd{nroi} = std(greenDeltaFST); 
    
    %% Plot traces 
    % Plot the green trace
    h(2) = subplot(2,2,4);
    hold on
    p(i) = myplot(frameTimes,greenDeltaF,'Color',currcolor,'Linewidth',2,'DisplayName',num2str(greenPreStimBaseline));
    if numTrials > 1
        myplot(frameTimes,greenDeltaFST,'Color',currcolor,'Linewidth',1,'LineStyle','--');
    end
    colorindex = colorindex+1;
    xlabel('Time (s)')
    title('Green Channel','Fontsize',20)
    
    % Plot the red trace
    h(3) = subplot(2,2,3);
    hold on
    q(i) = myplot(frameTimes,redDeltaF,'Color',currcolor,'Linewidth',2,'DisplayName',num2str(redPreStimBaseline));
    if numTrials>1 
        myplot(frameTimes,redDeltaFST,'Color',currcolor,'Linewidth',1,'LineStyle','--');
    end
    colorindex = colorindex+1;
    ylabel('dF/F')
    xlabel('Time (s)')
    title('Red channel','Fontsize',20)
    
    %% Store the rois
    outputRoi{nroi} = [xv, yv];
    nroi = nroi + 1;
end

% subplot(2,2,4)
% legend(p(:),'Location','Best')
% legend boxoff
% 
% subplot(2,2,3) 
% legend(q(:),'Location','Best')
% legend boxoff

%% Figure formatting
spaceplots
linkaxes(h(:),'x')
set(gca,'FontName','Calibri')
set(0,'DefaultFigureColor','w')

%% Add text description
% h = axes('position',[0,0,1,1],'visible','off','Units','normalized');
% hold(h);
% pos = [0.01,0.6, 0.15 0.7];
% ht = uicontrol('Style','Text','Units','normalized','Position',pos,'Fontsize',20,'HorizontalAlignment','left','FontName','Calibri','BackGroundColor','w');
% 
% % Wrap string, also returning a new position for ht
% [outstring,newpos] = textwrap(ht,sumTitle);
% set(ht,'String',outstring,'Position',newpos)

%% Save Figure
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
fileStem = char(regexp(fileName,'.*(?=_trial)','match'));
saveFileName = [saveFolder,fileStem,'.pdf'];
figSize = [6 5]; 
mySave(saveFileName,figSize);

%% Close figure


