FROM ghcr.io/linuxserver/baseimage-alpine:3.12 as buildstage
ENV PYTHONUSERBASE /app
ENV PATH "$PATH:/app/bin/"

WORKDIR /app/

RUN apk add --no-cache curl

RUN if [ "${TARGETPLATFORM}" == "linux/arm64" ] ; then \
      curl -Lo /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-arm64.tar.gz ; \
  elif [ "${TARGETPLATFORM}" == "linux/arm/v7" ] ; then \
      curl -Lo /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-arm.tar.gz ; \
  else \
      curl -Lo /tmp/terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-linux-amd64.tar.gz ; \
  fi

RUN tar -xzf /tmp/terraform-docs.tar.gz -C /tmp/
RUN chmod +x /tmp/terraform-docs
RUN mkdir -p /app/terraform-docs 
RUN mv /tmp/terraform-docs /app/terraform-docs/terraform-docs

COPY root/ /root-layer/

FROM scratch
COPY --from=buildstage /root-layer/ /
COPY --from=buildstage /app /app
