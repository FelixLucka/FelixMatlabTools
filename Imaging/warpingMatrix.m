function W = warpingMatrix(v, para)
%WARPINGMATRIX sets up a sparse matrix to warp an image wrt a flow field
%
% DETAILS:
%   ToDo
%
% USAGE:
%   W = warpingMatrix(v, para)
%
% INPUTS:
%   v - 1D, 2D or 3D flow field
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'interpolationMethod' - see interpn.m, default: linear
%       'X' - cell of ndgrid volumes
%       'gridVec' - grid vectors of the ndgrid.
%
%   WARNING: warpingMatrix.m only works with grids that are equidistantly
%   spaced in each direction (also dx might differ from dy)!!!
%
% OUTPUTS:
%   W - sparse matrix that can warp an image x via reshape(W * x(:),
%       size(x))
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 18.12.2018
%       last update     - 22.05.2019
%
% See also warpImage

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

if(isvector(v))
    dim = 1;
else
    dim    = nDims(v)-1;
end

sizeIm = size(v);
sizeIm = sizeIm(1:dim);
n      = prod(sizeIm);

interpolationMethod = checkSetInput(para, 'interpolationMethod', ...
    {'linear', 'nearest', 'pchip', 'cubic', 'spline', 'makima'}, 'linear');

% check if spatial grids are given, otherwise construct
[X, dfX] = checkSetInput(para, 'X', 'cell', 0);
if(dfX)
    clear X
    for iDim = 1:dim
        gridVec{iDim} = (1:sizeIm(iDim))';
    end
    gridVec = checkSetInput(para, 'gridVec', 'cell', gridVec);
    
    % set up grids
    argOutStr = '[';
    for iDim=1:dim
        argOutStr = [argOutStr 'X{' int2str(iDim) '},'];
    end
    argOutStr = [argOutStr(1:end-1), ']'];
    eval([argOutStr ' = ndgrid(gridVec{:});'])
else
    [gridVec, dfg] = checkSetInput(para, 'gridVec', 'cell', 0);
    if(dfg)
        clear gridVec
        % extract grid vectors
        for iDim = 1:dim
            gridVec{iDim} = X{iDim};
            for jDim = 1:dim
                if(jDim ~= iDim)
                    gridVec{iDim} = sliceArray(gridVec{iDim}, jDim, 1, false);
                end
            end
            gridVec{iDim} = vec(gridVec{iDim})';
        end
    end
end

% take care of nan values in V
isnanV    = isnan(v);
v(isnanV) = 0;

% compute propagated points and restrict to grid
Xq = zeros(n, dim, 'like', v);

for iDim=1:dim
    Xintp       = X{iDim} + sliceArray(v, dim+1, iDim, true);
    Xintp       = max(Xintp, gridVec{iDim}(1));
    Xintp       = min(Xintp, gridVec{iDim}(end));
    Xq(:, iDim) = Xintp(:); 
end

intPara = [];
intPara.interpolationMethod = interpolationMethod;
% call interpolationMatrix.m
W = interpolationMatrix(gridVec, Xq, intPara);

end