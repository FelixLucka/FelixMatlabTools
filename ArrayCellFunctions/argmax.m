function res = argmax(f, x)
%ARGMIN returns the index of the maximal value in a vector
%
% DETAILS:
%   argmax.m can be used to directly get the index of the maximal value and
%   is a wrapper for [~, res] = max(f)
%
% USAGE:
%   index   = argmax(f)
%   x_max   = argmax(f, x) 
%
% INPUTS:
%   f - vector of values for which the index with maximal value is searched
%
% OPTIONAL INPUTS:
%   x    - grid on which f was evaluted  
%
% OUTPUTS:
%   res - index of maximal value of f if x is not provided
%         x(index) if x is provided
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 17.04.2022
%       last update     - 17.04.2022
%
% See also

[~, res] = max(f(:));

% check user defined value for para, otherwise assign default value
if(nargin > 1)
    res = x(res);
end


end