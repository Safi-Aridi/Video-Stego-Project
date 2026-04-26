import cv2
import argparse

END_MARKER = b"#####END#####"


def bits_to_byte(bits):
    return int(''.join(bits), 2)


def extract_message_from_video(stego_video: str) -> str:
    cap = cv2.VideoCapture(stego_video)

    if not cap.isOpened():
        return f"Error: Could not open stego video: {stego_video}"

    bit_buffer = []
    extracted_bytes = bytearray()
    marker_len = len(END_MARKER)

    while True:
        ret, frame = cap.read()
        if not ret:
            break

        flat_frame = frame.reshape(-1)

        for value in flat_frame:
            bit_buffer.append(str(value & 1))

            if len(bit_buffer) == 8:
                extracted_bytes.append(bits_to_byte(bit_buffer))
                bit_buffer.clear()

                # Check only tail for efficiency
                if len(extracted_bytes) >= marker_len and extracted_bytes[-marker_len:] == END_MARKER:
                    cap.release()
                    payload = extracted_bytes[:-marker_len]
                    try:
                        return payload.decode("utf-8")
                    except UnicodeDecodeError:
                        return payload.decode("utf-8", errors="replace")

    cap.release()
    return "No hidden message found."


if __name__ == "__main__":
    print("Recover file started")
    parser = argparse.ArgumentParser(description="Recover a hidden message from a stego video.")
    parser.add_argument("-i", "--input", default="stego_output.avi", help="Stego video path")
    args = parser.parse_args()

    message = extract_message_from_video(args.input)
    print("Recovered message:", message)