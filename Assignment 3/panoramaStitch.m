function [combined_image, combined_weight_map, nextImage_t, H] = panoramaStitch(baseImage, nextImage, basePoints, movingPoints)
%panoramaStitch Summary of this function goes here
%   Detailed explanation goes here
    nPoints = size(basePoints, 1);
    A = zeros(2 * nPoints, 9);
    
    A(1:2:end, 1:2) = -basePoints;
    A(2:2:end, 4:5) = -basePoints;
    
    A(1:2:end, 3) = -1;
    A(2:2:end, 6) = -1;
    
    A(1:2:end, 7) = basePoints(:, 1) .* movingPoints(:, 1);
    A(2:2:end, 7) = basePoints(:, 1) .* movingPoints(:, 2);
    
    A(1:2:end, 8) = basePoints(:, 2) .* movingPoints(:, 1);
    A(2:2:end, 8) = basePoints(:, 2) .* movingPoints(:, 2);
    
    A(1:2:end, 9) = movingPoints(:, 1);
    A(2:2:end, 9) = movingPoints(:, 2);
    
    [~, ~, V] = svd(A);
    
    H = reshape(V(:, end), 3, 3);
    
    trans = maketform('projective', inv(H));
    
    [baseHeight, baseWidth, dim] = size(baseImage);
    wChan = dim + 1;
    didDoubleConvert = false;
    
    if isa(baseImage, 'integer')
        baseImage = im2double(baseImage);
        didDoubleConvert = true;
    end
    
    if isa(nextImage, 'integer')
        nextImage = im2double(nextImage);
        didDoubleConvert = true;
    end
    
    baseImage(:, :, wChan) = generateDistanceMap(baseImage);
    nextImage(:, :, wChan) = generateDistanceMap(nextImage);
    
    [nextImage_t, offset_y, offset_x] = cWarpInverse_doTransform(nextImage, trans);
    
    [next_tHeight, next_tWidth, ~] = size(nextImage_t);
    
    % get transformed correspondence point from transformed image
    % map this point to the corresponding point in the base image
    corr_t = trans.tdata.T' * [movingPoints(1, :)'; 1.0];
    corr_t = int32(round(corr_t / corr_t(3))) + [offset_x; offset_y; 0];
    
    comb_trans_upper_left  = [basePoints(1, 1) + (1 - corr_t(1));           basePoints(1, 2) + (1 - corr_t(2))];
    comb_trans_upper_right = [basePoints(1, 1) + (next_tWidth - corr_t(1)); basePoints(1, 2) + (1 - corr_t(2))];
    comb_trans_lower_left  = [basePoints(1, 1) + (1 - corr_t(1));           basePoints(1, 2) + (next_tHeight - corr_t(2))];
    comb_trans_lower_right = [basePoints(1, 1) + (next_tWidth - corr_t(1)); basePoints(1, 2) + (next_tHeight - corr_t(2))];
    
    comb_trans_min_x = min([comb_trans_upper_left(1), comb_trans_upper_right(1), comb_trans_lower_left(1), comb_trans_lower_right(1)]);
    comb_trans_min_y = min([comb_trans_upper_left(2), comb_trans_upper_right(2), comb_trans_lower_left(2), comb_trans_lower_right(2)]);
    
    comb_trans_max_x = max([comb_trans_upper_left(1), comb_trans_upper_right(1), comb_trans_lower_left(1), comb_trans_lower_right(1)]);
    comb_trans_max_y = max([comb_trans_upper_left(2), comb_trans_upper_right(2), comb_trans_lower_left(2), comb_trans_lower_right(2)]);
    
    
    comb_min_x = min([1, comb_trans_min_x]);
    comb_min_y = min([1, comb_trans_min_y]);
    
    comb_max_x = max([baseWidth, comb_trans_max_x]);
    comb_max_y = max([baseHeight, comb_trans_max_y]);
    
    comb_base_offset_x = 1 - comb_min_x;
    comb_base_offset_y = 1 - comb_min_y;
    
    comb_trans_offset_x = abs(offset_x) - comb_base_offset_x;
    comb_trans_offset_y = abs(offset_y) - comb_base_offset_y;
    
    comb_width = comb_max_x - comb_min_x + 1;
    comb_height = comb_max_y - comb_min_y + 1;
    
    combined_image = zeros(comb_height, comb_width, dim + 1);
    
    
    for y = 1:baseHeight
        for x = 1:baseWidth
            combined_image(y + comb_base_offset_y, x + comb_base_offset_x, 1:dim) = baseImage(y, x, wChan) * baseImage(y, x, 1:dim);
            combined_image(y + comb_base_offset_y, x + comb_base_offset_x, wChan) = baseImage(y, x, wChan);
        end
    end
    
    for y = 1:next_tHeight
        for x = 1:next_tWidth
            if (max(nextImage_t(y, x, :)) > 0)
                combined_image(y + comb_trans_offset_y, x + comb_trans_offset_x, 1:dim) = combined_image(y + comb_trans_offset_y, x + comb_trans_offset_x, 1:dim) + nextImage_t(y, x, wChan) * nextImage_t(y, x, 1:dim);
                combined_image(y + comb_trans_offset_y, x + comb_trans_offset_x, wChan) = combined_image(y + comb_trans_offset_y, x + comb_trans_offset_x, wChan) + nextImage_t(y, x, wChan);
            end
        end
    end
    
    for n = 1:dim
        combined_image(:, :, n) = combined_image(:, :, n) ./ combined_image(:, :, wChan); 
    end
    
    combined_weight_map = combined_image(:, :, wChan);
    
    combined_image(:, :, wChan) = [];
    nextImage_t(:, :, wChan) = [];
    
    if didDoubleConvert
       combined_image = im2uint8(combined_image);
       nextImage_t = im2uint8(nextImage_t);
    end
end
