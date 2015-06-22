function [greenMov,redMov,frameRate,metaFileName,frameTimes] = loadMovie(play,imageFileName,metaFileName,varargin)

% Loads movie 

%% Get filenames if not provided 
if ~exist('metaFileName','var')
    [fileName, pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName);
end
if ~exist('imageFileName','var')
    fileNameStem = char(regexp(metaFileName,'.*(?=.mat)','match'));
    imageFileName = [fileNameStem,'_image.tif'];
end

%% Load meta data 
load(metaFileName);

%% Load image data 
% Get image info
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning')
[header,~] = scim_openTif(imageFileName);
frameRate = header.acq.frameRate;
imInfo = imfinfo(imageFileName);
chans = regexp(imInfo(1).ImageDescription,'state.acq.acquiringChannel\d=1');
numChans = length(chans);
numFrames = round(length(imInfo)/numChans);
im1 = imread(imageFileName,'tiff','Index',1,'Info',imInfo);
numPx = size(im1);

% Read in image
mov = zeros([numPx(:); numChans; numFrames]', 'double');  %preallocate 3-D array
for frame=1:numFrames
    for chan = 1:numChans
        [mov(:,:,chan,frame)] = imread(imageFileName,'tiff',...
            'Index',(2*(frame-1)+chan),'Info',imInfo);
    end
end

%% Image processing
% Remove the last line where the image doesn't change
mov(64,:,:,:)=[];

%% Separate channels
greenMov = squeeze(mov(:,:,2,:));
redMov = squeeze(mov(:,:,1,:));

%% Find max and min values of images 
limits(1) = min(greenMov(:));
limits(2) = max(greenMov(:)); 

%% Play movies 
if strcmp(play,'y')
    ImplayWithMap(greenMov, frameRate, limits)
end

%% Get frame timing data 
% find(max(data.yMirror),'first',1))
% sampsPerFrame = round(length(Stim.stimulus)/(numFrames + 1));
sampsPerFrame = 1/frameRate * Stim.sampleRate;
frameDivisions = round(0.5*sampsPerFrame + sampsPerFrame.*(0:numFrames));
for i = 1:numFrames
    if i == numFrames
        yMirrorSubset = data.yMirror(frameDivisions(i):end);
    else 
        yMirrorSubset = data.yMirror(frameDivisions(i):frameDivisions(i+1));
    end
    [~,maxIdx] = max(yMirrorSubset);
    frameEndIdxs(i) = frameDivisions(i) + maxIdx - 1;
end

frameTimes = Stim.timeVec(frameEndIdxs);
