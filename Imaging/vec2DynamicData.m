function cell_data = vec2DynamicData(X, size_data)
% VEC2DYNAMICDATA reshapes dynamic data given as a vector into a cell array
%
% USAGE:
%  f_cell  = vec2DynamicData(f_vec, size_f_vec)
%
%  INPUT:
%   X - dynamic data as a vector 
%   size_data - sizes of the single frame data
%
%  OUTPUTS:
%   cell_data - the data as a cell array, each cell corresponds to the data
%              of a single frame
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 16.05.2023
%
% See also dynamicData2Vec

cell_data       = cell(1, length(size_data));
data_start_index = 1;

for i=1:length(cell_data)
    length_this_data = prod(size_data{i});
    cell_data{i}     = X(data_start_index:(data_start_index + length_this_data - 1));
    data_start_index = data_start_index + length_this_data;
    cell_data{i}     = reshape(cell_data{i}, size_data{i});
end

end