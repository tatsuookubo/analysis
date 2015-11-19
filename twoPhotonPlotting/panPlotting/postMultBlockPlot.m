function postMultBlockPlot(metaFileName,figSuffix,varargin)

if ~exist('metaFileName','var')
    [fileName,pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName);
end
if ~exist('figSuffix','var')
    figSuffix = 'Online';
end

%% Perfrom clicky on each trial
roiFolder = char(regexp(metaFileName,'.*(?=\\blockNum)','match'));
cd(roiFolder);
blockFolders = dir('block*');
numBlocks = length(blockFolders);
close all

cd([roiFolder,'\',blockFolders(1).name])
trialFiles = dir('*.mat');
metaFileName = [roiFolder,'\',blockFolders(1).name,'\',trialFiles(1).name];
[greenMov,~,~,metaFileName,frameTimes] = loadMeanMovie(metaFileName);
load(metaFileName)
[greenCorrected,refFrameGreen] = motionCorrection(greenMov,metaFileName);
blockPlot(greenCorrected,Stim,frameTimes,metaFileName,figSuffix,numBlocks);

% blockPlotKMeans(greenCorrected,Stim,frameTimes,metaFileName,figSuffix,numBlocks);





