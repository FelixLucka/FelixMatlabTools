function Y = simplestDataType(X)
%SIMPLESTDATATYPE is crude function to losslessly compress an input by 
% converting it to the simplest data
%
% DESCRIPTION: 
%   simplestDataType.m is a crude way to compress a numerical array
%   losslessly by downcasting as much as possible. 
%
% USAGE:
%   Y = simplestDataType(1:10) will result in Y being a unit8 array 
%
% INPUTS:
%   X - numerical array to convert
%
% OUTPUTS:
%   Y - downcasted numerical array
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 16.05.2023
%
% See also mem, memCheck

data_types = {'logical','uint8','int8','uint16','int16','uint32','int32', ...
    'uint64','int64','single','double'};

% convert to all these types
for i=1:length(data_types)
    eval(['Y = ' data_types{i} '(X);']);
    if(isequal(X,Y))
        return
    end
end

end