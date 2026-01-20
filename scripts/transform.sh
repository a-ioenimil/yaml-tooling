#!/bin/bash
# scripts/transform.sh

INPUT_FILE=$1
OUTPUT_FILE=$2

if [ -z "$INPUT_FILE" ] || [ -z "$OUTPUT_FILE" ]; then
  echo "Usage: $0 <input-yaml> <output-json>"
  exit 1
fi

echo "Transforming $INPUT_FILE to $OUTPUT_FILE..."
yq -o=json eval '.' "$INPUT_FILE" > "$OUTPUT_FILE"

if [ -f "$OUTPUT_FILE" ]; then
  echo "✅ Conversion successful. File '$OUTPUT_FILE' created."
else
  echo "❌ Conversion failed."
  exit 1
fi
