function [image_g] = imgamma(image_rgb, gamma_value)
%imgamma Summary of this function goes here
%   Detailed explanation goes here
    [height, width, dim] = size(image_rgb);
    
    image_ratios_d = zeros(height, width, dim);
    image_g = zeros(height, width, dim);
    
    image_gray = rgb2gray(image_rgb);
    
    for n = 1:dim
        image_ratios_d(:, :, n) = image_rgb(:, :, n) ./ image_gray;
    end
    
    image_gray = image_gray .^ (1. / double(gamma_value));
    
    for n = 1:dim
        image_g(:, :, n) = image_ratios_d(:, :, n) .* image_gray;
    end
end
