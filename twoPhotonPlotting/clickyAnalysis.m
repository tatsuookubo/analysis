folder = 'C:\Users\Alex\Documents\Data\calciumImagingData\JO4\expNum001\flyNum001\roiNum005\block2\';
metaFileName = [folder,'JO4_expNum001_flyNum001_roiNum005_trialNum033'];
imageFileName = [folder,'JO4_expNum001_flyNum001_roiNum005_trialNum033_image.tif'];

load(metaFileName);

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

greenMov = squeeze(mov(:,:,2,:));

%%
[~, intens] = clicky(greenMov);

% [intens,dummy] = clicky_all_greenMov_df_f_with_rois( squeeze(greenMov(tt,:,:,:,:)), FR, TPRE, STIM, TPRE_FLUSH, FLUSH, [basepath '/'], [trial_types{tt} '_' num2str(cur_num)], rois );


% Get corr image for above df/f

% greenMov = avg_greenMov{1};

% BEGIN_TC = 1;
% END_TC = size(greenMov,3);

BEGIN_TC = 80;
END_TC = 400;

f2 = figure;

rho = corr(squeeze(intens(BEGIN_TC:END_TC,1)), reshape(greenMov(:,:,BEGIN_TC:END_TC), [size(greenMov,1)*size(greenMov,2) size(greenMov(:,:,BEGIN_TC:END_TC),3) ])' );

corr_img = reshape(rho', [size(greenMov,1), size(greenMov,2)]);
imagesc( corr_img );
axis image;
colorbar;

%% K means 

kmat = reshape(greenMov, [size(greenMov,1)*size(greenMov,2) size(greenMov,3)] );
stds = std(kmat,0,2);
figure
hist(stds,100)
xlabel('Std')
ylabel('Counts')
[cutoff,~] = ginput(1);
close all

highStdInd = find(stds>cutoff); 
kmat2 = kmat(highStdInd,:); 

k = 10;
[IDX, C] = kmeans( kmat2 , k ,'distance','correlation');

IDX2(1:size(kmat,1),1) = k+1;
IDX2(highStdInd) = IDX; 


idx_img = reshape( IDX2, [ size(greenMov,1) size(greenMov,2) ]);

figure;
imagesc(idx_img);
title('Kmeans clusters');
lutbar

figure;
colormap jet;
cmap = colormap;
temp = linspace(1,size(cmap,1),k+1);
cs = cmap(floor(temp),:);
t = [0:size(greenMov,3)-1]./frameRate;
for i=1:k
    clustIdx = find(IDX2 == i);
    trace = mean(kmat(clustIdx,:));
    hold on;
%     plot(t, C(i,:), 'color', cs(i,:) , 'DisplayName', ['Cluster: ' num2str(i)]);
    plot(t, trace, 'color', cs(i,:) , 'DisplayName', ['Cluster: ' num2str(i)]);
end
title('Kmeans centroids for HbT');