function res = mssim(x, ref, channelDim)


sizeX  = size(x);
nDimsX = nDims(x);

if(nargin < 3)
    switch nDimsX
        case {2,3}
            imageDim   = 2;
            channelDim = 3;
        case 4
            imageDim   = 3;
            channelDim = 4;
        otherwise
            imageDim   = 2;
            channelDim = sizeX(3:end);
    end
else
    imageDim = (channelDim-1);
end

% reshape x
x   = reshape(x,   [sizeX(1:imageDim), prod(sizeX(channelDim))]);
ref = reshape(ref, [sizeX(1:imageDim), prod(sizeX(channelDim))]);

res   = 0;
for i = 1 : size(x, 3)
    switch imageDim
        case 2
            res = res + ssim( x(:, :, i), ref(:, :, i));
        case 3
            res = res + ssim( x(:, :, :, i), ref(:, :, :, i));
    end
end
res = res / size(x, 3);

end
