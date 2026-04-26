import cv2
import argparse

END_MARKER = b"#####END#####"


def bytes_to_bits(data: bytes) -> str:
    return ''.join(format(byte, '08b') for byte in data)


def get_video_info(cap: cv2.VideoCapture):
    width = int(cap.get(cv2.CAP_PROP_FRAME_WIDTH))
    height = int(cap.get(cv2.CAP_PROP_FRAME_HEIGHT))
    fps = cap.get(cv2.CAP_PROP_FPS)
    frame_count = int(cap.get(cv2.CAP_PROP_FRAME_COUNT))
    return width, height, fps, frame_count


def create_writer(output_video: str, fps: float, width: int, height: int):
    # Preferred: lossless codec (FFV1) in AVI
    fourcc = cv2.VideoWriter_fourcc(*'FFV1')
    out = cv2.VideoWriter(output_video, fourcc, fps, (width, height))

    if out.isOpened():
        return out, "FFV1"

    # Fallback (likely lossy -> may break recovery)
    fourcc = cv2.VideoWriter_fourcc(*'MJPG')
    out = cv2.VideoWriter(output_video, fourcc, fps, (width, height))
    if out.isOpened():
        return out, "MJPG"

    return None, None


def hide_message_in_video(input_video: str, output_video: str, secret_message: str):
    cap = cv2.VideoCapture(input_video)

    if not cap.isOpened():
        print(f"Error: Could not open input video: {input_video}")
        return False

    width, height, fps, frame_count = get_video_info(cap)
    channels = 3  # BGR
    capacity_bits = frame_count * width * height * channels

    message_bytes = secret_message.encode("utf-8") + END_MARKER
    message_bits = bytes_to_bits(message_bytes)
    required_bits = len(message_bits)

    if required_bits > capacity_bits:
        cap.release()
        print("Error: Message too long for this video.")
        print(f"Required bits: {required_bits}, Capacity bits: {capacity_bits}")
        return False

    out, codec_used = create_writer(output_video, fps, width, height)
    if out is None:
        cap.release()
        print("Error: Could not create output video writer.")
        return False

    if codec_used != "FFV1":
        print("Warning: Using non-lossless codec (MJPG). Recovery may fail due to compression artifacts.")

    bit_index = 0

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        flat_frame = frame.reshape(-1)

        remaining = required_bits - bit_index
        if remaining > 0:
            write_count = min(len(flat_frame), remaining)
            for i in range(write_count):
                flat_frame[i] = (flat_frame[i] & 0xFE) | int(message_bits[bit_index])
                bit_index += 1

        stego_frame = flat_frame.reshape(frame.shape)
        out.write(stego_frame)

    cap.release()
    out.release()

    if bit_index == required_bits:
        print(f"Message hidden successfully in: {output_video}")
        print(f"Codec used: {codec_used}")
        return True
    else:
        print("Error: Unexpected incomplete embedding.")
        return False


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Hide a secret message in a video using LSB steganography.")
    parser.add_argument("-i", "--input", default="input.mp4", help="Input video path")
    parser.add_argument("-o", "--output", default="stego_output.avi", help="Output stego video path")
    parser.add_argument("-m", "--message", default="SOFTWARE Engineering", help="Secret message to hide")
    args = parser.parse_args()

    hide_message_in_video(args.input, args.output, args.message)