function [image_result, trans] = cWarpForward(image, basePoints, movingPoints)
%cWarpForward Summary of this function goes here
%   Detailed explanation goes here
    
    trans = cp2tform(basePoints, movingPoints, 'projective');
    
    image_result = cWarpForward_doTransform(image, trans);
end
