function bits = extract_bits_from_channel(channel)
    channel = double(channel);
    [rows, cols] = size(channel);

    bits = [];

    for r = 1:8:floor(rows/8)*8
        for c = 1:8:floor(cols/8)*8
            block = channel(r:r+7, c:c+7);
            dctBlock = dct2(block);

            c1 = dctBlock(4,5);
            c2 = dctBlock(5,4);

            if c1 > c2
                bits = [bits 1];
            else
                bits = [bits 0];
            end
        end
    end
end