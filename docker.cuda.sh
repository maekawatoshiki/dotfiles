#!/bin/sh -eux

export DOCKER_BUILDKIT=1

TAG=cuda

docker build -t uint:"$TAG" -f Dockerfile.cuda .

# Start the container if running in terminal
if [ -t 0 ]; then
  docker run \
    --rm \
    -it \
    -e "TERM=xterm-256color" \
    -w "/work" \
    -v "${PWD}:/work" \
    -u "$(id -u):$(id -g)" \
    uint:"$TAG"
fi
