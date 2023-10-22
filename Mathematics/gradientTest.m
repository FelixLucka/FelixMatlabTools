function results = gradientTest(fgrad, x, para)
%GRADIENTTEST COMPARES A FUNCTION TO COMPUTE A GRADIENT WITH A FINITE
%DIFFERENCE APPROXIMATION OF IT
%
% DETAILS: 
%   gradientTest.m can be used to see if numerial approximatios of
%   gradients are valid 
%
% USAGE:
%   results = gradientTest(fgrad, x, para)
%
% INPUTS:
%   fgrad  - function handle that returns objective function and gradient
%            if called as 
%            [F(x), gradF(x)] = fgrad(x)
%       x - point at which to evaluate gradient
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'mode'  - 'full' compute full gradient via 
%       'delta' - step in finite difference computations
%
% OUTPUTS:
%   results - a struct summarizing the results
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 28.09.2019
%       last update     - 21.10.2023
%
% See also


% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

mode      = checkSetInput(para, 'mode', {'full'}, 'full');
delta_df  = max(abs(x(:))) * 10^-6;
delta     = checkSetInput(para, 'delta', '>0', delta_df);


switch mode
    case 'full'
        [fx, grad_fun] = fgrad(x);
        grad_fd        = zeros(size(x), 'like', x);
        for i=1:numel(x)
           x_delta    = x;
           x_delta(i) = x(i) + delta;
           fx_delta   = fgrad(x_delta);
           grad_fd(i) = (fx_delta - fx) / delta;
        end
end

results.grad_fun     = grad_fun;
results.grad_fd      = grad_fd;
results.rel_l2_err   = norm(grad_fun(:) - grad_fd(:)) / (0.5 * (norm(grad_fun(:)) + norm(grad_fd(:))));
results.rel_linf_err = norm(grad_fun(:) - grad_fd(:),'inf') / norm([grad_fun(:),grad_fd(:)],'inf');
results.delta        = delta;

end