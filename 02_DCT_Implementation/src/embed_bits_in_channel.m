function [modifiedChannel, nextBitIndex] = embed_bits_in_channel(channel, allBits, startBitIndex)
    channel = double(channel);
    [rows, cols] = size(channel);
    modifiedChannel = channel;

    bitIndex = startBitIndex;
    delta = 50;   % stronger robustness margin

    for r = 1:8:floor(rows/8)*8
        for c = 1:8:floor(cols/8)*8
            if bitIndex > length(allBits)
                nextBitIndex = bitIndex;
                modifiedChannel = uint8(round(modifiedChannel));
                return;
            end

            block = modifiedChannel(r:r+7, c:c+7);
            dctBlock = dct2(block);

            c1 = dctBlock(4,5);
            c2 = dctBlock(5,4);

            currentBit = allBits(bitIndex);

            if currentBit == 1
                if c1 <= c2 + delta
                    avgVal = (c1 + c2) / 2;
                    c1 = avgVal + delta/2;
                    c2 = avgVal - delta/2;
                end
            else
                if c2 <= c1 + delta
                    avgVal = (c1 + c2) / 2;
                    c2 = avgVal + delta/2;
                    c1 = avgVal - delta/2;
                end
            end

            dctBlock(4,5) = c1;
            dctBlock(5,4) = c2;

            modifiedChannel(r:r+7, c:c+7) = idct2(dctBlock);

            bitIndex = bitIndex + 1;
        end
    end

    nextBitIndex = bitIndex;
    modifiedChannel = uint8(round(modifiedChannel));
end