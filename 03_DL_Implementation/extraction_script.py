# ==========================================
# HIGH-ASSURANCE STEGANOGRAPHY EXTRACTION 
# ==========================================
# Run this cell to extract the hidden ZIP from the video.

import os
print("Installing dependencies...")
os.system('pip install -q reedsolo')

import cv2
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
from torchvision import transforms
from reedsolo import RSCodec

# --- 1. CONFIGURATION (The Lock & Key) ---
VIDEO_PATH = 'final_patched_widescreen.mp4'
WEIGHTS_PATH = 'decoder_rs.pth'

TOTAL_BITS = 144128       
MESSAGE_LENGTH = 596      
NUM_FRAMES = 242          

# --- 2. DECODER BLUEPRINT ---
class UNetDecoder(nn.Module):
    def __init__(self):
        super(UNetDecoder, self).__init__()
        self.conv1 = nn.Conv2d(3, 64, kernel_size=3, padding=1, stride=2)
        self.conv2 = nn.Conv2d(64, 128, kernel_size=3, padding=1, stride=2)
        self.conv3 = nn.Conv2d(128, 256, kernel_size=3, padding=1, stride=2)
        self.pool = nn.AdaptiveAvgPool2d((32, 32))
        self.final = nn.Conv2d(256, 1, kernel_size=1)
    def forward(self, x):
        x = F.relu(self.conv1(x))
        x = F.relu(self.conv2(x))
        x = F.relu(self.conv3(x))
        x = self.pool(x)
        return self.final(x).view(x.size(0), -1)

print("\nInitializing Decoder Architecture...")
device = torch.device("cuda" if torch.cuda.is_available() else "cpu")
decoder = UNetDecoder().to(device)
decoder.load_state_dict(torch.load(WEIGHTS_PATH, map_location=device))
decoder.eval()

transform = transforms.ToTensor()

# --- 3. VIDEO EXTRACTION ---
print("Scanning video for steganographic signature...")
cap = cv2.VideoCapture(VIDEO_PATH)
recovered_bits = []
f_idx = 0

# Patch Coordinates (Bottom-Left 256x256 of the 848x478 video)
NATIVE_H = 478
PATCH_SIZE = 256
Y_START = NATIVE_H - PATCH_SIZE 
Y_END = NATIVE_H
X_START = 0
X_END = PATCH_SIZE

while cap.isOpened():
    ret, frame = cap.read()
    if not ret or f_idx >= NUM_FRAMES: break
    
    # Isolate the exact patch where the data is hidden
    frame_rgb = cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
    patch_img = frame_rgb[Y_START:Y_END, X_START:X_END]
    
    patch_t = transform(patch_img).unsqueeze(0).to(device)
    
    with torch.no_grad():
        logits = decoder(patch_t)
        preds = (torch.sigmoid(logits) > 0.5).float()
        recovered_bits.append(preds[0, :MESSAGE_LENGTH].cpu())
    f_idx += 1
cap.release()

# --- 4. ERROR CORRECTION & RECOVERY ---
print("Applying Reed-Solomon Cryptographic Healing...")
all_recovered = torch.cat(recovered_bits)[:TOTAL_BITS]
recovered_np = all_recovered.numpy().astype(np.uint8)

rs = RSCodec(32) # Standard 32-byte parity armor
recovered_bytes_raw = np.packbits(recovered_np).tobytes()

try:
    fixed_zip_data, _, _ = rs.decode(recovered_bytes_raw)
    
    with open('EXTRACTED_SECRET.zip', 'wb') as f:
        f.write(fixed_zip_data)
        
    print("\n[SUCCESS] ZIP file extracted perfectly!")
    print("Check your Colab files folder for 'EXTRACTED_SECRET.zip'")
except Exception as e:
    print(f"\n[FAILURE] The payload was corrupted. Error: {e}")