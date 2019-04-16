function [fNoisy, info] = noiseSignal(f, para)
% NOISEDATA adds noise to a given signal 
%
% DETAILS:
%   noiseSignal.m applies a noising operation to a given input signal, e.g.
%     - fNoisy = f + sigma * randn(size(f)); to add Gaussian noise
%     - fNoisy = poissrnd(f); to apply Poisson noise (counting noise)
% 
% USAGE:
%   para.noiseType      = 'AdditiveGaussian'
%   para.amplitude      = 'relative'
%   para.noiseParameter = 0.1 % relative standart deviation
%   [fnoisy, SNR] = noiseData(f, para)
%
% INPUTS:
%   f    - the clean signal to be noised 
%
%  OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'noiseType' - str describing noise type: 
%                     'AdditiveGaussian': 'field 'noiseParameter' sets the
%                     relative or absolute standart deviation
%                     'Poission'
%       'noiseParameter' - vector of parameters describing properties of the
%                          noise (see below) as a scalar or numerical array
%                          of the same size as f
%       'amplitude' - for noiseType = 'AdditiveGaussian', it determines how 
%                     the standart deviation sigma will be determined:
%                     - 'relativeLInf': sigma = noiseParameter .* norm(f(:), inf)
%                     - 'relativeL2':   sigma = noiseParameter .* norm(f(:))
%                     - 'relativeSNR': noiseParameter determines SNR of
%                                      signal, sigma will be computed to
%                                      match it
%                     - 'absolute': sigma = noiseParameter
%       'rngSeed'   - non-negative integer used to set the random
%       generator (will be set to previous state after function call)
%       
%   
% OUTPUTS:
%   fNoisy  - the noisy data
%   info    - a struct containing additional information on the noise, such
%             as SNR, std deviation
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also

info   = [];

noiseType = checkSetInput(para, 'noiseType', {'AdditiveGaussian', 'Poisson'}, 'AdditiveGaussian');
amplitude = checkSetInput(para, 'amplitude', {'relativeLInf', 'relativeL2',...
                          'relativeSNR', 'absolute'}, 'relativeLInf');
noiseParameter = checkSetInput(para, 'noiseParameter', '>=0', 0.1);
rngSeed        = checkSetInput(para, 'noiseParameter', 'i,>=0', 'shuffle');

% get the current state of the random generator (will be set to that state
% after adding noise)
currRngState = rng;
rng(rngSeed)


switch noiseType
    case 'AdditiveGaussian'
        
        switch amplitude
            case 'absolute'
                sigma = noiseParameter;
            case 'relativeLInf'
                sigma = noiseParameter * max(abs(f(:)));
            case 'relativeL2'
                sigma = noiseParameter * norm(f(:));
            case 'relativeSNR'
                sigma = sqrt(mean(f(:).^2)) * 10^(-noiseParameter/20);
        end
        noise  = sigma .* randn(size(f), 'like', f);
        fNoisy = f + noise;
        
        if(isscalar(sigma))
           info.sigma = sigma;
           info.SNR = 20 * (log10(sqrt(mean(f(:).^2))) - log10(sigma)); 
        end
        
    case 'Poisson'
        
        fNoisy = poissrnd(f);
        
    otherwise
        notImpErr
end

% set the internal state of the random generator to what it was before
rng(currRngState);


end