#/bin/sh -eux

export DOCKER_BUILDKIT=1

TAG=base.ext
docker build -t uint:$TAG -f Dockerfile.base.ext .
docker run -e "TERM=xterm-256color" -w "/home/uint" --rm -it uint:$TAG
