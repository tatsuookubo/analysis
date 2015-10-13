function figSize = setFigSize(width,height) 
xPos = 0.5; 
yPos = 0.5; 
set(gcf,'Unit','inches','Position',[xPos yPos width height]);
figSize = [width height];
