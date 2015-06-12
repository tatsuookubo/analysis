set(0,'DefaultAxesFontSize', 20)
set(0,'DefaultFigureColor','w')
set(0,'DefaultAxesBox','off')

gray = [192 192 192]./255;
blue = [171 198 235]./255;
orange = [247 208 146]./255;
labels = {'Input 1','Input 2','Summing Neuron','Difference Neuron'};
colors = {'gray','gray','blue','orange'};
close all
figure() 
% input levels 1
subplot(2,1,1)
x = [1 2 3 4];
y  = [0.5 0.5 1 0];
for i = 1:4
p1 = bar(x(i),y(i));
set(p1,'FaceColor',eval(colors{i}),'EdgeColor',eval(colors{i}));
hold on 
end 
set(gca,'TickDir','out','Box','off','XTick',[])

% input levels 2
subplot(2,1,2)
y = [0.8 0.2 1 0.6];
for i = 1:4
p1 = bar(x(i),y(i));
set(p1,'FaceColor',eval(colors{i}),'EdgeColor',eval(colors{i}));
hold on 
end 
set(gca,'XTickLabel',labels)
set(gca,'TickDir','out','Box','off','XTick',[1:4])

suplabel('Activity level (Arbitrary units)','y')
% spaceplots