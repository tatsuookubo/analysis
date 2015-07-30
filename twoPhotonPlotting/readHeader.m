function [header] = readHeader(metaFileName)

% Loads movie

%% Get filenames if not provided
if ~exist('metaFileName','var')
    [fileName, pathName] = uigetfile;
    metaFileName = fullfile(pathName,fileName);
end

fileNameStem = char(regexp(metaFileName,'.*(?=.mat)','match'));
imageFileName = [fileNameStem,'_image.tif'];


%% Load meta data
load(metaFileName);

%% Load image data
% Get image info
warning('off','MATLAB:imagesci:tiffmexutils:libtiffWarning')
[header,~] = scim_openTif(imageFileName);

power = header.init.eom.maxPower;
disp(['Power = ',num2str(power)])
