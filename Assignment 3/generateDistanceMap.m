function [distance_map] = generateDistanceMap(image)
%generateDistanceMap Summary of this function goes here
%   Detailed explanation goes here
    [height, width, ~] = size(image);
    
    half_height = double(height) / 2.0;
    half_width = double(width) / 2.0;
    
    distance_map = zeros(height, width);
    
    for y = 1:height
        for x = 1:width
            if (x <= half_width)
                distance_map(y, x) = double(x) / half_width;
            else
                distance_map(y, x) = 1.0 - (double(x) - half_width) / half_width;
            end
            
            if (y <= half_height)
                distance_map(y, x) = distance_map(y, x) * (double(y) / half_height);
            else
                distance_map(y, x) = distance_map(y, x) * (1.0 - (double(y) - half_height) / half_height);
            end
        end
    end
end
