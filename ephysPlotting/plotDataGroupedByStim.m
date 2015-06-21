function plotDataGroupedByStim(prefixCode,expNum,flyNum,cellNum,cellExpNum)

close all

%% Plot settings
set(0,'DefaultAxesFontSize', 16)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

gray = [192 192 192]./255;


%% Load groupedData file
exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.cellNum        = cellNum;
exptInfo.cellExpNum     = cellExpNum;

[~, path, ~, idString] = getDataFileName(exptInfo);
fileName = [path,'groupedData.mat'];
load(fileName);

saveFolder = [path,'figures\'];
imageFolder = [saveFolder,'Images\'];
if ~isdir(saveFolder)
    mkdir(saveFolder);
end
if ~isdir(imageFolder)
    mkdir(imageFolder)
end

%% Load fly details 
microCzarSettings;   % Loads settings
filename = [dataDirectory,prefixCode,'\expNum',num2str(expNum,'%03d'),...
        '\flyNum',num2str(flyNum,'%03d'),'\flyData'];
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
    fig = figure(n);
    setCurrentFigurePosition(2)
    
    h(1) = subplot(3,1,1);
    plot(GroupStim(n).stimTime,GroupStim(n).stimulus,'k')
    hold on
    ylabel('Voltage (V)')
    set(gca,'Box','off','TickDir','out','XTickLabel','')
    ylim([-1.1 1.1])
    set(gca,'xtick',[])
    set(gca,'XColor','white')
    if n == 1 
        t = title(h(1),[dateAsString,', ',prefixCode,', ','ExpNum ',num2str(expNum),', FlyNum ',num2str(flyNum),', CellNum ',num2str(cellNum),', CellExpNum ',num2str(cellExpNum)]);
        set(t,'Fontsize',20);
    end
    
    h(3) = subplot(3,1,2);
    plot(GroupData(n).sampTime,GroupData(n).voltage,'Color',gray)
    hold on
    if size(GroupData(n).voltage,1)>1
        plot(GroupData(n).sampTime,mean(GroupData(n).voltage),'k')
    end
    hold on
    ylabel('Voltage (mV)')
    set(gca,'Box','off','TickDir','out','XTickLabel','')
    axis tight
    set(gca,'xtick',[])
    set(gca,'XColor','white')
    
    h(2) = subplot(3,1,3);
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
    xlim([2.5,4])
    
    if n == 1
        spaceplots(fig,[0 0 0.025 0])
    else
        spaceplots
    end
    
    %% Format and save
    saveFilename{n} = [saveFolder,'\GroupData_Stim',num2str(n),'.pdf'];
    set(gcf, 'PaperType', 'usletter');
    orient landscape
    export_fig(saveFilename{n},'-pdf','-q50')
    imageFilename = [imageFolder,'stimNum_',num2str(n),'.emf'];
    print(fig,'-dmeta',imageFilename)
      
    close all
end

figFilename = [saveFolder,idString,'allFigures.pdf'];
if exist(figFilename,'file')
    delete(figFilename)
end
append_pdfs(figFilename,saveFilename{:})
delete(saveFilename{:})

end