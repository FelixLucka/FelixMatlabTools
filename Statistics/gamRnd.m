function gam = gamRnd(alpha, beta)
%GAMRND samples from a gamma distribution by the method of
% Marsaglia and Tsang, 2000
%
% DESCRIPTION:
%   gamRnd.m is a re-implementation of the method of Marsaglia and Tsang,
%   2000, 'A Simple Method for Generating Gamma Variables",
%   ACM Trans. Math. Soft. 26(3):363-372.
%
% USAGE:
%   gamRnd(1, 1) returns one random variable a gamma distribution with
%   parameters alpha = 1, beta = 1;
%   gamRnd(1:10, 3 * ones(1,10) returns 10 random variables, distributed
%   with parameters alpha = 1:10, beta = 3
%
% INPUTS:
%   alpha - array of non-negative shape parameters alpha
%   beta  - array of non-negative shape parameters beta, must have same
%           size as alpha
%
% OUTPUTS:
%   gam - array of Gamma distributed random variables where gam(i) is
%   distributed according to shape and scale parameters alpha(i), beta(i)
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 16.05.2023
%
% See also gamrnd

% check that alpha and beta have the same size
if(size(alpha)~=size(beta))
    error('sizes of shape and scale parameters must be equal')
end

[m,n] = size(alpha);

alpha = alpha(:);
beta  = beta(:);

% discard negative parameters
alpha(alpha < 0) = NaN;
beta(beta < 0)   = NaN;

is_not_ready = find(not(isnan(alpha) | isnan(beta)));

% shift alpha by +1 if needed
if(any(alpha < 1))
    shift = true;
    alpha = alpha + 1;
else
    shift = false;
end

gam = zeros(size(alpha));

% the method by Marsaglia and Tsang, 2000

d = alpha - 1/3;
c = 1./sqrt(9*d);


while(~isempty(is_not_ready))
    n_nr = length(is_not_ready);
    x =  randn(n_nr,1);
    x2 = x.*x;
    U =  rand(n_nr,1);
    v = (1+c.*x);
    v = v.*v.*v;
    
    use1 = v > 0 & U < (1 - 0.0331 * (x2.*x2));
    
    gam(is_not_ready(use1)) = d(use1) .* v(use1);
    nuse1 = ~use1;
    x = x(nuse1);
    x2 = x2(nuse1);
    U = U(nuse1);
    v = v(nuse1);
    d = d(nuse1);
    c = c(nuse1);
    is_not_ready = is_not_ready(nuse1);
    
    use2  = v > 0 & (log(U) < 0.5 * x2 + d.*(1-v+log(v)));
    
    gam(is_not_ready(use2)) = d(use2) .* v(use2);
    nuse2 = ~use2;
    c = c(nuse2);
    d = d(nuse2);
    is_not_ready = is_not_ready(nuse2);
end

% reshift if needed
if(shift)
    gam = gam .* (rand(size(gam)).^(1./(alpha-1)));
end


% scale by beta
gam = beta .* gam;


% put back into original form
gam = reshape(gam, m, n);

end