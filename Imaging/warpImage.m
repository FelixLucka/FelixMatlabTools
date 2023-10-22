function im_warped = warpImage(im, v, adjoint, para)
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
%   im_warped = warpImage(phantom(100), 10*ones(100, 100, 2))
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
%   im_warped - backwards warped image
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 07.12.2018
%       last update     - 16.05.2023
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
    im_warped = im;
    return
end

dim    = nDims(v)-1;
sz_im = size(v);
sz_im = sz_im(1:dim);
n      = prod(sz_im);

interpolation_method = checkSetInput(para, 'interpolationMethod', ...
    {'linear', 'nearest', 'pchip', 'cubic', 'spline', 'makima', ...
     'linearMat', 'nearestMat'}, 'linear');


% check if spatial grids are given, otherwise construct
[X, df_X] = checkSetInput(para, 'X', 'cell', 0);
if(df_X)
    clear X
    for i_dim = 1:dim
        grid_vec{i_dim} = 1:sz_im(i_dim);
    end
    grid_vec = checkSetInput(para, 'gridVec', 'cell', grid_vec);
    
    % set up grids
    arg_out_str = '[';
    for i_dim=1:dim
        arg_out_str = [arg_out_str 'X{' int2str(i_dim) '},'];
    end
    arg_out_str = [arg_out_str(1:end-1), ']'];
    eval([arg_out_str ' = ndgrid(grid_vec{:});'])
else
    [grid_vec, df_g] = checkSetInput(para, 'gridVec', 'cell', 0);
    if(df_g)
        clear grid_vec
        % extract grid vectors
        for i_dim = 1:dim
            grid_vec{i_dim} = X{i_dim};
            for j_dim = 1:dim
                if(j_dim ~= i_dim)
                    grid_vec{i_dim} = sliceArray(grid_vec{i_dim}, j_dim, 1, false);
                end
            end
            grid_vec{i_dim} = vec(grid_vec{i_dim})';
        end
    end
end

% take care of nan values in V
is_nan_v    = isnan(v);
v(is_nan_v) = 0;

% compute propagated points and restrict to grid
for i_dim=1:dim
    X_intp{i_dim} = X{i_dim} + sliceArray(v, dim+1, i_dim, true);
    X_intp{i_dim} = max(X_intp{i_dim}, grid_vec{i_dim}(1));
    X_intp{i_dim} = min(X_intp{i_dim}, grid_vec{i_dim}(end));
end


switch interpolation_method
    case 'nearest'
        
        % compute nearest neighbour index
        for i_dim=1:dim
           dx        = grid_vec{i_dim}(2) - grid_vec{i_dim}(1);
           sub{i_dim} = round((X_intp{i_dim} - grid_vec{i_dim}(1)) / dx + 1);
        end
        
        if(~adjoint)
            im_warped = reshape(im(sub2ind(sz_im, sub{:})), sz_im);
        else
            ind_block = cell2mat(cellfun(@(x) x(:), sub, 'UniformOutput', false));
            im_warped = accumarray(ind_block, im(:), sz_im);
        end
        
    case 'linear'
        
        im_warped = zeros(sz_im, 'like', im);
        
        % auxillary variable
        if(adjoint)
            ind_block = zeros(n, dim);
        end
        
        % compute the closed neighbours in negative direction and distance towards them
        for i_dim=1:dim
            dx        = grid_vec{i_dim}(2) - grid_vec{i_dim}(1);
            sub{i_dim} = floor((X_intp{i_dim} - grid_vec{i_dim}(1)) / dx + 1);
            l{i_dim}   = X_intp{i_dim} - grid_vec{i_dim}(sub{i_dim}); 
        end
        
        % C encodes all vertices 
        C = binaryTable(dim);
        
        % compute weights
        for i_C=1:size(C,1)
            sub_C = sub;
            weights = ones(sz_im, 'like', im);
            for i_dim=1:dim
                if(C(i_C, i_dim)) % vertex in positiv direction
                    weights = weights .* l{i_dim};
                    sub_C{i_dim} = min(sub_C{i_dim} + 1, sz_im(i_dim));
                else % vertex in negative direction
                    weights    = weights .* (1-l{i_dim});
                end
            end
            
            if(~adjoint)
                % transform to linear indices
                % ind = sub2ind(sizeIm, subC{:});
                ind = sub_C{1};
                for i_dim=2:dim
                    ind = ind + (sub_C{i_dim} - 1) * prod(sz_im(1:i_dim-1));
                end
                % add weighted image intensities
                im_warped = im_warped + weights .* im(ind);
            else
                % distribute weighted image intensities over image
                for i_dim=1:dim
                   ind_block(:, i_dim) = sub_C{i_dim}(:); 
                end
                im_warped = im_warped + accumarray(ind_block, weights(:) .* im(:), sz_im);
            end
        end
        
    otherwise
        
        if(strcmp(interpolation_method(end-2:end), 'Mat'))
            interpolation_method = interpolation_method(1:end-3);
        end
        
        if(~adjoint)
            F = griddedInterpolant(X{:}, im, interpolation_method, 'none');
            im_warped = F(X_intp{:});
        else
            notImpErr
        end
end




end