function A_pad = padArray(A, sz_pad, v, side)
%MYPADARRAY is a simpler reimplementation of padarray.m
%
% DESCRIPTION:
%   padArray.m can can be used instead of padarray.m
%
% USAGE:
%   A_pad = padArray(phantom(100), [14, 14], 0, 'both')
%
% INPUTS:
%   A       - 1, 2, or 3D numerical array to pad
%   sz_pad - number of slices to attach in each direction
%
% OPTIONAL INPUTS:
%   v    - value of the padded columns and rows (default: 0)
%   side - 'pre', 'post' or 'both' to specify where the additional slices
%          and rows should be attached
%
% OUTPUTS:
%   A_pad - padded array
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 31.10.2018
%       last update     - 24.09.2023
%
% See also cutArray

% check user defined value for v, otherwise assign default value
if(nargin < 3)
    v = zeros(1,1, 'like', A);
end

% check user defined value for side, otherwise assign default value
if(nargin < 4)
    side = 'both';
end

dim_A = nDims(A);
sz_A  = size(A);

switch side
    case {'pre','post'}
        sz_A_pad = sz_A + sz_pad;
    case 'both'
        sz_A_pad = sz_A + 2 * sz_pad;
    otherwise
        error('unkown pad side, choose ''pre'', ''post'' or ''both''.')
end

A_pad = v * ones(sz_A_pad, 'like', A);
switch side
    case 'pre'
        switch dim_A
            case 1
                A_pad((sz_pad(1)+1):end) = A;
            case 2
                A_pad((sz_pad(1)+1):end, (sz_pad(2)+1):end) = A;
            case 3
                A_pad((sz_pad(1)+1):end, (sz_pad(2)+1):end, (sz_pad(3)+1):end) = A;
            otherwise
                notImpErr
        end
    case 'post'
        switch dim_A
            case 1
                A_pad(1:(end-sz_pad(1))) = A;
            case 2
                A_pad(1:(end-sz_pad(1)), 1:(end-sz_pad(2))) = A;
            case 3
                A_pad(1:(end-sz_pad(1)), 1:(end-sz_pad(2)), 1:(end-sz_pad(3))) = A;
            otherwise
                notImpErr
        end
    case 'both'
        switch dim_A
            case 1
                A_pad((sz_pad(1)+1):(end-sz_pad(1))) = A;
            case 2
                A_pad((sz_pad(1)+1):(end-sz_pad(1)), (sz_pad(2)+1):(end-sz_pad(2))) = A;
            case 3
                A_pad((sz_pad(1)+1):(end-sz_pad(1)), ...
                     (sz_pad(2)+1):(end-sz_pad(2)), (sz_pad(3)+1):(end-sz_pad(3))) = A;
            otherwise
                notImpErr
        end
    otherwise
        error('unkown pad side')
end

end