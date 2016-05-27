function [morphSequence] = morph(im1, im2, pIm1, pIm2, tStep)
%morph Summary of this function goes here
%   Detailed explanation goes here
    
    if (tStep <= 0) || (tStep > 1)
        error('Invalid time step');
    end
    
    if isa(im1, 'integer')
        im1 = im2double(im1);
    end
    
    if isa(im2, 'integer')
       im2 = im2double(im2); 
    end
    
    [height, width, dim] = size(im1);
    stepCount = int32(ceil(1.0 / tStep));
    loopStart = int32(2);
    loopEnd = int32(stepCount - 1);
    
    morphSequence(1:stepCount) = struct('cdata', [], 'colormap', []);
    
    pAvg = (pIm1 + pIm2) / 2.0;
    avgTRI = delaunayTriangulation(pAvg);
    avgTri = avgTRI(:, :);
    [triCount, ~] = size(avgTri);
    
    f = figure();
    
    figure(f);
    imshow(im1);
    morphSequence(1) = getframe(gca);
    
    parpool(2);
    
    t = tStep;
    for c = loopStart:loopEnd
        tInv = 1.0 - t;
        pCurrAvg = tInv * pIm1 + t * pIm2;
        transformsOneToAvg = zeros(triCount, 3, 3);
        transformsTwoToAvg = zeros(triCount, 3, 3);
        
        parfor n = 1:triCount
            currentTriIndices = avgTri(n, :);
            currentTriOne = [pIm1(currentTriIndices(1), :); pIm1(currentTriIndices(2), :); pIm1(currentTriIndices(3), :)];
            currentTriTwo = [pIm2(currentTriIndices(1), :); pIm2(currentTriIndices(2), :); pIm2(currentTriIndices(3), :)];
            currentTriAvg = [pCurrAvg(currentTriIndices(1), :); pCurrAvg(currentTriIndices(2), :); pCurrAvg(currentTriIndices(3), :)];
            
            currTransformOneToAvg = fitgeotrans(currentTriAvg, currentTriOne, 'affine');
            currTransformTwoToAvg = fitgeotrans(currentTriAvg, currentTriTwo, 'affine');
            
            transformsOneToAvg(n, :, :) = (currTransformOneToAvg.T)';
            transformsTwoToAvg(n, :, :) = (currTransformTwoToAvg.T)';
        end
        
        currentImage = zeros(height, width, dim);
        
        parfor y = 1:height
            for x = 1:width
                triIndex = pointLocation(avgTRI, x, y);
                
                coordInOne = squeeze(transformsOneToAvg(triIndex, :, :)) * double([x; y; 1.0]);
                coordInTwo = squeeze(transformsTwoToAvg(triIndex, :, :)) * double([x; y; 1.0]);
                
                colorInOne = zeros(3, 1);
                colorInTwo = zeros(3, 1);
                
                if (coordInOne(1) >= 1) && (coordInOne(2) >= 1) && (coordInOne(1) <= width) && (coordInOne(2) <= height)
                    colorInOne = bilinearInterpolate(im1, coordInOne(1), coordInOne(2));
                end
                
                if (coordInTwo(1) >= 1) && (coordInTwo(2) >= 1) && (coordInTwo(1) <= width) && (coordInTwo(2) <= height)
                    colorInTwo = bilinearInterpolate(im2, coordInTwo(1), coordInTwo(2));
                end
                
                currentImage(y, x, :) = tInv * colorInOne + t * colorInTwo;
            end
        end
        
        figure(f);
        imshow(currentImage);
        morphSequence(c) = getframe(gca);
        
        t = t + tStep;
        t = min([t, 1.0]);
    end
        
    delete(gcp('nocreate'));
    
    figure(f);
    imshow(im2);
    morphSequence(stepCount) = getframe(gca);
    close(f);
end

function [color] = bilinearInterpolate(image, x, y)
    x_lower = floor(x);
    x_upper = ceil(x);
    y_lower = floor(y);
    y_upper = ceil(y);

    x_delta_lower = x - x_lower;
    x_delta_upper = x_upper - x;
    y_delta_lower = y - y_lower;
    y_delta_upper = y_upper - y;
   
    color = image(y_lower, x_lower, :) * (x_delta_upper * y_delta_upper) + image(y_lower, x_upper, :) * (x_delta_lower * y_delta_upper) + image(y_upper, x_lower, :) * (x_delta_upper * y_delta_lower) + image(y_upper, x_upper, :) * (x_delta_lower * y_delta_lower);
    
%    color = image(round(y), round(x), :);
    color = squeeze(color);
end
