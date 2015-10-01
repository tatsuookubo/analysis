function figSize = setFigSize(width,height) 
xPos = 5; 
yPos = 3; 
set(gcf,'Unit','inches','Position',[xPos yPos width height]);
figSize = [width height];
