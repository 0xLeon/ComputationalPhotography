parrot = imread('C:\Users\hahnstef\Downloads\parrot.jpg');
[height width dim] = size(parrot);
parrot_d = im2double(parrot);

parrot_d_bright_add = parrot_d + .2;
imshow(parrot_d_bright_add)

parrot_d_bright_mult = zeros(height, width, dim);
parrot_d_bright_mult(:, :, 1) = parrot_d(:, :, 1) * .2;
parrot_d_bright_mult(:, :, 2) = parrot_d(:, :, 2) * .8;
parrot_d_bright_mult(:, :, 3) = parrot_d(:, :, 3) * .1;
imshow(parrot_d_bright_mult)

parrot_d_gray = parrot_d(:, :, 1) * .3 + parrot_d(:, :, 2) * .6 + parrot_d(:, :, 3) * .1;
imshow(parrot_d_gray)

parrot_d_slice = parrot_d;
parrot_d_slice(uint16(height * .75), :, :) = 1.;
parrot_d_slice(:, uint16(width * .25), :) = 1.;
imshow(parrot_d_slice)

slice_x1 = uint16(width * .8);
slice_x2 = slice_x1 + 3;
slice_y1 = uint16(height * .2);
slice_y2 = slice_y1 + 3;
parrot_d_slice(slice_y1:slice_y2, slice_x1:slice_x2, :) = 1.;
imshow(parrot_d_slice)

rgbtoyuv = [.299, .587, .114; -.14713, -.28886, .436; .615, -.51499, -.10001];
yuvtorgb = [1., 0, 1.13983; 1., -.39465, -.5806; 1., 2.03211, 0];

parrot_d_yuv = reshape(parrot_d, height * width, 3) * rgbtoyuv';
parrot_d_yuv = reshape(parrot_d_yuv, height, width, 3);
imshow(parrot_d_yuv(:, :, 1))
parrot_d_reconst = reshape(parrot_d_yuv, height * width, 3) * yuvtorgb';
parrot_d_reconst = reshape(parrot_d_reconst, height, width, 3);
imshow(parrot_d_reconst);

h = fspecial('gaussian', [9, 9], 10);

parrot_d_yuv_filter_y = parrot_d_yuv;
parrot_d_yuv_filter_y(:, :, 1) = imfilter(parrot_d_yuv_filter_y(:, :, 1), h);
imshow(parrot_d_yuv_filter_y(:, :, 1))
parrot_d_reconst_filter_y = reshape(parrot_d_yuv_filter_y, height * width, 3) * yuvtorgb';
parrot_d_reconst_filter_y = reshape(parrot_d_reconst_filter_y, height, width, 3);
imshow(parrot_d_reconst_filter_y)

parrot_d_yuv_filter_uv = parrot_d_yuv;
parrot_d_yuv_filter_uv(:, :, 2) = imfilter(parrot_d_yuv_filter_y(:, :, 2), h);
parrot_d_yuv_filter_uv(:, :, 3) = imfilter(parrot_d_yuv_filter_y(:, :, 3), h);
parrot_d_reconst_filter_uv = reshape(parrot_d_yuv_filter_uv, height * width, 3) * yuvtorgb';
parrot_d_reconst_filter_uv = reshape(parrot_d_reconst_filter_uv, height, width, 3);
imshow(parrot_d_reconst_filter_uv)
