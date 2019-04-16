function printFigure(figH, para)
%PRINTFIGURE prints a figure to different formats
%
% USAGE:
%   printFigure(figH, struct('png', true, 'pdf', true))
%
% INPUTS:
%   figH - handle to figure
%
% OPTIONAL INPUTS:
%   para - a struct containing further optional parameters:
%       'png' - logical indicating wether the figure should be printed to
%       png format
%       'tiff' - logical indicating wether the figure should be printed to
%       tiff format
%       'pdf' - logical indicating wether the figure should be printed to
%       pdf format
%       'eps' - logical indicating wether the figure should be printed to
%       eps format
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 03.12.2018
%       last update     - 03.12.2018
%
% See also printRGB

drawnow();

% check user defined value for para, otherwise assign default value
if(nargin < 2)
    para = [];
end

fileName = check_and_assign_struc(para, 'fileName', 'char', 'figure');
png      = checkSetInput(para, 'png',  'logical', true);
tiff     = checkSetInput(para, 'tiff', 'logical', false);
pdf      = checkSetInput(para, 'pdf',  'logical', false);
eps      = checkSetInput(para, 'eps',  'logical', false);

% print to png
if(png)
    eval(['print(figH,''' fileName '.png'',''-r600'',''-dpng'');']);
end

% print to tiff
if(tiff)
    eval(['print(figH,''' fileName '.tiff'',''-r600'',''-dtiff'');']);
end

% print to pdf and cut margins
if(pdf)

    eval(['print(figH,''' fileName '.pdf'',''-r600'',''-dpdf'');']);
    status = 0;
    
    % use pdfcrop to crop margins
    if(isunix && ~ismac)
        [status,result] = system(['pdfcrop --margins 2 ' fileName '.pdf ' fileName '.pdf']);
    elseif(ismac)
        % little workaround: write and execute shell script
        fid = fopen('script.sh','w');
        fprintf(fid,'%s\n','#!/bin/bash');
        fprintf(fid,'%s\n','export PATH=''/sw/bin:/sw/sbin:/usr/bin:/bin:/usr/sbin:/sbin:/usr/local/bin:/usr/texbin:/usr/X11/bin:/usr/X11R6/bin''');
        fprintf(fid,'%s\n',['pdfcrop --margins 2 ' fileName '.pdf ' fileName '.pdf']);
        fclose(fid);
        
        [status,result] = system('/bin/bash script.sh');
        delete script.sh
    end
    
    if(status ~= 0)
        result
    end
    
end

if(eps)
    eval(['print(figH,''' fileName '.eps'',''-r600'',''-depsc'');']);
end

end
