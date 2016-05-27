function [image_wb] = whitebalance(image_rgb, x, y)
%whitebalance Summary of this function goes here
%   Detailed explanation goes here
    [cx, ~] = size(x);
    [cy, ~] = size(y);
    [height, width, dim] = size(image_rgb);
    rgb_sum = zeros(1, dim);
    
    if cx ~= cy
        error('x and y missmatch in length');
    end
    
    x = uint16(x);
    y = uint16(y);
    
    image_wb = zeros(height, width, dim);
    
    for n = 1:cx
        for m = 1:dim
           rgb_sum(m) = rgb_sum(m) + image_rgb(y(n), x(n), m);
        end
    end
    
    rgb_sum = rgb_sum / cx;
    
    for n = 1:dim
       image_wb(:, :, n) = image_rgb(:, :, n) * (1. / rgb_sum(n)); 
    end
end
