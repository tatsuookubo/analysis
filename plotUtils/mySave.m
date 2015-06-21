function mySave(filename)

% Save settings 
set(gcf, 'PaperType', 'usletter');
orient landscape

% Save pdf 
export_fig(filename,'-pdf','-q50')

% Save emf 
fileStem = char(regexp(filename,'.*(?=.pdf)','match'));
imageFilename = [fileStem,'_image.emf'];
print(gcf,'-dmeta',imageFilename)