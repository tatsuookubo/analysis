set(0,'DefaultAxesFontSize', 25)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

t = -5:0.01:5; 
sig = 1./(1+(exp(-t))); 
figure()
subplot(2,1,1) 
plot(sig,'k','Linewidth',2)
hold on 
plot(1-sig,'r','Linewidth',2)
legend({'Right comparator','Left comparator'},'Location','SouthEastOutside')
% % legend({'Low intensity','High intensity'},'Location','NorthWest')
% legend boxoff
xlim([0 1000])
ylim([0 1.5])
set(gca,'YTick',[],'XTick',[],'Box','off')
ylabel('Activity')

x = [0:0.1:1000];
norm = normpdf(x,250,10);
norm2 = normpdf(x,750,10);
subplot(2,1,2) 
plot(x,norm,'r','Linewidth',2)
hold on 
plot(x,norm2,'k','Linewidth',2)
xlim([0 1000])
ylabel('Neural activity') 
set(gca,'YTick',[],'XTick',[],'Box','off')
ylabel('Activity')
xlabel('ILD')





