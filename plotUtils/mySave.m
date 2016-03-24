function mySave(filename,figSize,varargin)

% Save settings 
% set(gcf, 'PaperType', 'usletter');
% orient landscape

if ~exist('figSize','var')
    figSize = [5 3];
end

% Save pdf 
export_fig(filename,'-pdf','-q50')

% Save svg
set(gcf, 'PaperSize', figSize);
set(gcf,'PaperUnits','inches','PaperPositionMode','manual','PaperPosition',[0 0,figSize]);
% set(gcf,'PaperPositionMode','auto','Unit','inches','Position',[1 1 4 5]);

fileStem = char(regexp(filename,'.*(?=.pdf)','match'));
imageFilename = [fileStem,'_image.eps'];
print(gcf,'-depsc',imageFilename,'-r50','-painters','-cmyk')

fileStem = char(regexp(filename,'.*(?=.pdf)','match'));
imageFilename = [fileStem,'_meta_image.emf'];
print(gcf,'-dmeta',imageFilename,'-r300','-painters','-cmyk')

figFileStem = char(regexp(filename,'.*(?=.pdf)','match'));
figFilename = [figFileStem,'_matFig.fig'];
savefig(figFilename)