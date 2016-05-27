function [image_eq] = histoEqual(image)
%histoEqual Summary of this function goes here
%   Detailed explanation goes here
    [height, width, dim] = size(image);
    
    if dim ~= 1
        image = rgb2gray(image);
    end
    
    h = imhist(image);
    h_cum = cumsum(h);
    
    [h_height, ~] = size(h);
    
    h_min = h_height;
    
    for n = h_height:-1:1
        if (h_cum(n) > 0) && (h_cum(n) < h_min)
            h_min = h_cum(n);
        end
    end
    
    image_eq = uint8(zeros(height, width));
    
    image_eq(:, :) = round((((h_cum(image(:, :)) - h_min)) / (height * width - h_min)) * (h_height - 1));
end
