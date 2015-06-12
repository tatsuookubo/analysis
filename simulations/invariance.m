set(0,'DefaultAxesFontSize', 25)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

t = -5:0.01:5; 
sig = 1./(1+(exp(-t))); 
figure()
subplot(3,1,1) 
plot(sig,'r--','Linewidth',2)
hold on 
plot(0.5+sig,'r','Linewidth',2)
% legend({'Low intensity','High intensity'},'Location','NorthWest')
% legend boxoff
xlim([0 1000])
ylim([0 1.5])
set(gca,'YTick',[],'XTick',[],'Box','off')
ylabel('Activity')

subplot(3,1,2) 
plot(1-sig,'k--','Linewidth',2)
hold on 
plot(0.5+1-sig,'k','Linewidth',2)
xlim([0 1000])
ylabel('Neural activity') 
ylim([0 1.5])
set(gca,'YTick',[],'XTick',[],'Box','off')
ylabel('Activity')

subplot(3,1,3) 
plot(sig- (1-sig),'g--','Linewidth',2)
hold on 
plot(0.05+(0.5+sig)-(0.5+1-sig),'g','Linewidth',2)
xlim([0 1000])
xlabel('ILD')
ylim([-1 1.1])
set(gca,'YTick',[],'XTick',[],'Box','off')
ylabel('Difference')

spaceplots([0 0 0 0],[.2])

