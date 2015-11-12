function postMultTrialPlot(metaFileName,figSuffix,varargin)

if ~exist('metaFileName','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName); 
end

[pathName, fileName] = fileparts(metaFileName); 
flyPath = char(regexp(pathName,'.*(?=\\roi)','match'));
fileStem = char(regexp(fileName,'.*(?=block)','match'));

if ~exist('figSuffix','var')
    figSuffix = 'Offline';
    folderCount = 1; 
    saveFolder = [flyPath,'\Figures\',figSuffix,num2str(folderCount,'%03d'),'\']; 
    while isdir(saveFolder) 
        folderCount = folderCount + 1;
        saveFolder = [flyPath,'\Figures\',figSuffix,num2str(folderCount,'%03d'),'\']; 
    end
else 
    saveFolder = [flyPath,'\Figures\',figSuffix,'\']; 
end

analysisDataFileName = [saveFolder,fileStem,'analysisData.mat'];

%% Perfrom clicky on each trial 
[greenMov,redMov,frameRate,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
load(metaFileName)
greenCorrected = motionCorrection(greenMov,metaFileName,frameTimes); 
redCorrected = motionCorrection(redMov,metaFileName); 

%% Perfrom kmeans
[kmeansData] = kmeansMult(greenCorrected,redCorrected, Stim, frameTimes,metaFileName,figSuffix,frameRate,analysisDataFileName);
[roiData] = clickyMult(greenCorrected,redCorrected,Stim,frameTimes,metaFileName,figSuffix,analysisDataFileName);

%% Save plot data 
% roiData.frameTime = frameTimes; 
% save(analysisDataFileName,'roiData','kmeansData')



