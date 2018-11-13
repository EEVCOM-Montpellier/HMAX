classdef GaborParameters
    %GABOR Parameters for gabor filters
    
    properties
        aspectRatio
        nbOrientations
        scales
    end

    properties (Access = private)
      degreeOrientations
      radianOrientations
      nbScales
      maxFilterSize
    end
    
    methods

        function obj = GaborParameters(aspectRatio, nbOrientations, effectiveWidth, wavelength, filterSize)
            obj.aspectRatio = aspectRatio;
            obj.nbOrientations = nbOrientations;
            
            obj.nbScales = min([length(effectiveWidth), length(wavelength), length(filterSize)]);
            obj.scales = cell(1, obj.nbScales);
            
            for i = 1:obj.nbScales
                obj.scales{i} = hmax.classic.GaborScaleParameters( ...
                        effectiveWidth(i), ...
                        wavelength(i), ...
                        filterSize(i) ...
                );
            end
        end
        
        function orientations = Orientations(obj, unit)
            switch unit
                case 'degree'
                    if ~exist(obj.degreeOrientations, 'var')
                        obj.degreeOrientations = (0:obj.nbOrientations-1)*180/obj.nbOrientations;
                    end
                    orientations = obj.degreeOrientations;
                otherwise
                    if ~exist(obj.radianOrientations, 'var')
                        obj.degreeOrientations = (0:obj.nbOrientations-1)*pi/obj.nbOrientations;
                    end
                    orientations = obj.degreeOrientations;
            end
        end
        
        function nbScales = NbScales(obj)
            if ~exist('obj.nbScales', 'var')
                obj.nbScales = length(obj.scales);
            end
            nbScales = obj.nbScales;
        end
        
        function maxFilterSize = MaxFilterSize(obj)
            if ~exist('obj.maxFilterSize', 'var')
                obj.maxFilterSize = 0;
                for i = 1:obj.nbScales
                    if obj.scales{i}.filterSize > obj.maxFilterSize
                        obj.maxFilterSize = obj.scales{i}.filterSize;
                    end
                end
            end
            maxFilterSize = obj.maxFilterSize;
        end
            
    end
    
end

