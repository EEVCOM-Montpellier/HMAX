function hmax(path, varargin)
%HMAX Run the HMax algorithm over one or several images
%   Options available: 
%      GPU:               true, false
%      Parallel:          true, false
%      Engine:            'classic', 'color', 'sparseCoding', 
%      'sparseCodingColor'
%      ConfigurationFile: Valid path to a json file. Input arguments will
%      automatically override this file.
%      Image size: Size in pixel

%% Parse parameters
if(~exist('path', 'var'))
    throw(MException('HMax:PathMissing','Path argument is missing. Usage: hmax(path, <options>)'));
elseif exist(path, 'dir')
    pathtype = 'directory';
elseif exist(path, 'file')
    pathtype = 'file';
else
    throw(MException('HMax:FileNotFound','File or directory not found'));
end
%%
argin = horzcat({'PathType', pathtype}, varargin);
parameters = helpers.inputParser(path, argin);
helpers.displayParameters(parameters);
%%

gaborParameters = hmax.classic.GaborParameters(parameters.GaborAspectRatio, parameters.GaborNbOrientations, parameters.GaborEffectiveWidth, parameters.GaborWavelength, parameters.GaborSizes);

W=ones(3, parameters.ColorNbChannels); W(2,1)=-1; W(3,1)=0; W(1,2)=2;
W(2,2)=-1; W(3,2)=-1; W(3,3)=-2; W(:,1)=W(:,1)/sqrt(2);
W(:,2)=W(:,2)/sqrt(6); W(:,3)=W(:,3)/sqrt(6); W(:,4)=W(:,4)/sqrt(3);

switch parameters.Engine
    case 'classic'
        disp('Classic')
        hlParameters = hmax.classic.HLParameters(parameters.NbFilters, parameters.FiltersSizes);
        hmaxModel = hmax.classic.HMaxModel(gaborParameters, parameters.MaxPoolingSizes);
    case 'color'
        disp('Color')
        hlParameters = hmax.classic.HLParameters(parameters.NbFilters, parameters.FiltersSizes);
        hmaxModel = hmax.color.HMaxColorModel(gaborParameters, parameters.MaxPoolingSizes, W, parameters.ColorNbChannels);
    case 'sparseCoding'
        disp('Sparse coding')
        hlParameters = hmax.sparseCoding.HLSparseCodingParameters(parameters.SparseCodingFilterSize, ...
            parameters.SparseCodingNbPatches, parameters.SparseCodingBatchSize, parameters.SparseCodingNbIterations, ...
            parameters.SparseCodingPenalty, parameters.NbFilters);
        hmaxModel = hmax.sparseCoding.HMaxSparseCodingModel(gaborParameters, parameters.MaxPoolingSizes, hlParameters);
    case 'classicSparseCoding'
        disp('Classic sparse coding')
        sparseParameters = hmax.sparseCoding.HLSparseCodingParameters(parameters.SparseCodingFilterSize, ...
            parameters.SparseCodingNbPatches, parameters.SparseCodingBatchSize, parameters.SparseCodingNbIterations, ...
            parameters.SparseCodingPenalty, parameters.NbFilters);
        hlParameters = hmax.classic.HLParameters(parameters.NbFilters, parameters.FiltersSizes);
        hmaxModel = hmax.classicSparseCoding.HMaxClassicSparseCodingModel(gaborParameters, parameters.MaxPoolingSizes, sparseParameters);
    otherwise
        disp('Sparse coding color')
        hlParameters = hmax.sparseCoding.HLSparseCodingParameters(parameters.SparseCodingFilterSize, ...
            parameters.SparseCodingNbPatches, parameters.SparseCodingBatchSize, parameters.SparseCodingNbIterations, ...
            parameters.SparseCodingPenalty, parameters.NbFilters);
        hmaxModel = hmax.sparseCodingColor.HMaxSparseCodingColorModel(gaborParameters, parameters.MaxPoolingSizes, W, parameters.ColorNbChannels, hlParameters);
end

if parameters.PathType == "directory"
    if parameters.Train
        [images, ~] = helpers.readImages(parameters.Path);
        for i = 1:length(images)
            images{i} = helpers.resizeImage(images{i}, parameters.ImageSize);
        end
        tic
        hmaxModel.train(images, hlParameters, parameters.GPU, parameters.Parallel);
        et = toc;
        disp(et);
        if ~exist(parameters.Output, "dir")
            mkdir(parameters.Output);
        end
        fid=fopen(fullfile(parameters.Output, 'training_time.txt'),'w');
        fprintf(fid, '%s', et);
        fclose(fid);
    else
        [images, paths] = helpers.readImages(parameters.Path, parameters.Output);
        for i = 1:length(images)
            images{i} = helpers.resizeImage(images{i}, parameters.ImageSize);
        end
        tic
        hmaxModel.encodeMultiples(images, parameters.GPU, parameters.Parallel, paths);
        et = toc;
        disp(et);
        fid=fopen(fullfile(parameters.Output, 'exetution_time.txt'),'w');
        fprintf(fid, '%s', et);
        fclose(fid);
    end
else
    image = helpers.resizeImage(imread(parameters.Path), parameters.ImageSize);
    [~, name, ~] = fileparts(parameters.Path);
    if parameters.Train
       hmaxModel.train({image}, hlParameters); 
    else
        tic
        hmaxModel.encode(image, parameters.GPU, name);
        toc
    end
end

disp('Done.');
end