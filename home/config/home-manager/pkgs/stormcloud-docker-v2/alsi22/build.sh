#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag stormcloud-env-v2:alsi22 \
  --tag stormcloud-env-v2:latest \
  --ssh default \
  --build-arg USER=$(whoami) \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  .
