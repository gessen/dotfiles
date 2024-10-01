#!/usr/bin/env bash

set -eo

docker buildx build --tag=stormcloud-env:latest --ssh=default .
