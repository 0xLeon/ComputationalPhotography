function [image_rgb] = debayer(image_raw)
%debayer Summary of this function goes here
%   Detailed explanation goes here
    [height, width] = size(image_raw);
    mask_a = .25 * [1, 0, 1; 0, 0, 0; 1, 0, 1];
    mask_b = .5  * [0, 1, 0; 0, 0, 0; 0, 1, 0];
    mask_c = .5  * [0, 0, 0; 1, 0, 1; 0, 0, 0];
    mask_d = .25 * [0, 1, 0; 1, 0, 1; 0, 1, 0];
    
    image_channels = zeros(height, width, 3);
    image_channels(1:2:height, 1:2:width, 1) = image_raw(1:2:height, 1:2:width);
    image_channels(1:2:height, 2:2:width, 2) = image_raw(1:2:height, 2:2:width);
    image_channels(2:2:height, 1:2:width, 2) = image_raw(2:2:height, 1:2:width);
    image_channels(2:2:height, 2:2:width, 3) = image_raw(2:2:height, 2:2:width);
    
    image_channels_r = image_channels(:, :, 1);
    image_channels_g = image_channels(:, :, 2);
    image_channels_b = image_channels(:, :, 3);
    
    image_channels_r = image_channels_r + imfilter(image_channels(:, :, 1), mask_a);
    image_channels_r = image_channels_r + imfilter(image_channels(:, :, 1), mask_b);
    image_channels_r = image_channels_r + imfilter(image_channels(:, :, 1), mask_c);
    image_channels_g = image_channels_g + imfilter(image_channels(:, :, 2), mask_d);
    image_channels_b = image_channels_b + imfilter(image_channels(:, :, 3), mask_a);
    image_channels_b = image_channels_b + imfilter(image_channels(:, :, 3), mask_b);
    image_channels_b = image_channels_b + imfilter(image_channels(:, :, 3), mask_c);
    
    image_rgb = zeros(height, width, 3);
    image_rgb(:, :, 1) = image_channels_r;
    image_rgb(:, :, 2) = image_channels_g;
    image_rgb(:, :, 3) = image_channels_b;
end
