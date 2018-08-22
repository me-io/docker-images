# Dockerfile
ARG IMG_NAME
ARG IMG_TAG

FROM ${IMG_NAME}:${IMG_TAG}
MAINTAINER Mohamed Meabed <meabed@me.io>

ENV DEBIAN_FRONTEND noninteractive
RUN export LANG=C.UTF-8 && export LC_ALL=en_US.UTF-8

ENV BUILD_PACKAGES \
    build-essential    \
    pkg-config         \
    libsslcommon2-dev  \
    libcurl4-openssl-dev  \
    wget

RUN apt-get update &&  \
    apt-get -qq install -y ${BUILD_PACKAGES}


ARG CURL_VER
ARG CURL_PREFIX
ARG OPENSSL_PREFIX
#
# Download OpenSSL, verify, build, test, install
#
RUN cd /tmp && wget -q -O ${CURL_VER}.tar.gz https://curl.haxx.se/download/${CURL_VER}.tar.gz && \
    tar xfz ${CURL_VER}.tar.gz && \
    cd ${CURL_VER} && \
    ldconfig && \
    LDFLAGS="-Wl,-rpath,$OPENSSL_PREFIX/lib -Wl,-rpath,${CURL_PREFIX}/lib" ./configure --with-ssl --prefix=${CURL_PREFIX} && \
    make > /dev/null && \
    # make test && \
    make install > /dev/null && \
    ldconfig

RUN openssl version -a && \
    curl --version && \
    echo -e "\n\nSuccess: Installed ${CURL_VER} in ${CURL_PREFIX}\n"

# Clean-up
RUN rm -rf /var/lib/apt/* ; \
    rm -rf /var/lib/cache/* ; \
    rm -rf /var/lib/log/* ; \
    rm -rf /var/tmp/* ; \
    rm -rf /tmp/*
