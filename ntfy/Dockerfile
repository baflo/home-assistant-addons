ARG BUILD_ARCH=amd64
ARG NTFY_VERSION=2.12.0

FROM ghcr.io/home-assistant/${BUILD_ARCH}-base AS target

RUN mkdir -p /usr/bin \
    && cd /usr/bin \
    && wget -O ntfy  https://github.com/binwiederhier/ntfy/releases/download/v${NTFY_VERSION}/ntfy_${NTFY_VERSION}_linux_${BUILD_ARCH}.tar.gz \
    && chmod +x ntfy

COPY rootfs /
RUN update-ca-certificates
