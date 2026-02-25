# Comparing the 3 Types of Video Steganography

# 📊 Comparison & Evaluation Criteria

To objectively compare LSB, DCT, and Deep Learning, we evaluate every output video based on the following four pillars:

### 1. Visual Fidelity (Stealth)
We use mathematical algorithms to see how much the video changed after hiding data.
* **PSNR (Peak Signal-to-Noise Ratio):** Higher is better (Target: >30dB).
* **SSIM (Structural Similarity Index):** Measures how "natural" the video looks (Target: >0.95).

### 2. Payload Capacity (Efficiency)
* **Bit-per-Pixel (BPP):** How much data can we hide before the video breaks?
* **File Size Increase:** Original vs. Encoded (LSB will be huge, DL should be small).

### 3. Robustness
* Does the secret message survive if we compress the video?
* Does it survive if we change the file format?

### 4. Speed (Computational Cost)
* **Encoding Time:** 
* **Decoding Time:** 
