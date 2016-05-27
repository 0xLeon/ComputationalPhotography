function movie2gif(m, filename, delay, holdLast)
%movie2gif Summary of this function goes here
%   Detailed explanation goes here
    [~, frameCount] = size(m);
    
    im = frame2im(m(1));
    [A, map] = rgb2ind(im, 256);
    imwrite(A, map, filename, 'gif', 'LoopCount', inf, 'DelayTime', delay);
    
    for n = 2:frameCount
        im = frame2im(m(n));
        [A, map] = rgb2ind(im, 256);
        imwrite(A, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
    end
    
    for n = 0:holdLast
        imwrite(A, map, filename, 'gif', 'WriteMode', 'append', 'DelayTime', delay);
    end
end
