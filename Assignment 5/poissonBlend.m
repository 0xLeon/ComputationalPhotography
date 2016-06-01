function [imBlended] = poissonBlend(sourceImage, targetImage, mask, cIteration)
%poissonBlend Summary of this function goes here
%   Detailed explanation goes here
    
    [height, width, dim] = size(targetImage);
    [heightS, widthS, dimS] = size(sourceImage);
    [heightM, widthM, ~] = size(mask);
    
    if (height ~= heightS) || (width ~= widthS) || (dim ~= dimS) 
        error('Images don''t match in dimensionality!');
    end
    
    if (height ~= heightM) || (width ~= widthM)
        error('Mask size doesn''t match image size!');
    end
    
    if dim > 1
        error('Images can''t have more than one channel!');
    end
    
    didConvert = false;
    
    if isa(sourceImage, 'integer')
       sourceImage = im2double(sourceImage);
       didConvert = true;
    end
    
    if isa(targetImage, 'integer')
        targetImage = im2double(targetImage);
        didConvert = true;
    end
    
    if ~isa(mask, 'logical')
        mask = im2bw(mask);
    end
    
    lapFilter = [0, -1, 0; -1, 4, -1; 0, -1, 0];
    
    g = imgradient(sourceImage);
    
    currImage = targetImage .* ~mask + g .* mask;
    b = imfilter(sourceImage, lapFilter, 'replicate');
    
    for i = 1:cIteration
        r = b - imfilter(currImage, lapFilter, 'replicate');
        
        currImage = currImage + (((sum(dot(r, r)) / sum(dot(r, imfilter(r, lapFilter, 'replicate')))) * r) .* mask);
    end
    
    imBlended = currImage;
    
    if didConvert
        imBlended = im2uint8(imBlended);
    end
end
