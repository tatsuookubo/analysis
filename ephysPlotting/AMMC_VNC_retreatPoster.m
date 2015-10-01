function AMMC_VNC_retreatPoster(prefixCode,expNum,flyNum,cellNum,cellExpNum)

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
if ~isdir(saveFolder)
    mkdir(saveFolder);
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


n = 1; 
fig = figure(n);
set(gcf,'Unit','inches','Position',[5 3 4 5]);

h(1) = subplot(4,1,1);
plot(GroupStim(n).stimTime,GroupStim(n).stimulus,'k')
hold on
ylabel('Voltage (V)')
set(gca,'Box','off','TickDir','out','XTickLabel','')
ylim([-1.1 1.1])
set(gca,'xtick',[])
set(gca,'XColor','white')
% if n == 1
%     t = title(h(1),[dateAsString,', ',prefixCode,', ','ExpNum ',num2str(expNum),', FlyNum ',num2str(flyNum),', CellNum ',num2str(cellNum),', CellExpNum ',num2str(cellExpNum)]);
%     
%     %         t = title({[dateAsString,', ',prefixCode,', ','ExpNum ',num2str(expNum),', CellNum ',num2str(cellNum),', CellExpNum ',num2str(cellExpNum)];...
%     %             ['Membrane Resistance = ',num2str(preExptData.initialMembraneResistance/1000),' G{\Omega}',', Access Resistance = ',num2str(preExptData.initialAccessResistance/1000),' G{\Omega}']});
%     %         set(t, 'horizontalAlignment', 'left','units', 'normalized','position', [0 1 0])
%     set(t,'Fontsize',20);
% end

h(2) = subplot(4,1,2);
std1 = std(GroupData(1).voltage);
plot(GroupData(1).sampTime,mean(GroupData(1).voltage),'r','LineWidth',2)
hold on 
% plot(GroupData(1).sampTime,mean(GroupData(1).voltage)+std1,'r','LineWidth',0.5)
% plot(GroupData(1).sampTime,mean(GroupData(1).voltage)-std1,'r','LineWidth',0.5)
% plot(GroupData(1).sampTime,GroupData(1).voltage,'r','LineWidth',0.5)
set(gca,'Box','off','TickDir','out','XTickLabel','')
set(gca,'xtick',[],'XColor','white')
axis tight
legend({'probe on left'},'Location','Best')
legend boxoff;

h(3) = subplot(4,1,3);
std2 = std(GroupData(2).voltage);
hold on 
plot(GroupData(2).sampTime,mean(GroupData(2).voltage),'k','LineWidth',2)
% plot(GroupData(2).sampTime,mean(GroupData(2).voltage)+std2,'k','LineWidth',0.5)
% plot(GroupData(2).sampTime,mean(GroupData(2).voltage)-std2,'k','LineWidth',0.5)
% plot(GroupData(2).sampTime,GroupData(2).voltage,'k','LineWidth',0.5)
set(gca,'xtick',[],'XColor','white')
ylabel('Voltage (mV)')
set(gca,'Box','off','TickDir','out','XTickLabel','')
axis tight
legend({'probe off'},'Location','Best')
legend boxoff;

h(4) = subplot(4,1,4);
hold on 
std3 = std(GroupData(3).voltage);
plot(GroupData(3).sampTime,mean(GroupData(3).voltage),'b','LineWidth',2)
% plot(GroupData(3).sampTime,mean(GroupData(3).voltage)+std3,'b','LineWidth',0.5)
% plot(GroupData(3).sampTime,mean(GroupData(3).voltage)-std3,'b','LineWidth',0.5)
% plot(GroupData(3).sampTime,GroupData(3).voltage,'b','LineWidth',0.5)
set(gca,'Box','off','TickDir','out','XTickLabel',{'0','0.5','1','1.5'})
xlabel('Time (s)')
axis tight
legend({'probe on right'},'Location','Best')
legend boxoff;
linkaxes(h,'x')
xlim([2.5 4])

if n == 1
    spaceplots(fig,[0 0 0.025 0])
else
    spaceplots
end

%% Format and save
% saveFilename{n} = [saveFolder,'\GroupData_Stim',num2str(n),'.pdf'];
% set(gcf, 'PaperType', 'usletter');
% orient landscape
% export_fig(saveFilename{n},'-pdf','-q50')
% imageFilename = [saveFolder,'\overlay.emf'];
% print(fig,'-dmeta',imageFilename)

figFilename = [saveFolder,idString,'allFigs.pdf'];
mySave(figFilename)
% if exist(figFilename,'file')
%     delete(figFilename)
% end
% append_pdfs(figFilename,saveFilename{:})
% delete(saveFilename{:})

end