%% Happy neuron frequency tuning 
clear all 
close all
cd('C:\Users\Alex\Documents\Data\happy\expNum001\flyNum005\Figures\test')

%% Figure settings
figure
hold on 
colors = {'r';'k';'b'};
purple = [97 69 168]./255;

load(['C:\Users\Alex\Documents\Data\happy\expNum001\flyNum005\roiNum013\blockNum002\',...
    'happy_expNum001_flyNum005_roiNum013_blockNum002_trialNum047']);
%% Frequencies 
freq = 25.*sqrt(2).^(([1:11])+1);

h(1) = subplot(2,1,1);
plot(Stim.timeVec,Stim.stimulus,'Color',purple)
ylabel('Stimulus (V)')
set(gca,'xtick',[])
set(gca,'XColor','white')
set(gca,'FontSize',14);
set(gca,'TickDir','out','Box','off')

%% Load fluor data
h(2) = subplot(2,1,2);
for i = 1:3
    blockNums = 2:4;
    load(['happy_expNum001_flyNum005_roiNum013_blockNum',num2str(blockNums(i),'%03d'),'_rois.mat'])
    fData(:,i) = [roiData.greenDeltaFMat{:}];
    stdData(:,i) = [roiData.greenStd{:}];
    ph(i) = plot(roiData.frameTime,fData(:,i),'Color',colors{i},'LineWidth',2);
    hold on 
    plot(roiData.frameTime,fData(:,i)+stdData(:,i),'Color',colors{i},'LineWidth',0.5)
    plot(roiData.frameTime,fData(:,i)-stdData(:,i),'Color',colors{i},'LineWidth',0.5)
end
legend(ph(:),{'probe on left','no probe','probe on right'})
legend boxoff
set(gca,'TickDir','out','Box','off')
axis tight
xlabel('Time (s)')
ylabel('dF/F')
% spaceplots
linkaxes(h(:),'x')
