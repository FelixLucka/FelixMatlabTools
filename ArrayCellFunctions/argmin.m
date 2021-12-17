function res = argmin(f, x)
%ARGMIN returns the index of the minimal value in a vector
%
% DETAILS:
%   argmin.m can be used to directly get the index of the minimal value and
%   is a wrapper for [~, res] = min(f)
%
% USAGE:
%   index   = argmin(f)
%   x_min   = argmin(f, x) 
%
% INPUTS:
%   f - vector of values for which the index with minimal value is searched
%
% OPTIONAL INPUTS:
%   x    - grid on which f was evaluted  
%
% OUTPUTS:
%   res - index of minimal value of f if x is not provided
%         x(index) if x is provided
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 10.11.2020
%       last update     - 10.11.2020
%
% See also

[~, res] = min(f(:));

% check user defined value for para, otherwise assign default value
if(nargin > 1)
    res = x(res);
end


end