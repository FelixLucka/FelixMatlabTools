function step = stepFunction(x_grid, x_steps, sigma)
%STEPFUNCTION creates a step function in a given grid with optional
%Gaussian smoothing
%
% DETAILS: 
%   stepFunction.m can be used to create a function that alternates between
%   0 and 1 at given points. The transition can be smoothed with a Gaussian
%   window
%
% USAGE:
%   plot the following results to understand what the function is doing:
%   window = stepFunction(linspace(0,1,100), 0.5)
%   window = stepFunction(linspace(0,1,100), [0.25, 0.75], 0.02)
%
% INPUTS:
%   x_grid - grid vector (needs to be strictly monotonically increasing but
%   does not need to be equidistantly spaced
%   x_steps - vector of x positions at which the function switches between
%   0 and 1
%
% OPTIONAL INPUTS:
%   sigma - standard variation of the Gaussian used to smooth the transition 
%           (default = 0, no smoothing) 
%
% OUTPUTS:
%   step - step function evaluated on x_grid
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 17.12.2021
%       last update     - 17.12.2021
%
% See also

% check user defined value for x_steps, otherwise assign default value
if(nargin < 2)
    x_steps = mean(x_grid);
end

% check user defined value for x_steps, otherwise assign default value
if(nargin < 3)
    sigma = 0;
end

% construct binary function
value = false;
step  = double(value) * ones(size(x_grid));
for i=1:length(x_steps)
    value = not(value);
    step(x_grid >= x_steps(i)) = double(value);
end

% smooth with Gaussian
if(sigma)
    dx     = x_grid(2) - x_grid(1);
    kernel = gaussianKernel(1, sigma / dx, 4);
    step   = conv(step, kernel, 'same');
    step   = max(0, min(1, step));
end

end