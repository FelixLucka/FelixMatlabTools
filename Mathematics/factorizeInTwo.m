function [a, b]  = factorizeInTwo(c)
%FACTORIZEINTWO tries to factor a number into two factors such that both
%are as close as possible
%
% DESCRIPTION: 
%   factorizeInTwo.m uses a pretty simple and inefficient algorithm to find
%   a factorization of a number into two factors of equal size
%
% USAGE:
%   [a, b]  = factorizeInTwo(12) should return 3 and 4
%
% INPUTS:
%   c - number to be factored, must be non-negative integer
%
% OUTPUTS:
%   a - smaller of the two factors
%   b - larger  of the two factors 
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 16.05.2023
%
% See also

prime_factors = factor(c);
nFac          = length(prime_factors);

%factors that make up the first factor
I_best     = (rand(nFac,1)<0.5);
min_misfit = abs(prod(prime_factors(I_best))-prod(prime_factors(~I_best)));
change     = 1;
rep        = 1000;

while(change)
    if(min_misfit == 0)
        break
    end
    change = 0;
    for i=1:rep
        I      = (rand(nFac,1)<0.5);
        misfit = abs(prod(prime_factors(I))-prod(prime_factors(~I)));
        if(misfit < min_misfit)
            I_best = I;
            change = 1;
            min_misfit = misfit;
            if(min_misfit == 0)
                break
            end
        end
    end
end

aux = [prod(prime_factors(I_best)), prod(prime_factors(~I_best))];
a = min(aux);
b = max(aux);

end
