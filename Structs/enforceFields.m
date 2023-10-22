function enforceFields(struct, struct_name, field_names)
% ENFORCEFIELDS checks if a struct has certain fields and throws an error
% otherwise
%
% DESCRIPTION:
%   enforceFields.m can be used to ensure that a struct contains certain
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
%   last update     - 16.05.2023
%
% See also listDifferentFields, compareStructs

% ensure fieldNames is a cell
field_names = checkSetInput(field_names, [], 'cell', 'error');

error_msg = ['struct ' struct_name ' does not have required fields ' ];
throw_err = false;
for i = 1:length(field_names)
    if(~isfield(struct, field_names{i}))
        throw_err = true;
        error_msg = [error_msg '''' field_names{i} ''', '];
    end
end
error_msg(end-1) = '.';
error_msg        = error_msg(1:end-1);

if(throw_err)
   error(error_msg)
end


end