function a = intManipulation(a, mode)
%INTMANIPULATION performs different manipulations on numbers like
%replacing them with the smallest even integer larger then them
%
% DESCRIPTION:
%       intManipulation can be used to transform an input number to a
%       close-by integer fullfilling a certain condition
%
% USAGE:
%       a = intManipulation(a,mode)
%
% INPUTS:
%       a    - number
%       mode - mode, choose one of the following manipulations:
%           'evenUp'   - return smallest even integer larger than a 
%           'oddUp'    - return smallest odd integer larger than a 
%           'evenDown' - return largest even integer smaller than a 
%           'oddDown'  - return largest odd integer smaller than a 
%
% OUTPUTS:
%       a - modified integer
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.03.2017
%       last update     - 16.11.2021
%
% see also round, mod

switch mode
    case 'evenUp'
        a = ceil(a);
        a = a + mod(a, 2);
    case 'oddUp'
        a = ceil(a);
        a = a + mod(a+1, 2);
    case 'evenDown'
        a = floor(a);
        a = a - mod(a, 2);
    case 'oddDown'
        a = floor(a);
        a = a - mod(a + 1, 2);
    otherwise
        error('invalid mode')
end

end