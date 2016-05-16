function plotBallVelocity(prefixCode,expNum,flyNum,flyExpNum)
%%% process group data
%%% Tatsuo Okubo
%%% 2016/05/15

%% Load group filename
dsFactor = 400;
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.flyExpNum      = flyExpNum;
[~, path, fileNamePreamble, ~] = getDataFileNameBall(exptInfo);
fileName = [path,fileNamePreamble,'groupedData.mat'];
load(fileName);
fileName = [path,fileNamePreamble,'exptData.mat'];
load(fileName);

%%
1
temp=[Data.xVel{:}];
t = Data.dsTime{1};
figure(1); clf;
hold on
plot(t,temp(:,1:10),'k')
hold on
plot(t,median(temp(:,1:10),2),'r')

%%
figure(2); clf;
hold on
for k=1:10
    plot(Data.xDisp{k},Data.yDisp{k},'k')
end

for k=11:20
    plot(Data.xDisp{k},Data.yDisp{k},'r')
end

for k=71:80
    plot(Data.xDisp{k},Data.yDisp{k},'b')
end
