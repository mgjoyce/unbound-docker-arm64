#!/bin/bash

# Build script for ARM64 support
# This script builds the Docker image for ARM64 architecture

echo "Building Unbound Docker image with ARM64 support..."

# Detect current architecture
ARCH=$(uname -m)
echo "Current system architecture: $ARCH"

# Default to latest version
VERSION=${1:-"1.24.2"}

echo "Building version: $VERSION"

# Validate version exists
if [ ! -d "$VERSION" ]; then
    echo "Error: Version $VERSION not found. Available versions:"
    ls -d */ | grep -E '^[0-9]+\.[0-9]+\.[0-9]+/$' | sed 's/\///'
    exit 1
fi

# Build for ARM64 if on ARM64, otherwise build for current platform
if [ "$ARCH" = "arm64" ] || [ "$ARCH" = "aarch64" ]; then
    echo "Building for ARM64 architecture..."
    docker build -t unbound:arm64-$VERSION ./$VERSION/
else
    echo "Building for x86_64 architecture (use docker buildx for multi-arch)..."
    docker build -t unbound:x86_64-$VERSION ./$VERSION/
fi

echo "Build completed!"

# Instructions for multi-arch build
if [ "$ARCH" != "arm64" ] && [ "$ARCH" != "aarch64" ]; then
    echo ""
    echo "To build for ARM64 on x86_64, use docker buildx:"
    echo "docker buildx build --platform linux/arm64 -t unbound:arm64-$VERSION ./$VERSION/"
fi
