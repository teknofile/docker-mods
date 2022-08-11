FROM ghcr.io/linuxserver/baseimage-alpine:3.12 as buildstage

RUN apk add --no-cache \
  dpkg \
  curl \
  git


COPY root/ /root-layer/

FROM scratch
COPY --from=buildstage /root-layer/ /
