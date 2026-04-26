function recoveredMessage = extract_dct_image(stegoImg)
    if size(stegoImg, 3) == 3
        stegoImg = rgb2gray(stegoImg);
    end

    stegoImg = double(stegoImg);
    [rows, cols] = size(stegoImg);

    extractedBits = [];

    for r = 1:8:floor(rows/8)*8
        for c = 1:8:floor(cols/8)*8
            block = stegoImg(r:r+7, c:c+7);
            dctBlock = dct2(block);

            coeff = round(dctBlock(4,5));
            extractedBits = [extractedBits mod(abs(coeff), 2)];
        end
    end

    % First 16 bits store message length
    lengthBits = extractedBits(1:16);
    msgLength = bin2dec(char(lengthBits + '0'));

    % Next msgLength bits are the actual message
    messageBits = extractedBits(17:16+msgLength);

    recoveredMessage = bits_to_text(messageBits);
end