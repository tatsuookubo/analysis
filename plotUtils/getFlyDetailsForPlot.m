function getFlyDetailsForPlot(prefixCode,expNum,flyNum,cellNum)

microCzarSettings;   % Loads settings

filename = [dataDirectory,prefixCode,'\expNum',num2str(expNum,'%03d'),...
        '\flyNum',num2str(flyNum,'%03d'),'\flyData'];
load(filename)

isOpen  = exportToPPTX();
if ~isempty(isOpen),
    % If PowerPoint already started, then close first and then open a new one
    exportToPPTX('close');
end
exportToPPTX('new')
slideNum = exportToPPTX('addslide');
exportToPPTX('addtext',prefixCode,'Position',[0 0 4 2]);
exportToPPTX('save','C:\Users\Alex\Documents\TempFigs\exampleyeah.ppt');

end