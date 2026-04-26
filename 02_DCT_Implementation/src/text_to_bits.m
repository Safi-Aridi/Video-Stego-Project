function bits = text_to_bits(textMessage)
    asciiVals = uint8(textMessage);
    bits = [];

    for i = 1:length(asciiVals)
        charBits = dec2bin(asciiVals(i), 8) - '0';
        bits = [bits charBits];
    end
end