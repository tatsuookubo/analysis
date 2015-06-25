function postMultTrialPlotNumTrials(metaFileName,figSuffix,varargin)

if ~exist('metaFileName','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName); 
end
if ~exist('figSuffix','var')
    figSuffix = 'test';
end

[greenMov,redMov,~,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
load(metaFileName)
greenCorrected = motionCorrection(greenMov,Stim,frameTimes);
redCorrected = motionCorrection(redMov,Stim);
[roi, greenCountMat, redCountMat] = clickyMultNumTrials(greenCorrected,redCorrected,Stim,frameTimes,metaFileName,figSuffix);

setpref('scimPlotPrefs','roi',roi);
roiData.roi = roi;
roiData.greenCountMat = greenCountMat;
roiData.redCountMat = redCountMat;
roiData.frameTime = frameTimes;

[pathName, fileName] = fileparts(metaFileName);
flyPath = char(regexp(pathName,'.*(?=\\roi)','match'));
saveFolder = [flyPath,'\Figures\',figSuffix,'\'];
roiNum = num2str(trialMeta.roiNum,'%03d');
blockNum = num2str(trialMeta.blockNum,'%03d');
saveFileName = [saveFolder,'roiNum',roiNum,'_blockNum',blockNum,'_rois.mat'];
save(saveFileName,'roiData')