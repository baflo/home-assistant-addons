# https://developers.home-assistant.io/docs/add-ons/configuration#add-on-dockerfile
ARG BUILD_FROM
FROM $BUILD_FROM


RUN mkdir -p /data \
    && mv /teddycloud /data/ \
    && ln -s /data/teddycloud /teddycloud

