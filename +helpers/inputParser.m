function results = inputParser(path, argin)
%INPUTPARSER Get the input parser specific to the HMax function

isfolderorfile = @(x) logical(exist(x, 'file'));

parser = inputParser;
addRequired  (parser, 'Path', isfolderorfile);
addParameter (parser, 'PathType', @(x) any(validatestring(x, {'directory', 'file'})));
addParameter (parser, 'ConfigurationFile', 'defaultParameters.json', @isfile);
addParameter (parser, 'GPU', 'null', @islogical);
addParameter (parser, 'Parallel', 'null', @islogical);
addParameter (parser, 'Engine', 'null', @(x) any(validatestring(x, {'classic', 'color', 'sparseCoding', 'classicSparseCoding', 'sparseCodingColor'})));
addParameter (parser, 'ImageSize', 'null', @isinteger);
addParameter (parser, 'GaborNbOrientations', 'null', @isinteger);
addParameter (parser, 'GaborAspectRatio', 'null', @isfloat);
addParameter (parser, 'GaborEffectiveWidth', 'null', @isnumeric);
addParameter (parser, 'GaborWavelength', 'null', @isnumeric);
addParameter (parser, 'GaborSizes', 'null', @isnumeric);
addParameter (parser, 'FiltersSizes', 'null', @isnumeric);
addParameter (parser, 'MaxPoolingSizes', 'null', @isnumeric);
addParameter (parser, 'ColorNbChannels', 'null', @integer);
addParameter (parser, 'SparseCodingFilterSize', 'null', @isinteger);
addParameter (parser, 'SparseCodingNbPatches', 'null', @isinteger);
addParameter (parser, 'SparseCodingBatchSize', 'null', @isinteger);
addParameter (parser, 'SparseCodingNbIterations', 'null', @isinteger);
addParameter (parser, 'SparseCodingPenalty', 'null', @isfloat);
addParameter (parser, 'NbFilters', 'null', @isinteger);
addParameter (parser, 'Output', 'null', @isdir);
addParameter (parser, 'Train', 'null', @islogical);

parse(parser, path, argin{:});

results = parser.Results;

% Read the JSON data and replace null values
fileID = fopen(results.ConfigurationFile,'r');
data = fscanf(fileID, '%s');
p = jsondecode(data);

if ~islogical(results.GPU) && results.GPU == "null" && isfield(p.Parameters, 'GPU')
    results.GPU = p.Parameters.GPU;
elseif ~islogical(results.GPU) && results.GPU == "null"
    results.GPU = false;
end
if ~islogical(results.Parallel) && results.Parallel == "null" && isfield(p.Parameters, 'Parallel')
    results.Parallel = p.Parameters.Parallel;
elseif ~islogical(results.Parallel) && results.Parallel == "null"
    results.Parallel = false;
end
if results.Engine == "null" && isfield(p.Parameters, 'Engine')
    results.Engine = p.Parameters.Engine;
elseif results.Engine == "null"
    results.Engine = 'classic';
end
if results.ImageSize == "null" && isfield(p.Parameters, 'ImageSize')
    results.ImageSize = p.Parameters.ImageSize;
elseif results.ImageSize == "null"
    results.ImageSize = 600;
end
if results.GaborNbOrientations == "null" && isfield(p.Parameters, 'GaborNbOrientations')
    results.GaborNbOrientations = p.Parameters.GaborNbOrientations;
elseif results.GaborNbOrientations == "null"
    results.GaborNbOrientations = 4;
end
if results.GaborAspectRatio == "null" && isfield(p.Parameters, 'GaborAspectRatio')
    results.GaborAspectRatio = p.Parameters.GaborAspectRatio;
elseif results.GaborAspectRatio == "null"
    results.GaborAspectRatio = 0.3;
end
if results.GaborEffectiveWidth == "null" && isfield(p.Parameters, 'GaborEffectiveWidth')
    results.GaborEffectiveWidth = p.Parameters.GaborEffectiveWidth;
elseif results.GaborEffectiveWidth == "null"
    results.GaborEffectiveWidth = [2.8, 3.6, 4.5, 5.4, 6.3, 7.3, 8.2, 9.2, 10.2, 11.3, 12.3, 13.4, 14.6, 15.8, 17.0, 18.2];
end
if results.GaborWavelength == "null" && isfield(p.Parameters, 'GaborWavelength')
    results.GaborWavelength = p.Parameters.GaborWavelength;
elseif results.GaborWavelength == "null"
    results.GaborWavelength = [3.5, 4.6, 5.6, 6.8, 7.9, 9.1, 10.3, 11.5, 12.7, 14.1, 15.4, 16.8, 18.2, 19.7, 21.2, 22.8];
end
if results.GaborSizes == "null" && isfield(p.Parameters, 'GaborSizes')
    results.GaborSizes = p.Parameters.GaborSizes;
elseif results.GaborSizes == "null"
    results.GaborSizes = [7, 9, 11, 13, 15, 17, 19, 21, 23, 25, 27, 29, 31, 33, 35, 37];
end
if results.FiltersSizes == "null" && isfield(p.Parameters, 'FiltersSizes')
    results.FiltersSizes = p.Parameters.FiltersSizes;
elseif results.FiltersSizes == "null"
    results.FiltersSizes = [4, 8, 12, 16];
end
if results.MaxPoolingSizes == "null" && isfield(p.Parameters, 'MaxPoolingSizes')
    results.MaxPoolingSizes = p.Parameters.MaxPoolingSizes;
elseif results.MaxPoolingSizes == "null"
    results.MaxPoolingSizes = [8, 8, 10, 10, 12, 12, 14, 14, 16, 16, 18, 18, 20, 20, 22, 22];
end
if results.ColorNbChannels == "null" && isfield(p.Parameters, 'ColorNbChannels')
    results.ColorNbChannels = p.Parameters.ColorNbChannels;
elseif results.ColorNbChannels == "null"
    results.ColorNbChannels = 4;
end
if results.SparseCodingFilterSize == "null" && isfield(p.Parameters, 'SparseCodingFilterSize')
    results.SparseCodingFilterSize = p.Parameters.SparseCodingFilterSize;
elseif results.SparseCodingFilterSize == "null"
    results.SparseCodingFilterSize = 12;
end
if results.SparseCodingNbPatches == "null" && isfield(p.Parameters, 'SparseCodingNbPatches')
    results.SparseCodingNbPatches = p.Parameters.SparseCodingNbPatches;
elseif results.SparseCodingNbPatches == "null"
    results.SparseCodingNbPatches = 10000;
end
if results.SparseCodingBatchSize == "null" && isfield(p.Parameters, 'SparseCodingBatchSize')
    results.SparseCodingBatchSize = p.Parameters.SparseCodingBatchSize;
elseif results.SparseCodingBatchSize == "null"
    results.SparseCodingBatchSize = 1000;
end
if results.SparseCodingNbIterations == "null" && isfield(p.Parameters, 'SparseCodingNbIterations')
    results.SparseCodingNbIterations = p.Parameters.SparseCodingNbIterations;
elseif results.SparseCodingNbIterations == "null"
    results.SparseCodingNbIterations = 2;
end
if results.SparseCodingPenalty == "null" && isfield(p.Parameters, 'SparseCodingPenalty')
    results.SparseCodingPenalty = p.Parameters.SparseCodingPenalty;
elseif results.SparseCodingPenalty == "null"
    results.SparseCodingPenalty = 0.4;
end
if results.NbFilters == "null" && isfield(p.Parameters, 'NbFilters')
    results.NbFilters = p.Parameters.NbFilters;
elseif results.NbFilters == "null"
    results.NbFilters = 156;
end
if results.Output == "null" && isfield(p.Parameters, 'Output')
    results.Output = p.Parameters.Output;
elseif results.Output == "null"
    results.Output = './results';
end
if ~islogical(results.Train) && results.Train == "null" && isfield(p.Parameters, 'Train')
    results.Train = p.Parameters.Train;
elseif ~islogical(results.Train) && results.Train == "null"
    results.Train = false;
end

end