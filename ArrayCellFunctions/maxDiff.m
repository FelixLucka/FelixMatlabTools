function z = maxDiff(x, y, relativeDiff)
% MAXDIFF computes the maximal (absolute or relative) component-wise difference
%   between two inputs
% 
% DESCRIPTION: 
%   computes the maximal (absolute or relative) component-wise difference
%   (norm(x - y, 'inf') between two inputs
%
% USAGE:
%   z = maxDiff(x,y)
%   z = maxDiff(x,y, true)
%
%  INPUTS:
%   x - first numerical array
%   y - first numerical array
%
%  OPTIONAL INPUTS:
%   relativeDiff - logical indicating whether the relative difference and not the
%        absolute difference should be computed. For scalar inputs, this
%        returns abs(x - y)/max(abs(x), abs(y))
%
%  OUTPUTS:
%   z - scalar with the maximal (absolute or relative) component-wise
%       difference between x and y
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 08.07.2018
%
% See also max, abs

z = max(abs(x(:) - y(:)));

if(nargin > 2 && relativeDiff)
    z = z / max(maxAll(abs(x)), maxAll(abs(y)));
end

end