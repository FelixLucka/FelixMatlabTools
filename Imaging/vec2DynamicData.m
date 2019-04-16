function cellData = vec2DynamicData(X, sizeData)
% VEC2DYNAMICDATA reshapes dynamic data given as a vector into a cell array
%
% USAGE:
%  fCell  = vec2DynamicData(fVec,sizeFVec)
%
%  INPUT:
%   X - dynamic data as a vector 
%   sizeData - sizes of the single frame data
%
%  OUTPUTS:
%   cellData - the data as a cell array, each cell corresponds to the data
%              of a single frame
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also dynamicData2Vec

cellData       = cell(1, length(sizeData));
dataStartIndex = 1;

for i=1:length(cellData)
    lengthThisData = prod(sizeData{i});
    cellData{i}    = X(dataStartIndex:(dataStartIndex + lengthThisData - 1));
    dataStartIndex = dataStartIndex + lengthThisData;
    cellData{i}    = reshape(cellData{i}, sizeData{i});
end

end