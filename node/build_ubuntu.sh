#!/usr/bin/env bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null && pwd )"

## todo fix
## convert it to node image from ubuntu:tags, not ubuntu
GIT_TAG=`git rev-parse --abbrev-ref HEAD`
# build only tag branch master
if [[ ${GIT_TAG} =~ ^master$ || ${TRAVIS_BRANCH} =~ ^master$ ]]; then
    true
    echo "TAG: ${GIT_TAG} - start build"
else
    echo "TAG: ${GIT_TAG} - skip build"
    exit 0
fi

# https://hub.docker.com/_/ubuntu/
IMG_NAME="ubuntu"
IMG_TAG="16.04"
# https://curl.haxx.se/docs/releases.html
CURL_VER="curl-7.61.1"
CURL_PREFIX="/usr/local"
OPENSSL_PREFIX="/usr/local/ssl"
NODE_VER="11.0.0"
NODE_PREFIX="/usr/local/node"
# docker hub image_name:tag
REPO_NAME="meio/ubuntu"
REPO_TAG=${IMG_TAG}-${NODE_VER}

if [[ ! -z "${DOCKER_PASSWORD}" && ! -z "${DOCKER_USERNAME}" ]]
then
    echo "${DOCKER_PASSWORD}" | docker login -u "${DOCKER_USERNAME}" --password-stdin
fi

TAG_EXIST=`curl -s "https://hub.docker.com/v2/repositories/${REPO_NAME}/tags/${REPO_TAG}/" | grep '"id":'`

if [[ ! -z ${TAG_EXIST} ]]; then
    echo "${REPO_NAME}:${REPO_TAG} already exist"
    exit 0
fi

docker build --build-arg IMG_NAME=${IMG_NAME} \
             --build-arg IMG_TAG=${IMG_TAG} \
             --build-arg CURL_VER=${CURL_VER} \
             --build-arg NODE_VER=${NODE_VER} \
             --build-arg NODE_PREFIX=${NODE_PREFIX} \
             --build-arg CURL_PREFIX=${CURL_PREFIX} \
             --build-arg OPENSSL_PREFIX=${OPENSSL_PREFIX} \
             -t ${REPO_NAME}:${REPO_TAG} ${DIR}

if [[ $? != 0 ]]; then
    echo "${REPO_NAME}:${REPO_TAG} build failed"
    exit 1
fi

if [[ -z ${TAG_EXIST} ]]; then
    docker push ${REPO_NAME}:${REPO_TAG}
    echo "${REPO_NAME}:${REPO_TAG} pushed successfully"
fi
