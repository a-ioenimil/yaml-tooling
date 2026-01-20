#!/bin/bash
# scripts/validate-json.sh

FILE=$1

if [ -z "$FILE" ]; then
  echo "Usage: $0 <path-to-json-file>"
  exit 1
fi

echo "Validating JSON integrity for $FILE..."
if cat "$FILE" | jq '.' > /dev/null; then
  echo "✅ JSON Integrity Verified."
  echo "Preview of generated JSON:"
  jq '.' "$FILE"
else
  echo "❌ JSON Validation Failed."
  exit 1
fi
