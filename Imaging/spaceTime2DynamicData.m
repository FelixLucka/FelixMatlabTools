function cellData = spaceTime2DynamicData(X, szX)
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
%  OPTIONAL INPUT:
%   szX - size of the dynamic data
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

if(nargin < 2)
    szX    = size(X);
end

timeDim  = length(szX);
T        = szX(end);

if(T > 1)
    cellData = cell(1, T);
    for i=1:T
        cellData{i} = sliceArray(X, timeDim, i, 1);
    end
else
    cellData = {X};
end

end