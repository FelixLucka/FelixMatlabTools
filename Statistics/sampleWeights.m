function ind = sampleWeights(w, size)
%SAMPLEWEIGHTS samples a given, unnormalized distribution of weights
%
% DESCRIPTION: 
%   sampleWeights.m constructs a discrete sampling density from an input
%   vector of length n containing non-negative weights. The probability of
%   returning i is p(i) = w(i)/sum(w)
%
% USAGE:
%   i = sampleWeights(w, [2,3])
%
% INPUTS:
%   w - vector of non-negative weights
%
% OPTIONAL INPUTS
%   size - size of the random samples (default = [1,1])
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

% check user defined value for z, otherwise assign default value
if(nargin < 2)
    size = [1,1];
end

if(any(w < 0))
   error('weight vector w must be non-negative!') 
end

% normalize
w = w/sum(w);
w = cumsum(w);

t   = rand(size);
ind = ones(size);
for i=1:numel(t)
    ind(i) = find(t(i) < w, 1, 'first');
end

end