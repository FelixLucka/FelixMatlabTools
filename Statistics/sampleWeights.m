function i = sampleWeights(w)
%SAMPLEWEIGHTS samples a given, unnormalized distribution of weights
%
% DESCRIPTION: 
%   sampleWeights.m constructs a discrete sampling density from an input
%   vector of length n containing non-negative weights. The probability of
%   returning i is p(i) = w(i)/sum(w)
%
% USAGE:
%   i = sampleWeights(w)
%
% INPUTS:
%   w - vector of non-negative weights
%
% OUTPUTS:
%   i - index of sampled weight
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 08.07.2018
%       last update     - 08.07.2018
%
% See also

if(any(w < 0))
   error('weight vector w must be non-negative!') 
end

% normalize
w = w/sum(w);
w = cumsum(w);

t = rand();
i = find(t < w, 1, 'first');

if(isempty(i))
    i = 1;
end

end