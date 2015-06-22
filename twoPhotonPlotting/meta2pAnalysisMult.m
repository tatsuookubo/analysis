% meta2pAnalysis.m

% Meta script to easily allow you to run different analysis functions.  Run load movie first then run any of the other functions.  

%% Load movie 
[greenMov,redMov,frameRate,metaFileName,frameTimes] = loadMeanMovie;

load(metaFileName)

%% Clicky
clickyMult(greenMov,redMov,Stim,frameTimes)

%% Clicky correlation 
roiCorr(mov)

%% Kmeans 
k = 4; 
kmeansCorr(mov,frameRate,k)