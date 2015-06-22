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

figCount = 0;

for i = 1:numRois
    cd(fullfile(folder,roiFolders(i).name))
    metaFiles = dir('*.mat');
    numTrials = length(metaFiles);
    numBlocks = 1;
    
    if isempty(metaFiles)
        blockFolders = dir('block*');
        numBlocks = length(blockFolders);
    end
    
    for m = 1:numBlocks
        
        if numBlocks>1
            cd(fullfile(folder,roiFolders(i).name,blockFolders(m).name))
            metaFiles = dir('*.mat');
            numTrials = length(metaFiles);
        end
        
        count = 0;
        prevStim = 0;
        
        for j = 1:numTrials;
            load(metaFiles(j).name);
            trialNum = char(regexp(metaFiles(j).name,'(?<=trialNum)\d*(?=.mat)','match'));

            [greenMov,redMov,frameRate,metaFileName,frameTimes] = loadMovie('n',imageFileName,metaFileName);
            clicky(greenMov,redMov,Stim,frameTimes)


            clear Stim data onlinePlot trialMeta
        end

    
    for k = 1:count

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
        
        
        spaceplots(gcf,[0 0 0.05 0.05])
        

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

