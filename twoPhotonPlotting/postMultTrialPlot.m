function postMultTrialPlot(metaFileName,varargin)

if ~exist('metaFilename','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName); 
end

%% Perfrom clicky on each trial 
[greenMov,redMov,~,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
load(metaFileName)
[roi, greenCountMat, redCountMat] = clickyMult(greenMov,redMov,Stim,frameTimes,metaFileName);

%% Save plot data 
setpref('scimPlotPrefs','roi',roi);
onlinePlot.roi = roi; 
onlinePlot.greenCountMat = greenCountMat; 
onlinePlot.redCountMat = redCountMat; 
onlinePlot.frameTime = frameTimes; 

[pathName, fileName] = fileparts(metaFileName); 
fileNameStem = char(regexp(fileName,'.*(?=_trial)','match'));
saveFileName = [pathName,'\',fileNameStem,'_onlinePlotData.mat'];
save(saveFileName,'onlinePlot')
