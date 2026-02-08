# ARM64 Support for Unbound Docker

This repository provides ARM64 support for the Unbound DNS resolver Docker image.

## Changes Made for ARM64 Support

### 1. Architecture Detection
- Added architecture detection in all build stages
- Conditional compilation flags based on detected architecture

### 2. OpenSSL Compilation Fix
- Removed `enable-ec_nistp_64_gcc_128` flag for ARM64 (x86_64 specific)
- Added conditional logic to apply architecture-specific optimizations

### 3. Multi-Architecture Support
- Base image `debian:bookworm` supports both ARM64 and x86_64
- All dependencies are cross-platform compatible

## Building for ARM64

### Option 1: On ARM64 System
```bash
./build-arm64.sh
```

### Option 2: On x86_64 System with Buildx
```bash
# Setup buildx
docker buildx create --name multiarch --use
docker buildx inspect --bootstrap

# Build for ARM64
docker buildx build --platform linux/arm64 -t unbound:arm64-1.22.0 ./1.22.0/

# Build and push to registry
docker buildx build --platform linux/arm64 -t your-registry/unbound:arm64-1.22.0 ./1.22.0/ --push
```

### Option 3: Using Docker Compose
```bash
docker-compose build
docker-compose up -d
```

## Testing the ARM64 Build

### Quick Test
```bash
# Run the container
docker run --name unbound-test -p 53:53/tcp -p 53:53/udp -d unbound:arm64-1.22.0

# Test DNS resolution
drill @127.0.0.1 cloudflare.com

# Check container logs
docker logs unbound-test
```

### Health Check
The image includes a built-in healthcheck that queries cloudflare.com:
```bash
docker ps --filter name=unbound-test
```

## Multi-Architecture Deployment

For production deployments supporting both architectures:

```bash
# Build for both architectures
docker buildx build --platform linux/amd64,linux/arm64 \
  -t your-registry/unbound:1.22.0 \
  -t your-registry/unbound:latest \
  ./1.22.0/ --push
```

## Architecture-Specific Notes

### ARM64 Optimizations
- OpenSSL: Removed x86_64-specific NIST P-256 optimizations
- Memory: ARM64 typically uses different memory alignment patterns
- Performance: ARM64 may show different performance characteristics

### Compatibility
- All Unbound features work identically across architectures
- Configuration files are architecture-independent
- DNS resolution functionality is identical

## Verification

To verify ARM64 support:

1. Check architecture in container logs:
```bash
docker logs unbound-test | grep "architecture detected"
```

2. Verify binary architecture:
```bash
docker exec unbound-test file /opt/unbound/sbin/unbound
```

3. Test DNS functionality:
```bash
docker exec unbound-test drill @127.0.0.1 google.com
```

## Troubleshooting

### Build Issues
- Ensure Docker Buildx is installed for cross-compilation
- Check that all base images support ARM64
- Verify build dependencies are available for ARM64

### Runtime Issues
- ARM64 containers may use slightly more memory
- Performance tuning may be needed for production workloads
- Some monitoring tools may need ARM64-specific configuration
