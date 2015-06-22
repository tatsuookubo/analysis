function [roi_points, greenCountMat, redCountMat] = clickyMult(greenMov,redMov, Stim, frameTimes,metaFileName,varargin)

% Lets you select ROIS by left clicking to make a shape then right clicking
% to finish that shape.
% Then plots the fluorescence trace for that ROI
% You can select mutliple ROIs.
% A second right click prevents stops further ROIs from being drawn.

%% Calculate title
[pathName] = fileparts(metaFileName);
cd(pathName)
exptInfoFile = dir('*exptInfo.mat');
load(exptInfoFile.name)
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');
sumTitle = [dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),...
    ', RoiNum ',num2str(i),', BlockNum ',num2str(k)];
   

%% Get mean movies
meanGreenMov = mean(greenMov,4);
meanRedMov = mean(redMov,4);

%% Plot reference image
refimg = mean(meanGreenMov, 3);

figure
setCurrentFigurePosition(1)
subplot(2,2,1)
imshow(refimg, [], 'InitialMagnification', 'fit')
hold on;
title(sumTitle, 'Position', [0 1], 'HorizontalAlignment', 'left');

%% Get image details
nframes = size(meanGreenMov, 3);
[ysize, xsize] = size(refimg(:,:,1));


%% Set colors
colorindex = 0;
ColorSet = distinguishable_colors(20,'b');
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');
purple = [97 69 168]./255;

%% Get ROIs
npts = 1;
nroi = 1;
greenCountMat = [];
redCountMat = [];
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
        % Create a matrix of traces
        greenCountMat{i} = [greenCountMat{i}; greenFCount'];
        redCountMat{i} = [redCountMat{i}; redFCount'];
    end
    
    % Plot stimulus
    subplot(2,2,2)
    myplot(Stim.timeVec,Stim.stimulus,'Color',purple)
    ylabel('Stimulus (V)')
    set(gca,'xtick',[])
    set(gca,'XColor','white')
    title('Stimulus')
    
    % Plot the green trace
    subplot(2,2,4)
    myplot(frameTimes,meanGreenFCount,'Color',currcolor,'Linewidth',2);
    hold on
    myplot(frameTimes,greenFCount,'Color',currcolor,'Linewidth',1,'LineStyle','--');
    colorindex = colorindex+1;
    ylabel('F count')
    xlabel('Time (s)')
    title('Green Channel')
    
    % Plot the red trace
    subplot(2,2,3)
    myplot(frameTimes,meanRedFCount,'Color',currcolor,'Linewidth',2);
    hold on;
    myplot(frameTimes,redFCount,'Color',currcolor,'Linewidth',1,'LineStyle','--');
    colorindex = colorindex+1;
    ylabel('F count')
    xlabel('Time (s)')
    title('Red channel')
    
    % Figure formatting and add title
    spaceplots
    set(gca,'FontName','Calibri')
    
    % Store the rois
    roi_points{nroi} = [xv, yv];
    nroi = nroi + 1;
end

%% Save Figure
saveFolder = [fileNameStem,'OnlineFigures\'];
fileStem = char(regexp(metaFiles(1).name,'.*(?=trial)','match'));
saveFileName{figCount} = [saveFolder,fileStem,'.pdf'];
mySave(saveFileName);

