classdef GaborScaleParameters
    %GABORSCALE Gabor parameters for differents scales
    
    properties
        effectiveWidth
        wavelength
        filterSize
    end
    
    methods
        function obj = GaborScaleParameters(effectiveWidth, wavelength, filterSize)
            %GABORSCALE Construct an instance of this class
            obj.effectiveWidth = effectiveWidth;
            obj.wavelength = wavelength;
            obj.filterSize = filterSize;
        end
    end
end

