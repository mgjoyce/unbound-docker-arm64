#!/bin/bash

# Build and push multi-architecture Unbound images
# This script creates and pushes ARM64 and x86_64 images to Docker Hub

set -e

# Configuration
REGISTRY="mgjoyce"
IMAGE_NAME="unbound-arm64"
VERSION=${1:-"1.24.2"}
LATEST_TAG="latest"

echo "Building and pushing Unbound Docker images with ARM64 support..."
echo "Registry: $REGISTRY"
echo "Image: $IMAGE_NAME"
echo "Version: $VERSION"

# Check if buildx is available
if ! docker buildx version >/dev/null 2>&1; then
    echo "Error: docker buildx is not available. Please install buildx first."
    echo "See: https://docs.docker.com/buildx/install/"
    exit 1
fi

# Create and use buildx builder
echo "Setting up buildx builder..."
docker buildx create --name multiarch-builder --use --bootstrap 2>/dev/null || true

# Build and push multi-architecture image
echo "Building and pushing multi-architecture image..."
docker buildx build \
    --platform linux/amd64,linux/arm64 \
    --tag "$REGISTRY/$IMAGE_NAME:$VERSION" \
    --tag "$REGISTRY/$IMAGE_NAME:$LATEST_TAG" \
    --push \
    "./$VERSION/"

echo "Multi-architecture image pushed successfully!"
echo ""
echo "Available tags:"
echo "  $REGISTRY/$IMAGE_NAME:$VERSION"
echo "  $REGISTRY/$IMAGE_NAME:$LATEST_TAG"
echo ""
echo "To pull the image:"
echo "  docker pull $REGISTRY/$IMAGE_NAME:$LATEST_TAG"
echo ""
echo "To run the image:"
echo "  docker run --name unbound -p 53:53/tcp -p 53:53/udp -d $REGISTRY/$IMAGE_NAME:$LATEST_TAG"
