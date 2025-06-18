ARG BUILD_ARCH=amd64
ARG NTFY_VERSION=2.12.0

FROM ghcr.io/home-assistant/amd64-base AS target

RUN mkdir -p /usr/bin \
    && cd /usr/bin \
    && wget -O ntfy.tar.gz  https://github.com/binwiederhier/ntfy/releases/download/v2.12.0/ntfy_2.12.0_linux_amd64.tar.gz \
    && tar -xf ntfy.tar.gz --strip-components=1 ntfy_2.12.0_linux_amd64/ntfy \
    && chmod +x ntfy

COPY rootfs /
RUN update-ca-certificates
