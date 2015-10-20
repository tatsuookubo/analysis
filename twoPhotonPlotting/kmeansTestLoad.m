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

%% Perfrom kmeans
meanGreenMovCount = squeeze(mean(greenMov,4));
k = 5;
kmeansCorr(meanGreenMovCount,frameRate,k)