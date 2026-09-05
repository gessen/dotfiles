#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag ew-buildenv:alsi24 \
  --network host \
  --ssh default \
  --build-arg BASE_IMAGE=noble \
  --build-arg BUILD_OS=alsi24 \
  .
