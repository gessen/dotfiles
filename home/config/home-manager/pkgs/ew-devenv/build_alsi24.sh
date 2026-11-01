#!/usr/bin/env bash

set -eo

docker buildx build \
  --tag ew-devenv:alsi24 \
  --tag ew-devenv:latest \
  --network host \
  --ssh default \
  --build-arg BASE_IMAGE=noble \
  --build-arg BUILD_OS=alsi24 \
  --build-arg USER="$(whoami)" \
  --build-arg USER_ID="$(id -u)" \
  --build-arg GROUP_ID="$(id -g)" \
  .
