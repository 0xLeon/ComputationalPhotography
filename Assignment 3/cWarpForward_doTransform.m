function [image_result, offset_y, offset_x] = cWarpForward_doTransform(image, trans)
%cWarpForward_doTransform Summary of this function goes here
%   Detailed explanation goes here
    
    [height, width, ~] = size(image);
    [image_result, new_height, new_width, offset_y, offset_x] = cWarpNewImage(image, trans);
    
    for y = 1:height
        for x = 1:width
            new_coord = trans.tdata.T' * [x; y; 1];
            new_coord = int32(round(new_coord / new_coord(3)));
            
            new_coord(1) = new_coord(1) + offset_x;
            new_coord(2) = new_coord(2) + offset_y;
            
            if (new_coord(1) > 0) && (new_coord(2) > 0) && (new_coord(1) <= new_width) && (new_coord(2) <= new_height)
                image_result(new_coord(2), new_coord(1), :) = image(y, x, :);
            end
        end
    end
end
