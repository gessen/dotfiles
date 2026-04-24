#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag ew-buildenv:alsi22 \
  --tag ew-buildenv:latest \
  --network host \
  --ssh default \
  .
