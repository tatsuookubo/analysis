function mySave(filename)

% Save settings 
% set(gcf, 'PaperType', 'usletter');
% orient landscape

% Save pdf 
export_fig(filename,'-pdf','-q50')

% Save svg
set(gcf, 'PaperSize', [5 4]);
set(gcf,'PaperUnits','inches','PaperPositionMode','manual','PaperPosition',[0 0 4 5]);
% set(gcf,'PaperPositionMode','auto','Unit','inches','Position',[1 1 4 5]);

fileStem = char(regexp(filename,'.*(?=.pdf)','match'));
imageFilename = [fileStem,'_image.eps'];
print(gcf,'-depsc',imageFilename,'-r300','-painters','-cmyk')

fileStem = char(regexp(filename,'.*(?=.pdf)','match'));
imageFilename = [fileStem,'_image.emf'];
print(gcf,'-dmeta',imageFilename,'-r300','-painters','-cmyk')

figFileStem = char(regexp(filename,'.*(?=.pdf)','match'));
figFilename = [figFileStem,'_matFig.fig'];
savefig(figFilename)