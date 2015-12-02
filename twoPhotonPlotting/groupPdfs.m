function groupPdfs(folder,varargin)

if nargin == 0 
    folder = uigetdir; 
end
cd(folder) 
fileNames = dir('*.pdf'); 

allFileStem = char(regexp(fileNames(1).name,'.*(?=roi)','match'));
groupFileFolder = [folder,'\','SumFigs\'];
if ~isdir(groupFileFolder) 
    mkdir(groupFileFolder) 
end
groupFileName = [groupFileFolder,allFileStem,'allFigs.pdf'];

saveFileNameArray = struct2cell(fileNames); 
saveFileName = saveFileNameArray(1,:);
saveFileName = saveFileName';
myAppendPdfs(saveFileName,groupFileName)

