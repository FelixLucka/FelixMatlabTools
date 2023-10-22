function RGB = arrangeRGB(RGB_cell, ratio, frame_sz, frame_colour)
%ARRANGERGB CAN BE USED TO ARRANGE MULTIPLE IMAGES INTO A SINGLE IMAGE
%
% DETAILS: 
%   arrangeRGB.m can be used to arrange multiple rgb image of the same size
%   into a table arrangement 
%
% USAGE:
%   RGB = arrangeRGB({rand([100,100,3]), rand([100,100,3])}, 2, 20, [1,0,0])
%
% INPUTS:
%   RGB_cell - cell of rgb images 
%
% OPTIONAL INPUTS:
%   ratio - desired ration between width and heigth of the composed picture
%   frame_sz - size of the frame around each image in pixel
%   frame_color - rgb vector determining the color of the frame
%
% OUTPUTS:
%   RGB - single RGB image of the composition
%
% ABOUT:
%       author          - Felix Lucka
%       date            - 19.12.2018
%       last update     - 13.10.2023
%
% See also

% check user defined value for ratio, otherwise assign default value
if(nargin < 2 | isempty(ratio))
   screen_info  = get( groot, 'Screensize' );
   ratio        = screen_info(3)/screen_info(4);
end

% check user defined value for z, otherwise assign default value
if(nargin < 3)
   frame_sz = 1;
end

% check user defined value for z, otherwise assign default value
if(nargin < 4)
   frame_colour = [1,1,1];
end



RGB_cell = RGB_cell(:);
n_rgb    = length(RGB_cell);

% add frame
for i=1:n_rgb
    RGB_cell{i} = addFrameRGB(RGB_cell{i}, frame_sz, frame_colour);  
end

n_x      = size(RGB_cell{1},1);
n_y      = size(RGB_cell{1},2);
% find layout
n_rows   = 1;
n_cols   = 1;
while(n_rows * n_cols < n_rgb)
   size_one_more_row  = [(n_rows+1) * n_x, n_cols * n_y]; 
   ratio_one_more_row = size_one_more_row(2) / size_one_more_row(1);
   size_one_more_col  = [n_rows * n_x, (n_cols+1) * n_y]; 
   ratio_one_more_col = size_one_more_col(2) / size_one_more_col(1);
   % chose the configuration that is close to the desired ratio (in log
   % scale)
   if(abs(log(ratio_one_more_row/ratio)) >  abs(log(ratio_one_more_col/ratio)))
      % one more column wins
      n_cols = n_cols + 1;
   else
      n_rows = n_rows + 1;
   end
end

% append empy images
n_missing  = n_rows * n_cols - n_rgb;
for i=1:n_missing
    RGB_cell{end+1} = bsxfun(@times, ones(n_x,n_y,3), reshape(frame_colour,[1,1,3]));
end

RGB_cell = reshape(RGB_cell, n_rows, n_cols);
RGB      = cell2mat(RGB_cell);

end