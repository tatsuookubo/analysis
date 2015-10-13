%% Happy neuron frequency tuning 
clear all 
close all
cd('C:\Users\Alex\Documents\Data\happy\expNum001\flyNum005\Figures\test')

%% Figure settings
figure
hold on 
ColorSet = distinguishable_colors(20,'b');
set(gca, 'ColorOrder', ColorSet);
order = get(gca,'ColorOrder');


%% Frequencies 
freq = 25.*sqrt(2).^(([1:11])+1);

%% Load fluor data
for i = 1:11
    blockNums = 7:17;
    load(['happy_expNum001_flyNum005_roiNum022_blockNum',num2str(blockNums(i),'%03d'),'_rois.mat'])
    fData(:,i) = [roiData.deltaFInt{:}];
end


%% Plot 
for j = 1:size(fData,1)
    currColor = order(j,:);
    plot(log(freq),fData(j,:)./max(fData(j,:)),'Color',currColor,'LineWidth',2)
    hold on 
end

xlabel('Frequency (Hz)')
ylabel('Normalized response during stimulus')
axis tight
