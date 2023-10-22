function pp = openParPool(n_worker_pool, output, delete_existing_pool)
% OPENPARPOOL safely opens a parallel pool with a specified number of
% workers, without throwing all the warnings. 
%
% DESCRIPTION:
%   openParPool is a wrapper to safely open a parallel pool with a specified 
%   number of workers, without throwing all the warnings and a few additional 
%   options.
%
% USAGE:
%   pp = openParPool(10, true)
%
% INPUTS:
%   n_worker_pool - number of workers
%   output      - logical indicating whether output should be displayed.
%
% OPTIONAL INPUTS: 
%   delete_existing_pool - a logical indicating whether existing par pools 
%                        should be closed, even if they match the number of
%                        requested workers
%
% OUTPUTS:
%   pp - handle to the pool created
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 16th June 2018
%       last update     - 16th June 2018
%
% See also closeParPool

% check user defined value for deleteExistingPoolFL, otherwise assign default value
if(nargin < 3)
    delete_existing_pool = true;
end

% check whether another pool is open and delete it if it does not match the
% number of requested workers
pp = gcp('nocreate');
if(~isempty(pp))
    if(delete_existing_pool)
        evalc('delete(gcp)');
    else
        n_worker_current_pool = pp.NumWorkers;
        if(n_worker_current_pool == n_worker_pool)
            % don't do anything
           return 
        else
            evalc('delete(gcp)');
        end
    end
end

% open new pool
warning off all
if(output)
    eval(['pp = parpool(''local'',' int2str(n_worker_pool) ');']);
else
    evalc(['pp = parpool(''local'',' int2str(n_worker_pool) ');']);
end
warning on all

end