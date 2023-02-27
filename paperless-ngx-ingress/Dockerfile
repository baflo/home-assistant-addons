FROM ghcr.io/paperless-ngx/paperless-ngx:latest

ARG YQ_BINARY=yq_linux_amd64
ARG YQ_VERSION=4.30.8
ARG S6_OVERLAY_VERSION=3.1.3.0

ENV CONFIG_PATH=/data/options.json

RUN curl -Lo /usr/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/${YQ_BINARY} \
    && chmod +x /usr/bin/yq

RUN apt-get update && apt-get install -y nginx redis-server xz-utils && apt autoremove && apt clean

# Install s6-overlay
ADD https://github.com/just-containers/s6-overlay/releases/download/v3.1.3.0/s6-overlay-noarch.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-noarch.tar.xz
ADD https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-x86_64.tar.xz /tmp
RUN tar -C / -Jxpf /tmp/s6-overlay-x86_64.tar.xz
ENTRYPOINT ["/init"]

COPY rootfs /
RUN chmod a+x /run.sh /usr/bin/get-port

CMD ["/run.sh", "/usr/local/bin/paperless_cmd.sh"]
EXPOSE 8000
