bg = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignments\Assignment 5\bg.jpg');
source = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignments\Assignment 5\source.jpg');
mask = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignments\Assignment 5\mask.jpg');
bg = im2double(rgb2gray(bg));
source = im2double(rgb2gray(source));
mask = im2bw(mask);
blended = poissonBlend(source, bg, mask, 200);
imshow(blended);

ausBG = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignments\Assignment 5\Aus-Bg.jpg');
ausOver = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignments\Assignment 5\Aus-Over.jpg');
ausMask = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignments\Assignment 5\Aus-Mask.jpg');
ausBG = im2double(ausBG);
ausOver = im2double(ausOver);
ausMask = im2bw(ausMask);
ausBlended = poissonBlendRGB(ausOver, ausBG, ausMask, 2000);
imshow(ausBlended);
