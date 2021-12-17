function TF = isEven(x)
%ISEVEN checks if an input is an integer and is even
%
% DETAILS: 
%   isEven.m can be used to check parameter choices
%
% USAGE:
%   TF = isEven(3)
%
% INPUTS:
%   x - integer that is tested
%
% OUTPUTS:
%   TF - bool that is only true if x is an integer and is even
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 15.12.2021
%       last update     - 15.12.2021
%
% See also

TF = mod(x,2) == 0;

end