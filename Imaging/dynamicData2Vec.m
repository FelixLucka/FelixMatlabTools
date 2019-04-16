function X = dynamicData2Vec(cellData)
% DYNAMICDATA2VEC reshapes dynamic data of varying length given as a cell array into a vector
%
%  USAGE:
%   p0Vec = dynamicData2Vec(p0Cell)
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
%       last update     - 01.11.2018
%
% See also vec2DynamicData, dynamicData2Mat dynamicData2SpaceTime


numelX = 0;
for i=1:length(cellData)
    numelX =  numelX + numel(cellData{i});
end

X = zeros(numelX,1);
dataStartIndex = 1;
for i=1:length(cellData)
    lengthThisData = numel(cellData{i});
    X(dataStartIndex:(dataStartIndex+lengthThisData-1)) =  cellData{i}(:);
    dataStartIndex = dataStartIndex + lengthThisData;
end

end