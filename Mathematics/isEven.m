function tf = isEven(x)
%ISEVEN checks if an input is an integer and is even
%
% DETAILS: 
%   isEven.m can be used to check parameter choices
%
% USAGE:
%   isEven(3) returns false
%
% INPUTS:
%   x - integer that is tested
%
% OUTPUTS:
%   tf - bool that is only true if x is an integer and is even
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 15.12.2021
%       last update     - 16.05.2023
%
% See also

tf = mod(x,2) == 0;

end