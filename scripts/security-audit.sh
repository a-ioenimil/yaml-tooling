#!/bin/bash


# Function to check for dependencies
check_dependency() {
    if ! command -v "$1" &> /dev/null; then
        echo "❌ Error: $1 is not installed."
        exit 1
    fi
}

CONFIG_FILE=$1

if [ -z "$CONFIG_FILE" ]; then
    echo "Usage: $0 <path-to-yaml-config>"
    exit 1
fi

check_dependency yq

echo "🔍 Auditing database configuration for hardcoded secrets in $CONFIG_FILE..."

# Extract password using yq
DB_PASS=$(yq '.database.password' "$CONFIG_FILE")

# Check if password starts with ${ and ends with }
if [[ "$DB_PASS" =~ ^\$\{.*\}$ ]]; then
    echo "✅ Security Check Passed: Password uses a secure placeholder variable."
else
    echo "❌ Security Risk Detected: 'database.password' must use a variable placeholder (e.g., \${DB_PASS})."
    echo "Current value found: $DB_PASS"
    exit 1
fi
