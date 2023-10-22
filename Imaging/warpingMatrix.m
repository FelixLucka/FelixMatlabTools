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
%       last update     - 16.05.2023
%
% See also warpImage, interpolationMatrix

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

if(isvector(v))
    dim = 1;
else
    dim    = nDims(v)-1;
end

size_im = size(v);
size_im = size_im(1:dim);
n       = prod(size_im);

interpolation_method = checkSetInput(para, 'interpolationMethod', ...
    {'linear', 'nearest', 'pchip', 'cubic', 'spline', 'makima'}, 'linear');

% check if spatial grids are given, otherwise construct
[X, df_X] = checkSetInput(para, 'X', 'cell', 0);
if(df_X)
    clear X
    for i_dim = 1:dim
        grid_vec{i_dim} = (1:size_im(i_dim))';
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
    [grid_vec, dfg] = checkSetInput(para, 'gridVec', 'cell', 0);
    if(dfg)
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
X_q = zeros(n, dim, 'like', v);

for i_dim=1:dim
    X_intp       = X{i_dim} + sliceArray(v, dim+1, i_dim, true);
    X_intp       = max(X_intp, grid_vec{i_dim}(1));
    X_intp       = min(X_intp, grid_vec{i_dim}(end));
    X_q(:, i_dim) = X_intp(:); 
end

int_para = [];
int_para.interpolationMethod = interpolation_method;
% call interpolationMatrix.m
W = interpolationMatrix(grid_vec, X_q, int_para);

end