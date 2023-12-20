ARG BUILD_FROM
# hadolint ignore=DL3006


############## build stage ##############
FROM ghcr.io/linuxserver/baseimage-alpine:3.18 as buildstage

# environment settings
ARG TZ="Etc/UTC"
ARG TVHEADEND_COMMIT
ENV HOME="/config/tvheadend"

RUN \
  echo "**** install build packages ****" && \
  apk add --no-cache \
    autoconf \
    automake \
    bsd-compat-headers \
    build-base \
    cmake \
    ffmpeg4-dev \
    file \
    findutils \
    gettext-dev \
    git \
    gnu-libiconv-dev \
    libdvbcsa-dev \
    libgcrypt-dev \
    libhdhomerun-dev \
    libtool \
    libva-dev \
    libvpx-dev \
    libxml2-dev \
    libxslt-dev \
    linux-headers \
    openssl-dev \
    opus-dev \
    patch \
    pcre2-dev \
    pkgconf \
    pngquant \
    python3 \
    sdl2-dev \
    uriparser-dev \
    x264-dev \
    x265-dev \
    zlib-dev

RUN \
  echo "**** remove musl iconv.h and replace with gnu-iconv.h ****" && \
  rm -rf /usr/include/iconv.h && \
  cp /usr/include/gnu-libiconv/iconv.h /usr/include/iconv.h

RUN \
  echo "**** compile tvheadend ****" && \
  if [ -z ${TVHEADEND_COMMIT+x} ]; then \
    TVHEADEND_COMMIT=$(curl -sX GET https://api.github.com/repos/tvheadend/tvheadend/commits/master \
    | jq -r '. | .sha'); \
  fi && \
  mkdir -p \
    /tmp/tvheadend && \
  git clone https://github.com/tvheadend/tvheadend.git /tmp/tvheadend && \
  cd /tmp/tvheadend && \
  git checkout ${TVHEADEND_COMMIT} && \
  ./configure \
    `#Encoding` \
    --disable-ffmpeg_static \
    --disable-libfdkaac_static \
    --disable-libtheora_static \
    --disable-libopus_static \
    --disable-libvorbis_static \
    --disable-libvpx_static \
    --disable-libx264_static \
    --disable-libx265_static \
    --disable-libfdkaac \
    --enable-libopus \
    --enable-libvorbis \
    --enable-libvpx \
    --enable-libx264 \
    --enable-libx265 \
    \
    `#Options` \
    --disable-avahi \
    --disable-dbus_1 \
    --disable-bintray_cache \
    --disable-execinfo \
    --disable-hdhomerun_static \
    --enable-hdhomerun_client \
    --enable-libav \
    --enable-pngquant \
    --enable-trace \
    --enable-vaapi \
    --infodir=/usr/share/info \
    --localstatedir=/var \
    --mandir=/usr/share/man \
    --prefix=/usr \
    --python=python3 \
    --sysconfdir=/config && \
  make -j 2 && \
  make DESTDIR=/tmp/tvheadend-build install


############## runtime stage ##############
FROM ${BUILD_FROM}

# set version label
ARG BUILD_DATE
ARG VERSION
LABEL build_version="Linuxserver.io version:- ${VERSION} Build-date:- ${BUILD_DATE}"
LABEL maintainer="saarg"

RUN \
  echo "**** install runtime packages ****" && \
  apk add --no-cache \
    bsd-compat-headers \
    ffmpeg \
    ffmpeg4-libavcodec \
    ffmpeg4-libavdevice \
    ffmpeg4-libavfilter \
    ffmpeg4-libavformat \
    ffmpeg4-libavutil \
    ffmpeg4-libpostproc \
    ffmpeg4-libswresample \
    ffmpeg4-libswscale \
    gnu-libiconv \
    libdvbcsa \
    libhdhomerun-libs \
    libva \
    libva-intel-driver \
    intel-media-driver \
    libvpx \
    libxml2 \
    libxslt \
    linux-headers \
    mesa-va-gallium \
    opus \
    pcre2 \
    perl \
    perl-datetime-format-strptime \
    perl-json \
    perl-json-xs \
    py3-requests \
    python3 \
    uriparser \
    x264 \
    x265 \
    xmltv \
    zlib

# copy local files and buildstage artifacts
COPY --from=buildstage /tmp/tvheadend-build/usr/ /usr/

COPY requirements.txt /tmp/

RUN \
    apk update \
    && apk add --no-cache --virtual .build-deps \
        musl-dev \
        gcc \
        g++ \
        libxml2-dev \
        libxslt-dev \
        python3-dev \
    && apk add --no-cache \
        tvheadend \
        py3-pip \
        libxslt \
    && pip3 install \
        --no-cache-dir \
        --prefer-binary \
        -r /tmp/requirements.txt \
    && apk del --no-cache --purge .build-deps

# Copy root filesystem
COPY rootfs /

# Build arguments
ARG BUILD_ARCH
ARG BUILD_DATE
ARG BUILD_DESCRIPTION
ARG BUILD_NAME
ARG BUILD_REF
ARG BUILD_REPOSITORY
ARG BUILD_VERSION

# Labels
LABEL \
    io.hass.name="${BUILD_NAME}" \
    io.hass.description="${BUILD_DESCRIPTION}" \
    io.hass.arch="${BUILD_ARCH}" \
    io.hass.type="addon" \
    io.hass.version=${BUILD_VERSION} \
    maintainer="Gautham Varma K <43441192+GauthamVarmaK@users.noreply.github.com>" \
    org.opencontainers.image.title="${BUILD_NAME}" \
    org.opencontainers.image.description="${BUILD_DESCRIPTION}" \
    org.opencontainers.image.vendor="GauthamVarmaK" \
    org.opencontainers.image.authors="Gautham Varma K <43441192+GauthamVarmaK@users.noreply.github.com>" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.url="https://github.com/GauthamVarmaK/addon-tvheadend" \
    org.opencontainers.image.source="https://github.com/${BUILD_REPOSITORY}" \
    org.opencontainers.image.documentation="https://github.com/${BUILD_REPOSITORY}/blob/main/README.md" \
    org.opencontainers.image.created=${BUILD_DATE} \
    org.opencontainers.image.revision=${BUILD_REF} \
    org.opencontainers.image.version=${BUILD_VERSION}
