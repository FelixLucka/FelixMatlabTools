function [castFun, castZeros, castOnes] = castFunction(dataCast, noGPU, noLogical)
%CASTFUNCTION returns a function handle to cast variables to a certain
%numeric type and a handle to allocate an array of a given size
%
% DESCRIPTION: 
%       castFunction.m can be used to cast variables into a specific type 
%       or to transfer them onto the GPU
%
% USAGE:
%       castFun              = castFunction('single')
%       [castFun, castZeros] = castFunction('gpuArray-single', true)
%       [castFun, castZeros] = castFunction('gpuArray-single', true, true)
%
% INPUTS:
%       dataCast - a string determining the cast: 'double', 'single',
%                  'gpuArray-single', or 'gpuArray-double'
%
% OPTIONAL INPUTS:
%       noGPU   - a logical indicating whether the gpuArray pre-fix should
%                 be ignored
%       noLogical - logical indicating whether logical arrays will not be
%                   converted but might be tranfered to GPU. 
%
% OUTPUTS:
%       castFun - a function handle that can be used to cast a variable
%       castZeros - a function handle that can be used to create an
%                   all-zero numerical array of the specified type (similar to
%                   e.g., calling zeros(x, 'int16')
%       castOnes - a function handle that can be used to create a
%                   numerical array of the specified type (similar to
%                   e.g., calling ones(x, 'int16')
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 12.11.2017
%       last update     - 21.06.2020
%
% See also

% check user defined value for noGPU, otherwise assign default value
if(nargin < 2)
    noGPU = false;
end

% check user defined value for noLogical, otherwise assign default value
if(nargin < 3)
    noLogical = false;
end

if(noGPU)
    switch dataCast
        case {'double', 'gpuArray-double'}
            dataCast = 'double';
        case {'single', 'gpuArray-single'}
            dataCast = 'single';
    end
end

if(noLogical)
    dataCast = [dataCast '-NoLog'];
end

switch dataCast
    case 'double'
        castFun = @(x) applyToMatOrCell(@(x) double(x), x);
        castZeros = @(size) zeros(size, 'double');
        castOnes  = @(size) ones(size, 'double');
    case 'double-NoLog'
        castFun = @(x) applyToMatOrCell(@(x) doubleOrLog(x), x);
        castZeros = @(size) zeros(size, 'double');
        castOnes  = @(size) ones(size, 'double');
    case 'single'
        castFun = @(x) applyToMatOrCell(@(x) single(x),x);
        castZeros = @(size) zeros(size, 'single');   
        castOnes  = @(size) ones(size, 'single');   
    case 'single-NoLog'
        castFun = @(x) applyToMatOrCell(@(x) singleOrLog(x), x);
        castZeros = @(size) zeros(size, 'single');
        castOnes  = @(size) ones(size, 'single');
    case 'gpuArray-single'
        castFun = @(x) applyToMatOrCell(@(x) gpuArray(single(x)), x);
        castZeros = @(sz) gpuArray.zeros(sz, 'single');
        castOnes  = @(sz) gpuArray.ones(sz, 'single');
    case 'gpuArray-single-NoLog'
        castFun = @(x) applyToMatOrCell(@(x) gpuArray(singleOrLog(x)), x);
        castZeros = @(sz) gpuArray.zeros(sz, 'single');
        castOnes  = @(sz) gpuArray.ones(sz, 'single');
    case 'gpuArray-double'
        castFun = @(x) applyToMatOrCell(@(x) gpuArray(double(x)), x);
        castZeros = @(sz) gpuArray.zeros(sz, 'double');
        castOnes  = @(sz) gpuArray.ones(sz, 'double');
    case 'gpuArray-double-NoLog'
        castFun = @(x) applyToMatOrCell(@(x) gpuArray(doubleOrLog(x)), x);
        castZeros = @(sz) gpuArray.zeros(sz, 'double');
        castOnes  = @(sz) gpuArray.ones(sz, 'double');
    otherwise
        error(['unknown data cast: ' dataCast])
end


    function x = doubleOrLog(x)
        if(~islogical(x))
            x = double(x);
        end
    end

    function x = singleOrLog(x)
        if(~islogical(x))
            x = single(x);
        end
    end

end