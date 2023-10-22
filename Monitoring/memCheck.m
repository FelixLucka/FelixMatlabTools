function [str, bytes] = memCheck(sz, type)
%MEMCHECK prints how much memory an array of a given size and type would require
%
% DESCRIPTION:
%       memCheck returns strings that describe how much memory a variable
%       with a given size would take in memory
%
%       WARNING: THIS IS NOT AN EFFCIENT IMPLEMENTATION!
%
% USAGE:
%       memCheck([4,5], 'single') would return '128.00 B'
%
% INPUTS:
%       sz   - size of the array 
%       type - numerical type
%
% OUTPUTS:
%       str             - string with the memory that these variables take
%       bytes           - size in bytes
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 22.02.2019
%       last update     - 16.05.2023
%
% See also convertBytes, mem


num_el   = prod(sz);
base_var = ones(1, type);
info     = whos('base_var');
bytes    = num_el * info.bytes;
str      = convertBytes(bytes);

end