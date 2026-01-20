#!/bin/bash
# scripts/check-sync.sh

YAML_FILE=$1
JSON_FILE=$2

if [ -z "$YAML_FILE" ] || [ -z "$JSON_FILE" ]; then
  echo "Usage: $0 <yaml-file> <json-file>"
  echo "Example: $0 app-config.yaml app-config.json"
  exit 1
fi

if [ ! -f "$JSON_FILE" ]; then
  echo "❌ Error: $JSON_FILE not found."
  echo "Please run './scripts/transform.sh $YAML_FILE $JSON_FILE' locally and commit the file."
  exit 1
fi

echo "Verifying that $JSON_FILE matches $YAML_FILE..."

# Generate a temporary fresh JSON
TEMP_JSON="temp_check.json"
yq -o=json eval '.' "$YAML_FILE" > "$TEMP_JSON"

# Compare the files ignoring whitespace
if diff -b "$JSON_FILE" "$TEMP_JSON" > /dev/null; then
  echo "✅ Sync Check Passed: JSON file matches the YAML configuration."
  rm "$TEMP_JSON"
  exit 0
else
  echo "❌ Sync Check Failed: The committed JSON file does not match the YAML configuration."
  echo "Difference found:"
  diff -b "$JSON_FILE" "$TEMP_JSON"
  echo ""
  echo "👉 Fix: Run './scripts/transform.sh $YAML_FILE $JSON_FILE' locally and push the changes."
  rm "$TEMP_JSON"
  exit 1
fi
