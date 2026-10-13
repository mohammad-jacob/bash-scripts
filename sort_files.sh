
#!/bin/bash

# Folder to organize (default: current directory)
TARGET_DIR="${1:-.}"

# Check whether the directory exists
if [[ ! -d "$TARGET_DIR" ]]; then
    echo "Error: Directory does not exist: $TARGET_DIR"
    exit 1
fi

# Process files directly inside the folder
find "$TARGET_DIR" -maxdepth 1 -type f -print0 |
while IFS= read -r -d '' file; do

    filename=$(basename "$file")

    # Handle files without an extension
    if [[ "$filename" != *.* || "$filename" == .* && "$filename" != *.*.* ]]; then
        extension="NO_EXTENSION"
    else
        extension="${filename##*.}"
        extension=$(printf '%s' "$extension" | tr '[:lower:]' '[:upper:]')
    fi

    # Create the destination folder
    destination="$TARGET_DIR/$extension"
    mkdir -p "$destination"

    # Move the file
    if [[ "$file" != "$destination/"* ]]; then
        if mv -n -- "$file" "$destination/"; then
            echo "Moved: $filename -> $extension/"
        else
            echo "Skipped: $filename"
        fi
    fi

done

echo "File sorting completed!"
