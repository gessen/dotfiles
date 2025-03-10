#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag stormcloud-env-v2:alsi11 \
  --ssh default \
  --build-arg USER=$(whoami) \
  --build-arg USER_ID=$(id -u) \
  --build-arg GROUP_ID=$(id -g) \
  .
