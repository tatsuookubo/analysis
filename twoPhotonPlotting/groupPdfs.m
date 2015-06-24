function groupPdfs

folder = uigetdir; 
cd(folder) 
fileNames = dir('*.pdf'); 

allFileStem = char(regexp(fileNames(1).name,'.*(?=roi)','match'));
groupFileName = [folder,'\',allFileStem,'allFigs.pdf'];

saveFileNameArray = struct2cell(fileNames); 
saveFileName = saveFileNameArray(1,:);
saveFileName = saveFileName';
myAppendPdfs(saveFileName,groupFileName)

