function split = splitIntoSets(vector, nSplit)
%FUNCTIONTEMPLATE is a template for a function describtion
%
% DETAILS: 
%   functionTemplate.m can be used as a template 
%
% USAGE:
%   x = functionTemplate(y)
%
% INPUTS:
%   y - bla bla
%
% OPTIONAL INPUTS:
%   z    - bla bla
%   para - a struct containing further optional parameters:
%       'a' - parameter a
%
% OUTPUTS:
%   x - bla bla
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 19.12.2018
%
% See also

n                = length(vector);
binLength        = floor(n/nSplit) * ones(1, nSplit);
mis              = n - sum(binLength);
binLength(1:mis) = binLength(1:mis) + 1;
startInd         = cumsum([1,binLength]);
split            = cell(1, nSplit);

for iSplit=1:nSplit
    split{iSplit} = vector(startInd(iSplit):(startInd(iSplit+1)-1));
end

end