function I = interpolationMatrix(grid_vec, X_q, para)
%INTERPOLATIONMATRIX sets up a sparse matrix to interpolate from a regular grid 
% to a set of query points
%
% DETAILS:
%   ToDo
%
% USAGE:
%   I = interpolationMatrix(grid_vec, X_q, para)
%
% INPUTS:
%   grid_vec - cell of grid vectors
%   X_q      - n x dim array of query points
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'interpolationMethod' - see 'nearest' or 'linear'
%       'tol'                 - numerical tolerance below which weights are
%       set to 0
%
%   WARNING: interpolationMatrix.m only works with grids that are equidistantly
%   spaced in each direction (although dx might differ from dy/dz)!!!
%
% OUTPUTS:
%   I - sparse matrix that maps a function defined on the regular grid x 
%       to the set of query points via reshape(I * x(:), size(x))
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 10.11.2019
%       last update     - 05.09.2023
%
% See also ndgrid

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

% get sizes and dimensions
dim     = length(grid_vec);
size_im = cellfun(@length, grid_vec);
m       = prod(size_im);
n       = size(X_q, 1);


interpolation_method = checkSetInput(para, 'interpolationMethod', ...
                                    {'linear', 'nearest'}, 'linear');
tol                  = checkSetInput(para, 'tol', '>0', 0);

% check that all query points lie within the grid
for i_dim=1:dim
    if(min(X_q(:,i_dim)) < grid_vec{i_dim}(1) || max(X_q(:,i_dim)) > grid_vec{i_dim}(end))
        error('query points Xq lie outside of defined grid X')
    end
end


switch interpolation_method

    %%% nearest neighbour interpolation
    case 'nearest'
        for i_dim=1:dim
            dx        = grid_vec{i_dim}(2) - grid_vec{i_dim}(1);
            ind{i_dim} = round((X_q(:,i_dim) - grid_vec{i_dim}(1)) / dx + 1);
        end
        if(dim > 1)
            j_ind = vec(sub2ind(size_im, ind{:}));
        else
            j_ind = ind{:};
        end
        i_ind = (1:n)';
        w_val = ones(n,1);

    %%% linear interpolation
    case 'linear'
        
        % compute the closed neighbours in negative direction and distance towards them
        for i_dim=1:dim
            dx        = grid_vec{i_dim}(2)   - grid_vec{i_dim}(1);
            sub{i_dim} = floor((X_q(:,i_dim) - grid_vec{i_dim}(1)) / dx + 1);
            l{i_dim}   = (X_q(:,i_dim) - grid_vec{i_dim}(sub{i_dim})) / dx;
        end
        
        % C encodes all vertices
        C   = binaryTable(dim);
        n_C = size(C,1);
        
        i_ind = [];
        j_ind = [];
        w_val = [];
        
        % compute weights
        for iC=1:n_C
            sub_C   = sub;
            weights = ones(n, 1);
            for i_dim=1:dim
                if(C(iC, i_dim)) % vertex in positiv direction
                    weights = weights .* l{i_dim};
                    sub_C{i_dim} = sub_C{i_dim} + 1;
                else % vertex in negative direction
                    weights    = weights .* (1-l{i_dim});
                end
            end
            
            % find vertices with non-zeros weights
            nzW = weights > 0;
            for i_dim=1:dim
                sub_C{i_dim} = sub_C{i_dim}(nzW);
            end
            if(dim > 1)
                ind = sub2ind(size_im, sub_C{:});
            else
                ind =  sub_C{:};
            end
            
            i_ind = [i_ind; find(nzW)];
            j_ind = [j_ind; ind];
            w_val = [w_val; weights(nzW)];
        end
        
    otherwise
        notImpErr
end

% set small weights to 0
if(tol)
    keep = abs(w_val) > tol;
    i_ind = i_ind(keep);
    j_ind = j_ind(keep);
    w_val = w_val(keep);
end

I = sparse(i_ind, j_ind, w_val, n, m);

end