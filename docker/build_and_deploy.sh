#!/bin/sh
# Build and push the loggly-mcp image.
# Usage: ./docker/build_and_deploy.sh <tag> [platform]
#   e.g. ./docker/build_and_deploy.sh 1.0.0-arm64 linux/arm64/v8

set -e

TAG=${1:?usage: build_and_deploy.sh <tag> [platform]}
PLATFORM=${2:-linux/arm64/v8}
DOCKER=$(command -v docker)

$DOCKER build --push \
  --platform "$PLATFORM" \
  -t "registry.gitlab.com/skails/loggly-mcp:$TAG" \
  -f ./docker/Dockerfile .