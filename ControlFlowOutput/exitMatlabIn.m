function exitMatlabIn(t)
%PAUSEANDEXITMATLAB terminates MATLAB after t seconds to free rescources and licences.
%
%  USAGE:
%       pauseAndExitMatlab(60) to terminate Matlab after one minute
%
%  INPUTS:
%       t       - time to close in seconds
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 16.01.2019
%
% See also continueComputationIn

% countdown loop
tPassed = 0;
while(tPassed < t)
    
    disp(['Matlab will close in ' int2str(t - tPassed)...
        ' seconds. Press ''ctrl + c'' to prevent this'])
    
    pause(1)
    
    stringLength = length(int2str(t- tPassed));
    for i=1:stringLength
        fprintf('\b')
    end
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
    tPassed = tPassed + 1;
    
end

% exit Matlab
exit

end