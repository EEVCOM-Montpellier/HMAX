function [images, paths] = readImages(readdir, writedir)
%READDIRECTORY Read reccursively images from a folder and copy the
%structure in writedir
    images = {};
    paths = {};
    curdirs = dir(readdir);
    curdirs = curdirs(~ismember({curdirs.name},{'.','..'}));
    for ii = 1:length(curdirs)
        if curdirs(ii).isdir
            [tmpimages, tmppaths] = helpers.readImages(fullfile(readdir, curdirs(ii).name), fullfile(writedir, curdirs(ii).name));
            images = [images, tmpimages];
            paths = [paths, tmppaths];
        else
            fullpath = fullfile(curdirs(ii).folder, curdirs(ii).name);
            try
                image = imread(fullpath);
                if ~exist(writedir, 'dir')
                    mkdir(writedir);
                end
                tmppath = fullfile(writedir, curdirs(ii).name);
                [filepath, name, ~] = fileparts(tmppath);
                savepath = [fullfile(filepath, name), '.mat'];
                images = [images, image];
                paths = [paths, savepath];
            catch
            end
        end
    end
end