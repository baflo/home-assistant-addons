ARG BUILD_ARCH=amd64
ARG GITEA_ACT_RUNNER_VERSION=0.2.11

FROM ghcr.io/home-assistant/${BUILD_ARCH}-base AS target

ARG BUILD_ARCH
ARG GITEA_ACT_RUNNER_VERSION

# Install Gitea Act Runner
RUN mkdir -p /usr/bin \
    && cd /usr/bin \
    && wget -o gitea_act_runner https://gitea.com/gitea/act_runner/releases/download/v${GITEA_ACT_RUNNER_VERSION}/act_runner-${GITEA_ACT_RUNNER_VERSION}-linux-${BUILD_ARCH} \
    && chmod +x gitea_act_runner

COPY rootfs /
RUN update-ca-certificates
