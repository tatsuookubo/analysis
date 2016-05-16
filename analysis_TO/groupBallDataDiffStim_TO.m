function groupBallDataDiffStim_TO(prefixCode,expNum,flyNum,flyExpNum)
%%% originally written by Alex
%%% make a structure groupedData with all the trials
%%% commented by Tatsuo Okubo
%%% 2016/05/13

dsFactor = 400;

exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
cd(path);
dirCont = dir('*trial*');
for i = 1:length(dirCont) % for all the trials in that directory
    display(['Trial ',num2str(i)])
    load(dirCont(i).name); % load the raw data
    trialNum = trialMeta.trialNum;
    settings = ballSettings;
    Fs_old = Stim.sampleRate; % samplin frequency of the raw data (Hz)
    Fs_new = Stim.sampleRate/dsFactor; % sampling frequency after downsampling [Hz]
    [procData.vel(:,1),procData.disp(:,1)] = processBallData(data.xVel,settings.xMinVal,settings.xMaxVal,settings,Stim); % process the ball data in the same way as the online plotting
    [procData.vel(:,2),procData.disp(:,2)] = processBallData(data.yVel,settings.yMinVal,settings.yMaxVal,settings,Stim);
    
    groupedData.xVel{trialNum} = resample(procData.vel(:,1),Fs_new,Fs_old);
    groupedData.yVel{trialNum} = resample(procData.vel(:,2),Fs_new,Fs_old);
    groupedData.xDisp{trialNum} = resample(procData.disp(:,1),Fs_new,Fs_old);
    groupedData.yDisp{trialNum} = resample(procData.disp(:,2),Fs_new,Fs_old);
    groupedData.dsTime{trialMeta.stimNum} = resample(Stim.timeVec,Fs_new,Fs_old);
    groupedData.stim{trialMeta.stimNum} = Stim.stimulus;
    groupedData.stimTimeVect{trialMeta.stimNum} = Stim.timeVec;
    groupedData.stimNum(trialNum) = trialMeta.stimNum;
    groupedData.stimStartPadDur{trialMeta.stimNum} = Stim.startPadDur;
    groupedData.stimDur{trialMeta.stimNum} = Stim.stimDur;
    
    % Take the middle chunk of the trial
%     timeBefore = Stim.windPre;
%     pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1;
%     indBefore = pipStartInd - timeBefore*Stim.sampleRate/dsFactor;
%     indAfter = pipStartInd + timeBefore*Stim.sampleRate/dsFactor;
%     temp.xDisp = groupedData.xDisp{trialNum};
%     temp.yDisp = groupedData.yDisp{trialNum};
%     groupedData.midChunk.xDisp{trialNum} = temp.xDisp(indBefore:indAfter);
%     groupedData.midChunk.yDisp{trialNum} = temp.yDisp(indBefore:indAfter);
    
    % Find trials to remove based on the velocity
    Vxy = sqrt((groupedData.xVel{trialNum}.^2)+(groupedData.yVel{trialNum}.^2));
    avgResultantVelocity = mean(Vxy); % mean velocity over the entire trial
    groupedData.Vxy(trialNum) = mean(Vxy); % save for later use
    groupedData.trialsToInclude(trialNum) = 3<avgResultantVelocity && avgResultantVelocity<50; % remove trials without walking (<3 mm/s), or flying (>50 mm/s)
    clear procData temp
end

Data = groupedData;
fileName = [path,fileNamePreamble,'groupedData.mat'];
%save(fileName, 'groupedData'); % save the groupedData structure
save(fileName, 'Data'); % save the groupedData structure