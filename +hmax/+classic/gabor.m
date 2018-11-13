function [out] = gabor(x,y,theta,wavelength,effectiveWidth,aspectRatio)
    %GABOR Compute Gabor filters for orientation and parameters given
    %   lambda is the wavelength of the sinusoidal factor
    %   theta is the orientation
    %   sigma is the standard deviation of the Gaussian envelope
    %   gamma is the spatial aspect ratio

    [nx,ny] = size(x);
    nbOrientations = length(theta);
    x0 = zeros(nx,ny,nbOrientations);
    y0 = x0;
    for i=1:nbOrientations
        x0(:,:,i) = x .* cos(theta(i)) + y .* sin(theta(i));
        y0(:,:,i) = y .* cos(theta(i)) - x .* sin(theta(i));
    end
	out = exp( -0.5 * (x0.^2 + aspectRatio * y0.^2) / effectiveWidth^2) .* cos(2 * pi * x0 / wavelength);
end
