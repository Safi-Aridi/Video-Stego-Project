function recoveredMessage = extract_dct_video(stegoVideoPath)
    videoReader = VideoReader(stegoVideoPath);

    if ~hasFrame(videoReader)
        error('Stego video contains no frames.');
    end

    frame = readFrame(videoReader);
    blueChannel = frame(:,:,3);

    extractedBits = extract_bits_from_channel(blueChannel);

    if length(extractedBits) < 16
        error('Not enough bits to read message length.');
    end

    lengthBits = extractedBits(1:16);
    msgLength = bin2dec(char(lengthBits + '0'));

    if msgLength == 0
        recoveredMessage = '';
        return;
    end

    totalBitsNeeded = 16 + msgLength;

    if length(extractedBits) < totalBitsNeeded
        error('First frame does not contain the full hidden message.');
    end

    messageBits = extractedBits(17:16+msgLength);
    recoveredMessage = bits_to_text(messageBits);
end