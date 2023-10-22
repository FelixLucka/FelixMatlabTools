function u_in = localAverageInpainting(u, mask, para)
%FUNCTIONTEMPLATE is a template for a function describtion
%
% DETAILS: 
%   functionTemplate.m can be used as a template 
%
% USAGE:
%   x = functionTemplate(y)
%
% INPUTS:
%   y - bla bla
%
% OPTIONAL INPUTS:
%   z    - bla bla
%   para - a struct containing further optional parameters:
%       'a' - parameter a
%
% OUTPUTS:
%   x - bla bla
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 20.04.2023
%
% See also

% check user defined value for para, otherwise assign default value
if(nargin < 3)
    para = [];
end

u_dim   = nDims(u);
u_sz    = Size(u);

u_ini   = checkSetInput(para, 'u_ini', 'mixed', u);
std     = checkSetInput(para, 'std', '>0', 1);
cut_off = checkSetInput(para, 'cut_off', '>0', 1); 

mask    = double(mask > 0);

kernel = gaussianKernel(u_dim, std, cut_off);
switch u_dim
    case 2
        kernel(end/2+0.5, end/2+0.5) = 0;
    case 3
        kernel(end/2+0.5, end/2+0.5, end/2+0.5) = 0;
end
normalization = convn(ones(u_sz), kernel, 'same');
A    = @(x) convn(x, kernel, 'same') ./ normalization;
G    = @(x) (x - (not(mask) .* A(x))); 

g            = u;
g(not(mask)) = 0;

u_in = GenCGLS({G}, {G}, [], {g}, 1, u_ini, para);

end