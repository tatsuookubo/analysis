function myAppendPdfs(filenames,groupFilename)

% Delete old group pdf 
fileNameCount = 1;
while exist(groupFilename,'file')
%     delete(groupFilename)
    fileNameCount = fileNameCount + 1; 
    groupFileStem = char(regexp(groupFilename,'.*(?=.pdf)','match'));
    groupFilename = [groupFileStem,'v',num2str(fileNameCount),'.pdf'];
end

% Append individual pdfs together
append_pdfs(groupFilename,filenames{:})

% % Delete individual pdfs
% delete(filenames{:})
