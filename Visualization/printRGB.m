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
%       last update     - 20.10.2032
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

print_pix_per_pix = checkSetInput(para, 'printPixPerPix', 'i,>0', [1 1]);
if(~isequal(print_pix_per_pix, [1,1]))
    R = incImageRes(R, print_pix_per_pix);
    G = incImageRes(G, print_pix_per_pix);
    B = incImageRes(B, print_pix_per_pix);
end

% re-unite it to an RGB
RGB = cat(3, R, G, B);


file_name = checkSetInput(para,'fileName','char','dfRGBfile.png');
% attach '.png' if it is missing.
if(length(file_name) < 4 || ~strcmp(file_name(end-3:end),'.png'))
    file_name = [file_name '.png'];
end

% use imwrite to print it
error_count = 0;
while(1)
    try
        imwrite(RGB, file_name,'png','bitdepth',8)
        break
    catch ME
        if (error_count == 10 || ~strcmp(ME.identifier,'MATLAB:imagesci:png:libraryFailure'))
            rethrow(ME)
        else
            error_count = error_count + 1;
            pause(0.1)
        end
    end
end

end