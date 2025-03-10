#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag=stormcloud-env:alsi11 \
  --ssh=default \
  .
