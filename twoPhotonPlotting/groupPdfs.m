function groupPdfs(folder,varargin)

if nargin == 0 
    folder = uigetdir; 
end
cd(folder) 
fileNames = dir('*.pdf'); 

allFileStem = char(regexp(fileNames(1).name,'.*(?=roi)','match'));
groupFileName = [folder,'\',allFileStem,'allFigs.pdf'];

saveFileNameArray = struct2cell(fileNames); 
saveFileName = saveFileNameArray(1,:);
saveFileName = saveFileName';
myAppendPdfs(saveFileName,groupFileName)

