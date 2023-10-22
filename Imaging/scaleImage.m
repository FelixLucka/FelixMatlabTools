function im_new = scaleImage(im, size_new, para)
%SCALEIMAGE scales an image to a new size by interpolation
%
% USAGE:
%   im_new = scaleImage([1,0;0,-1]), [3,3]) produces
%
% INPUTS:
%   im - d-dim numerical array assumed in ndgrid format representing the
%        image
%   size_new  - 1 x d integer vector of the new image size
%
% OPTIONAL INPUTS:
%   para    - a struct containing further optional parameters:
%       'interpolationMethod' - see interpn.m, default: linear
%
% OUTPUTS:
%   im_new - resized image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 28.12.2018
%       last update     - 16.05.2023
%
% See also warpImage, incImageRes


% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

% if image is in the right size, don't do anything
if(isequal(size(im), size_new))
    im_new = im;
    return
end

dim    = nDims(im);
size_im = size(im);
n      = prod(size_new);

interpolation_method = checkSetInput(para, 'interpolationMethod', ...
    {'linear', 'nearest', 'pchip', 'cubic', 'spline', 'makima', ...
    'linearMat', 'nearestMat'}, 'linear');

% construct spatial grids are given, otherwise construct

for i_dim = 1:dim
    grid_vec{i_dim}     = 1:size_im(i_dim);
    grid_vec_new{i_dim} = linspace(1,size_im(i_dim),size_new(i_dim));
end

% set up grids
arg_out_str     = '[';
arg_out_str_new = '[';
for i_dim=1:dim
    arg_out_str     = [arg_out_str 'im{' int2str(i_dim) '},'];
    arg_out_str_new = [arg_out_str_new 'im_new{' int2str(i_dim) '},'];
end
arg_out_str    = [arg_out_str(1:end-1), ']'];
arg_out_str_new = [arg_out_str_new(1:end-1), ']'];
eval([arg_out_str    ' = ndgrid(grid_vec{:});'])
eval([arg_out_str_new ' = ndgrid(grid_vec_new{:});'])


switch interpolation_method
    case 'nearest'
        
        % compute nearest neighbour index
        for i_dim=1:dim
            dx        = grid_vec{i_dim}(2) - grid_vec{i_dim}(1);
            sub{i_dim} = round((im_new{i_dim} - grid_vec{i_dim}(1)) / dx + 1);
        end
        
        im_new = reshape(im(sub2ind(size_im, sub{:})), size_new);
        
    case 'linear'
        
        im_new = zeros(size_new, 'like', im);
        
        % compute the closed neighbours in negative direction and distance towards them
        for i_dim=1:dim
            dx        = grid_vec{i_dim}(2) - grid_vec{i_dim}(1);
            sub{i_dim} = floor((XNew{i_dim} - grid_vec{i_dim}(1)) / dx + 1);
            l{i_dim}   = vec(XNew{i_dim} - grid_vec{i_dim}(sub{i_dim}));
        end
        
        % C encodes all vertices
        C = binaryTable(dim);
        
        % compute weights
        for iC=1:size(C,1)
            subC = sub;
            weights = ones(n, 1);
            for i_dim=1:dim
                if(C(iC, i_dim)) % vertex in positiv direction
                    weights = weights .* l{i_dim};
                    subC{i_dim} = subC{i_dim} + 1;
                else % vertex in negative direction
                    weights    = weights .* (1-l{i_dim});
                end
            end
            
            % find vertices with non-zeros weights
            nzW = weights > 0;
            for i_dim=1:dim
                subC{i_dim} = subC{i_dim}(nzW);
            end
            ind = sub2ind(size_im, subC{:});
            
            % add weighted image intensities
            im_new(nzW) = im_new(nzW) + weights(nzW) .* im(ind);
        end
        
    otherwise
        
        if(strcmp(interpolation_method(end-2:end), 'Mat'))
            interpolation_method = interpolation_method(1:end-3);
        end
        
        F = griddedInterpolant(X{:}, im, interpolation_method, 'none');
        im_new = F(XNew{:});
end




end