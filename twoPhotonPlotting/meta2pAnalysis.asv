% meta2pAnalysis.m

%% Load movie 
[greenMov,redMov,frameRate] = loadMovie('n');

mov = greenMov;

%% Clicky
clicky(mov)

%% Clicky correlation 
roiCorr(mov)

%% Kmeans 
k = 4; 
kmeansCorr(mov,frameRate,k)