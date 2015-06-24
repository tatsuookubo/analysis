function postMultTrialPlotBWC(metaFileName,figSuffix,blockNum,varargin)

if ~exist('metaFileName','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName); 
end

%% Perfrom clicky on each trial 
[greenMov,redMov,~,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
load(metaFileName)
greenCorrected = motionCorrection(greenMov,Stim,frameTimes); 
redCorrected = motionCorrection(redMov,Stim); 
[roi, greenCountMat, redCountMat] = clickyMultBWC(greenCorrected,redCorrected,Stim,frameTimes,metaFileName,figSuffix,blockNum);

%% Save plot data 
setpref('scimPlotPrefs','roi',roi);
roiData.roi = roi; 
roiData.greenCountMat = greenCountMat; 
roiData.redCountMat = redCountMat; 
roiData.frameTime = frameTimes; 

[pathName, fileName] = fileparts(metaFileName); 
flyPath = char(regexp(pathName,'.*(?=\\roi)','match'));
saveFolder = [flyPath,'\Figures\',figSuffix,'\'];
roiNum = num2str(trialMeta.roiNum,'%03d'); 
saveFileName = [saveFolder,'roiNum',roiNum,'_blockNum',blockNum,'_rois.mat'];
save(saveFileName,'roiData')
