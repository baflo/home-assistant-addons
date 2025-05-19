ARG BUILD_ARCH amd64

FROM ghcr.io/home-assistant/${BUILD_ARCH}-base AS builder

COPY rootfs /
RUN update-ca-certificates

# Nothing to do here, just a placeholder

FROM ghcr.io/home-assistant/${BUILD_ARCH}-base AS target

# Install Gitea Act Runner
RUN mkdir -p /usr/bin \
    && cd /usr/bin \
    && curl -Lo gitea_act_runner https://gitea.com/gitea/act_runner/releases/download/v${GITEA_ACT_RUNNER_VERSION}/act_runner-${GITEA_ACT_RUNNER_VERSION}-linux-${BUILD_ARCH} \
    && chmod +x gitea_act_runner

COPY rootfs /
RUN update-ca-certificates
