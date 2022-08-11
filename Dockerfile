FROM ghcr.io/linuxserver/baseimage-alpine:3.12 as buildstage

WORKDIR /root-layer/app/

RUN apk add --no-cache \
  dpkg \
  curl \
  git

RUN if [ "${TARGETPLATFORM}" == "linux/arm64" ] ; then \
      curl -Lo /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-arm64.tar.gz ; \
  elif [ "${TARGETPLATFORM}" == "linux/arm/v7" ] ; then \
      curl -Lo /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-arm.tar.gz ; \
  else \
      curl -Lo /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-amd64.tar.gz ; \
  fi

RUN tar -xzf /tmp/terraform-docs.tar.gz -C /tmp/
RUN chmod +x /tmp/terraform-docs
RUN mkdir -p /root-layer/app/terraform-docs 
RUN mv /tmp/terraform-docs /root-layer/app/terraform-docs/terraform-docs

RUN \
    git clone --depth=1 https://github.com/tfutils/tfenv.git /root-layer/app/tfenv

RUN \
  git clone https://github.com/cunymatthieu/tgenv.git /root-layer/app/tgenv


RUN \
  mkdir -p /root-layer/app/tfsec/ && \
  curl -o /root-layer/app/tfsec/install.sh -s https://raw.githubusercontent.com/aquasecurity/tfsec/master/scripts/install_linux.sh && \
  chmod +x /root-layer/app/tfsec/install.sh && \
  TFSEC_INSTALL_PATH=/root-layer/app/tfsec/ /root-layer/app/tfsec/install.sh

COPY root/ /root-layer/

FROM scratch
COPY --from=buildstage /root-layer/ /
