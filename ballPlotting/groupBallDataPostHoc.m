function groupBallDataPostHoc(prefixCode,expNum,flyNum,flyExpNum)

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
    groupedData.xVel(trialNum,:) = downsample(procData.vel(:,1),dsFactor,dsPhaseShift);
    groupedData.yVel(trialNum,:) = downsample(procData.vel(:,2),dsFactor,dsPhaseShift);
    groupedData.xDisp(trialNum,:) = downsample(procData.disp(:,1),dsFactor,dsPhaseShift);
    groupedData.yDisp(trialNum,:) = downsample(procData.disp(:,2),dsFactor,dsPhaseShift);
    groupedData.dsTime = downsample(Stim.timeVec,400,200);
    groupedData.stimNum(trialNum) = trialMeta.stimNum;
    stimInd = Stim.startPadDur*Stim.sampleRate:(Stim.startPadDur+Stim.stimDur)*Stim.sampleRate;
    Vxy = sqrt((groupedData.xVel(trialNum,:).^2)+(groupedData.yVel(trialNum,:).^2));
    avgResultantVelocity = mean(Vxy);
    groupedData.trialsToInclude(trialNum,:) = 3<avgResultantVelocity && avgResultantVelocity<50;
end

fileName = [path,fileNamePreamble,'groupedData.mat'];
save(fileName, 'groupedData');


