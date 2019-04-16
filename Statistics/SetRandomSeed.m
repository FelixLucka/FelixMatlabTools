function setRandomSeed(seed)
%SETRANDOMSEED sets the state of the global random stream to a given input
%or shuffles is using clock()
%
% USAGE:
%   SetRandomSeed(1) sets the global stream to a fixed value for exaclty 
%   reproduing the results of previous computations
%   SetRandomSeed('rand') uses the clock function to construct a
%   pseudo-random initilization of the stream
%
% INPUTS:
%   seed - nonnegative integer value less than 2^32 or 'rand' to use the
%   current 'clock' output to do the initilization
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 01.11.2018
%
% See also rng

% use input integer or construct one
if(ischar(seed) && strcmp(seed,'rand'))
    % no seed given, construct one by using clock
    fc = clock;
    seed = fc(4)*10^8 + fc(4)*10^6 + fc(5)*10^4 + fc(6)*10^2;
end

% set random stream depening on version of Matlab
if verLessThan('matlab', '7.12')
    RandStream.setDefaultStream(RandStream('mt19937ar', 'seed', seed));
else
    RandStream.setGlobalStream(RandStream( 'mt19937ar', 'seed', seed));
end

end