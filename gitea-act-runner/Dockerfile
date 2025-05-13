ARG BUILD_FROM
FROM ${BUILD_FROM}

ARG BASHIO_VERSION="v0.17.0"

# Install Home Assistant Add-on Base tools
RUN curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf \
        /tmp/bashio.tar.gz \
        --strip 1 -C /tmp/bashio \
    \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    \
    && curl -L -s -o /usr/bin/tempio \
        "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}" \
    && chmod a+x /usr/bin/tempio
    
# Optional: Create a non-root user if needed
# RUN adduser -D -H -u 1000 hassio

# Copy run script
COPY rootfs /
RUN chmod +x /run.sh

ENTRYPOINT ["/sbin/tini" "--" "/run.sh"]
