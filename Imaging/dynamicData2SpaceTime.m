function X = dynamicData2SpaceTime(cell_data)
% DYNAMICDATA2SPACETIME reshapes dynamic data given as cell into a space-time volume
%
%  USAGE:
%   p0_vol = dynamicData2SpaceTime(p0_cell)
%
%  INPUT:
%   cell_data - the data as a cell array, each cell corresponds to the data
%              of a single frame, where the last index of X is assumed to
%              be time
%
%  OUTPUTS:
%   X - dynamic data as a volume ([sizeSpace] x nFrames)
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 29.09.2023
%
% See also spaceTime2DynamicData, dynamicData2Vec, dynamicData2Mat

T     = length(cell_data);
sz_X  = size(cell_data{1});
X     = zeros([sz_X,T]);

for i=1:T
    switch length(sz_X)
        case 5
            X(:,:,:,:,:,i) = cell_data{i};
        case 4
            X(:,:,:,:,i)   = cell_data{i};
        case 3
            X(:,:,:,i)     = cell_data{i};
        case 2
            X(:,:,i)       = cell_data{i};
        case 1
            X(:,i)         = cell_data{i};
        otherwise
            notImpErr
    end
end

end