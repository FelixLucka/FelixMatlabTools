function x = filtfiltAlong(b, a, x, dim)
% FILTFILTALONG is a wrapper for filtfilt.m which only operates along the 
% first nonsingleton dimension of an input array
%
%  x_filtered = filtfiltAlong(b,a,x,3)
%
%  INPUTS:
%   b, a, x - see filtfilt.m
%   dim     - dimension of x along which to filter
%
%
%  OUTPUTS:
%   x       - filtered data
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 16.05.2023
%
% See also filtfilt

% we simply permute the dimensions of x such that the desired dimension is
% the first one and apply filtfilt
dimension_permutation      = 1:ndims(x);
dimension_permutation(dim) = 1;
dimension_permutation(1)   = dim;
x = permute(filtfilt(b, a, permute(x,dimension_permutation)), dimension_permutation);

end