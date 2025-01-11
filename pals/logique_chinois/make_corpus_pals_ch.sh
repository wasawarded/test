#!/bin/sh

# Paths
SCRIPT="cooccurrents.py"
TEXT_FILE=$1
OUTPUT="output_contexte.tsv"

# Target word
TARGET="逻辑"

# Run the Python script
python3 "$SCRIPT" "$TEXT_FILE" --target "$TARGET" > "$OUTPUT"

echo "Analysis complete. Results saved to $OUTPUT."

