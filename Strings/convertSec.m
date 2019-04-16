function time_str_cell = convertSec(T)
%CONVERTSEC convert a time span given in seconds into a string readable by
%humans
%
% DESCRIPTION:
%       convertSec takes a cell of numericals, interprets them as time
%       spans measured in seconds and converts them into common descriptions
%       of time spans, e.g, convertSec(361) returns the string '6m 1s'
%
% USAGE:
%       time_str_cell = convertSec(T)
%
% INPUTS:
%       T    - vector of numerical vales 
%
% OUTPUTS:
%       time_str_cell - cell with strings or single string for single input
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 15th March 2017
%       last update     - 15th March 2017
%
% See also convertBytes

% prepare output cell
time_str_cell = cell(size(T));

% loop over all values in input cell
for i=1:numel(T)
    t = T(i);
    
    if(t >= 24 * 60 * 60) % show as days and hours
        time_str = [int2str(floor(t/(24*3600))) 'd '];
        t        = t - floor(t/(24*3600)) * (24*3600);
        if(floor(t/(3600)) > 0)
            time_str = [time_str int2str(floor(t/(3600))) 'h'];
        end
    elseif(t >= 60 * 60) % show as hours and minutes
        time_str = [int2str(floor(t/(3600))) 'h '];
        t        = t - floor(t/(3600)) * 3600;
        if(floor(t/(60)) > 0)
            time_str = [time_str int2str(floor(t/(60))) 'm'];
        end
    elseif(t >= 60 ) % show as minutes and seconds
        time_str = [int2str(floor(t/(60))) 'm '];
        t        = t - floor(t/(60)) * 60;
        if(floor(t) > 0)
            time_str = [time_str int2str(floor(t)) 's'];
        end
    elseif(t >= 1 ) % show as seconds and mili seconds
        time_str = [int2str(floor(t)) 's '];
        t        = t - floor(t);
        if(floor(1000*t) > 0)
            time_str = [time_str int2str(floor(1000*t)) 'ms'];
        end
    else % just show mili  seconds
        time_str = [num2str(1000*t,'%1.3e') 'ms '];
    end
    
    time_str_cell{i} = deblank(time_str);
    
end

% return just a string
if(numel(T) == 1)
    time_str_cell = cell2mat(time_str_cell);
end


end