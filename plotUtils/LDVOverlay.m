function LDVOverlay(expNum,flyNum)

expNum = num2str(expNum,'%03d');
flyNum = num2str(flyNum,'%03d');

exptNums =[3,4];
gray = [192 192 192]./255;

colours = {'r','b'};
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

count2 = 0;
for n = exptNums %18:21; %[1:3,5:18,22:27];
    %     close all
    count2 = count2+1;
    filename = ['C:\Users\Alex\Documents\Data\ldv\expNum001\flyNum006\ldv_expNum001_flyNum006_flyExpNum',num2str(n,'%03d')];
    load(filename);
    
    dateNumber = datenum(exptInfo.dNum,'yymmdd');
    dateAsString = datestr(dateNumber,'mm-dd-yy');
    
    clear velocity displacement
    count = 0;
    for i = 1:length(data)
        if max(abs(data(i).velocity)) < 5
            count = count + 1;
            velocity(count,:) = data(i).velocity;
            displacement(count,:) = data(i).displacement - mean(data(i).displacement(9000:10000));
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
    t = title(h(1),[dateAsString,', ',exptInfo.prefixCode,', ','ExpNum ',num2str(exptInfo.expNum),', FlyNum ',num2str(exptInfo.flyNum)]);
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
    %     plot(sampTime,velocity,'Color',gray,'lineWidth',2);
    %     hold on
    stdVel = std(velocity,1);
    %     plot(sampTime,mean(velocity),colours{count2},'lineWidth',2);
    %     hold on
    shadedErrorBar(sampTime,mean(velocity),stdVel,colours{count2},1)
    hold on
    plot(sampTime,mean(velocity),colours{count2})
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
    %     plot(sampTime,displacement,'Color',gray,'lineWidth',2);
    %     hold on
    stdDisplacement = std(displacement,1);
    shadedErrorBar(sampTime,mean(displacement),stdDisplacement,colours{count2},1)
    hold on
    plot(sampTime,mean(displacement),colours{count2})
    ylabel('displacement (um)');
    set(gca,'Box','off','TickDir','out')
    axis tight
    xlabel('time (seconds)');
    ylim([-1.1 1.1])
    
    linkaxes(h,'x')
    
    %xlim([0.995 1.025])
    % ylim([-2 2])
    
    spaceplots
    
    
    
end


% legend({['FlyExpNum',num2str(exptNums(1))],['FlyExpNum',num2str(exptNums(2))]});
figCount = figCount + 1;
saveFilename{figCount} = [saveFolder,'overlay_zoom_1.pdf'];
set(gcf, 'PaperType', 'usletter');
orient landscape
export_fig(saveFilename{figCount},'-pdf','-q50','-opengl')
imageFilename = [imageFolder,'overlay_zoom_1.emf'];
print(fig,'-dmeta',imageFilename)

xlim([0.9 1.45])
figCount = figCount + 1;
saveFilename{figCount} = [saveFolder,'overlay_zoom_2.pdf'];
set(gcf, 'PaperType', 'usletter');
orient landscape
export_fig(saveFilename{figCount},'-pdf','-q50','-opengl')
imageFilename = [imageFolder,'overlay_zoom_2.emf'];
print(fig,'-dmeta',imageFilename)

xlim([0.995 1.025])
figCount = figCount + 1;
saveFilename{figCount} = [saveFolder,'overlay_zoom_3.pdf'];
set(gcf, 'PaperType', 'usletter');
orient landscape
export_fig(saveFilename{figCount},'-pdf','-q50','-opengl')
imageFilename = [imageFolder,'overlay_zoom_3.emf'];
print(fig,'-dmeta',imageFilename)

%% Append pdfs
figFilename = [saveFolder,'allFigures2.pdf'];
if exist(figFilename,'file')
    delete(figFilename)
end
append_pdfs(figFilename,saveFilename{:})
delete(saveFilename{:})