function imWarped = warpImage(im, v, adjoint, para)
%WARPIMAGE warps an image backwards with the motion field v
%
% DETAILS: 
%   warpImage.m implements an interpolation operation related to the
%   optical flow equation u2(x + v) = u1(x), which describes that the motion 
%   v transports the intensities of image u1 to generate image u2. Given u2
%   and the motion field, we can transport the image u2 backwards: For a
%   given pixel (i,j) in 2D, we interpolate the value of u2 in (i+v1, j+v2)
%   and assign it to u2Warped(i,j). This procedure avoids having to
%   interpolate from a scatterd grid into a regular one. 
%
% USAGE:
%   imWarped = warpImage(phantom(100), 10*ones(100, 100, 2))
%
% INPUTS:
%   im - d-dim numerical array assumed in ndgrid format representing the
%        image
%   v  - (d+1)-dim numerical array represending the motion field. 
%        assumed in ndgrid format, the last dimension represents the field
%        components 
%
% OPTIONAL INPUTS:
%   adjoint - logical indicating whether the adjoint of the warping should
%             be applied (default = false);
%   para    - a struct containing further optional parameters:
%       'interpolationMethod' - see interpn.m, default: linear 
%       'X' - cell of ndgrid volumes
%       'gridVec' - grid vectors of the ndgrid. 
%
%   WARNING: warpImage.m only works with grids that are equidistantly
%   spaced in each direction (also dx might differ from dy)!!!
%
% OUTPUTS:
%   imWarped - backwards warped image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 07.12.2018
%       last update     - 07.12.2018
%
% See also

% check user defined value for para, otherwise assign default value
if(nargin < 3 || isempty(adjoint))
    adjoint = false;
else
    adjoint = checkSetInput(adjoint, [], 'logical', false);
end

% check user defined value for para, otherwise assign default value
if(nargin < 4)
    para = [];
end

% if v = 0, don't do anything
if(~any(v(:)))
    imWarped = im;
    return
end

dim    = nDims(v)-1;
sizeIm = size(v);
sizeIm = sizeIm(1:dim);
n      = prod(sizeIm);

interpolationMethod = checkSetInput(para, 'interpolationMethod', ...
    {'linear', 'nearest', 'pchip', 'cubic', 'spline', 'makima', ...
     'linearMat', 'nearestMat'}, 'linear');


% check if spatial grids are given, otherwise construct
[X, dfX] = checkSetInput(para, 'X', 'cell', 0);
if(dfX)
    clear X
    for iDim = 1:dim
        gridVec{iDim} = 1:sizeIm(iDim);
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
        
        % compute nearest neighbour index
        for iDim=1:dim
           dx        = gridVec{iDim}(2) - gridVec{iDim}(1);
           sub{iDim} = round((Xintp{iDim} - gridVec{iDim}(1)) / dx + 1);
        end
        
        if(~adjoint)
            imWarped = reshape(im(sub2ind(sizeIm, sub{:})), sizeIm);
        else
            indBlock = cell2mat(cellfun(@(x) x(:), sub, 'UniformOutput', false));
            imWarped = accumarray(indBlock, im(:), sizeIm);
        end
        
    case 'linear'
        
        imWarped = zeros(sizeIm, 'like', im);
        
        % auxillary variable
        if(adjoint)
            indBlock = zeros(n, dim);
        end
        
        % compute the closed neighbours in negative direction and distance towards them
        for iDim=1:dim
            dx        = gridVec{iDim}(2) - gridVec{iDim}(1);
            sub{iDim} = floor((Xintp{iDim} - gridVec{iDim}(1)) / dx + 1);
            l{iDim}   = Xintp{iDim} - gridVec{iDim}(sub{iDim}); 
        end
        
        % C encodes all vertices 
        C = binaryTable(dim);
        
        % compute weights
        for iC=1:size(C,1)
            subC = sub;
            weights = ones(sizeIm, 'like', im);
            for iDim=1:dim
                if(C(iC, iDim)) % vertex in positiv direction
                    weights = weights .* l{iDim};
                    subC{iDim} = min(subC{iDim} + 1, sizeIm(iDim));
                else % vertex in negative direction
                    weights    = weights .* (1-l{iDim});
                end
            end
            
            if(~adjoint)
                % transform to linear indices
                % ind = sub2ind(sizeIm, subC{:});
                ind = subC{1};
                for iDim=2:dim
                    ind = ind + (subC{iDim} - 1) * prod(sizeIm(1:iDim-1));
                end
                % add weighted image intensities
                imWarped = imWarped + weights .* im(ind);
            else
                % distribute weighted image intensities over image
                for iDim=1:dim
                   indBlock(:, iDim) = subC{iDim}(:); 
                end
                imWarped = imWarped + accumarray(indBlock, weights(:) .* im(:), sizeIm);
            end
        end
        
    otherwise
        
        if(strcmp(interpolationMethod(end-2:end), 'Mat'))
            interpolationMethod = interpolationMethod(1:end-3);
        end
        
        if(~adjoint)
            F = griddedInterpolant(X{:}, im, interpolationMethod, 'none');
            imWarped = F(Xintp{:});
        else
            notImpErr
        end
end




end