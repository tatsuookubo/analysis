function plotAllExpts(prefixCode,expNum,flyNum)

% prefixCode = '26B07';
% expNum = 1; 
% flyNum = 2; 
% i = 1;
% 

exptInfo.prefixCode     = prefixCode;
exptInfo.expNum         = expNum;
exptInfo.flyNum         = flyNum;
exptInfo.cellNum        = 1;
exptInfo.cellExpNum     = 1; 

[~,path] = getDataFileName(exptInfo);
cellFileStem = char(regexp(path,'.*(?=cellNum)','match'));
cd(cellFileStem); 
cellNumList = dir('cellNum*');
for i = 1:length(cellNumList)
    exptInfo.cellNum = str2num(char(regexp(cellNumList(i).name,'(?<=cellNum).*','match')));
    [~,path] = getDataFileName(exptInfo);
    cellExpFileStem = char(regexp(path,'.*(?=cellExpNum)','match'));
    cd(cellExpFileStem);
    cellExpNumList = dir('cellExpNum*');
    for j = 1:length(cellExpNumList)
        exptInfo.cellExpNum = str2num(char(regexp(cellExpNumList(j).name,'(?<=cellExpNum).*','match')));
        [~,path] = getDataFileName(exptInfo);
        cd(path);
        fileNames = dir('*trial*.mat');
        numTrials = length(fileNames);
        if numTrials == 0
        else 
            groupDataFile = dir('*groupedData*.mat');
%             if length(groupDataFile) ~= 1
                mergeTrials(exptInfo)
%             end
            plotDataGroupedByStim(exptInfo)
        end
    end
end

flyFolder = char(regexp(path,'.*(?=cellNum)','match'));
groupPdfs([flyFolder,'Figures'])