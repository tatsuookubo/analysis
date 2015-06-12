close all
angles = -pi:0.01:pi;

%% normal
figure()
for n = 1:3;
    
    tuningR = n*sin(2*angles);
    tuningR = abs(min(tuningR))+n*sin(2*angles);

    tuningL = n*sin(2*(angles + pi/2));
    tuningL = abs(min(tuningL))+n*sin(2*angles);

    
    subplot(3,1,1)
    plot(angles,tuningR,'k')
    hold on
%     plot(angles,tuningL,'r')
    hold on
    legend right left
    legend boxoff
        set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
    set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
    
    difference = tuningR-tuningL;
    sum = tuningR + tuningL;
    subplot(3,1,2)
    plot(angles,difference)
    hold on
        set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
    set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
    
    subplot(3,1,3)
    plot(angles,sum)
    hold on
    set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
    set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
end


%% shifted upwards 
close all

tuningL = 1+sin(2*angles);
tuningR = 1+sin(2*(angles + pi/2));
figure()

subplot(6,1,1)
plot(angles,tuningR,'k')
hold on
plot(angles,tuningL,'r')
legend({'right JONs','left JONs'})
legend boxoff
% set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
% set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('JON tuning') 
ylim([-2 2])

subplot(6,1,2)
plot(angles,tuningR+tuningL)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Sum')
ylim([-2 2])

subplot(6,1,3)
plot(angles,tuningR-tuningL)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Difference R - L')
ylim([-2 2])

subplot(6,1,4)
plot(angles,tuningL-tuningR)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Difference L - R')
ylim([-2 2])

subplot(6,1,5)
plot(angles,tuningR./tuningL)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Ratio R/L')
ylim([-2 2])

subplot(6,1,6)
plot(angles,tuningL./tuningR)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Ratio L/R')
ylim([-2 2])

%% shifted upwards 
close all

tuningL = sin(2*angles);
tuningR = sin(2*(angles + pi/2));
figure()

subplot(6,1,1)
plot(angles,tuningR,'k')
hold on
plot(angles,tuningL,'r')
legend({'right JONs','left JONs'})
legend boxoff
% set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
% set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('JON tuning') 
ylim([-2 2])

subplot(6,1,2)
plot(angles,tuningR+tuningL)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Sum')
ylim([-2 2])

subplot(6,1,3)
plot(angles,tuningR-tuningL)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Difference R - L')
ylim([-2 2])

subplot(6,1,4)
plot(angles,tuningL-tuningR)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Difference L - R')
ylim([-2 2])

subplot(6,1,5)
plot(angles,tuningR./tuningL)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Ratio R/L')
ylim([-2 2])

subplot(6,1,6)
plot(angles,tuningL./tuningR)
set(gca,'XTick',[-pi,-3*pi/4,-pi/2,-pi/4,0,pi/4,pi/2,3*pi/4,pi]);
set(gca,'XTickLabel',[-180,-135,-90,-45,0,45,90,135,180])
xlim([-pi/2 pi/2])
title('Ratio L/R')
ylim([-2 2])

