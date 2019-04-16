function X = dynamicData2SpaceTime(cellData)
% DYNAMICDATA2SPACETIME reshapes dynamic data given as cell into a space-time volume
%
%  USAGE:
%   p0Vol = dynamicData2SpaceTime(p0Cell)
%
%  INPUT:
%   cellData - the data as a cell array, each cell corresponds to the data
%              of a single frame, where the last index of X is assumed to
%              be time
%
%  OUTPUTS:
%   X - dynamic data as a volume ([sizeSpace] x nFrames)
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 06.03.2019
%
% See also spaceTime2DynamicData, dynamicData2Vec, dynamicData2Mat

T     = length(cellData);
sizeX = size(cellData{1});
X     = zeros([sizeX,T]);

for i=1:T
    switch length(sizeX)
        case 5
            X(:,:,:,:,:,i) = cellData{i};
        case 4
            X(:,:,:,:,i)   = cellData{i};
        case 3
            X(:,:,:,i)     = cellData{i};
        case 2
            X(:,:,i)       = cellData{i};
        case 1
            X(:,i)         = cellData{i};
        otherwise
            notImpErr
    end
end

end