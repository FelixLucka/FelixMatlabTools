function id = getComputerID()
%GETCOMPUTERID tries to generate a string to identify the computer Matlab
%is running on 
%
% USAGE:
%   id = getComputerID()
%
% OUTPUTS:
%   id - string that identifies the machine, usually the name it uses to
%   identify in a network
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 25.11.2019
%       last update     - 25.11.2019
%
% See also

if(isunix)
    
    [~ , id] = system('hostname');
    id       = deblank(id);
    
elseif(ispc)
    
    id = getenv('COMPUTERNAME');
    
else
    notImpErr
end

end