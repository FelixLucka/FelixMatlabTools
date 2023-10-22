function movieFromRGB(RGB_cell, para)
% MOVIEFROMRGB creates a movie file from a cell of RGBs
%
% USAGE:
%  movieFromRGB(RGB_cell,para)
%
%  INPUTS:
%   RGB_cell - cell of same-size RGBs
%   para - a struct containing optional parameters
%       'fileType'    - 'gif' for an animated .gif or 'mpeg' (not
%       implemented yet)
%       'fps'     - frames per second
%       'fileName' - full file name of the output file
%
% ABOUT:
%   author          - Felix Lucka
%   date            - 13.12.2017
%   last update     - 14.10.2023
%
% See also printRGB

% check if we are on a unix system
if(~isunix)
    error('movieFromRGB.m will only run on a unix system')
end

% make a temporary dir in the home directory
[movie_dir, dir_exist] = makeDir('~/tmpMovieFromRGB', false);
if(dir_exist)
    error('temporal directory to be used for the generation of the animated gif does already exist!')
end

% print all RGBs to png files called im000001.png, im0000002.png, etc
print_para = para;
for i_frame = 1:length(RGB_cell)
    print_para.fileName = [movie_dir '/im' int2strLead0(i_frame, 6)];
    printRGB(RGB_cell{i_frame}, print_para);
end

% read out file name and type
file_type = checkSetInput(para, 'fileType', {'gif', 'mpeg', 'mp4'}, 'gif');
fps       = checkSetInput(para, 'fps', 'double', 1);

file_name = checkSetInput(para, 'fileName', 'char', 'movie');
% attach '.fileType' if missing.
if(length(file_name) < 4 || ~strcmp(file_name(end-3:end), ['.' file_type]))
    file_name = [file_name '.' file_type];
end


% convert the pngs to a movie file using convert
try
    
    switch file_type
        case 'mp4'
            kbit_rate    = checkSetInput(para, 'kbitrate', 'i,> 0', 5000); 
            command_str  = ['ffmpeg -i ' movie_dir '/im%6d.png -framerate ' int2str(fps) ...
                                  ' -pix_fmt yuv420p -vcodec libx264 -b ' int2str(kbit_rate) 'k '...
                                  file_name];
        case 'mpeg'
            % does, for some reason, not work on Mac
            oldImpErr
            command_str = 'PATH=$PATH:/usr/local/bin;convert -quality 100 *.png Outputfile.mpeg';
        case 'gif'
            command_str = 'PATH=$PATH:/usr/local/bin;convert';
            delay      = round(100/fps);
            command_str = [command_str ' -set delay ' int2str(delay)];
            command_str = [command_str ' +dither ' movie_dir '/*.png ' file_name];
    end
    [status, cmdout] = system(command_str);
    
    if(status)
        warning(['The command ''' command_str ''' failed to produce a movie! Error message:'])
        disp(cmdout);
    end
    
catch exception
    
    throw(exception)
    
end

% delete tmp dir
[status, message, ~] = rmdir(movie_dir, 's');
if(not(status))
    disp(message)
end


end