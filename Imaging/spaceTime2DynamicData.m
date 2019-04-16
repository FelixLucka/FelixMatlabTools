function cellData = spaceTime2DynamicData(X)
% SPACETIME2DYNAMICDATA reshapes dynamic data given as a space-time volume into a cell array
%
% DESCRIBTION:
%   Spatio-temporal quantities that are stored as numerical arrays are
%   converted into cell arrays
%
% USAGE:
%  xCell  = spaceTime2DynamicData(xVol)
%
%  INPUT:
%   X - dynamic data, the time dimension is always assumed to be the last one 
%
%  OUTPUTS:
%   cellData - the data as a cell array, each cell corresponds to the data
%              of a single frame, where the last index of X is assumed to
%              be time
%
% ABOUT:
%   author      - Felix Lucka
%   date        - 06.05.2018
%   last update - 01.11.2018
%
% See also dynamicData2SpaceTime


dimX     = nDims(X);
sizeX    = size(X);
T        = sizeX(end);
cellData = cell(1, T);

for i=1:T
    cellData{i} = sliceArray(X, dimX, i, 1);
end
    
end