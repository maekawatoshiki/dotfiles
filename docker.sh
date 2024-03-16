#/bin/sh -eux

export DOCKER_BUILDKIT=1

NAME=uint
TAG=base
USER=uint

IMG_UPDATE_TIME=0
# Check if the image exists
if [ $(docker image inspect ${imageName}:${imageTag} > /dev/null 2>&1) ]; then
  # Get the image creation time
  IMG_UPDATE_TIME=$(docker inspect --format '{{ .Created }}' ${NAME}:${TAG} | xargs date +%s -d)
fi

DOCKERFILE_UPDATE_TIME=$(date +%s -r Dockerfile)

# Rebuild the image if Dockerfile is updated
if [ $DOCKERFILE_UPDATE_TIME -gt $IMG_UPDATE_TIME ]; then
  docker build \
    -t $NAME:$TAG \
    --build-arg USER=$USER \
    --build-arg UID=$(id -u) \
    --build-arg GID=$(id -g) \
    -f Dockerfile .
fi

# Start the container if running in terminal
if [ -t 0 ]; then
  docker run \
    --rm \
    -it \
    -e "TERM=xterm-256color" \
    -w "/work" \
    -v "$PWD:/work" \
    -u "$(id -u):$(id -g)" \
    $NAME:$TAG
fi
