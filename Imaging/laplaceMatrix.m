function L = laplaceMatrix(dim_X, BC)
%LAPLACEMATRIX computes the matrix representation of the laplacian operator
% 
% DESCRIPTION:
%   laplaceMatrix.m computes the finite difference discretization of the
%   laplacian  on a spatial grid with unit grid size and given spatial dimensions
%   boundary conditions.
%
% USAGE:
%   L = laplaceMatrix([256,256], 'NB')
%  Describtion: https://en.wikipedia.org/wiki/Kronecker_sum_of_discrete_Laplacians
%
%  INPUTS:
%   dim_X - array with the size the numerical array x to which it should be applied
%   BC   - boundary conditions, '0' or 'NB'
%
%  OUTPUTS:
%   L - Laplace operator as sparse matrix 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 05.09.2023
%
% See also kron


for i_dim = 1:length(dim_X)
    ones_vec  = ones(dim_X(i_dim),1);
    Dx{i_dim} = spdiags([-ones_vec,2*ones_vec,-ones_vec], [-1 0 1], dim_X(i_dim),dim_X(i_dim));
    switch BC
        case '0'
            % nothing to be corrected
        case 'NB'
            Dx{i_dim}(1,1) = 1;
            Dx{i_dim}(end,end) = 1;
        otherwise
            notImpErr
    end
    I{i_dim} = speye(dim_X(i_dim));
end
    
% L can be constructed by tensor products of the single dim laplacians 
switch length(dim_X)
    case 1
        L = Dx{1};
    case 2
        L =     kron(I{2},Dx{1});
        L = L + kron(Dx{2},I{1});
    case 3
        L =     kron(I{3}, kron(I{2}, Dx{1}));
        L = L + kron(I{3}, kron(Dx{2}, I{1}));
        L = L + kron(kron(Dx{3},I{2}),I{1});
    otherwise
        notImpErr
end

end