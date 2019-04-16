function [W, gradfW, f2gFlow] = WassersteinDistance1D(f, g, para)
% WassersteinDistance1D computes the Wasserstein Distance between two 1D
% functions and the gradient of the squared Wasserstein Distance
%
% DETAILS:
%   WassersteinDistance1D.m computes the Wasserstein distance between two
%   1D functions f and g by using the explict formula
%   W(f,g)_2 = sqrt( int_t |t - G^{-1}(F(t))|^2 f(t) dt )
%   and the gradient wrt f via
%   [d/df W(f, g)](t) = - 2 \int_t^T f(s) / g(G^{-1}(F(s)) ds + |t - G^{-1}(F(t))|^2
%   and the flow field from f to g
%
% USAGE:
%   W = WassersteinDistance1D(rand(10,1), rand(10,1))
%
% INPUTS:
%   f - function f as a vector
%   g - function g as a vector
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'normalize' - logical indicating wether the functions need to be
%       normalized first (default = true)
%       'negativeMode' - determines how to deal with negative values in f
%       or g
%
% OUTPUTS:
%   W - Wasserstein distance between f and g
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 02.02.2019
%       last update     - 02.02.2019
%
% See also

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

% spatial grids
n     = length(f);
tGrid = checkSetInput(para, 'tGrid', 'numeric', 1:n);
tStart = tGrid(1);
dt     = tGrid(2) - tGrid(1);

transform = checkSetInput(para, 'transform', {'norm', 'shiftNorm', 'yang'}, 'yang');
fac       = 1;
switch transform
    case 'norm'
        %
    case 'shiftNorm'
        c = min(min(f), min(g));
        f = f - c;
        g = g - c;
        
    case 'yang'
        c = checkSetInput(para, 'c', '>0', 1);
        f_sign = (f >= 0);
        f = (f + 1/c) .* f_sign + 1/c * exp(c * f) .* not(f_sign);
        fac = 1 .* f_sign + exp(c * f) .* not(f_sign);
        g   = (g + 1/c) .* (g >= 0) + 1/c * exp(c * g) .* (g < 0);
end
fShift = f;
Nf     = sum(f);
f      = f / Nf;
g      = g / sum(g);




% compute cummulative distributions and correct
F       = cumsum(f);
F       = min(1, max(F, 0));
F(1)    = 0;
F(end)  = 1;
G       = cumsum(g);
G       = min(1, max(G, 0));
G(1)    = 0;
G(end)  = 1;

% set up interpolation functions for F and G^{-1}
% t2i   = @(t) min(n-1, floor((t - tStart)/dt) + 1);
% FHelp = @(t, i) F(i) + (t - tGrid(i)) * (F(i+1)-F(i))/dt;
% FFun  = @(t) FHelp(t, t2i(t));

% y2i      = @(y) max(2, find(G >= y, 1, 'first'));
% GInvHelp = @(y, i) ((y - G(i-1)) / (G(i) - G(i-1))) * dt + tGrid(i-1);
% GInvFun  = @(y) GInvHelp(y, y2i(y));

GInvF = zeros(1, n);
ind = 2;
for i=1:length(tGrid)
    %GInvF(i) = GInvFun(F(i));
    y = F(i);
    while(G(ind) < y)
        ind = ind + 1;
    end
    GInvF(i) = ((y - G(ind-1)) / (G(ind) - G(ind-1))) * dt + tGrid(ind-1);
end


% simple integration
W = sqrt(sum((tGrid - GInvF).^2 .* f));

if(nargout > 1)
    
    % compute analytical gradient wrt to f
    gGInvF                    = interp1(tGrid, g, GInvF);
    fOverFGInvF               = f./interp1(tGrid, g, GInvF);
    fOverFGInvF(gGInvF < eps) = 0;
    revIntegal = cumsum(fOverFGInvF .* (tGrid - GInvF), 2, 'reverse') * dt;
    gradfW  = -2 * revIntegal + (tGrid - GInvF).^2;
    
    % apply transpose of Jakobian of transform
    gradfW = multWithTransposeJac(gradfW);
    
end

if(nargout > 2)
    
    % compute flow from f to g
    delta = checkSetInput(para, 'delta', '>0', 10^-2);
    fTrans = interp1(tGrid, g, (1-delta) * GInvF + delta * tGrid);
    f2gFlow = fTrans - f;
    
    % apply transpose of Jakobian of transform
    f2gFlow = multWithTransposeJac(f2gFlow);
    
end



    function y = multWithTransposeJac(x)
        y = fShift.*x/Nf^2;
        y = fac.*x/Nf - fac * sum(y(:));
    end

end