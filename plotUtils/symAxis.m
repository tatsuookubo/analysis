function symAxis 

axis tight
xlimits = xlim; 
ylimits = ylim; 
xMax = max(abs(xlimits)); 
yMax = max(abs(ylimits)); 
xlim([-xMax,xMax])
ylim([-yMax,yMax])
axis square 
