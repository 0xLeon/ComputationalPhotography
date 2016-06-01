function [imBlended] = poissonBlendRGB(sourceImage, targetImage, mask, cIteration)
%poissonBlendRGB Summary of this function goes here
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
    
    imBlended = zeros(height, width, dim);
    
    cluster = parcluster('local');
    workerCount = cluster.NumWorkers;
    cluster.NumWorkers = dim;
    saveProfile(cluster);
    
    parpool(dim);
    
    parfor i = 1:dim
       imBlended(:, :, i) = poissonBlend(squeeze(sourceImage(:, :, i)), squeeze(targetImage(:, :, i)), mask, cIteration);
    end
    
    delete(gcp('nocreate'));
    
    cluster.NumWorkers = workerCount;
    saveProfile(cluster);
    
    if didConvert
        imBlended = im2uint8(imBlended);
    end
end
