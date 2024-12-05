#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag=stormcloud-env-alsi22:latest \
  --ssh=default \
  .
