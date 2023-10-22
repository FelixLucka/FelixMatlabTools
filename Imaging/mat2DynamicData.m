function cell_data = mat2DynamicData(X, size_data, tmp_int)
% MAT2DYNAMICDATA bins dynamic data given as a matrix (n_data x
% n_time) into a cell array 
%
%  f_cell = mat2DynamicData(F, size_f)
%  p_cell = mat2DynamicData(P, info.N_xyz)
%
%  INPUT:
%   X - dynamic data as a matrix (n_data x n_frames)
%   sizeData - size of the single frame data; if left empty ([]) the data
%   will not be reshaped after extraction
%
% OPTIONAL INPUTS
%   tmp_int - a list of temporal intervals to bin the data as [t1a,t1b; t2a, t2b;...] 
%
%  OUTPUTS:
%   cell_data - the data as a cell array, each cell corresponds to the data
%              of a single frame
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 05.09.2023
%
% See also dynamicData2Mat

% check optional input tmpInt, otherwise set default
if(nargin < 3)
    tmp_bin = false;
    T       = size(X,2);
else 
    tmp_bin = true;
    T       = size(tmp_int, 1);
end

cell_data = cell(1, T);
for i=1:length(cell_data)
    if(tmp_bin)
        cell_data{i} =  X(:, tmp_int(i, 1):tmp_int(i, 2));
    else
        cell_data{i} =  X(:,i);
    end
    if ~isempty(size_data)
        cell_data{i} =  reshape(cell_data{i}, size_data);
    end
end

end