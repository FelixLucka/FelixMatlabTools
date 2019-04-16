function cellData = num2DynamicData(X, tmpInt, sizeData, dimDyn)
% NUM2DYNAMICDATA extracts and reshapes dynamic data given as a numerical
% array into a cell array
%
%  USAGE:
%  cellData = num2DynamicData(X, dimDyn, tmpInt, sizeData)
%
%  INPUT:
%   X      - dynamic data as a numerical array 
%   tmpInt - temporal intervals indicating how thin the temporal slices are
%
%  OPTIONAL INPUTS:
%   sizeData - vector of sizes to which the the single frame data will be reshaped
%              if left empty ([]) the data will not be reshaped after extraction
%   dimDyn - dimension along which the time slices are extracted
%
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
% See also

% check optional input sizeData, otherwise set default
if(nargin < 3)
    sizeData = [];
end

% check optional input dimDyn, otherwise set default
if(nargin < 4)
    dimDyn = nDims(X);
end

T         = size(tmpInt, 1);
cellData  = cell(1, T);

for i=1:length(cellData)
    cellData{i} =  sliceArray(X, dimDyn, tmpInt(i, 1):tmpInt(i, 2), true);
    if(~isempty(sizeData))
        cellData{i} =  reshape(cellData{i}, sizeData{i});
    end
end

end