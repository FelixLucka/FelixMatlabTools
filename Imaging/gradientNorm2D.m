function fGradNorm = gradientNorm2D(f,h1, h2)
%GRADIENTNORM is wrapper for computing the norm of the gradient in one step
%
% USAGE:
%   gradientNorm2D(f, dx, dy) computes the norm of the gradient of f
%   assuming grid sizes dx and dy 
%
% INPUTS:
%   f - 2D numerical array representing function values on a regular grid
%   h1 - grid size in first dimension 
%   h2 - grid size in second dimension 
%
% OUTPUTS:
%   fGradNorm - 2D numerical array of the same size as f, containing the
%               norm of the numerical gradient in each location
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also gradient

[FX,FY]   = gradient(f, h1, h2);
fGradNorm = sqrt(FX.^2 + FY.^2);
    
end