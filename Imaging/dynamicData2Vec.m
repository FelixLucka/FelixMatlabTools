function X = dynamicData2Vec(cell_data)
% DYNAMICDATA2VEC reshapes dynamic data of varying length given as a cell array into a vector
%
%  USAGE:
%   p0_vec = dynamicData2Vec(p0_cell)
%
%  INPUT:
%   cellData - the data as a cell array, each cell corresponds to the data
%              of a single frame
%
%  OUTPUTS:
%   X - dynamic data as a vector
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 29.09.2023
%
% See also vec2DynamicData, dynamicData2Mat dynamicData2SpaceTime


numel_X = 0;
for i=1:length(cell_data)
    numel_X =  numel_X + numel(cell_data{i});
end

X = zeros(numel_X,1);
data_start_ind = 1;
for i=1:length(cell_data)
    length_this_data = numel(cell_data{i});
    X(data_start_ind:(data_start_ind+length_this_data-1)) =  cell_data{i}(:);
    data_start_ind = data_start_ind + length_this_data;
end

end