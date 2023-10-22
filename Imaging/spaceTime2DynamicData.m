function cell_data = spaceTime2DynamicData(X, sz_X)
% SPACETIME2DYNAMICDATA reshapes dynamic data given as a space-time volume into a cell array
%
% DESCRIBTION:
%   Spatio-temporal quantities that are stored as numerical arrays are
%   converted into cell arrays
%
% USAGE:
%  x_cell  = spaceTime2DynamicData(x_vol)
%
%  INPUT:
%   X - dynamic data, the time dimension is always assumed to be the last one
%
%  OPTIONAL INPUT:
%   sz_X - size of the dynamic data
%
%  OUTPUTS:
%   cell_data - the data as a cell array, each cell corresponds to the data
%              of a single frame, where the last index of X is assumed to
%              be time
%
% ABOUT:
%   author      - Felix Lucka
%   date        - 06.05.2018
%   last update - 16.05.2023
%
% See also dynamicData2SpaceTime

if(nargin < 2)
    sz_X    = size(X);
end

time_dim  = length(sz_X);
T        = sz_X(end);

if(T > 1)
    cell_data = cell(1, T);
    for i=1:T
        cell_data{i} = sliceArray(X, time_dim, i, 1);
    end
else
    cell_data = {X};
end

end