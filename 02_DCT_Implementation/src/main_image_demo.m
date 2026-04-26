clc;
clear;
close all;

% Read original image
coverImg = imread('../data/input/cover.png');

% Secret message
secretMessage = 'Hello, this is my DCT steganography test!';

% Embed message
stegoImg = embed_dct_image(coverImg, secretMessage);

% Save stego image
imwrite(stegoImg, '../data/output/stego.png');

% Read saved stego image again
savedStegoImg = imread('../data/output/stego.png');

% Extract message from saved image
recoveredMessage = extract_dct_image(savedStegoImg);

% Save recovered message
fid = fopen('../data/output/recovered_message.txt', 'w');
fprintf(fid, '%s', recoveredMessage);
fclose(fid);

% Convert original to grayscale for fair comparison
if size(coverImg, 3) == 3
    coverGray = rgb2gray(coverImg);
else
    coverGray = coverImg;
end

% Performance
[mseValue, psnrValue] = compute_psnr_mse(coverGray, savedStegoImg);

% Display results
disp('Original Secret Message:');
disp(secretMessage);

disp('Recovered Secret Message:');
disp(recoveredMessage);

disp(['MSE: ' num2str(mseValue)]);
disp(['PSNR: ' num2str(psnrValue) ' dB']);

if strcmp(secretMessage, recoveredMessage)
    disp('SUCCESS: Extracted message matches the original message exactly.');
else
    disp('ERROR: Extracted message does NOT match the original message.');
end

figure;
subplot(1,2,1);
imshow(coverGray);
title('Original Image');

subplot(1,2,2);
imshow(savedStegoImg);
title('Stego Image');