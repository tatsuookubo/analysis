function [roi_points, greenCountMat, redCountMat] = clickyMult(greenMov,redMov, Stim, frameTimes,metaFileName,varargin)

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
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');
roiNum = getpref('scimSavePrefs','roiNum');
blockNum = getpref('scimSavePrefs','blockNum');
blockDescription = getpref('scimSavePrefs','blockDescrip');
roiDescription = getpref('scimSavePrefs','roiDescrip');
sumTitle = {dateAsString;exptInfo.prefixCode;['ExpNum ',num2str(exptInfo.expNum)];['FlyNum ',num2str(exptInfo.flyNum)];...
    ['RoiNum ',num2str(roiNum)];['BlockNum ',num2str(blockNum)];blockDescription};

%% Get mean movies
meanGreenMov = mean(greenMov,4);
meanRedMov = mean(redMov,4);

%% Plot reference image
refimg = mean(meanGreenMov, 3);

figure
setCurrentFigurePosition(1)

subplot(2,2,1);
imshow(refimg, [], 'InitialMagnification', 'fit')
hold on 
title(roiDescription)


%% Plot stimulus
purple = [97 69 168]./255;
h(1) = subplot(2,2,2);
myplot(Stim.timeVec,Stim.stimulus,'Color',purple)
ylabel('Stimulus (V)')
set(gca,'xtick',[])
set(gca,'XColor','white')
title('Stimulus')


%% Get image details
nframes = size(meanGreenMov, 3);
[ysize, xsize] = size(refimg(:,:,1));


%% Set colors
colorindex = 0;
ColorSet = distinguishable_colors(20,'b');
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');

%% Get ROIs
npts = 1;
nroi = 1;
greenCountMat = {};
redCountMat = {};
[x, y] = meshgrid(1:xsize, 1:ysize);
numTrials = size(greenMov,4);
while(npts > 0)
    
    % Draw the ROI
    subplot(2,2,1)
    [xv, yv] = (getline(gca, 'closed'));
    if size(xv,1) < 3  % exit loop if only a line is drawn
        break
    end
    % Generate the mask
    inpoly = inpolygon(x,y,xv,yv);
    
    % Draw the bounding polygons and label them
    currcolor = order(nroi,:);
    plot(xv, yv, 'Linewidth', 1,'Color',currcolor);
    text(mean(xv),mean(yv),num2str(nroi),'Color',currcolor,'FontSize',12);
    
    % Calculate the mean trace within the polygon
    meanGreenFCount = squeeze(sum(sum(meanGreenMov.*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
    meanRedFCount = squeeze(sum(sum(meanRedMov.*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
    for i = 1:numTrials
        greenFCount(i,:) = squeeze(sum(sum(squeeze(greenMov(:,:,:,i)).*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
        redFCount(i,:) = squeeze(sum(sum(squeeze(redMov(:,:,:,i)).*repmat(inpoly, [1, 1, nframes]))))/sum(inpoly(:));
    end
    
    % Store traces
    greenCountMat{nroi} =  greenFCount';
    redCountMat{nroi} = redFCount';
    
    % Plot the green trace
    h(2) = subplot(2,2,4);
    hold on 
    myplot(frameTimes,meanGreenFCount,'Color',currcolor,'Linewidth',2);
    myplot(frameTimes,greenFCount,'Color',currcolor,'Linewidth',1,'LineStyle','--');
    colorindex = colorindex+1;
    ylabel('F count')
    xlabel('Time (s)')
    title('Green Channel')
    
    % Plot the red trace
    h(3) = subplot(2,2,3);
    hold on 
    myplot(frameTimes,meanRedFCount,'Color',currcolor,'Linewidth',2);
    myplot(frameTimes,redFCount,'Color',currcolor,'Linewidth',1,'LineStyle','--');
    colorindex = colorindex+1;
    ylabel('F count')
    xlabel('Time (s)')
    title('Red channel')
    
    % Store the rois
    roi_points{nroi} = [xv, yv];
    nroi = nroi + 1;
end

% Figure formatting
h = axes('position',[0,0,1,1],'visible','off');
hold(h)
text(0.01,0.8,sumTitle,'FontSize',26);
spaceplots
linkaxes(h(:),'x')
set(gca,'FontName','Calibri')
set(0,'DefaultFigureColor','w')

%% Save Figure
saveFolder = [flyPath,'\OnlineFigures\'];
if ~isdir(saveFolder)
    mkdir(saveFolder)
end
fileStem = char(regexp(fileName,'.*(?=trial)','match'));
saveFileName = [saveFolder,fileStem,'.pdf'];
mySave(saveFileName);

