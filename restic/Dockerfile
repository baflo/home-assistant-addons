# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM

# Execute during the build of the image
ARG RESTIC_VERSION BUILD_ARCH

RUN curl -sSLf -o /tmp/restic.bz2 \
    "https://github.com/restic/restic/releases/download/v${RESTIC_VERSION}/restic_${RESTIC_VERSION}_linux_${BUILD_ARCH}.bz2" && \
    cd /tmp && bunzip2 restic.bz2 && \
    chmod +x restic && mv restic /usr/bin/restic

# Copy root filesystem
COPY rootfs /
RUN chmod +x /etc/services.d/restic-backup/*
