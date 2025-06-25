#!/bin/bash

# Hash Password Script for Caddy Basic Auth
# Usage: ./hash-password.sh "your-password"

set -e

if [ $# -eq 0 ]; then
    echo "Usage: $0 <password>"
    echo "Example: $0 \"your-password\""
    exit 1
fi

PASSWORD="$1"

# Check if docker is available
if ! command -v docker &> /dev/null; then
    echo "Error: Docker is required but not found."
    exit 1
fi

echo "Generating password hash..."

# Generate hash using Caddy
HASH=$(docker run --rm caddy:latest caddy hash-password --plaintext "$PASSWORD")

if [ $? -eq 0 ] && [ ! -z "$HASH" ]; then
    echo ""
    echo "Password hash generated:"
    echo "$HASH"
    echo ""
    echo "Add this to your .env file:"
    echo "AUTH_PASSWORD_HASH=$HASH"
else
    echo "Error: Failed to generate password hash"
    exit 1
fi
