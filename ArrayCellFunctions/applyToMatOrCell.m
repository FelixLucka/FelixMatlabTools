function x = applyToMatOrCell(fun, x)
%APPLYTOMATORCELL applies a function handle to the input if the input is
% a numeric, or to each cell of a cell array
%
% DESCRIPTION:
%   applyToMatOrCell is a wrapper that to apply the same function to a
%   single matrix or to every image in a cell array
%
% USAGE:
%       result = applyToMatOrCell(@(x) max(x(:)), y)
%
% INPUTS:
%       fun - function handle to be applied to numerical array
%         x - input on which fun should be applied to 
%
% OUTPUTS:
%       x - fun(x) for x being a numerical or x{i} = fun(x{i}) for all i,
%           if x is a cell
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 16.03.2018
%   last update     - 16.03.2018
%
% See also repIntoCell


if(iscell(x))
    for i = 1:numel(x)
        if(~isempty(x{i}))
            x{i} = fun(x{i});
        end
    end
else
    x = fun(x);
end

end