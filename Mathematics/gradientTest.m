function results = gradientTest(FGrad, x, para)
%GRADIENTTEST is a function to compare a function to compute a gradient
%with a finite difference approximation of it
%
% DETAILS: 
%   ToDo
%
% USAGE:
%   results = gradientTest(FGrad, x, para)
%
% INPUTS:
%   FGrad  - function handle that returns objective function and gradient
%            if called as 
%            [F(x), gradF(x)] = FGrad(x)
%       x - point at which to evaluate gradient
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'mode'  - 'full' compute full gradient via 
%       'delta' - step in finite difference computations
%
% OUTPUTS:
%   result - a struct summarizing the results
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 28.09.2019
%       last update     - 28.09.2019
%
% See also


% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

mode     = checkSetInput(para, 'mode', {'full'}, 'full');
deltaDF  = max(abs(x(:))) * 10^-6;
delta    = checkSetInput(para, 'delta', '>0', deltaDF);


switch mode
    case 'full'
        [Fx, gradFun] = FGrad(x);
        gradFd        = zeros(size(x), 'like', x);
        for i=1:numel(x)
           xDelta    = x;
           xDelta(i) = x(i) + delta;
           FxDelta   = FGrad(xDelta);
           gradFd(i) = (FxDelta - Fx) / delta;
        end
end

results.gradFun    = gradFun;
results.gradFd     = gradFd;
results.relL2Error   = norm(gradFun(:) - gradFd(:)) / (0.5 * (norm(gradFun(:)) + norm(gradFd(:))));
results.relLInfError = norm(gradFun(:) - gradFd(:),'inf') / norm([gradFun(:),gradFd(:)],'inf');
results.delta        = delta;

end