function x = vec(x)
%VEC vetorizes an input
%
% DESCRIPTION:
%       vec(x) is a function that excecutes x(:) if x is a numerical array
%       and builds one long vector of all entries in x if it is a cell
%
% USAGE:
%       x_vec = vec(x)
%
% INPUTS:
%       x - a multidimensional array of cell with multidimensional arrays
%
% OUTPUTS:
%       x  - a column vector consisting of the entries of x in the order
%            x(:) would return them 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 30.04.2017
%       last update     - 30.04.2017
%
% See also reshape

if(iscell(x))
    x = x(:);
    for i=1:numel(x)
        x{i} = vec(x{i});
    end
    x = cell2mat(x);
else
    x = x(:);
end

end