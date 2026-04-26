# Steganography Using DCT Method

This implementation demonstrates video and image steganography using the Discrete Cosine Transform (DCT) method.

## Overview

The DCT-based steganography technique embeds secret messages into the frequency domain of cover media (images/videos) by modifying DCT coefficients. This approach provides better robustness against attacks compared to spatial domain techniques.

## Files Structure

### Source Code (`src/`)

- `main_image_demo.m` - Demo script for image steganography
- `main_video_demo.m` - Demo script for video steganography
- `embed_dct_image.m` - Embed message into image using DCT
- `embed_dct_video.m` - Embed message into video using DCT
- `extract_dct_image.m` - Extract message from DCT-stego image
- `extract_dct_video.m` - Extract message from DCT-stego video
- `embed_bits_in_channel.m` - Core embedding function for DCT coefficients
- `extract_bits_from_channel.m` - Core extraction function from DCT coefficients
- `text_to_bits.m` - Convert text to binary representation
- `bits_to_text.m` - Convert binary back to text
- `compute_psnr_mse.m` - Calculate PSNR and MSE metrics
- `show_dct_block_demo.m` - Demonstration of DCT block processing

### Data Files (`data/`)

- `input/` - Cover media files
  - `cover_video.mp4` - Sample cover video
  - `cover.png` - Sample cover image
- `output/` - Stego media and extracted messages
  - `stego_video.avi` - Video with embedded message
  - `stego.png` - Image with embedded message
  - `recovered_video_message.txt` - Extracted message from video

## Usage

### Image Steganography

```matlab
% Run the image demo
main_image_demo
```

### Video Steganography

```matlab
% Run the video demo
main_video_demo
```

## Technical Details

- **DCT Block Size**: 8x8 blocks for JPEG-like processing
- **Embedding Strategy**: Modify mid-frequency DCT coefficients
- **Message Capacity**: Depends on cover media size and embedding parameters
- **Quality Metrics**: PSNR and MSE calculated for steganalysis

## Requirements

- MATLAB with Image Processing Toolbox
- Video Processing Toolbox (for video steganography)

## Notes

- Output `.avi` files are ignored by git due to their large size
- The implementation focuses on robustness and imperceptibility
- Test data files are included for demonstration purposes
