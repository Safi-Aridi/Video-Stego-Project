function embed_dct_video(inputVideoPath, outputVideoPath, secretMessage)
    videoReader = VideoReader(inputVideoPath);
    %videoWriter = VideoWriter(outputVideoPath, 'Uncompressed AVI');
    videoWriter = VideoWriter(outputVideoPath, 'Motion JPEG AVI');
    videoWriter.Quality = 100;
    open(videoWriter);

    messageBits = text_to_bits(secretMessage);
    msgLength = length(messageBits);

    if msgLength > 65535
        error('Message too long. Maximum supported length is 65535 bits.');
    end

    lengthBits = dec2bin(msgLength, 16) - '0';
    allBits = [lengthBits messageBits];

    bitIndex = 1;
    frameCount = 0;
    embeddedInFirstFrame = false;

    while hasFrame(videoReader)
        frame = readFrame(videoReader);
        frameCount = frameCount + 1;

        if ~embeddedInFirstFrame
            blueChannel = frame(:,:,3);

            [modifiedBlue, bitIndex] = embed_bits_in_channel(blueChannel, allBits, bitIndex);
            frame(:,:,3) = modifiedBlue;

            embeddedInFirstFrame = true;
        end

        writeVideo(videoWriter, frame);
    end

    close(videoWriter);

    if bitIndex <= length(allBits)
        error('First frame capacity was not enough to store the full message.');
    end

    disp(['Embedding completed successfully in ' num2str(frameCount) ' frame(s).']);
    disp('Hidden message was embedded in the first frame only.');
end