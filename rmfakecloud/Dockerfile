FROM busybox:1.35.0-uclibc AS busybox

FROM ddvk/rmfakecloud

COPY --from=busybox /bin/sh /bin/sh
COPY /rootfs /

ENTRYPOINT ["/entrypoint.sh"]
