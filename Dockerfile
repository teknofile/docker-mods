FROM ghcr.io/linuxserver/baseimage-alpine:3.12 as buildstage

RUN \
  apk add --no-cache \
    dpkg \
    curl && \
    mkdir -p /root-layer/app/tfsec/ && \
    curl -o /root-layer/app/tfsec/install.sh -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh && \
    chmod +x /root-layer/app/tfsec/install.sh && \
    TFSEC_INSTALL_PATH=/root-layer/app/tfsec/ /root-layer/app/tfsec/install.sh

COPY root/ /root-layer/

FROM scratch
COPY --from=buildstage /root-layer/ /
