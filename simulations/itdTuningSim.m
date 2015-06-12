close all 

orange = [250 178 77]./255;

set(0,'DefaultAxesFontSize', 25)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

t = -3*pi:0.01:3*pi; 
sig = sin(t); 
figure()
plot(t,sig,'Color',orange,'Linewidth',4)
set(gca,'Linewidth',3)
set(gca,'Box','off','XTick',[],'YTick',[])
ylabel('Response rate')
xlabel('ITD')
drawaxis(gca,'y',0)
set(gca,'YColor','white')

%% Sensitivity to timing by subtraction 
close all 

orange = [250 178 77]./255;

set(0,'DefaultAxesFontSize', 25)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

t = -3*pi:0.0001:3*pi; 
sig = cos(t); 
sig2 = cos(t+pi);
figure()
plot(t,sig,'Color',orange,'Linewidth',4)
hold on 
plot(t,sig2,'b','Linewidth',4)
legend({'E-E comparator','E-I comparator'},'location','SouthOutside')
legend boxoff
set(gca,'Linewidth',3)
set(gca,'Box','off','XTick',[],'YTick',[])
ylabel('Response rate')
set(gca,'YColor','white','XColor','white')

%% Sensitivity to timing by subtraction 
close all 

orange = [250 178 77]./255;

set(0,'DefaultAxesFontSize', 25)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

t = -3*pi:0.0001:3*pi; 
sig = cos(t); 
sig2 = cos(t);
figure()
subplot(2,1,1)
plot(t,sig,'k','Linewidth',4)
set(gca,'Box','off','XTick',[],'YTick',[])
ylabel('Response rate')
set(gca,'YColor','white','XColor','white')
subplot(2,1,2)
plot(t,sig2,'r','Linewidth',4)
set(gca,'Box','off','XTick',[],'YTick',[])
ylabel('Response rate')
set(gca,'YColor','white','XColor','white')


spaceplots([0.1 0.1 0.1 0.1],[0.05 0.05,0.05])


