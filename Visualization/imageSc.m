function res = imageSc(x, varargin)
%IMAGESC is a wrapper for Matlab's imagesc.m that squeezes the input
%
% USAGE:
%  imageSc(x, ...)
%
% INPUTS:
%   see imagesc.m
%
% OPTIONAL INPUTS:
%   see imagesc.m
%
% OUTPUTS:
%   see imagesc.m
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 22.11.2019
%       last update     - 22.11.2019
%
% See also see imagesc

res = imagesc(squeeze(x), varargin{:});

end