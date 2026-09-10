#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag ew-buildenv:alsi22 \
  --network host \
  --ssh default \
  --build-arg BASE_IMAGE=jammy \
  --build-arg BUILD_OS=alsi22 \
  .
