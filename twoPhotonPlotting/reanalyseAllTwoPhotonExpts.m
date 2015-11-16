function reanalyseAllTwoPhotonExpts 

%% Select metaFileName
flyFolder = uigetdir;

%% Decide fixSuffix 
figSuffix = 'Offline';
folderCount = 1;
saveFolder = [flyFolder,'\Figures\',figSuffix,num2str(folderCount,'%03d'),'\'];
while isdir(saveFolder)
    folderCount = folderCount + 1;
    saveFolder = [flyFolder,'\Figures\',figSuffix,num2str(folderCount,'%03d'),'\'];
end
figSuffix = [figSuffix,num2str(folderCount,'%03d')];

%% Analyse each block
cd(flyFolder); 
roiFolders = dir('roi*');
for i = 1:length(roiFolders)
    roiFolderName = [flyFolder,'\',roiFolders(i).name];
    cd(roiFolderName)
    blockFolders = dir('block*');
    for j = 1:length(blockFolders) 
        blockFolderName = [flyFolder,'\',roiFolders(i).name,'\',blockFolders(j).name];
        cd(blockFolderName)
        trialFileNames = dir('*.mat');
        if ~isempty(trialFileNames)
            metaFileName = [flyFolder,'\',roiFolders(i).name,'\','\',blockFolders(j).name,'\',trialFileNames(1).name];
            postMultTrialPlot(metaFileName,figSuffix)
        end
    end
    if length(blockFolders)>1
        postMultBlockPlot(metaFileName,figSuffix)
    end
    clear blockFolders
end

figFolder = [flyFolder,'\Figures\',figSuffix];
groupPdfs(figFolder)
close all