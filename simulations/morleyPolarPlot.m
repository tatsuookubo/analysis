close all

set(0,'DefaultAxesFontSize', 12)
set(0,'DefaultFigureColor','w')



theta = 0:0.01:2*pi;

figure
% Right antenna
rho = sin(theta-(pi/4));
h1 = polar(theta,rho,'k');
hold on
rho = sin(theta-(pi)-(pi/4));
h2 = polar(theta,rho,'k');

% Left antenna
rho = sin(theta-(pi/4)-(3*pi/2));
h3 = polar(theta,rho,'r');
rho = sin(theta-(pi/4)-(pi/2));
h4 = polar(theta,rho,'r'); 

set(h1,'linewidth',2)
set(h2,'linewidth',2)
set(h3,'linewidth',2)
set(h4,'linewidth',2)


set(gca,'LineWidth',4,'XTick',[])

hHiddenText = findall(gca,'type','text');
Angles = 0 : 30 : 330;
hObjToDelete = zeros( length(Angles)-4, 1 );
k = 0;
for ang = Angles
    hObj = findall(hHiddenText,'string',num2str(ang));
    switch ang
        case 0
            set(hObj,'string','90°','HorizontalAlignment','Left');
        case 30
            set(hObj,'string','60°','HorizontalAlignment','Left');
        case 60
            set(hObj,'string','30°','HorizontalAlignment','Left');
        case 90
            set(hObj,'string','0°','VerticalAlignment','Bottom');
        case 120
            set(hObj,'string','330°','HorizontalAlignment','Right');
        case 150
            set(hObj,'string','300°','HorizontalAlignment','Right');
        case 180
            set(hObj,'string','270°','HorizontalAlignment','Right');
        case 210
            set(hObj,'string','240°','HorizontalAlignment','Right');
        case 240
            set(hObj,'string','210°','HorizontalAlignment','Right');
        case 270
            set(hObj,'string','180°','VerticalAlignment','Top');
        case 300
            set(hObj,'string','150°','HorizontalAlignment','Left');
        case 330
            set(hObj,'string','120°','HorizontalAlignment','Left');
        otherwise
            k = k + 1;
            hObjToDelete(k) = hObj;
    end
end
delete( hObjToDelete(hObjToDelete~=0) );
%------------------------

%% Delete rho labels 

% Find all handles to text labels
h     = findall(gca,'type','text');

% Define what to keep
legit = {'0°','30°','60°','90°','120°','150°','180°','210°','240°','270°','300°','330°','360°',''};

% Take the others and set them to empty string
idx   = ~ismember(get(h,'string'),legit);
set(h(idx),'string','')
