function symAxisY

axis tight
ylimits = ylim; 
yMax = max(abs(ylimits)); 
ylim([-yMax,yMax])