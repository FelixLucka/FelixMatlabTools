function [W, grad_f_W, f2g_flow] = WassersteinDistance1D(f, g, para)
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
%       last update     - 16.05.2023
%
% See also

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

% spatial grids
n     = length(f);
t_grid = checkSetInput(para, 'tGrid', 'numeric', 1:n);
t_start = t_grid(1);
dt     = t_grid(2) - t_grid(1);

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
f_shift = f;
n_f     = sum(f);
f       = f / n_f;
g       = g / sum(g);




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

G_inv_F = zeros(1, n);
ind = 2;
for i=1:length(t_grid)
    %GInvF(i) = GInvFun(F(i));
    y = F(i);
    while(G(ind) < y)
        ind = ind + 1;
    end
    G_inv_F(i) = ((y - G(ind-1)) / (G(ind) - G(ind-1))) * dt + t_grid(ind-1);
end


% simple integration
W = sqrt(sum((t_grid - G_inv_F).^2 .* f));

if(nargout > 1)
    
    % compute analytical gradient wrt to f
    g_G_inv_F                    = interp1(t_grid, g, G_inv_F);
    f_over_FG_inv_F               = f./interp1(t_grid, g, G_inv_F);
    f_over_FG_inv_F(g_G_inv_F < eps) = 0;
    rev_integal = cumsum(f_over_FG_inv_F .* (t_grid - G_inv_F), 2, 'reverse') * dt;
    grad_f_W  = -2 * rev_integal + (t_grid - G_inv_F).^2;
    
    % apply transpose of Jakobian of transform
    grad_f_W = multWithTransposeJac(grad_f_W);
    
end

if(nargout > 2)
    
    % compute flow from f to g
    delta = checkSetInput(para, 'delta', '>0', 10^-2);
    f_trans = interp1(t_grid, g, (1-delta) * G_inv_F + delta * t_grid);
    f2g_flow = f_trans - f;
    
    % apply transpose of Jakobian of transform
    f2g_flow = multWithTransposeJac(f2g_flow);
    
end



    function y = multWithTransposeJac(x)
        y = f_shift.*x/n_f^2;
        y = fac.*x/n_f - fac * sum(y(:));
    end

end