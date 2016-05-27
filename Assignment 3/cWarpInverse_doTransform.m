function [image_result, offset_y, offset_x] = cWarpInverse_doTransform(image, trans)
%cWarpInverse Summary of this function goes here
%   Detailed explanation goes here
    
    [height, width, ~] = size(image);
    [image_result, new_height, new_width, offset_y, offset_x] = cWarpNewImage(image, trans);
    
    for y_new = 1:new_height
        for x_new = 1:new_width
            original_coord = trans.tdata.Tinv' * double([x_new - offset_x; y_new - offset_y; 1.0]);
            original_coord = original_coord / original_coord(3);
            
            if (original_coord(1) > 1) && (original_coord(2) > 1) && (original_coord(1) < width) && (original_coord(2) < height)
                x_lower = floor(original_coord(1));
                x_upper = ceil(original_coord(1));
                y_lower = floor(original_coord(2));
                y_upper = ceil(original_coord(2));
                
                x_delta_lower = original_coord(1) - x_lower;
                x_delta_upper = x_upper - original_coord(1);
                y_delta_lower = original_coord(2) - y_lower;
                y_delta_upper = y_upper - original_coord(2);
            
                image_result(y_new, x_new, :) = image(y_lower, x_lower, :) * (x_delta_upper * y_delta_upper) + image(y_lower, x_upper, :) * (x_delta_lower * y_delta_upper) + image(y_upper, x_lower, :) * (x_delta_upper * y_delta_lower) + image(y_upper, x_upper, :) * (x_delta_lower * y_delta_lower);
           
%                 x_round = round(original_coord(1));
%                 y_round = round(original_coord(2));
%                 
%                 image_result(y_new, x_new, :) = image(y_round, x_round, :);
            end
        end
    end
end
