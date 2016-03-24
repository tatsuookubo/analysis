function plotDataGroupedByStim(exptInfo)

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
fileName = [path,'groupedData.mat'];
load(fileName);

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
numStim = length(GroupData);


for n = 1:numStim
    if isempty(GroupData(n).sampTime)
        continue
    end
    fig = figure(n);
    setCurrentFigurePosition(2)
    colormap(ColorSet);

    
    h(1) = subplot(4,1,1);
    plot(GroupData(n).sampTime,GroupData(n).speakerCommand,'Color',purple)

    hold on
    ylabel('Voltage (V)')
    set(gca,'Box','off','TickDir','out','XTickLabel','')
%     ylim([-1.1 1.1])
    set(gca,'xtick',[])
    set(gca,'XColor','white')
    t = title(h(1),{[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),', CellNum ',num2str(exptInfo.cellNum),', CellExpNum ',num2str(exptInfo.cellExpNum)];[GroupData(n).description]});
    set(t,'Fontsize',20);

    
    h(2) = subplot(4,1,2);
    hold on
    plot(GroupStim(n).stimTime,GroupData(n).piezoCommand,'Color',gray)
    plot(GroupData(n).sampTime,GroupData(n).piezoSG,'Color',purple)
    if size(GroupData(n).piezoSG,1)>1
        plot(GroupData(n).sampTime,mean(GroupData(n).piezoSG),'k')
    end
    ylabel('Voltage (V)')
    set(gca,'Box','off','TickDir','out','XTickLabel','')
%     ylim([-0.1 10.1])
    set(gca,'xtick',[])
    set(gca,'XColor','white')
    
    h(3) = subplot(4,1,3);
    set(gca, 'ColorOrder', ColorSet,'NextPlot', 'replacechildren');
%     plot(GroupData(n).sampTime,GroupData(n).voltage,'Color',gray)
    plot(GroupData(n).sampTime,GroupData(n).voltage)
    hold on
    if size(GroupData(n).voltage,1)>1
%         plot(GroupData(n).sampTime,mean(GroupData(n).voltage),'k')
    end
    hold on
    ylabel('Voltage (mV)')
    set(gca,'Box','off','TickDir','out','XTickLabel','')
    axis tight
    set(gca,'xtick',[])
    set(gca,'XColor','white')

    
    h(4) = subplot(4,1,4);
    plot(GroupData(n).sampTime,GroupData(n).current,'Color',gray)
    hold on
    if size(GroupData(n).current,1)>1
        plot(GroupData(n).sampTime,mean(GroupData(n).current),'k')
    end
    hold on
    xlabel('Time (s)')
    ylabel('Current (pA)')
    set(gca,'Box','off','TickDir','out')
    axis tight
    
    linkaxes(h,'x')
    
    if n == 1
        spaceplots(fig,[0 0 0.025 0])
    else
        spaceplots
    end
    
    %% Format and save
    saveFileName{n} = [saveFolder,idString,'stimNum',num2str(n,'%03d'),'.pdf'];
    mySave(saveFileName{n});      
    close all
end
% 
% figFilename = [saveFolder,idString,'.pdf'];
% myAppendPdfs(saveFileName,figFilename);

end