% meta2pAnalysis.m

% Meta script to easily allow you to run different analysis functions.  Run load movie first then run any of the other functions.  

%% Load movie 
[greenMov,redMov,frameRate,metaFileName,frameTimes] = loadMovie('n');

load(metaFileName)

%% Clicky
clicky(greenMov,redMov,Stim,frameTimes)

%% Clicky correlation 
roiCorr(mov)

%% Kmeans 
k = 4; 
kmeansCorr(greenMov,frameRate,k)