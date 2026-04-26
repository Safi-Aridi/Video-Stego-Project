# Steganography Using DCT Method

# Frequency Domain Video and Image Steganography via Discrete Cosine Transform

**PROJECT:** Frequency Domain Video and Image Steganography via Discrete Cosine Transform  
**AUTHOR:** Jad Mghames

## 1. SYSTEM OVERVIEW

This repository contains a comprehensive implementation of DCT-based steganography for both image and video media. The system embeds secret messages into the **frequency domain** of cover media by strategically modifying **mid-frequency DCT coefficients** within **8x8 blocks**, following JPEG compression standards.

The embedding process targets **mid-frequency coefficients** to balance **imperceptibility** and **robustness** against compression attacks. The implementation includes **quality assessment metrics** (PSNR and MSE) to evaluate steganographic performance and maintain visual fidelity of the carrier media.

The system leverages **MATLAB's Image Processing Toolbox** for efficient DCT computation and **Video Processing Toolbox** for frame-by-frame video processing, providing a robust foundation for academic research and practical steganography applications.

## 2. REPOSITORY CONTENTS

- **src/**: Complete MATLAB implementation source code
  - `main_image_demo.m`: Image steganography demonstration script
  - `main_video_demo.m`: Video steganography demonstration script
  - `embed_dct_image.m`: Core image embedding algorithm
  - `embed_dct_video.m`: Core video embedding algorithm
  - `extract_dct_image.m`: Core image extraction algorithm
  - `extract_dct_video.m`: Core video extraction algorithm
  - `embed_bits_in_channel.m`: Low-level DCT coefficient modification
  - `extract_bits_from_channel.m`: Low-level bit extraction from coefficients
  - `text_to_bits.m`: Text-to-binary conversion utility
  - `bits_to_text.m`: Binary-to-text reconstruction utility
  - `compute_psnr_mse.m`: Quality metrics calculation
  - `show_dct_block_demo.m`: DCT block processing visualization
- **data/**: Sample media files for testing and demonstration
  - `input/cover_video.mp4`: Sample video carrier
  - `input/cover.png`: Sample image carrier
  - `output/recovered_video_message.txt`: Extracted message sample
- **README.md**: System documentation and usage guide
- **.gitignore**: Version control configuration

## 3. EXECUTION PROTOCOL

The implementation is designed for MATLAB environment with standard image and video processing toolboxes.

### PREREQUISITES

MATLAB R2020a or later with:

- **Image Processing Toolbox** (required)
- **Video Processing Toolbox** (for video steganography)

### EXECUTION STEPS

#### IMAGE STEGANOGRAPHY

1. Navigate to the `02_DCT_Implementation/src/` directory
2. Execute the image demonstration:
   ```matlab
   main_image_demo
   ```
3. The script will:
   - Load the cover image from `../data/input/cover.png`
   - Embed a sample message using DCT coefficients
   - Generate stego image and extract the message
   - Calculate and display PSNR/MSE metrics

#### VIDEO STEGANOGRAPHY

1. Navigate to the `02_DCT_Implementation/src/` directory
2. Execute the video demonstration:
   ```matlab
   main_video_demo
   ```
3. The script will:
   - Load the cover video from `../data/input/cover_video.mp4`
   - Process frames sequentially using DCT embedding
   - Generate stego video and extract embedded message
   - Display quality metrics and processing statistics

## 4. PIPELINE BEHAVIOR

Upon execution, the system will:

#### EMBEDDING PROCESS

1. **LOAD** the cover media (image or video frames)
2. **PARTITION** media into 8x8 blocks for DCT processing
3. **COMPUTE** DCT coefficients for each block
4. **IDENTIFY** optimal mid-frequency coefficients for embedding
5. **MODIFY** selected coefficients to encode message bits
6. **RECONSTRUCT** stego media using inverse DCT
7. **CALCULATE** quality metrics (PSNR, MSE) for assessment

#### EXTRACTION PROCESS

1. **LOAD** the stego media
2. **PARTITION** into 8x8 blocks matching embedding structure
3. **COMPUTE** DCT coefficients of stego media
4. **EXTRACT** message bits from modified coefficients
5. **RECONSTRUCT** original message using bit-to-text conversion
6. **VALIDATE** extraction accuracy against original payload

## 5. TECHNICAL SPECIFICATIONS

- **DCT Block Size**: 8×8 pixels (JPEG standard)
- **Embedding Strategy**: Mid-frequency coefficient modification
- **Message Capacity**: Variable based on media dimensions and embedding strength
- **Quality Assessment**: PSNR > 30dB, MSE < 100 for imperceptible embedding
- **Supported Formats**: Images (PNG, JPG, BMP), Videos (MP4, AVI, MOV)
- **Processing Speed**: Real-time capable for standard definition video
