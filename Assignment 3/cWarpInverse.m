function [image_result, trans] = cWarpInverse(image, basePoints, movingPoints)
%cWarpInverse Summary of this function goes here
%   Detailed explanation goes here
    
    trans = cp2tform(basePoints, movingPoints, 'projective');
    
    image_result = cWarpInverse_doTransform(image, trans);
end
