function displayParameters(parameters)
%DISPLAYPARAMETERS Print parameters for the algorithm to the default
%output.
disp('Parameters:');
disp([' - Folder path: ', parameters.Path]);
disp([' - Output path: ', parameters.Output]);
disp([' - Path type: ', parameters.PathType]);
disp([' - GPU: ', helpers.log2str(parameters.GPU)]);
disp([' - Parallel: ', helpers.log2str(parameters.Parallel)]);
disp([' - Engine: ', parameters.Engine]);
disp([' - ConfigurationFile: ', parameters.ConfigurationFile]);
disp([' - ImageSize: ', int2str(parameters.ImageSize), 'px']);
disp([' - GaborNbOrientations: ', int2str(parameters.GaborNbOrientations)]);
disp([' - GaborAspectRatio: ', num2str(parameters.GaborAspectRatio)]);
disp([' - GaborEffectiveWidth: ', mat2str(parameters.GaborEffectiveWidth)]);
disp([' - GaborWavelength: ', mat2str(parameters.GaborWavelength)]);
disp([' - GaborSizes: ', mat2str(parameters.GaborSizes)]);
disp([' - MaxPoolingSizes: ', mat2str(parameters.MaxPoolingSizes)]);
disp([' - NbFilters: ', int2str(parameters.NbFilters)]);
if (parameters.Engine == "classic" || parameters.Engine == "color")
    disp([' - FiltersSizes: ', mat2str(parameters.FiltersSizes)]);
end
if (parameters.Engine == "color" || parameters.Engine == "sparseCodingColor")
    disp([' - ColorNbChannels: ', int2str(parameters.ColorNbChannels)]);
end
if (parameters.Engine == "sparseCoding" || parameters.Engine == "sparseCodingColor")
    disp([' - SparseCodingFilterSize: ', int2str(parameters.SparseCodingFilterSize)]);
    disp([' - SparseCodingNbPatches: ', int2str(parameters.SparseCodingNbPatches)]);
    disp([' - SparseCodingBatchSize: ', int2str(parameters.SparseCodingBatchSize)]);
    disp([' - SparseCodingNbIterations: ', int2str(parameters.SparseCodingNbIterations)]);
    disp([' - SparseCodingPenalty: ', num2str(parameters.SparseCodingPenalty)]);
end
end