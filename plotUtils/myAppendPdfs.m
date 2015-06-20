function myAppendPdfs(filenames,groupFilename)

% Delete old group pdf 
if exist(groupFilename,'file')
    delete(groupFilename)
end

% Append individual pdfs together
append_pdfs(groupFilename,filenames{:})

% Delete individual pdfs
delete(filenames{:})
