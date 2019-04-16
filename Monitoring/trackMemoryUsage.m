function trackMemoryUsage(pid, updateInt, logTxt, logMat)
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
%       last update     - 01.11.2018
%
% See also mem, memCheck

checkUnix(trackMemoryUsage)

tInt = 0;
fid = fopen(logTxt, 'w');

while(1)
    pause(updateInt)
    
    tInt = tInt+1;
    t(tInt) = tInt*updateInt;
    
    [stat out] = system(['pmap -x ' int2str(pid) ' | grep ''total''']);
    aux = str2num(out(11:end));
    mem_GByte(tInt) = aux(1)/1048576;
    
    save(logMat,'t','mem_GByte');
    
    % write something to file
    filestr = [datestr(clock) '     ' num2str(mem_GByte(tInt)) ' GB'];
    fprintf(fid, '%s\n',filestr);
end

fclose(fid);

end