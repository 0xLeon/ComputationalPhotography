fine_image = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignment 3\fine.png');
[fine_basePoints, fine_movingPoints] = cpselect(fine_image, fine_image, 'Wait', true)
fine_f_result = cWarpForward(fine_image, fine_basePoints, fine_movingPoints);
fine_i_result = cWarpInverse(fine_image, fine_basePoints, fine_movingPoints);
imshow(fine_f_result);
imshow(fine_i_result);
fine_trans = fitgeotrans(fine_basePoints, fine_movingPoints, 'projective');
fine_g_result = imwarp(fine_image, fine_trans);
imshow(fine_g_result);


pan_base = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignment 3\IMG_2355.jpg');
pan_next_1 = imread('C:\Users\Stefan\Dropbox\Medieninformatik - HFU\7. Semester\Computational Photography\Assignment 3\IMG_2356.jpg');
[pan_basePoints, pan_moving_points] = cpselect(pan_base, pan_next_1, 'Wait', true);
[pan_combined, pan_comb_weight, pan_right_trans, pan_H] = panoramaStitch(pan_base, pan_next_1, pan_basePoints, pan_movingPoints);
imshow(pan_combined); 
imshow(pan_comb_weight);
imshow(pan_right_trans);
