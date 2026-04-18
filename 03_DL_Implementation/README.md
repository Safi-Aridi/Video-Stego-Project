# Steganography Using Deep Learning
# High-Assurance Video Steganography via Adversarial U-Nets


**PROJECT:** High-Assurance Video Steganography via Adversarial U-Nets  
**AUTHOR:** Safi Aridi  


## 1. SYSTEM OVERVIEW
This repository contains a demonstration of a high-capacity, deep learning-based steganography pipeline. A **144,128-bit** encrypted ZIP archive has been spatially embedded into an **H.264 widescreen video** carrier. 

To preserve the native **16:9 aspect ratio** and eliminate interpolation aliasing during MP4 compression, the payload embedding is localized to a **256x256 Region of Interest (ROI)** located in the lower-left spatial quadrant of the frames. This specific coordinate space was selected due to its high-frequency textural complexity (trees and shadows), which optimizes visual camouflage against steganalysis.

The system relies on a custom **Spatial U-Net architecture** to weave the binary data into the visual residual frequencies, reinforced by a **Reed-Solomon Forward Error Correction (FEC)** layer to guarantee 100% cryptographic data integrity.

## 2. REPOSITORY CONTENTS
* **final_patched_widescreen.mp4**: The H.264 encoded carrier video.
* **decoder_rs.pth**: PyTorch state dictionary containing the trained U-Net decoder weights.
* **extraction_script.py**: The Python execution environment for extraction.
* **README.md**: System documentation.

## 3. EXTRACTION PROTOCOL
The extraction script is designed to run in a standard cloud GPU environment to bypass local dependency configuration.

### PREREQUISITES
A Google Colab environment (colab.research.google.com) or a local Jupyter environment with **PyTorch**, **OpenCV**, and **reedsolo** installed.

### EXECUTION STEPS
1.  Initialize a new Google Colab notebook.
2.  Open the **'Files'** directory pane (folder icon on the left sidebar).
3.  Upload the following assets to the root directory (`/content/`):
    * `final_patched_widescreen.mp4`
    * `decoder_rs.pth`
4.  Copy the contents of `extraction_script.py` into the primary code cell.
5.  **Execute the cell.**

## 4. PIPELINE BEHAVIOR
Upon execution, the script will:
1.  **Initialize** the U-Net Decoder architecture and load the parameter weights.
2.  **Isolate** the target 256x256 ROI from the lower-left quadrant of the video frames.
3.  **Extract** the latent binary signal from the spatial domain.
4.  **Execute** Reed-Solomon error correction to repair stochastic bit-flips introduced by the H.264 lossy compression channel.
5.  **Reconstruct** the payload and write the output archive to the active directory as `EXTRACTED_SECRET.zip`.

================================================================================
