FROM busybox:1.35.0-uclibc AS busybox

FROM ddvk/rmfakecloud

ARG YQ_VERSION=4.44.3
ADD --chmod=755 https://github.com/mikefarah/yq/releases/download/v${YQ_VERSION}/yq_linux_amd64 /bin/yq

COPY --from=busybox /bin/sh /bin/sh
COPY /rootfs /

ENTRYPOINT ["/entrypoint.sh"]
