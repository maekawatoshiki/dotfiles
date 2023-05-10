#/bin/sh -eux

export DOCKER_BUILDKIT=1

docker build -t uint:base -f Dockerfile.base .
docker run -v "$(pwd):/home/uint/dotfiles" -w "/home/uint" --rm -it uint:base
