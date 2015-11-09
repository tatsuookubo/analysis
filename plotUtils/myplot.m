function h = myplot(varargin)

h = plot(varargin{:});
box off;
set(gca,'TickDir','out')
set(0,'DefaultFigureColor','w')
axis tight
set(gca,'Fontsize',24)
set(gca,'FontName','Calibri')
set(groot,'defaultLineLineWidth',2)
set(0,'defaultAxesFontName','Calibri')
set(0,'defaultAxesFontSize',24)

end