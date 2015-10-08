close all
folder = 'C:\Users\Alex\Documents\Data\happy\expNum001\flyNum005\Figures\Online';
cd(folder)

fileNames = dir('*.fig');

for i = 1:length(fileNames)
    open(fileNames(i).name)
    fileStem = char(regexp(fileNames(i).name,'.*(?=_matFig)','match'));
    pdfFileName = [fileStem,'.pdf'];
    if exist(pdfFileName,'file') > 0
    else
        set(gcf, 'PaperType', 'usletter');
        orient landscape
        export_fig(pdfFileName,'-pdf','-q50')
    end
    close all
end

