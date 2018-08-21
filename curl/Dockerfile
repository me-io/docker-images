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
    libcurl4-openssl-dev  \
    wget

ARG CURL_VER
ARG CURL_PREFIX
ARG OPENSSL_PREFIX
#
# Download OpenSSL, verify, build, test, install
#
RUN wget -O ${CURL_VER}.tar.gz https://curl.haxx.se/download/${CURL_VER}.tar.gz && \
    tar xfz ${CURL_VER}.tar.gz && \
    cd ${CURL_VER} && \
    ldconfig && \
    LDFLAGS="-Wl,-rpath,$OPENSSL_PREFIX/lib -Wl,-rpath,${CURL_PREFIX}/lib" ./configure --with-ssl --prefix=${CURL_PREFIX} && \
    make > /dev/null && \
    make test && \
    make install > /dev/null && \
    ldconfig

RUN openssl version -a && \
    curl --version && \
    echo -e "\n\nSuccess: Installed ${CURL_VER} in ${CURL_PREFIX}\n"

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*