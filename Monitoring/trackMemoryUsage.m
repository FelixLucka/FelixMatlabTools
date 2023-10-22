function trackMemoryUsage(pid, update_int, log_txt, log_mat)
%TRACKMEMORYUSAGE can be used to track the memory consumption of an
%external process (UNIX ONLY!)
%
% DESCRIPTION:
%   trackMemoryUsage.m uses the pmap command to track the memory
%   consumption of an external process
%
% USAGE:
%   trackMemoryUsage(1091, 10, log.txt, log.mat) tracks process 1091 every
%   10 seconds and writes the results into files log.txt and log.mat
%
% INPUTS:
%   pid       - process id
%   updateInt - temporal interval (sec) in which to log
%   logTxt    - filename of the txt file used for logging
%   logMat    - filename of the max file used for logging
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 01.11.2018
%       last update     - 16.05.2023
%
% See also mem, memCheck

checkUnix(trackMemoryUsage)

t_int = 0;
fid  = fopen(log_txt, 'w');

while(1)
    pause(update_int)
    
    t_int = t_int+1;
    t(t_int) = t_int*update_int;
    
    [stat out] = system(['pmap -x ' int2str(pid) ' | grep ''total''']);
    aux = str2num(out(11:end));
    mem_GByte(t_int) = aux(1)/1048576;
    
    save(log_mat,'t','mem_GByte');
    
    % write something to file
    file_str = [datestr(clock) '     ' num2str(mem_GByte(t_int)) ' GB'];
    fprintf(fid, '%s\n',file_str);
end

fclose(fid);

end