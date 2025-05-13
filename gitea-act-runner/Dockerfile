

ARG BUILD_FROM
FROM ${BUILD_FROM} AS builder

ARG BASHIO_VERSION="v0.17.0"
ARG TEMPIO_VERSION="2024.11.2"

# Install Linux tools
RUN apk add --no-cache curl

# Install Home Assistant Add-on Base tools
RUN curl -J -L -o /tmp/bashio.tar.gz \
        "https://github.com/hassio-addons/bashio/archive/${BASHIO_VERSION}.tar.gz" \
    && mkdir /tmp/bashio \
    && tar zxvf \
        /tmp/bashio.tar.gz \
        --strip 1 -C /tmp/bashio \
    \
    && mv /tmp/bashio/lib /usr/lib/bashio \
    && ln -s /usr/lib/bashio/bashio /usr/bin/bashio
    
RUN curl -L -s -o /usr/bin/tempio \
        "https://github.com/home-assistant/tempio/releases/download/${TEMPIO_VERSION}/tempio_${BUILD_ARCH}" \
    && chmod a+x /usr/bin/tempio
    
# Optional: Create a non-root user if needed
# RUN adduser -D -H -u 1000 hassio

FROM ${BUILD_FROM} AS target

COPY --from=builder /usr/lib/bashio /usr/lib/bashio
COPY --from=builder /usr/bin/bashio /usr/bin/bashio

COPY --from=builder /usr/bin/tempio /usr/bin/tempio

# Copy run script
COPY rootfs /
RUN chmod +x /run.sh

ENTRYPOINT ["/sbin/tini" "--" "/run.sh"]
