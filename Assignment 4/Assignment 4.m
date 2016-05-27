im1 = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignment 4\cranston1.jpg');
im2 = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignment 4\cranston2.jpg');
[pIm1, pIm2] = cpselect(im1, im2, 'WAIT', true);
pAvg = (pIm1 + pIm2) / 2.0;
tri = delaunayTriangulation(pAvg);

figure; imshow(im1);
hold on; triplot(tri(:, :), pAvg(:, 1), pAvg(:, 2));
figure; imshow(im2);
hold on; triplot(tri(:, :), pAvg(:, 1), pAvg(:, 2));


m = morph(im1, im2, pIm1, pIm2, 0.01);
movie(m, 1, 15);
movie2gif(m, 'C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignment 4\BreakingBad.gif', 1.0 / 15.0, 25);
movie2avi(m, 'C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignment 4\BreakingBad.avi', 'compression', 'none', 'fps', 15);
