function y = round2Precision(x,p)
% ROUND2PRECISION rounds a number to the precision described by the precision string p.
% it uses num2str and str2double, which is not too elegant...
%
%  USAGE:
%   y = round2Precision(pi, '%.2d')
%
%  INPUT:
%   x - number to round
%   p - precision string, see num2str.m
%
%  OUTPUTS:
%   y  - rounded input
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also roundN

y = zeros(size(x), 'like', x);
for i=1:numel(x)
    % use num2str and str2double to do the rounding (not very elegant, and very slow)
    y(i) = str2double(num2str(x(i), p));
end

end