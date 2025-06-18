ARG BUILD_ARCH=amd64
ARG NTFY_VERSION=2.12.0

FROM ghcr.io/home-assistant/amd64-base AS target

RUN apk add openssl \
            curl \
            ca-certificates \
            envsubst

RUN printf  "%s%s%s%s\n" \
            "@nginx " \
            "http://nginx.org/packages/alpine/v" \
            `egrep -o '^[0-9]+\.[0-9]+' /etc/alpine-release` \
            "/main" \
            | tee -a /etc/apk/repositories \
    && curl -o /tmp/nginx_signing.rsa.pub https://nginx.org/keys/nginx_signing.rsa.pub \
    && openssl rsa -pubin -in /tmp/nginx_signing.rsa.pub -text -noout \
    && mv /tmp/nginx_signing.rsa.pub /etc/apk/keys/ \
    && apk add nginx@nginx

RUN mkdir -p /usr/bin \
    && cd /usr/bin \
    && wget -O ntfy.tar.gz  https://github.com/binwiederhier/ntfy/releases/download/v2.12.0/ntfy_2.12.0_linux_amd64.tar.gz \
    && tar -xf ntfy.tar.gz --strip-components=1 ntfy_2.12.0_linux_amd64/ntfy \
    && chmod +x ntfy

COPY rootfs /
RUN update-ca-certificates
