function movieFromRGB(RGBcell, para)
% MOVIEFROMRGB creates a movie file from a cell of RGBs
%
% USAGE:
%  movieFromRGB(RGBcell,para)
%
%  INPUTS:
%   RGBcell - cell of same-size RGBs
%   para - a struct containing optional parameters
%       'fileType'    - 'gif' for an animated .gif or 'mpeg' (not
%       implemented yet)
%       'fps'     - frames per second
%       'fileName' - full file name of the output file
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 13.12.2017
%
% See also printRGB

% check if we are on a unix system
if(~isunix)
    error('movieFromRGB.m will only run on a unix system')
end

% make a temporary dir in the home directory
[movieDir, dirExistFL] = makeDir('~/tmpMovieFromRGB', false);
if(dirExistFL)
    error('temporal directory to be used for the generation of the animated gif does already exist!')
end

% print all RGBs to png files called im000001.png, im0000002.png, etc
printPara = para;
for i_frame = 1:length(RGBcell)
    printPara.fileName = [movieDir '/im' int2strLead0(i_frame, 6)];
    printRGB(RGBcell{i_frame}, printPara);
end

% read out file name and type
fileType = checkSetInput(para, 'fileType', {'gif', 'mpeg', 'mp4'}, 'gif');
fps      = checkSetInput(para, 'fps', 'double', 1);

fileName = checkSetInput(para, 'fileName', 'char', 'movie');
% attach '.fileType' if missing.
if(length(fileName) < 4 || ~strcmp(fileName(end-3:end), ['.' fileType]))
    fileName = [fileName '.' fileType];
end


% convert the pngs to a movie file using convert
try
    
    switch fileType
        case 'mp4'
            kbitrate    = checkSetInput(para, 'kbitrate', 'i,> 0', 5000); 
            [status, cmdout] = system(['ffmpeg -i ' movieDir '/im%6d.png -framerate ' int2str(fps) ...
                                  ' -pix_fmt yuv420p -vcodec libx264 -b ' int2str(kbitrate) 'k '...
                                  fileName]);
        case 'mpeg'
            % does, for some reason, not work on Mac
            oldImpErr
            [status, cmdout] = system('PATH=$PATH:/usr/local/bin;convert -quality 100 *.png Outputfile.mpeg');
        case 'gif'
            commandStr = 'PATH=$PATH:/usr/local/bin;convert';
            delay      = round(100/fps);
            commandStr = [commandStr ' -set delay ' int2str(delay)];
            commandStr = [commandStr ' +dither ' movieDir '/*.png ' fileName];
            [status, cmdout] = system(commandStr);
    end
    
    if(status)
        warning(['The command ''' commandStr ''' failed to produce a movie! Error message:'])
        disp(cmdout);
    end
    
catch exception
    
    throw(exception)
    
end

% delete tmp dir
[status, message, ~] = rmdir(movieDir, 's');
if(not(status))
    disp(message)
end


end