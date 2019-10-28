function printRGB(RGB, para)
% PRINTRGB prints an RGB to a png file using imwrite
%
%  USAGE:
%   printRGB(rand(120,120,3), [])
%
%  INPUTS:
%   RGB    - a RGB image of size [n,m,3]
%   para - a struct containing optional parameters
%       'flip'        - a string specifying whether the image should be
%                       fliped before printing
%       'fileName'    - a string specifying the filename 
%       'printPixPerPix' - a array of the form [nX nY] specifying how many pixels should be used for printing 
%                          a pixel in the RGB image. Can be used to increase strech the image in certain directions
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 05.11.2018
%       last update     - 05.11.2018
%
% See also movieFromRGB


% split the RGB into the color channels
R = RGB(:,:,1);
G = RGB(:,:,2);
B = RGB(:,:,3);

flip = checkSetInput(para, 'flip', {'none','ud'}, 'none');
switch flip
    case 'ud'
        R = flipud(R);
        G = flipud(G);
        B = flipud(B);
end

printPixPerPix = checkSetInput(para, 'printPixPerPix', 'i,>0', [1 1]);
if(~isequal(printPixPerPix, [1,1]))
    R = IncImageRes(R, printPixPerPix);
    G = IncImageRes(G, printPixPerPix);
    B = IncImageRes(B, printPixPerPix);
end

% re-unite it to an RGB
RGB = cat(3, R, G, B);


fileName = checkSetInput(para,'fileName','char','dfRGBfile.png');
% attach '.png' is missing.
if(length(fileName) < 4 || ~strcmp(fileName(end-3:end),'.png'))
    fileName = [fileName '.png'];
end

% use imwrite to print it
imwrite(RGB, fileName,'png','bitdepth',8)

end