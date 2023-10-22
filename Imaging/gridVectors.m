function grvec = gridVectors(grvec)
%GRIDVECTORS is an auxillary function turning a cell of grid vectors in
%arbitray format into the correct format for grid vectors 
%
% DETAILS: 
%   gridVectors.m turns a cell of grid vectors in arbitray format into the 
%   correct format for grid vectors, namely {[n_x, 1, 1], [1, n_y, 1],
%   [1, 1, n_z]} for 3D
%
% USAGE:
%   grvec = gridVectors(grvec)
%
% INPUTS:
%   grvec - cell of d grid vectors  
%
% OUTPUTS:
%   grvec - cell of d grid vectors in the format {[n_1, 1, ..., 1], [1,
%   n_2, 1, ..., 1], ..., [1,...,1, n_d]}
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.09.2023
%       last update     - 05.09.2023
%
% See also

dim = length(grvec);
for i=1:dim
    reshape_vec    = ones(1, dim);
    reshape_vec(i) = length(grvec{i}(:));
    grvec{i}       = reshape(grvec{i}(:), reshape_vec);
end

end