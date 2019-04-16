function imNew = scaleImage(im, sizeNew, para)
%SCALEIMAGE scales an image to a new size by interpolation
%
% USAGE:
%   imNew = scaleImage([1,0;0,-1]), [3,3]) produces
%
% INPUTS:
%   im - d-dim numerical array assumed in ndgrid format representing the
%        image
%   sizeNew  - 1 x d integer vector of the new image size
%
% OPTIONAL INPUTS:
%   para    - a struct containing further optional parameters:
%       'interpolationMethod' - see interpn.m, default: linear
%
% OUTPUTS:
%   imNew - resized image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 28.12.2018
%       last update     - 28.12.2018
%
% See also warpImage, incImageRes


% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

% if image is in the right size, don't do anything
if(isequal(size(im), sizeNew))
    imNew = im;
    return
end

dim    = nDims(im);
sizeIm = size(im);
n      = prod(sizeNew);

interpolationMethod = checkSetInput(para, 'interpolationMethod', ...
    {'linear', 'nearest', 'pchip', 'cubic', 'spline', 'makima', ...
    'linearMat', 'nearestMat'}, 'linear');

% construct spatial grids are given, otherwise construct

for iDim = 1:dim
    gridVec{iDim}    = 1:sizeIm(iDim);
    gridVecNew{iDim} = linspace(1,sizeIm(iDim),sizeNew(iDim));
end

% set up grids
argOutStr    = '[';
argOutStrNew = '[';
for iDim=1:dim
    argOutStr    = [argOutStr 'X{' int2str(iDim) '},'];
    argOutStrNew = [argOutStrNew 'XNew{' int2str(iDim) '},'];
end
argOutStr    = [argOutStr(1:end-1), ']'];
argOutStrNew = [argOutStrNew(1:end-1), ']'];
eval([argOutStr    ' = ndgrid(gridVec{:});'])
eval([argOutStrNew ' = ndgrid(gridVecNew{:});'])


switch interpolationMethod
    case 'nearest'
        
        % compute nearest neighbour index
        for iDim=1:dim
            dx        = gridVec{iDim}(2) - gridVec{iDim}(1);
            sub{iDim} = round((XNew{iDim} - gridVec{iDim}(1)) / dx + 1);
        end
        
        imNew = reshape(im(sub2ind(sizeIm, sub{:})), sizeNew);
        
    case 'linear'
        
        imNew = zeros(sizeNew, 'like', im);
        
        % compute the closed neighbours in negative direction and distance towards them
        for iDim=1:dim
            dx        = gridVec{iDim}(2) - gridVec{iDim}(1);
            sub{iDim} = floor((XNew{iDim} - gridVec{iDim}(1)) / dx + 1);
            l{iDim}   = vec(XNew{iDim} - gridVec{iDim}(sub{iDim}));
        end
        
        % C encodes all vertices
        C = binaryTable(dim);
        
        % compute weights
        for iC=1:size(C,1)
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
            ind = sub2ind(sizeIm, subC{:});
            
            % add weighted image intensities
            imNew(nzW) = imNew(nzW) + weights(nzW) .* im(ind);
        end
        
    otherwise
        
        if(strcmp(interpolationMethod(end-2:end), 'Mat'))
            interpolationMethod = interpolationMethod(1:end-3);
        end
        
        F = griddedInterpolant(X{:}, im, interpolationMethod, 'none');
        imNew = F(XNew{:});
end




end