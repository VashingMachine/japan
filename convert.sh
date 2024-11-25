#!/bin/bash

# Check if ffmpeg is installed
if ! command -v ffmpeg &> /dev/null; then
  echo "ffmpeg is not installed. Please install it and try again."
  exit 1
fi

# Check if folder path is provided
if [ -z "$1" ]; then
  echo "Usage: $0 <folder-path>"
  exit 1
fi

# Get the folder path
FOLDER_PATH="$1"

# Check if the folder exists
if [ ! -d "$FOLDER_PATH" ]; then
  echo "The folder '$FOLDER_PATH' does not exist."
  exit 1
fi

# Loop through all .jpg and .jpeg files in the folder
for FILE in "$FOLDER_PATH"/*.{jpg,jpeg,JPG,JPEG}; do
  if [ -f "$FILE" ]; then
    # Get the base name of the file (without extension)
    BASENAME=$(basename "$FILE" | sed 's/\.[^.]*$//')

    # Define the output file path
    OUTPUT_FILE="$FOLDER_PATH/$BASENAME.png"

    # Convert the file to PNG
    ffmpeg -i "$FILE" "$OUTPUT_FILE"

    if [ $? -eq 0 ]; then
      echo "Converted: $FILE -> $OUTPUT_FILE"

      # Remove the original file
      rm "$FILE"
      echo "Deleted: $FILE"
    else
      echo "Failed to convert: $FILE"
    fi
  fi
done

echo "Conversion complete."
