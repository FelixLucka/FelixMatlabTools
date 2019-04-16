function Apad = padArray(A, sizePad, v, side)
%MYPADARRAY is a simpler reimplementation of padarray.m
%
% DESCRIPTION:
%   padArray.m can can be used instead of padarray.m
%
% USAGE:
%   Apad = padArray(phantom(100), [14, 14], 0, 'both')
%
% INPUTS:
%   A       - 1, 2, or 3D numerical array to pad
%   sizePad - number of slices to attach in each direction
%
% OPTIONAL INPUTS:
%   v    - value of the padded columns and rows (default: 0)
%   side - 'pre', 'post' or 'both' to specify where the additional slices
%          and rows should be attached
%
% OUTPUTS:
%   Apad - padded array
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 31.10.2018
%       last update     - 18.12.2018
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

dimA  = nDims(A);
sizeA = size(A);

switch side
    case {'pre','post'}
        szApad = sizeA + sizePad;
    case 'both'
        szApad = sizeA + 2 * sizePad;
    otherwise
        error('unkown pad side, choose ''pre'', ''post'' or ''both''.')
end

Apad = v * ones(szApad, 'like', A);
switch side
    case 'pre'
        switch dimA
            case 1
                Apad((sizePad(1)+1):end) = A;
            case 2
                Apad((sizePad(1)+1):end, (sizePad(2)+1):end) = A;
            case 3
                Apad((sizePad(1)+1):end, (sizePad(2)+1):end, (sizePad(3)+1):end) = A;
            otherwise
                notImpErr
        end
    case 'post'
        switch dimA
            case 1
                Apad(1:(end-sizePad(1))) = A;
            case 2
                Apad(1:(end-sizePad(1)), 1:(end-sizePad(2))) = A;
            case 3
                Apad(1:(end-sizePad(1)), 1:(end-sizePad(2)), 1:(end-sizePad(3))) = A;
            otherwise
                notImpErr
        end
    case 'both'
        switch dimA
            case 1
                Apad((sizePad(1)+1):(end-sizePad(1))) = A;
            case 2
                Apad((sizePad(1)+1):(end-sizePad(1)), (sizePad(2)+1):(end-sizePad(2))) = A;
            case 3
                Apad((sizePad(1)+1):(end-sizePad(1)), ...
                     (sizePad(2)+1):(end-sizePad(2)), (sizePad(3)+1):(end-sizePad(3))) = A;
            otherwise
                notImpErr
        end
    otherwise
        error('unkown pad side')
end

end