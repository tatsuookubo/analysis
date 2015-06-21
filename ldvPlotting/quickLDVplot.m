function quickLDVplot(expNum,flyNum)

expNum = num2str(expNum,'%03d');
flyNum = num2str(flyNum,'%03d');

gray = [192 192 192]./255;

figCount = 0;
rootFolder = ['C:\Users\Alex\Documents\Data\ldv\expNum',expNum,'\flyNum',flyNum,'\'];
saveFolder = [rootFolder,'Figures\'];
imageFolder = [rootFolder,'Figures\Images\'];

if ~isdir(saveFolder)
    mkdir(saveFolder)
end
if ~isdir(imageFolder)
    mkdir(imageFolder)
end

rawfiles = dir([rootFolder,'ldv*']);

for n = 1:length(rawfiles)
    close all
    
    load([rootFolder,rawfiles(n).name]);
    flyExpNum = char(regexp(rawfiles(n).name,'(?<=flyExpNum)\d*(?=.mat)','match'));
    
    dateNumber = datenum(exptInfo.dNum,'yymmdd');
    dateAsString = datestr(dateNumber,'mm-dd-yy');
    
    clear velocity displacement
    count = 0;
    for i = 1:length(data)
        if max(abs(data(i).velocity)) < 5
            count = count + 1;
            velocity(count,:) = data(i).velocity;
            displacement(count,:) = data(i).displacement;
        end
    end
    
    set(0,'DefaultAxesFontSize', 16)
    set(0,'DefaultFigureColor','w')
    set(0,'DefaultAxesBox','off')
    
    fig = figure(1);
    setCurrentFigurePosition(1)
    
    h(1) = subplot(3,1,1);
    stimTime = [1/Stim(1).sampleRate:1/Stim(1).sampleRate:Stim(1).totalDur]';
    plot(stimTime,Stim(1).stimulus,'k','lineWidth',2);
    ylabel('Stimulus');
    set(gca,'Box','off','TickDir','out','XTickLabel','')
    ylim([-1.1 1.1])
    set(gca,'xtick',[])
    set(gca,'XColor','white')
    t = title(h(1),[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum),', FlyExpNum ',num2str(exptInfo.flyExpNum)]);
    set(t,'Fontsize',20);
    
    h(2) = subplot(3,1,2);
    sampTime = [1/settings.sampRate.in:1/settings.sampRate.in:Stim(1).totalDur]';
    %     if size(velocity,1)>=10
    %         plot(sampTime,velocity(1,:),'Color',gray,'lineWidth',2);
    %         hold on
    %         plot(sampTime,velocity(5,:),'Color',gray,'lineWidth',2);
    %         hold on
    %         plot(sampTime,velocity(10,:),'Color',gray,'lineWidth',2);
    %     else
    %         plot(sampTime,velocity(1,:),'Color',gray,'lineWidth',2);
    %         hold on
    %         plot(sampTime,velocity(end,:),'Color',gray,'lineWidth',2);
    %     end
    plot(sampTime,velocity,'Color',gray,'lineWidth',2);
    hold on
    plot(sampTime,mean(velocity),'k','lineWidth',2);
    ylabel('velocity (mm/s)');
    set(gca,'Box','off','TickDir','out','XTickLabel','')
    axis tight
    set(gca,'xtick',[])
    set(gca,'XColor','white')
    ylim([-1.1 1.1])
    
    h(3) = subplot(3,1,3);
    %     if size(displacement,1)>=10
    %         plot(sampTime,displacement(1,:),'Color',gray,'lineWidth',2);
    %         hold on
    %         plot(sampTime,displacement(5,:),'Color',gray,'lineWidth',2);
    %         hold on
    %         plot(sampTime,displacement(10,:),'Color',gray,'lineWidth',2);
    %     else
    %         plot(sampTime,displacement(1,:),'Color',gray,'lineWidth',2);
    %         hold on
    %         plot(sampTime,displacement(end,:),'Color',gray,'lineWidth',2);
    %     end
    plot(sampTime,displacement,'Color',gray,'lineWidth',2);
    hold on
    plot(sampTime,mean(displacement),'k','lineWidth',2);
    ylabel('displacement (um)');
    set(gca,'Box','off','TickDir','out')
    axis tight
    xlabel('time (seconds)');
    ylim([-1.1 1.1])
    
    linkaxes(h,'x')
    
    %xlim([0.995 1.025])
    % ylim([-2 2])
    
    spaceplots
    
    figCount = figCount + 1;
    set(gcf, 'PaperType', 'usletter');
    orient landscape
    saveFilename{figCount} = [saveFolder,'flyExpNum_',flyExpNum,'_zoom_1.pdf'];
    export_fig(saveFilename{figCount},'-pdf','-q50')
    imageFilename = [imageFolder,'flyExpNum_',flyExpNum,'_zoom_1.emf'];
    print(fig,'-dmeta',imageFilename)
    
    xlim([0.9 1.45])
    figCount = figCount + 1;
    set(gcf, 'PaperType', 'usletter');
    orient landscape
    saveFilename{figCount} = [saveFolder,'flyExpNum_',flyExpNum,'_zoom_2.pdf'];
    export_fig(saveFilename{figCount},'-pdf','-q50')
    imageFilename = [imageFolder,'flyExpNum_',flyExpNum,'_zoom_2.emf'];
    print(fig,'-dmeta',imageFilename)
    
    xlim([0.995 1.025])
    figCount = figCount + 1;
    set(gcf, 'PaperType', 'usletter');
    orient landscape
    saveFilename{figCount} = [saveFolder,'flyExpNum_',flyExpNum,'_zoom_3.pdf'];
    export_fig(saveFilename{figCount},'-pdf','-q50')
    imageFilename = [imageFolder,'flyExpNum_',flyExpNum,'_zoom_3.emf'];
    print(fig,'-dmeta',imageFilename)
end

figFilename = [saveFolder,'allFigures1.pdf'];
if exist(figFilename,'file')
    delete(figFilename)
end
append_pdfs(figFilename,saveFilename{:})
delete(saveFilename{:})