% Post-hoc 2P analysis 

close all
clear all

folder = uigetdir;
cd(folder) 
roiFolders = dir('roi*');
numRois = length(roiFolders); 

for i = 3%1:numRois 
    cd(fullfile(folder,roiFolders(i).name))
    metaFiles = dir('*.mat');
    imageFiles = dir('*.tif');
    numTrials = length(imageFiles); 
    count = 0; 
    prevStim = 0; 
    for j = 1:numTrials; 
        load(metaFiles(j).name);
        trialNum = char(regexp(metaFiles(j).name,'(?<=trialNum)\d*(?=.mat)','match'));
        currStim = Stim.stimulus; 
        if ~isequal(currStim,prevStim)
            count = count + 1; 
            mergedStim(count).stim = Stim.stimulus; 
            mergedStim(count).time = Stim.timeVec;     
%             mergedStim(count).stim = []; 
%             mergedStim(count).time = [];           
            mergedData(count).fCount = [];
            mergedData(count).frameTime = [];   
        end
        try          
            mergedData(count).fCount(end+1,:) = onlinePlot.fCount;
            mergedData(count).frameTime(end+1,:) = onlinePlot.frameTime; 
        catch err
            disp(err.identifier)
        end
%         try 
          
%         catch
%             disp(['Could not analyse this trial, roi num ',num2str(i),' trial num ',trialNum])
%             mergedData(count).fCount(j,:) = NaN;
%             mergedData(count).frameTime(j,:) = NaN;
%         end
        prevStim = currStim; 
        clear Stim data onlinePlot trialMeta
    end
    
    for k = 1:count
        figure
        subplot(2,1,1) 
        myplot(mergedStim(k).time,mergedStim(k).stim)
        title(['Roi ',num2str(i),', Block ',num2str(k)])
        subplot(2,1,2) 
        myplot(nanmean(mergedData(k).frameTime,1),nanmean(mergedData(k).fCount,1))
       
    end
    
    clear mergedStim mergedData 
end

