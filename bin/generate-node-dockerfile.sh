#!/bin/bash

exec 2>&1

set -e

if (( $# < 2 )); then
    echo "USAGE: ${0##*/} <BASE_IMAGE> <TARGET_DIR>"
    exit 1
fi

BASE_IMAGE=$1
TARGET_DIR=$2
CHROMIUM_VERSION=$(docker run --rm --name=chromiumver $BASE_IMAGE /usr/lib/chromium-browser/chromium-browser --product-version)

if [[ -z $CHROMIUM_VERSION ]]; then
    echo "Invalid chromium version"
    exit 1
fi

eval $(curl -sL -H "Accept: application/json, text/plain" "https://omahaproxy.appspot.com/deps.json?version=$CHROMIUM_VERSION" | sed -E 's#[?, \{\}$]"([^"]+)": "([^"]+)[",\}]+#\U\1=\2\n#gm')

cat <<'NODE_DOCKERFILE' > $TARGET_DIR/Dockerfile
# This is generated file
FROM ${BASE_IMAGE}

ENV CHROMIUM_VERSION=${CHROMIUM_VERSION} \
    CHROMIUM_REVISION=${CHROMIUM_BASE_POSITION}

COPY ./ /tmp/build
RUN /tmp/build/build.sh \
    && rm -rf /tmp/* /var/lib/apt/lists/* /var/cache/apt/*

NODE_DOCKERFILE