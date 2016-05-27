function [new_image, new_height, new_width, offset_y, offset_x] = cWarpNewImage(image, trans)
%cWarpNewImage Summary of this function goes here
%   Detailed explanation goes here
    
    [height, width, dim] = size(image);
    
    % transform corners of image first
    new_upper_left = (trans.tdata.T' * [1; 1; 1]);
    new_upper_left = int32(floor(new_upper_left / new_upper_left(3)));
    
    new_upper_right = (trans.tdata.T' * [width; 1; 1]);
    new_upper_right = new_upper_right / new_upper_right(3);
    new_upper_right(1) = ceil(new_upper_right(1));
    new_upper_right(2) = floor(new_upper_right(2));
    new_upper_right = int32(new_upper_right);
    
    new_lower_left = (trans.tdata.T' * [1; height; 1]);
    new_lower_left = new_lower_left / new_lower_left(3);
    new_lower_left(1) = floor(new_lower_left(1));
    new_lower_left(2) = ceil(new_lower_left(2));
    new_lower_left = int32(new_lower_left);
    
    new_lower_right = (trans.tdata.T' * [width; height; 1]);
    new_lower_right = int32(ceil(new_lower_right / new_lower_right(3)));
    
    % calc new corners
    min_new_x = min([new_upper_left(1), new_upper_right(1), new_lower_left(1), new_lower_right(1)]);
    min_new_y = min([new_upper_left(2), new_upper_right(2), new_lower_left(2), new_lower_right(2)]);
    max_new_x = max([new_upper_left(1), new_upper_right(1), new_lower_left(1), new_lower_right(1)]);
    max_new_y = max([new_upper_left(2), new_upper_right(2), new_lower_left(2), new_lower_right(2)]);
    
    % calc new dimensions
    new_height = max_new_y - min_new_y;
    new_width = max_new_x - min_new_x;
    
    offset_x = 1 - min_new_x;
    offset_y = 1 - min_new_y;
    
    new_image = zeros(new_height, new_width, dim);
    
    if (isa(image, 'integer'))
        new_image = im2uint8(new_image);
    end
end
