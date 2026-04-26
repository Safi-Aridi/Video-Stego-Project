clc;
clear;
close all;

img = imread('../data/input/cover.png');

if size(img, 3) == 3
    img = rgb2gray(img);
end

img = double(img);

block = img(1:8, 1:8);
dctBlock = dct2(block);
reconstructedBlock = idct2(dctBlock);

disp('Original 8x8 block:');
disp(block);

disp('DCT coefficients of 8x8 block:');
disp(round(dctBlock, 2));

disp('Reconstructed block after inverse DCT:');
disp(round(reconstructedBlock, 2));

figure;
subplot(1,3,1);
imshow(uint8(block));
title('Original 8x8 Block');

subplot(1,3,2);
imagesc(dctBlock);
colormap gray;
colorbar;
title('DCT Coefficients');

subplot(1,3,3);
imshow(uint8(reconstructedBlock));
title('Reconstructed Block');