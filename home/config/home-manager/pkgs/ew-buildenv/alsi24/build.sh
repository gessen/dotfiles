#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag ew-buildenv:alsi24 \
  --tag ew-buildenv:latest \
  --network host \
  --ssh default \
  .
