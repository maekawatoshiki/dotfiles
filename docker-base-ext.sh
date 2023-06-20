#/bin/sh -eux

export DOCKER_BUILDKIT=1

TAG=base.ext
docker build -t uint:$TAG -f Dockerfile.base.ext .
docker run -w "/home/uint" --rm -it uint:$TAG
