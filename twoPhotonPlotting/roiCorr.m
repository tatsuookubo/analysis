function roiCorr(mov,startFrame,endFrame,varargin)

% Plots the correlation of pixels with the mean fluorescence trace from the
% first ROI you draw with clicky.

%% Set start and end frame 
if ~exist('startFrame','var')
    startFrame = 1; 
end 
if ~exist('endFrame','var')
    endFrame = size(mov,3); 
end 

%% Select roi 
[~, intens] = clicky(mov);

%% Perform correlation 
rho = corr(squeeze(intens(startFrame:endFrame,1)), reshape(mov(:,:,startFrame:endFrame), [size(mov,1)*size(mov,2) size(mov(:,:,startFrame:endFrame),3) ])' );

%% Plot correlation figure 
figure
corr_img = reshape(rho', [size(mov,1), size(mov,2)]);
imagesc( corr_img );
axis image;
colorbar;