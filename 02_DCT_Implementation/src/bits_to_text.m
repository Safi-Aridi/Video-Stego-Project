function textMessage = bits_to_text(bits)
    numChars = floor(length(bits) / 8);
    textMessage = '';

    for i = 1:numChars
        byte = bits((i-1)*8 + 1 : i*8);
        asciiVal = bin2dec(char(byte + '0'));
        textMessage = [textMessage char(asciiVal)];
    end
end