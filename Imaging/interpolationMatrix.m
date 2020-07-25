function I = interpolationMatrix(gridVec, Xq, para)
%INTERPOLATIONMATRIX sets up a sparse matrix to interpolate from a regular grid 
% to a set of query points
%
% DETAILS:
%   ToDo
%
% USAGE:
%   I = interpolationMatrix(gridVec, Xq, para)
%
% INPUTS:
%   gridVec  - cell of grid vectors
%   Xq       - n x dim array of query points
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'interpolationMethod' - see 'nearest' or 'linear'
%       'tol'                 - numerical tolerance below which weights are
%       set to 0
%
%   WARNING: interpolationMatrix.m only works with grids that are equidistantly
%   spaced in each direction (although dx might differ from dy)!!!
%
% OUTPUTS:
%   I - sparse matrix that maps a function defined on the regular grid x 
%       to the set of query points via reshape(I * x(:), size(x))
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 10.11.2019
%       last update     - 10.11.2019
%
% See also ndgrid

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

dim    = length(gridVec);
sizeIm = cellfun(@length, gridVec);
m      = prod(sizeIm);
n      = size(Xq, 1);


interpolationMethod = checkSetInput(para, 'interpolationMethod', ...
    {'linear', 'nearest'}, 'linear');
tol              = checkSetInput(para, 'tol', '>0', 0);

% check that all query points lie within the grid
for iDim=1:dim
    if(min(Xq(:,iDim)) < gridVec{iDim}(1) || max(Xq(:,iDim)) > gridVec{iDim}(end))
        error('query points Xq lie outside of defined grid X')
    end
end


switch interpolationMethod
    case 'nearest'
        for iDim=1:dim
            dx        = gridVec{iDim}(2) - gridVec{iDim}(1);
            ind{iDim} = round((Xq(:,iDim) - gridVec{iDim}(1)) / dx + 1);
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
            sub{iDim} = floor((Xq(:,iDim) - gridVec{iDim}(1)) / dx + 1);
            l{iDim}   = (Xq(:,iDim) - gridVec{iDim}(sub{iDim})) / dx;
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

% set small weights to 0
if(tol)
    keep = abs(wVal) > tol;
    iInd = iInd(keep);
    jInd = jInd(keep);
    wVal = wVal(keep);
end

I = sparse(iInd, jInd, wVal, n, m);

end