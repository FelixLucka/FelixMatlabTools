function cellData = mat2DynamicData(X, sizeData, tmpInt)
% MAT2DYNAMICDATA bins dynamic data given as a matrix (nData x
% nTime) into a cell array 
%
%  fCell = mat2DynamicData(F, sizeF)
%  pCell = mat2DynamicData(P, info.Nxyz)
%
%  INPUT:
%   X - dynamic data as a matrix (nData x nFrames)
%   sizeData - size of the single frame data; if left empty ([]) the data
%   will not be reshaped after extraction
%
% OPTIONAL INPUTS
%   tmpInt - a list of temporal intervals to bin the data as [t1a,t1b; t2a, t2b;...] 
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
% See also dynamicData2Mat

% check optional input tmpInt, otherwise set default
if(nargin < 3)
    tmpBin = false;
    T      = size(X,2);
else 
    tmpBin = true;
    T      = size(tmpInt, 1);
end

cellData = cell(1, T);
for i=1:length(cellData)
    if(tmpBin)
        cellData{i} =  X(:, tmpInt(i, 1):tmpInt(i, 2));
    else
        cellData{i} =  X(:,i);
    end
    if ~isempty(sizeData)
        cellData{i} =  reshape(cellData{i}, sizeData);
    end
end

end