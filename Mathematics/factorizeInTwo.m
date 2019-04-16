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
%       last update     - 01.11.2018
%
% See also

primeFactors = factor(c);
nFac         = length(primeFactors);

%factors that make up the first factor
I_best    = (rand(nFac,1)<0.5);
minMisfit = abs(prod(primeFactors(I_best))-prod(primeFactors(~I_best)));
change    = 1;
rep       = 1000;

while(change)
    if(minMisfit == 0)
        break
    end
    change = 0;
    for i=1:rep
        I      = (rand(nFac,1)<0.5);
        misfit = abs(prod(primeFactors(I))-prod(primeFactors(~I)));
        if(misfit < minMisfit)
            I_best = I;
            change = 1;
            minMisfit = misfit;
            if(minMisfit == 0)
                break
            end
        end
    end
end

aux = [prod(primeFactors(I_best)), prod(primeFactors(~I_best))];
a = min(aux);
b = max(aux);

end
