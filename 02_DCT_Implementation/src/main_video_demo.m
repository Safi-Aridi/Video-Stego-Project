clc;
clear;
close all;

inputVideoPath = '../data/input/cover_video.mp4';
outputVideoPath = '../data/output/stego_video.avi';

secretMessage = 'Frequency-domain embedding improves robustness over simple spatial methods.';

% Embed
embed_dct_video(inputVideoPath, outputVideoPath, secretMessage);

% Extract
recoveredMessage = extract_dct_video(outputVideoPath);

% Save recovered message
fid = fopen('../data/output/recovered_video_message.txt', 'w');
fprintf(fid, '%s', recoveredMessage);
fclose(fid);

disp('Original Secret Message:');
disp(secretMessage);

disp('Recovered Secret Message:');
disp(recoveredMessage);

if strcmp(secretMessage, recoveredMessage)
    disp('SUCCESS: Video extracted message matches the original message exactly.');
else
    disp('ERROR: Video extracted message does NOT match the original message.');
end