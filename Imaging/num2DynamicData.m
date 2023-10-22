function cell_data = num2DynamicData(X, tmp_int, size_data, dim_dyn)
% NUM2DYNAMICDATA extracts and reshapes dynamic data given as a numerical
% array into a cell array
%
%  USAGE:
%  cell_data = num2DynamicData(X, dim_dyn, tmp_int, size_data)
%
%  INPUT:
%   X      - dynamic data as a numerical array 
%   tmp_int - temporal intervals indicating how thin the temporal slices are
%
%  OPTIONAL INPUTS:
%   size_data - vector of sizes to which the the single frame data will be reshaped
%              if left empty ([]) the data will not be reshaped after extraction
%   dim_dyn - dimension along which the time slices are extracted
%
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
% See also

% check optional input sizeData, otherwise set default
if(nargin < 3)
    size_data = [];
end

% check optional input dimDyn, otherwise set default
if(nargin < 4)
    dim_dyn = nDims(X);
end

T         = size(tmp_int, 1);
cell_data = cell(1, T);

for i=1:length(cell_data)
    cell_data{i} =  sliceArray(X, dim_dyn, tmp_int(i, 1):tmp_int(i, 2), true);
    if(~isempty(size_data))
        cell_data{i} =  reshape(cell_data{i}, size_data{i});
    end
end

end