function postMultTrialPlot(metaFileName,figSuffix,varargin)

if ~exist('metaFileName','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName); 
end
if ~exist('figSuffix','var')
    figSuffix = 'test';
end

%% Perfrom clicky on each trial 
[greenMov,redMov,frameRate,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
load(metaFileName)
greenCorrected = motionCorrection(greenMov); 
redCorrected = motionCorrection(redMov); 

%% Perfrom kmeans
[kmeansData] = kmeansMult(greenMov,redMov, Stim, frameTimes,metaFileName,figSuffix,frameRate);
[roiData] = clickyMult(greenCorrected,redCorrected,Stim,frameTimes,metaFileName,figSuffix);

%% Save plot data 
setpref('scimPlotPrefs','idx_img',kmeansData.idx_img);
setpref('scimPlotPrefs','colorMat',kmeansData.colorMat);
setpref('scimPlotPrefs','roi',roiData.roi);
roiData.frameTime = frameTimes; 

[pathName, fileName] = fileparts(metaFileName); 
flyPath = char(regexp(pathName,'.*(?=\\roi)','match'));
fileStem = char(regexp(fileName,'.*(?=trial)','match'));
saveFolder = [flyPath,'\Figures\',figSuffix,'\']; 
saveFileName = [saveFolder,fileStem,'rois.mat'];
save(saveFileName,'roiData','kmeansData')



