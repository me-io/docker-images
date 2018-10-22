# Dockerfile
ARG IMG_NAME
ARG IMG_TAG

FROM ${IMG_NAME}:${IMG_TAG} as buildContainer
ARG MOZ_TAG
WORKDIR /app
RUN apk update && apk add git
RUN git clone --branch ${MOZ_TAG} https://github.com/mozilla/mozjpeg.git .
RUN apk --update add autoconf automake build-base libtool nasm
RUN autoreconf -fiv && ./configure --prefix=/opt/mozjpeg && make install

FROM ${IMG_NAME}:${IMG_TAG}
COPY --from=buildContainer /opt/mozjpeg/bin /opt/mozjpeg/bin

RUN apk add --update \
    bash \
    lcms2-dev \
    libpng-dev \
    libtool \
    nasm \
    gcc \
    g++ \
    make \
    autoconf \
    automake \
  && rm -rf /var/cache/apk/*

# Install pm2
RUN npm install pm2 -g

#RUN npm install mozjpeg -g

# Expose ports needed to use Keymetrics.io
EXPOSE 80 443 43554

# Start pm2.json process file
CMD ["pm2-runtime", "start", "pm2.json"]
