function postMultBlockPlot(metaFileName,figSuffix,varargin)

if ~exist('metaFileName','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName); 
end
if ~exist('figSuffix','var')
    figSuffix = 'test';
end

%% Perfrom clicky on each trial 
roiFolder = char(regexp(metaFileName,'.*(?=\\blockNum)','match'));
cd(roiFolder); 
blockFolders = dir('block*'); 
numBlocks = length(blockFolders); 
close all 

for i = 1:numBlocks
    blockNum = i;
    cd([roiFolder,'\',blockFolders(i).name])
    trialFiles = dir('*.mat');
    [greenMov,redMov,~,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
    load(metaFileName)
    if i == 1
        [greenCorrected,refFrameGreen] = motionCorrection(greenMov);
        [redCorrected,refFrameRed] = motionCorrection(redMov);
    else 
        greenCorrected = motionCorrection(greenMov,refFrameGreen);
        redCorrected = motionCorrection(redMov,refFrameRed);
    end
    [roi, greenCountMat, redCountMat] = clickyMult(greenCorrected,Stim,frameTimes,metaFileName,figSuffix,numBlocks,blockNum);

end


%% Save plot data 
setpref('scimPlotPrefs','roi',roi);
roiData.roi = roi; 
roiData.greenCountMat = greenCountMat; 
roiData.redCountMat = redCountMat; 
roiData.frameTime = frameTimes; 

[pathName, fileName] = fileparts(metaFileName); 
flyPath = char(regexp(pathName,'.*(?=\\roi)','match'));
fileStem = char(regexp(fileName,'.*(?=trial)','match'));
saveFolder = [flyPath,'\Figures\',figSuffix,'\'];
roiNum = num2str(trialMeta.roiNum,'%03d'); 
blockNum = num2str(trialMeta.blockNum,'%03d'); 
saveFileName = [saveFolder,fileStem,'rois.mat'];
save(saveFileName,'roiData')



