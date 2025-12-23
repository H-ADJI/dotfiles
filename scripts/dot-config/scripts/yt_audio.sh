#!/bin/bash

# --- Configuration ---
MUSIC_DIR="$HOME/Music"
AUDIO_FORMAT="opus" # Can be opus, m4a, mp3, flac, etc.
AUDIO_QUALITY="0"   # 0 for best VBR quality for lossy formats, or lossless for FLAC.

# --- Function to check for dependencies ---
check_dependency() {
    command -v "$1" >/dev/null 2>&1 || {
        echo >&2 "Error: $1 is not installed."
        echo >&2 "Please install $1 using your package manager (e.g., sudo apt install $1 or sudo pacman -S $1)."
        exit 1
    }
}

# --- Main script logic ---

# 1. Check for required arguments
if [ -z "$1" ]; then
    echo "Usage: $0 <YouTube_URL>"
    echo "Example: $0 https://www.youtube.com/watch?v=dQw4w9WgXcQ"
    exit 1
fi

YOUTUBE_URL="$1"

# 2. Check for dependencies
echo "Checking dependencies..."
check_dependency "yt-dlp"
check_dependency "ffmpeg"
echo "Dependencies met."

# 3. Create Music directory if it doesn't exist
if [ ! -d "$MUSIC_DIR" ]; then
    echo "Creating directory: $MUSIC_DIR"
    mkdir -p "$MUSIC_DIR" || {
        echo >&2 "Error: Could not create directory $MUSIC_DIR. Check permissions."
        exit 1
    }
fi

# 4. Construct output filename format
# %(title)s - the video title
# %(ext)s   - the audio extension (e.g., opus)
OUTPUT_TEMPLATE="$MUSIC_DIR/%(title)s.%(ext)s"

# 5. Download the audio
echo "Downloading best quality $AUDIO_FORMAT audio from: $YOUTUBE_URL"
echo "Saving to: $OUTPUT_TEMPLATE"

yt-dlp -f bestaudio -x \
    --audio-format "$AUDIO_FORMAT" \
    --audio-quality "$AUDIO_QUALITY" \
    --embed-metadata \
    -o "$OUTPUT_TEMPLATE" \
    "$YOUTUBE_URL"
