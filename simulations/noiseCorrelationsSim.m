set(0,'DefaultAxesFontSize', 30)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

close all
angles = 0:0.01:pi;
angles = [zeros(1,100),angles,zeros(1,100)];
time = 0:1:length(angles)-1;
xtop = time(end); 

tuningL = (sin(angles));
tuningR = (sin((angles + pi)));


noise1 = rand(size(angles));
noise2 = rand(size(angles));
noise3 = rand(size(angles));

corrR = tuningR+noise1;
corrL = tuningL+noise1;

uncorrR = tuningR+noise2;
uncorrL = tuningL+noise3;

corrSubtractR = corrR-corrL; 
corrSubtractL = corrL-corrR; 

uncorrSubtractR = uncorrR-uncorrL; 
uncorrSubtractL = uncorrL-uncorrR; 

%% No noise 
figure()
subplot(5,1,1)
plot(time,tuningL,'r')
hold on 
plot(time,tuningR,'k')
legend({'left','right'},'Location','East')
legend boxoff
t = title('A: Zero noise');
set(t,'HorizontalAlignment','left','Position',[-.2 0 0]); 
xlim([0 xtop])
set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')


%% Correlated 
subplot(5,1,2)
plot(time,corrR,'k')
hold on
plot(time,0.05+corrL,'r')
ylim([min(corrR),max(corrL)])
t = title('B: Correlated noise');
set(gca,'YTick',[],'XTick',[])
xlim([0 xtop])
set(gca,'XColor','white','YColor','white','Box','off')
set(t,'HorizontalAlignment','left','Position',[-.2 1.5 0]); 

%% Uncorrelated 
subplot(5,1,3)
plot(time,uncorrR,'k')
hold on
plot(time,uncorrL,'r')
ylim([min(uncorrR),max(uncorrL)])
ylabel('neural activity')
t = title('C: Uncorrelated noise')
set(gca,'YTick',[],'XTick',[])
xlim([0 xtop])
set(gca,'XColor','white','YColor','white','Box','off')
set(t,'HorizontalAlignment','left','Position',[-.2 1.5 0]); 

%% Correlated Subtracted 
subplot(5,1,4)
plot(time,corrSubtractR,'k')
hold on
plot(time,corrSubtractL,'r')
ylim([min(corrSubtractR),max(corrSubtractL)])
t = title({'D: Correlated noise';'+ mutual inhibition'});
set(gca,'YTick',[],'XTick',[])
xlim([0 xtop])
set(gca,'XColor','white','YColor','white','Box','off')
set(t,'HorizontalAlignment','left','Position',[-.2 1 0]); 

%% Correlated Subtracted 
subplot(5,1,5)
plot(time,uncorrSubtractR,'k')
hold on
plot(time,uncorrSubtractL,'r')
ylim([min(uncorrSubtractR),max(uncorrSubtractL)])
xlabel('time')
t = title({'E: Uncorrelated noise';'+ mutual inhibition'});
set(gca,'YTick',[],'XTick',[])
xlim([0 xtop])
set(gca,'XColor','white','YColor','white','Box','off')
set(t,'HorizontalAlignment','left','Position',[-.2 1 0]); 

spaceplots

%% Zoom in 
figure()
range = time(end)-20:time(end);
plot(time(range),corrR(range),'k','Linewidth',2)
hold on
plot(time(range),0.05+corrL(range),'r','Linewidth',2)
set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')
set(t,'HorizontalAlignment','left','Position',[-.2 1 0]); 

figure()
plot(time(range),uncorrR(range),'k','Linewidth',2)
hold on
plot(time(range),uncorrL(range),'r','Linewidth',2)
set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')
set(t,'HorizontalAlignment','left','Position',[-.2 1 0]); 


