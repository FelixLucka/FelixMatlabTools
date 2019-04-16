function bin = decimal2Binary(dec, n)
%DECIMAL2BINARY is modification of dec2bin that returns a logical vector
%representing the binary code
%
% USAGE:
%   bin = decimal2Binary(7) returns    [true true true]
%   bin = decimal2Binary(7, 4) returns [false true true true]
%
% INPUTS:
%   dec - non-negative integer
%
% OUTPUTS:
%   bin - logical vector containing the binary code for dec
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 19.12.2018
%
% See also

% check user defined value for n, otherwise assign default value
if(nargin < 2)
    n = 1;
end

dec = double(checkSetInput(dec, [], 'i,>=0','error'));

[~, exponent]  = log2(max(dec));
bin = rem(floor(dec * pow2(1-max(n, exponent):0)), 2);
bin = bin > 0;

end