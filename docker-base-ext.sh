#/bin/sh -eux

export DOCKER_BUILDKIT=1

TAG=base.ext
docker build -t uint:$TAG -f Dockerfile.base.ext .
docker run \
  --rm \
  -it \
  -e "TERM=xterm-256color" \
  -w "/work" \
  -v "$PWD:/work" \
  -u "$(id -u):$(id -g)" \
  uint:$TAG
