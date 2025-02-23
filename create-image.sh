#!/usr/bin/env bash

docker rm -f docker-cpp

docker build --no-cache -t docker-cpp .
# docker build \
#   --build-arg USER_UID=$(id -u) \
#   --build-arg USER_GID=$(id -g) \
#   --no-cache \
#   -t docker-cpp .
