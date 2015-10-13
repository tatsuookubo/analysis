function postMultTrialPlot(metaFileName,figSuffix,varargin)

if ~exist('metaFileName','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName); 
end
if ~exist('figSuffix','var')
    figSuffix = 'test';
end

%% Perfrom clicky on each trial 
[greenMov,redMov,~,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
load(metaFileName)
greenCorrected = motionCorrection(greenMov); 
redCorrected = motionCorrection(redMov); 
[roiData] = clickyMult(greenCorrected,redCorrected,Stim,frameTimes,metaFileName,figSuffix);

%% Save plot data 
setpref('scimPlotPrefs','roi',roiData.roi);
roiData.frameTime = frameTimes; 

[pathName, fileName] = fileparts(metaFileName); 
flyPath = char(regexp(pathName,'.*(?=\\roi)','match'));
fileStem = char(regexp(fileName,'.*(?=trial)','match'));
saveFolder = [flyPath,'\Figures\',figSuffix,'\']; 
saveFileName = [saveFolder,fileStem,'rois.mat'];
save(saveFileName,'roiData')



