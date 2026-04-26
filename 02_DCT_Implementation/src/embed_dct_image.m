function stegoImg = embed_dct_image(coverImg, secretMessage)
    if size(coverImg, 3) == 3
        coverImg = rgb2gray(coverImg);
    end

    coverImg = double(coverImg);
    [rows, cols] = size(coverImg);

    % Convert text to bits
    messageBits = text_to_bits(secretMessage);

    % Store message length in first 16 bits
    msgLength = length(messageBits);
    if msgLength > 65535
        error('Message too long. Maximum supported length is 65535 bits.');
    end

    lengthBits = dec2bin(msgLength, 16) - '0';
    allBits = [lengthBits messageBits];

    % Capacity check
    totalBlocks = floor(rows / 8) * floor(cols / 8);
    if length(allBits) > totalBlocks
        error('Message is too large for this image.');
    end

    stegoImg = coverImg;
    bitIndex = 1;

    % Embedding strength
    alpha = 6;

    for r = 1:8:floor(rows/8)*8
        for c = 1:8:floor(cols/8)*8
            if bitIndex > length(allBits)
                break;
            end

            block = stegoImg(r:r+7, c:c+7);
            dctBlock = dct2(block);

            coeff = round(dctBlock(4,5));
            currentBit = allBits(bitIndex);

            % Force parity with stronger modification
            if mod(abs(coeff), 2) ~= currentBit
                if coeff >= 0
                    coeff = coeff + alpha;
                else
                    coeff = coeff - alpha;
                end
            end

            % Special case: if coeff is 0 and bit = 1, make sure it changes
            if coeff == 0 && currentBit == 1
                coeff = alpha;
            end

            dctBlock(4,5) = coeff;
            stegoImg(r:r+7, c:c+7) = idct2(dctBlock);

            bitIndex = bitIndex + 1;
        end

        if bitIndex > length(allBits)
            break;
        end
    end

    stegoImg = uint8(round(stegoImg));
end