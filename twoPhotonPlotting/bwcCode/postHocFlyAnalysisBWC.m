function postHocFlyAnalysisBWC

flyDir = uigetdir('C:\Users\Alex\Documents\Data\calciumImagingData'); 
cd(flyDir)
roiDirs = dir('roi*'); 
    
%% Determine fixSuffix 
figSuffix = input('Enter fig suffix ','s'); 
saveFolder = [flyDir,'\Figures\',figSuffix];

folderNum = 1;
while isdir([saveFolder,num2str(folderNum,'%03d')])
    folderNum = folderNum + 1;
end

figSuffix = [figSuffix,num2str(folderNum,'%03d')];

%% Analyse all images 
for i = 1:length(roiDirs) 
    cd([flyDir,'\',roiDirs(i).name])
    blockDirs = dir('block*');
    for j = 1:length(blockDirs) 
        cd([flyDir,'\',roiDirs(i).name,'\',blockDirs(j).name])
        blockNum = char(regexp(blockDirs(j).name,'(?<=blockNum).*','match'));
        imageFiles = dir('*.tif');
        metaStem = char(regexp(imageFiles(1).name,'.*(?=_image)','match'));
        metaFileName = [flyDir,'\',roiDirs(i).name,'\',blockDirs(j).name,'\',metaStem,'.mat'];
        postMultTrialPlotBWC(metaFileName,figSuffix,blockNum)
    end
end

