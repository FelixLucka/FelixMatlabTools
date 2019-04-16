function X = dynamicData2Mat(cellData)
% DYNAMICDATA2MAT reshapes dynamic data given as a cell array into a matrix
% (nData x nFrames)
%
%  USAGE:
%   P0 = dynamicData2Mat(p0Cell)
%
%  INPUT:
%   cellData - the data as a cell array, each cell corresponds to the data
%              of a single frame
%
%  OUTPUTS:
%   X - dynamic data as a matrix (nData x nFrames)
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also mat2DynamicData, dynamicData2SpaceTime, dynamicData2Vec

X = zeros(numel(cellData{1}),length(cellData));
for i=1:length(cellData)
    X(:,i) =  cellData{i}(:);
end

end