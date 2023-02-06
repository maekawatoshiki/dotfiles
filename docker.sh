#/bin/sh -eux

export DOCKER_BUILDKIT=1

docker build -t uint:latest .
docker run -w "/home/uint" --rm -it uint:latest
