function X = dynamicData2Mat(cell_data)
% DYNAMICDATA2MAT reshapes dynamic data given as a cell array into a matrix
% (nData x nFrames)
%
%  USAGE:
%   P0 = dynamicData2Mat(p0_cll)
%
%  INPUT:
%   cell_data - the data as a cell array, each cell corresponds to the data
%              of a single frame
%
%  OUTPUTS:
%   X - dynamic data as a matrix (nData x nFrames)
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 29.09.2023
%
% See also mat2DynamicData, dynamicData2SpaceTime, dynamicData2Vec

X = zeros(numel(cell_data{1}),length(cell_data));
for i=1:length(cell_data)
    X(:,i) =  cell_data{i}(:);
end

end