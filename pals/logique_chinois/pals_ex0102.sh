#!/bin/bash
# filepath: process_words.sh

# Check if folder path is provided
if [ $# -ne 1 ]; then
    echo "Usage: $0 <folder_path>"
    exit 1
fi

FOLDER_PATH="$1"
OUTPUT_FILE="result.txt"

# Check if folder exists
if [ ! -d "$FOLDER_PATH" ]; then
    echo "Error: Directory $FOLDER_PATH does not exist"
    exit 1
fi

# Clear output file if it exists
> "$OUTPUT_FILE"

# Process each txt file
first_file=true
find "$FOLDER_PATH" -type f -name "*.txt" | while read -r file; do
    # Add empty line between files, except for first file
    if [ "$first_file" = true ]; then
        first_file=false
    else
        echo "" >> "$OUTPUT_FILE"
    fi
    
    # Read file content, split by spaces, and output one word per line
    cat "$file" | tr ' ' '\n' | grep -v '^$' >> "$OUTPUT_FILE"
done

echo "Processing complete. Results saved in $OUTPUT_FILE"