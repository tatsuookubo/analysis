% Post-hoc 2P analysis
% with blocks

% Plots data if ROIs were already drawn during experiment

close all
clear all

folder = uigetdir;
cd(folder)
roiFolders = dir('roi*');
numRois = length(roiFolders);

exptInfoFile = dir('*exptInfo.mat');
load(exptInfoFile.name)

% Save settings
saveFolder = [folder,'\Figures\'];
if ~isdir(saveFolder)
    mkdir(saveFolder)
end

% Define colours 
purple = [97 69 168]./255;
gray = [192 192 192]./255;

figCount = 0;

for i = 1:numRois
    cd(fullfile(folder,roiFolders(i).name))
    metaFiles = dir('*.mat');
    imageFiles = dir('*.tif');
    numTrials = length(imageFiles);
    numBlocks = 1;
    
    if isempty(metaFiles)
        blockFolders = dir('block*');
        numBlocks = length(blockFolders);
    end
    
    for m = 1:numBlocks
        
        if numBlocks>1
            cd(fullfile(folder,roiFolders(i).name,blockFolders(m).name))
            metaFiles = dir('*.mat');
            imageFiles = dir('*.tif');
            numTrials = length(imageFiles);
        end
        
        count = 0;
        prevStim = 0;
        
        for j = 1:numTrials;
            load(metaFiles(j).name);
            trialNum = char(regexp(metaFiles(j).name,'(?<=trialNum)\d*(?=.mat)','match'));
            currStim = Stim.stimulus;
            if ~isequal(currStim,prevStim)
                count = count + 1;
                mergedStim(count).stim = Stim.stimulus;
                mergedStim(count).time = Stim.timeVec;
                %             mergedStim(count).stim = [];
                %             mergedStim(count).time = [];
                mergedData(count).fCount = [];
                mergedData(count).frameTime = [];
            end
            try
                mergedData(count).fCount(end+1,:) = onlinePlot.fCount;
                mergedData(count).frameTime(end+1,:) = onlinePlot.frameTime;
            catch err
                disp(err.identifier)
            end
            %         try
            
            %         catch
            %             disp(['Could not analyse this trial, roi num ',num2str(i),' trial num ',trialNum])
            %             mergedData(count).fCount(j,:) = NaN;
            %             mergedData(count).frameTime(j,:) = NaN;
            %         end
            prevStim = currStim;
            clear Stim data onlinePlot trialMeta
        end

    
    for k = 1:count
        figure
        figCount = figCount + 1;
        subplot(2,1,1)
        myplot(mergedStim(k).time,mergedStim(k).stim,'Color',purple)
        ylabel('Stimulus (V)')
        if figCount == 1
            dateNumber = datenum(exptInfo.dNum,'yymmdd');
            dateAsString = datestr(dateNumber,'mm-dd-yy');
            t = title([dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),...
                ', RoiNum ',num2str(i),', BlockNum ',num2str(k)],...
                'Position', [0 1], 'HorizontalAlignment', 'left');
        else
            title(['Roi ',num2str(i),', Block ',num2str(m)],...
                'Position', [0 1], 'HorizontalAlignment', 'left')
        end
        set(gca,'xtick',[])
        set(gca,'XColor','white')
        subplot(2,1,2)
        myplot(nanmean(mergedData(k).frameTime,1),mergedData(k).fCount,'Color',gray,'Linewidth',2)
        hold on 
        myplot(nanmean(mergedData(k).frameTime,1),nanmean(mergedData(k).fCount,1),'k','Linewidth',2)
        ylabel('F Count')
        xlabel('Time (s)')
        
        spaceplots(gcf,[0 0 0.05 0.05])
        
        %         spaceplots(gcf,[0.1 0 0.1 0.1])
        
        % Save
        fileStem = char(regexp(metaFiles(1).name,'.*(?=trial)','match'));
        saveFileName{figCount} = [saveFolder,fileStem,'block',num2str(m,'%03d'),'_stim',num2str(k,'%03d'),'.pdf'];
        mySave(saveFileName{figCount});
    end
    
    
    
    clear mergedStim mergedData
    close all
    
    end
end

% Append pdfs
allFileStem = char(regexp(metaFiles(1).name,'.*(?=roi)','match'));
groupFileName = [saveFolder,allFileStem,'allFigs.pdf'];
myAppendPdfs(saveFileName,groupFileName)

close all

