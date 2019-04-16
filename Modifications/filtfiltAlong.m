function x = filtfiltAlong(b, a, x, dim)
% FILTFILTALONG is a wrapper for filtfilt.m which only operates along the 
% first nonsingleton dimension of an input array
%
%  xFiltered = filtfiltAlong(b,a,x,3)
%
%  INPUTS:
%   b,a,x - see filtfilt.m
%   dim   - dimension of x along which to filter
%
%
%  OUTPUTS:
%   x       - filtered data
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also filtfilt

% we simply permute the dimensions of x such that the desired dimension is
% the first one and apply filtfilt
dimensionPermutation      = 1:ndims(x);
dimensionPermutation(dim) = 1;
dimensionPermutation(1)   = dim;
x = permute(filtfilt(b, a, permute(x,dimensionPermutation)), dimensionPermutation);

end