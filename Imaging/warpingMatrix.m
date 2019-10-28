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
for iDim=1:dim
    Xintp{iDim} = X{iDim} + sliceArray(v, dim+1, iDim, true);
    Xintp{iDim} = max(Xintp{iDim}, gridVec{iDim}(1));
    Xintp{iDim} = min(Xintp{iDim}, gridVec{iDim}(end));
end

switch interpolationMethod
    case 'nearest'
        for iDim=1:dim
            dx        = gridVec{iDim}(2) - gridVec{iDim}(1);
            ind{iDim} = round((Xintp{iDim} - gridVec{iDim}(1)) / dx + 1);
        end
        if(dim > 1)
            jInd = vec(sub2ind(sizeIm, ind{:}));
        else
            jInd = ind{:};
        end
        iInd = (1:n)';
        wVal = ones(n,1);
    case 'linear'
        
        % compute the closed neighbours in negative direction and distance towards them
        for iDim=1:dim
            dx        = gridVec{iDim}(2)   - gridVec{iDim}(1);
            sub{iDim} = floor((Xintp{iDim} - gridVec{iDim}(1)) / dx + 1);
            l{iDim}   = vec(Xintp{iDim} - gridVec{iDim}(sub{iDim}));
        end
        
        % C encodes all vertices
        C  = binaryTable(dim);
        nC = size(C,1);
        
        iInd = [];
        jInd = [];
        wVal = [];
        
        % compute weights
        for iC=1:nC
            subC = sub;
            weights = ones(n, 1);
            for iDim=1:dim
                if(C(iC, iDim)) % vertex in positiv direction
                    weights = weights .* l{iDim};
                    subC{iDim} = subC{iDim} + 1;
                else % vertex in negative direction
                    weights    = weights .* (1-l{iDim});
                end
            end
            
            % find vertices with non-zeros weights
            nzW = weights > 0;
            for iDim=1:dim
                subC{iDim} = subC{iDim}(nzW);
            end
            if(dim > 1)
                ind = sub2ind(sizeIm, subC{:});
            else
                ind =  subC{:};
            end
            
            iInd = [iInd; find(nzW)];
            jInd = [jInd; ind];
            wVal = [wVal; weights(nzW)];
        end
        
    otherwise
        notImpErr
end

W = sparse(iInd, jInd, wVal, n, n);

end