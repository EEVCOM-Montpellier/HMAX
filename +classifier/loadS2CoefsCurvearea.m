function T = loadS2CoefsCurvearea(directory)
%LOADC2S Summary of this function goes here
    allFiles = dir(fullfile(directory, '**/*.mat'));
    countFiles = size(allFiles, 1);
    filenames = cell(countFiles, 1);
    Curvearea = zeros(countFiles, 1);
    fileIndex = 1;
    curdirs = dir(directory);
    curdirs = curdirs(~ismember({curdirs.name},{'.','..', 'execution_time.txt', 'training_time.txt'}));
    files = curdirs(~[curdirs.isdir]);
    len_str = 0;
    for ii = 1:length(curdirs)
         files = dir(fullfile(curdirs(ii).folder, curdirs(ii).name));
         files = files(~ismember({files.name}, {'.', '..'}));
         files = files(~[files.isdir]);
         for jj = 1:length(files)
             for kk = 1:len_str
                 fprintf('\b');
             end
             stat_string = ['Folder ' int2str(ii) '/' int2str(length(curdirs)) ' - File ' int2str(jj) '/' int2str(length(files))];
             len_str = length(stat_string);
             fprintf(stat_string);
             load(fullfile(files(jj).folder, files(jj).name), 'coefsS2');
             filenames(fileIndex) = { files(jj).name };
             Curvearea(fileIndex) = trapz(coefsS2);
             fileIndex = fileIndex + 1;
         end
    end
    fprintf('\n');
    T = table(Curvearea, filenames);
end

