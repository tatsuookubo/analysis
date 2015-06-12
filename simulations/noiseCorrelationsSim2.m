
gray = [192 192 192]./255;


close all

signal1 = [zeros(1,30),ones(1,50),zeros(1,30)];
time = 1:length(signal1);
signal2 = -signal1;

a = -1; 
b = 1;
noise1 = (b-a).*rand(size(time)) + a;
noise2 = (b-a).*rand(size(time)) + a;


figure()
%% 
subplot(4,3,1)
plot(time,signal1,'Color',gray,'Linewidth',2)
hold on 
plot(time,signal1+noise1,'r','Linewidth',2)
ylim([-1 2])
% legend({'Original signal','Signal + noise'})
% legend boxoff
t = title({'Left'});
set(t,'HorizontalAlignment','left','Position',[0 1 0]); 
set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%% 
subplot(4,3,4) 
plot(time,signal2+noise1,'k','Linewidth',2)
% legend({'Signal + noise'},'Location','SouthEast')
% legend boxoff
hold on 
plot(time,signal2,'Color',gray,'Linewidth',2)
ylim([-2 1])

t = title('Right');
set(t,'HorizontalAlignment','left','Position',[0 0.8 0]); 
set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%%
subplot(4,3,7)
plot(time,(signal1+noise1 - (signal2+noise1))/2,'r','Linewidth',2)
ylim([-1 2])

t = title({'Recovered signals:';'';'Left'});
set(t,'HorizontalAlignment','left','Position',[0 0 0]); 
set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%% 
subplot(4,3,10)
plot(time,((signal2+noise1) - (signal1+noise1))/2,'k','Linewidth',2)
ylim([-2 1])

t = title('Right');
set(t,'HorizontalAlignment','left','Position',[0 0 0]); 

set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%% 
subplot(4,3,2)
plot(time,signal1,'Color',gray,'Linewidth',2)
hold on 
plot(time,signal1+noise1,'r','Linewidth',2)
ylim([-1 2])

set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%% 
subplot(4,3,5) 
plot(time,signal2-noise1,'k','Linewidth',2)
hold on 
plot(time,signal2,'Color',gray,'Linewidth',2)
ylim([-2 1])


set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%%
subplot(4,3,8)
plot(time,(signal1+noise1 - (signal2-noise1))/2,'r','Linewidth',2)
ylim([-1 2])

set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%% 
subplot(4,3,11)
plot(time,((signal2-noise1) - (signal1+noise1))/2,'k','Linewidth',2)
ylim([-2 1])

set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%% 
subplot(4,3,3)
plot(time,signal1,'Color',gray,'Linewidth',2)
hold on 
plot(time,signal1+noise1,'r','Linewidth',2)
ylim([-1 2])

set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%% 
subplot(4,3,6) 
plot(time,signal2+noise2,'k','Linewidth',2)
hold on 
plot(time,signal2,'Color',gray,'Linewidth',2)
ylim([-2 1])


set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%%
subplot(4,3,9)
plot(time,(signal1+noise1 - (signal2+noise2))/2,'r','Linewidth',2)
ylim([-1 2])

set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

%% 
subplot(4,3,12)
plot(time,((signal2+noise2) - (signal1+noise1))/2,'k','Linewidth',2)
ylim([-2 1])

set(gca,'YTick',[],'XTick',[])
set(gca,'XColor','white','YColor','white','Box','off')

spaceplots
