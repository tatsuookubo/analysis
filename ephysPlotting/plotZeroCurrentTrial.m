function plotZeroCurrentTrial(exptInfo)

close all

%% Plot settings
set(0,'DefaultAxesFontSize', 16)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

gray = [192 192 192]./255;

ColorSet = distinguishable_colors(5,'w');
purple = [97 69 168]./255;


%% Load groupedData file
[~, path, ~, idString] = getDataFileName(exptInfo);
preExptTrialsPath = [path,'\preExptTrials\'];
if ~isdir(preExptTrialsPath)
    return
end
cd(preExptTrialsPath);
zeroCFile = dir('*zeroCurrentTrial*.mat');
zeroCFileName = [preExptTrialsPath,zeroCFile(1).name];
if exist(zeroCFileName,'file') ~= 2
    return
end
load(zeroCFileName);

saveFolderStem = char(regexp(path,'.*(?=cellNum)','match'));
saveFolder = [saveFolderStem,'Figures\'];
if ~isdir(saveFolder)
    mkdir(saveFolder);
end

%% Load fly details
microCzarSettings;   % Loads settings
filename = [dataDirectory,exptInfo.prefixCode,'\expNum',num2str(exptInfo.expNum,'%03d'),...
    '\flyNum',num2str(exptInfo.flyNum,'%03d'),'\flyData'];
load(filename);

%% Load experiment details
settingsFileName = [path,idString,'exptData.mat'];
load(settingsFileName);

% Convert date into text
dateNumber = datenum(exptInfo.dNum,'yymmdd');
dateAsString = datestr(dateNumber,'mm-dd-yy');

%% Plot
sampTime = (1:length(data.voltage))./settings.sampRate.in;

fig = figure(1);
setCurrentFigurePosition(2)
colormap(ColorSet);

h(1) = subplot(2,1,1);
set(gca, 'ColorOrder', ColorSet,'NextPlot', 'replacechildren');
%     plot(GroupData(n).sampTime,GroupData(n).voltage,'Color',gray)
plot(sampTime,data.voltage)
ylabel('Voltage (mV)')
set(gca,'Box','off','TickDir','out','XTickLabel','')
axis tight
set(gca,'xtick',[])
set(gca,'XColor','white')
t = title(h(1),{[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),', CellNum ',num2str(exptInfo.cellNum),', CellExpNum ',num2str(exptInfo.cellExpNum)];['Zero Current Trial']});
set(t,'Fontsize',20);

h(2) = subplot(2,1,2);
plot(sampTime,data.current,'Color',gray)
xlabel('Time (s)')
ylabel('Current (pA)')
set(gca,'Box','off','TickDir','out')
axis tight

linkaxes(h,'x')
spaceplots


%% Format and save
saveFileName = [saveFolder,idString,'stimNum',num2str(0,'%03d'),'zero_current_trial.pdf'];
mySave(saveFileName);
close all


end