function T = loadC2sUnlabeled(directory)
%LOADC2S Summary of this function goes here
    allFiles = dir(fullfile(directory, '**/*.mat'));
    countFiles = size(allFiles, 1);
    filenames = cell(countFiles, 1);
    fileIndex = 1;
    curdirs = dir(directory);
    curdirs = curdirs(~ismember({curdirs.name},{'.','..', 'execution_time.txt', 'training_time.txt'}));
    files = curdirs(~[curdirs.isdir]);
    len_str = 0;
    load(fullfile(files(1).folder, files(1).name), 'C2');
    try
        nbFeatures = length(C2{1});
        nbFeatures = nbFeatures * length(C2);
    catch
        nbFeatures = length(C2);
    end
    C2s = zeros(countFiles, nbFeatures);
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
             load(fullfile(files(jj).folder, files(jj).name), 'C2');
             filenames(fileIndex) = { files(jj).name };
             try
                 size(C2{1});
                 [~, nbChan] = size(C2);
                 tmp = [];
                 for kk = 1:nbChan
                     tmp = [tmp, C2{1,kk}];
                 end
                 C2s(fileIndex,:) = tmp; 
             catch 
                C2s(fileIndex,:) = C2;
             end
             fileIndex = fileIndex + 1;
         end
    end
    fprintf('\n');
    T = table(C2s, filenames);
end

