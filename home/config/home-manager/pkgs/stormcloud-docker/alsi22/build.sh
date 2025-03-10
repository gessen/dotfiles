#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag=stormcloud-env:alsi22 \
  --tag=stormcloud-env:latest \
  --ssh=default \
  .
