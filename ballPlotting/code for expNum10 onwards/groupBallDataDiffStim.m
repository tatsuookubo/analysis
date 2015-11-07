function groupBallDataDiffStim(prefixCode,expNum,flyNum,flyExpNum)

dsFactor = 400;
dsPhaseShift = 200;
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
cd(path);
dirCont = dir('*trial*');
for i = 1:length(dirCont)
    load(dirCont(i).name);
    trialNum = trialMeta.trialNum;
    settings = ballSettings;
    [procData.vel(:,1),procData.disp(:,1)] = processBallData(data.xVel,settings.xMinVal,settings.xMaxVal,settings,Stim);
    [procData.vel(:,2),procData.disp(:,2)] = processBallData(data.yVel,settings.yMinVal,settings.yMaxVal,settings,Stim);
    groupedData.xVel{trialNum} = downsample(procData.vel(:,1),dsFactor,dsPhaseShift);
    groupedData.yVel{trialNum} = downsample(procData.vel(:,2),dsFactor,dsPhaseShift);
    groupedData.xDisp{trialNum} = downsample(procData.disp(:,1),dsFactor,dsPhaseShift);
    groupedData.yDisp{trialNum} = downsample(procData.disp(:,2),dsFactor,dsPhaseShift);
    groupedData.dsTime{trialMeta.stimNum} = downsample(Stim.timeVec,400,200);
    groupedData.stim{trialMeta.stimNum} = Stim.stimulus;
    groupedData.stimTimeVect{trialMeta.stimNum} = Stim.timeVec; 
    groupedData.stimNum(trialNum) = trialMeta.stimNum;
    groupedData.stimStartPadDur{trialMeta.stimNum} = Stim.startPadDur; 
    groupedData.stimDur{trialMeta.stimNum} = Stim.stimDur;
    % Take the middle chunk of the trial 
    timeBefore = 0.3;
    pipStartInd = Stim.startPadDur*Stim.sampleRate/dsFactor + 1;
    indBefore = pipStartInd - timeBefore*Stim.sampleRate/dsFactor;
    indAfter = pipStartInd + timeBefore*Stim.sampleRate/dsFactor;
    temp.xDisp = groupedData.xDisp{trialNum}; 
    temp.yDisp = groupedData.yDisp{trialNum};
    groupedData.midChunk.xDisp{trialNum} = temp.xDisp(indBefore:indAfter);
    groupedData.midChunk.yDisp{trialNum} = temp.yDisp(indBefore:indAfter);
    % Find trials to remove 
    Vxy = sqrt((groupedData.xVel{trialNum}.^2)+(groupedData.yVel{trialNum}.^2));
    avgResultantVelocity = mean(Vxy);
    groupedData.trialsToInclude(trialNum) = 3<avgResultantVelocity && avgResultantVelocity<50;
    clear procData temp
end

fileName = [path,fileNamePreamble,'groupedData.mat'];
save(fileName, 'groupedData');


