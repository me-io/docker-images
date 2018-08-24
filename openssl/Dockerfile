# Dockerfile
ARG IMG_NAME
ARG IMG_TAG

FROM ${IMG_NAME}:${IMG_TAG}
MAINTAINER Mohamed Meabed <meabed@me.io>

ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8

ENV BUILD_PACKAGES \
    build-essential \
    pkg-config \
    libsslcommon2-dev \
    wget

RUN apt-get update &&  \
    apt-get -qq install -y ${BUILD_PACKAGES}

ARG OPENSSL_VER
ARG OPENSSL_PREFIX
#
# Download OpenSSL, verify, build, test, install
# Only install the OpenSSL software components @ https://github.com/openssl/openssl/blob/master/INSTALL
#
RUN cd /tmp && wget -q -O ${OPENSSL_VER}.tar.gz https://www.openssl.org/source/${OPENSSL_VER}.tar.gz && \
    tar xfz ${OPENSSL_VER}.tar.gz && \
    cd ${OPENSSL_VER} && \
    ./config shared --openssldir=${OPENSSL_PREFIX} && \
    make > /dev/null && \
    make test && \
    make install_sw > /dev/null && \
    ldconfig

RUN openssl version -a && \
    echo -e "\n\nSuccess: Installed ${OPENSSL_VER} in ${OPENSSL_PREFIX}\n"

# Clean-up
RUN apt-get remove --purge -y ${BUILD_PACKAGES} ;\
    apt-get clean -y ;\
    apt-get autoclean -y ;\
    apt-get autoremove --purge -y

RUN rm -rf /var/lib/apt/* ; \
    rm -rf /var/lib/dpkg/info/* ; \
    rm -rf /var/lib/cache/* ; \
    rm -rf /var/lib/log/* ; \
    rm -rf /var/tmp/* ; \
    rm -rf /tmp/*
