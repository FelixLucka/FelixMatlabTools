function f = cutNormalize1DFilter(f, delta)
%CUTNORMALIZE1DFILTER NORMALIZES A FILTER AND CROPS AWAY SMALL LEADING AND
%TAILING ENTRIES
%
% DETAILS: 
%   cutNormalize1DFilter.m can be used to normalize a filter to L2 norm 1
%   and crop it from leading and trailing parts that don't contribute 
%
% USAGE:
%   gaussian_normalized_cropped = cutNormalize1DFilter(exp(-linspace(-10,10,1000).^2)/2, 10^-3)
%
% INPUTS:
%   f     - filter as a vector
%   delta - threshold in terms of l2 norm fraction before and after which
%   the filter is cut
%
% OUTPUTS:
%   x - bla bla
%
% ABOUT:
%       author          - Felix Lucka
%       date            - ??.??.2023
%       last update     - 29.09.2023
%
% See also

f          = f / sqrt(sum(f.^2));
ind1       = find(sqrt(cumsum(f.^2)) >   delta, 1, 'first');
ind2       = length(f) - find(sqrt(cumsum(flip(f).^2)) >   delta, 1, 'first') + 1;
f          = f(ind1:ind2);

end