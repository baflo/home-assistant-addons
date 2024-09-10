# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM AS build


ARG YQ_BINARY=yq_linux_amd64
ARG YQ_VERSION=4.30.8

ENV CONFIG_PATH=/data/options.json

RUN curl -Lo /usr/bin/yq https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/${YQ_BINARY} \
    && chmod +x /usr/bin/yq

RUN touch /etc/environment \
    && echo "JWT_SECRET_KEY=$(ha-config '.jwtSecretKey')"   >> /etc/environment \
    && echo "STORAGE_URL=$(ha-config '.storageUrl')"        >> /etc/environment

FROM ddvk/rmfakecloud

COPY --from=build /usr/bin/env /usr/bin/env
COPY --from=build /etc/environment /etc/environment

ADD --chmod=+x https://github.com/kreuzwerker/envplate/releases/download/v0.0.7/ep-linux /bin/ep
ENTRYPOINT ["ep", "-v", "/etc/environment", "--", "/rmfakecloud-docker"]
