#!/usr/bin/env bash
set -euo pipefail

if ! [ -x "$(command -v jq)" ]; then
  echo 'Error: jq is not installed. Get it here: https://jqlang.github.io/jq/download/' >&2
  exit 1
fi

PLATFORM=${1:-"linux"}
ARCH=${2:-"amd64"}

BINARY_VERSION_FILE="./binary-version.json"

dockerVersion=$(jq -r '.docker' < "${BINARY_VERSION_FILE}")
dockerComposeVersion=$(jq -r '.dockerCompose' < "${BINARY_VERSION_FILE}")
helmVersion=$(jq -r '.helm' < "${BINARY_VERSION_FILE}")
kubectlVersion=$(jq -r '.kubectl' < "${BINARY_VERSION_FILE}")
mingitVersion=$(jq -r '.mingit' < "${BINARY_VERSION_FILE}")

mkdir -p dist

echo "Downloading binaries for docker ${dockerVersion}, docker-compose ${dockerComposeVersion}, helm ${helmVersion}, kubectl ${kubectlVersion}, and mingit ${mingitVersion}"

./build/download_docker_binary.sh "$PLATFORM" "$ARCH" "$dockerVersion" &
./build/download_docker_compose_binary.sh "$PLATFORM" "$ARCH" "$dockerComposeVersion" &
./build/download_helm_binary.sh "$PLATFORM" "$ARCH" "$helmVersion" &
./build/download_kubectl_binary.sh "$PLATFORM" "$ARCH" "$kubectlVersion" &
./build/download_mingit_binary.sh "$PLATFORM" "$ARCH" "$mingitVersion" &
wait
