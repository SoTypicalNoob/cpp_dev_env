#!/usr/bin/env bash

docker stop docker-cpp

docker run -d \
  --name docker-cpp \
  -p 2222:22 \
  -v /home/eandill/projects:/home/devuser/projects \
  docker-cpp
