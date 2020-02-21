#!/usr/bin/env bash

function validate_args() {
  if [ -z "$1" ]; then
    echo 'First argument should be docker registry.'
    exit 1
  elif [ -z "$2" ]; then
    echo 'Second arguement should be registry user name.'
    exit 1
  fi
}

function docker_login() {
  local registry=$1 registryUsername="$2"

  echo "Please input the password for the registry '$registry': "
  read -r registryPassword
  docker login --username "$registryUsername" --password "$registryPassword" "$registry"

  if [ $? -eq 1 ]; then
    echo "Unable to login to docker registry: '$registry'"
    exit 1
  fi
}

function docker_build() {
  local taggedImageName="$1" nodeVersion="$2" scVersion="$3"

  docker build -t "$taggedImageName" --build-arg NODE_VERSION="$nodeVersion" --build-arg SC_VERSION="$scVersion" .

  if [ $? -eq 1 ]; then
    echo "Unable to build docker image with image name: '$taggedImageName', node version: '$nodeVersion', sc version: '$scVersion'."
    echo "Is the dockerfile in the same directory as this script?"
    exit 1
  fi
}

function docker_push() {
  local taggedImageName="$1"

  docker push "$taggedImageName"

  if [ $? -eq 1 ]; then
     echo "Unable to push docker image ('$taggedImageName') to registry."
     exit 1
  fi
}

function main() {
  validate_args "$1" "$2"
  local registry="$1" registryUsername="$2"
  local nodeVersion="${4:-12.14.0}" scVersion="${5:-4.5.4}"

  taggedImageName="$registry/node-sc:node-${nodeVersion}_sc-${scVersion}"

  docker_login "$registry" "$registryUsername"
  docker_build "$taggedImageName" "$nodeVersion" "$scVersion"
  docker_push "$taggedImageName"

  echo "Built and pushed image with name and tag: $taggedImageName"
  echo "Update the 'image' for the 'node-sc' container accordingly."
}

main "$1" "$2" "$3" "$4" "$5"
