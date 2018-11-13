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
disp( ' - Gabor: ');
disp([' - - NbOrientations: ', int2str(parameters.GaborNbOrientations)]);
disp([' - - AspectRatio: ', num2str(parameters.GaborAspectRatio)]);
disp([' - - EffectiveWidth: ', mat2str(parameters.GaborEffectiveWidth)]);
disp([' - - Wavelength: ', mat2str(parameters.GaborWavelength)]);
disp([' - - Sizes: ', mat2str(parameters.GaborSizes)]);
disp([' - FiltersSizes: ', mat2str(parameters.FiltersSizes)]);
disp([' - MaxPoolingSizes: ', mat2str(parameters.MaxPoolingSizes)]);

end