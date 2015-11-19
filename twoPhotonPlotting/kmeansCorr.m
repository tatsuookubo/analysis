function [idx_img, traces, colorMat,k] = kmeansCorr(mov,frameRate,stimFrames)

% Clusters pixels in movie into k clusters based on how correlated pixels
% are over time

%% Remove pixels that have low std 
kmat = reshape(mov, [size(mov,1)*size(mov,2) size(mov,3)] );

%% StimDiff version 
% meanDurStim = mean(kmat(:,stimFrames),2);
% preStimFrames = setxor(1:stimFrames(end),stimFrames);
% meanBeforeStim = mean(kmat(:,preStimFrames),2);
% stimDiff = abs(meanDurStim - meanBeforeStim);
% figure 
% hist(stimDiff,100)
% close all
% numPix = size(kmat,1);
% cutoffInd = round(numPix*0.75);
% cutoff = stimDiff(cutoffInd); 
% highStdInd = find(stimDiff>cutoff); 
% kmat2 = kmat(highStdInd,:); 

%% STD version 
stds = std(kmat,0,2);
figure
hist(stds,100)
xlabel('Std')
ylabel('Counts')
[cutoff,~] = ginput(1);
close all
% numPix = size(kmat,1);
% cutoffInd = round(numPix*0.75);
% cutoff = stds(cutoffInd); 
highStdInd = find(stds>cutoff); 
kmat2 = kmat(highStdInd,:); 

%% Perfom kmeans 
% [IDX] = kmeans( kmat , k ,'distance','correlation');
% s = silhouette(kmat,IDX,'correlation');

k = 2;
[tempIdx] = kmeans( kmat2 , k ,'distance','correlation','Replicates',k+1);
[silh,h] = silhouette(kmat2,tempIdx,'correlation');
prevClusSilh = mean(silh);
k =3;
[tempIdx] = kmeans( kmat2 , k ,'distance','correlation','Replicates',k+1);
[silh,h] = silhouette(kmat2,tempIdx,'correlation');
currClusSilh = mean(silh);
while prevClusSilh < currClusSilh
    k = k+1; 
    [tempIdx] = kmeans( kmat2 , k ,'distance','correlation','Replicates',k+1);
    [silh,h] = silhouette(kmat2,tempIdx,'correlation');
    prevClusSilh = currClusSilh; 
    currClusSilh = mean(silh);
    if k ==5
        break 
    end
end
k = k-1; 
[tempIdx] = kmeans( kmat2 , k ,'distance','correlation','Replicates',k+1);
[silh,h] = silhouette(kmat2,tempIdx,'correlation');

IDX = (k+1).*ones(size(kmat));
IDX(highStdInd) = tempIdx;

figure;
[silh,h] = silhouette(kmat2,tempIdx,'correlation');
xlabel 'Silhouette Value';
ylabel 'Cluster';

%% Calculate the within-cluster correlation 
for i=1:k
    clustIdx = find(IDX == i);
%     avgS(i) = mean(s(clustIdx));
    iTraces = kmat(clustIdx,:)';
    R = corrcoef(iTraces);
    upDiag = R(find(~tril(ones(size(R)))));
    avgR(i) = mean(upDiag);
end

figure
hist(avgR,100)
xlabel('avgR')
ylabel('Counts')
[cutoff,~] = ginput(1);
close all
 
clustToPlot = find(avgR>cutoff);
numRealClusters = length(clustToPlot);
k = numRealClusters;

%% Plot cluster image 
% IDX2(1:size(kmat,1),1) = k+1;
% IDX2(highStdInd) = IDX; 
% idx_img = reshape( IDX2, [ size(mov,1) size(mov,2) ]);

blankNum = length(clustToPlot) + 1; 
red_img(1:size(kmat,1),1) = blankNum;
clustCount = 1; 
for i = clustToPlot
    clustIdx = find(IDX == i);
    red_img(clustIdx) = clustCount; 
    idx_img = reshape( red_img, [ size(mov,1) size(mov,2) ]);
    clustCount = clustCount + 1; 
end

figure;
imagesc(idx_img);
title('Kmeans clusters');
legend(cellstr(num2str([1:k]')))

lutbar

%% Plot mean traces for each cluster 
figure;
colormap jet;
cmap = colormap;
temp = linspace(1,size(cmap,1),numRealClusters+1);
colorMat = cmap(floor(temp),:);
t = [0:size(mov,3)-1]./frameRate;
clustCount = 1; 
for i=clustToPlot
    clustIdx = find(IDX == i);
    traces(clustCount,:) = mean(kmat(clustIdx,:));
    hold on;
    plot(t, traces(clustCount,:), 'color', colorMat(clustCount,:) , 'DisplayName', ['Cluster: ' num2str(i)]);
    clustCount = clustCount + 1; 
end
% legend(cellstr(num2str([1:k]')))
title('Mean traces for each Kmeans cluster');

end