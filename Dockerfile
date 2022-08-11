FROM ghcr.io/linuxserver/baseimage-alpine:3.12 as buildstage
ENV PYTHONUSERBASE /app
ENV PATH "$PATH:/app/bin/"

WORKDIR /app/

RUN apk add --no-cache curl

RUN curl -Lo ./terraform-docs.tar.gz https://github.com/terraform-docs/terraform-docs/releases/download/v0.16.0/terraform-docs-v0.16.0-$(uname)-amd64.tar.gz
RUN tar -xzf terraform-docs.tar.gz
RUN chmod +x terraform-docs
RUN mkdir -p /app/terraform-docs && mv terraform-docs /app/terraform-docs/terraform-docs

COPY root/ /root-layer/

FROM scratch
COPY --from=buildstage /root-layer/ /
COPY --from=buildstage /app /app
