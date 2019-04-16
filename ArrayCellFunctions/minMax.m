function [min_, max_] = minMax(p)
% MYMINMAX returns minimal and maximal value of given data
%
% DESCRIPTION:
%   minMax returns minimal and maximal value of given data
%
% USAGE:
%  [a, b] = minMax(data)
%
%  INPUTS:
%   p    - the data 
%   
%  OUTPUTS:
%   min_     - minimal value of p
%   max_     - maximal value of p
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.12.2017
%
% See also min, max

min_ = min(p(:));
max_ = max(p(:));

end