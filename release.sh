#!/bin/sh

set -ex

USERNAME=handshake
IMAGE=pgbouncer

version=`cat VERSION`
echo "version: $version"

# TODO: Abort if docker image version already exists (or at least warn).

# run build
docker build -t $USERNAME/$IMAGE:latest .

# tag it
git add -A
git commit -m "version $version"
git tag -a "$version" -m "version $version"
git push
git push --tags

docker tag $USERNAME/$IMAGE:latest $USERNAME/$IMAGE:$version

# push it
docker push $USERNAME/$IMAGE:latest
docker push $USERNAME/$IMAGE:$version
