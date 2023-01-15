#/bin/sh -eux

docker build -t uint:latest .
docker run -w "/home/uint" --rm -it uint:latest
