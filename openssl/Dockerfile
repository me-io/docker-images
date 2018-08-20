# Dockerfile
ARG IMG_NAME
ARG IMG_TAG

FROM ${IMG_NAME}:${IMG_TAG}
MAINTAINER Mohamed Meabed <meabed@me.io>

ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8

RUN apt-get update &&  \
    apt-get install -y \
    build-essential    \
    pkg-config         \
    libsslcommon2-dev  \
    wget

RUN apt-get build-dep -y \
    openssl

ARG OPENSSL_VER
ARG OPENSSL_PREFIX
#
# Download OpenSSL, verify, build, test, install
#
RUN curl -O https://www.openssl.org/source/$OPENSSL_VER.tar.gz && \
    tar xvfz $OPENSSL_VER.tar.gz && \
    cd $OPENSSL_VER && \
    ./config shared --openssldir=$OPENSSL_PREFIX && \
    make && \
    # make test && \
    make install && \
    ldconfig && \
    cd .. && \
    echo -e "\n\n" && \
    /usr/local/bin/openssl version -a && \
    echo -e "\n\nSuccess: Installed $OPENSSL_VER in $OPENSSL_PREFIX\n"
