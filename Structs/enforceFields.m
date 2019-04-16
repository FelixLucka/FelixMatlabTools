function enforceFields(struct, structName, fieldNames)
% ENFORCEFIELDS checks if a struct has certain fields and throws an error
% otherwise
%
% DESCRIPTION:
%   enforceFields can be used to ensure that a struct contains certain
%   fields before using them in some part of the code
%
% USAGE:
%   enforceFields(myStuct, 'name', {'a', 'b'})
%
%  INPUTS:
%   struct     - struct 
%   fieldNames - cell of strings
%
%  OUTPUTS:
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.12.2017
%
% See also listDifferentFields, compareStructs

% ensure fieldNames is a cell
fieldNames = checkSetInput(fieldNames, [], 'cell', 'error');

errorMsg = ['struct ' structName ' does not have required fields ' ];
throwErr = false;
for i = 1:length(fieldNames)
    if(~isfield(struct, fieldNames{i}))
        throwErr = true;
        errorMsg = [errorMsg '''' fieldNames{i} ''', '];
    end
end
errorMsg(end-1) = '.';
errorMsg        = errorMsg(1:end-1);

if(throwErr)
   error(errorMsg)
end


end