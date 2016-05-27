image_i = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignment 2\test.pgm');
image_d = im2double(image_i);

image_debayered_d = debayer(image_d);
imshow(image_debayered_d);

[x, y] = getpts();
x = uint16(x);
y = uint16(y);

image_wb_d = whitebalance(image_debayered_d, x, y);
imshow(image_wb_d);

image_gamma_d = imgamma(image_wb_d, 2.2);
imshow(image_gamma_d);


image_uneq = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignment 2\uneqImg.jpg');
image_uneq = rgb2gray(image_uneq);
image_eq = histoEqual(image_uneq);
imshow(image_eq);
