function continueComputationIn(t)
% CONTINUECOMPUTATIONIN pauses the execution of a script for t seconds and
% displays a count down 
%
%    startComputationInSec(3600) % wait for an hour before starting 
%
%  INPUT:
%   t - seconds to wait
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.11.2018
%       last update     - 16.01.2019
%
% See also exitMatlabIn 

% countdown loop
tPassed = 0;
while(tPassed < t)
    disp(['Computation will continue in ' int2str(t - tPassed)...
        ' seconds. Press ''ctrl + c'' to prevent this'])
    pause(1)
    stringLength = length(int2str(t - tPassed));
    for i=1:stringLength
        fprintf('\b')
    end
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
    fprintf('\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b\b')
    tPassed = tPassed + 1;
end

end