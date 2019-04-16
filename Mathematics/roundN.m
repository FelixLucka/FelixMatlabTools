function x = roundN(x, n)
%ROUNDN rounds x to a given power of 10
%
% DESCRIPTION: 
%   roundN.m can be used to round an input to a given absolute accuracy 
%
% USAGE:
%   myRoundn(pi, 0) round pi to 10^0=1 accuracy will return 3
%   myRoundn(pi, 1) round pi to 10^1=10 accuracy will return 0
%   myRoundn(pi, -2) round pi to 10^-2=0.01 accuracy will return 3.14
%
% INPUTS:
%   x - input value to be rounded
%   n - power of 10 to which x should be rounded.
%
% OUTPUTS:
%   x - input rounded to n digits
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also round2Precision, roundn, round

if n < 0
    % Compute the inverse of the power of 10 to which input will be
    % rounded. Because n < 0, p will be greater than 1.
    p = 10^-n;
    % Round x to the nearest multiple of 1/p.
    x = round(p * x) / p;
elseif n > 0
    % Compute the power of 10 to which input will be rounded. Because
    % n > 0, p will be greater than 1.
    p = 10^n;
    % Round x to the nearest multiple of p.
    x = p * round(x / p);
else
    x = round(x);
end

end