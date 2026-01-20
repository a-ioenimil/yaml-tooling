#!/bin/bash

FILE=$1

if [ -z "$FILE" ]; then
  echo "Usage: $0 <path-to-yaml-file>"
  exit 1
fi

echo "Checking YAML syntax for $FILE..."
if yq eval '.' "$FILE" > /dev/null 2>&1; then
  echo "✅ YAML Syntax is valid."
else
  echo "❌ YAML Syntax Error!"
  exit 1
fi
