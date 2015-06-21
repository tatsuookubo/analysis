function myplot(varargin)

setCurrentFigurePosition(1) 
plot(varargin{:});
box off;
set(gca,'TickDir','out')
set(0,'DefaultFigureColor','w')
axis tight
set(gca,'Fontsize',26)
set(gca,'FontName','Calibri')

end