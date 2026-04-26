function [mseValue, psnrValue] = compute_psnr_mse(originalImg, stegoImg)
    originalImg = double(originalImg);
    stegoImg = double(stegoImg);

    error = originalImg - stegoImg;
    mseValue = mean(error(:).^2);

    if mseValue == 0
        psnrValue = Inf;
    else
        psnrValue = 10 * log10((255^2) / mseValue);
    end
end