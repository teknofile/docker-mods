FROM ghcr.io/linuxserver/baseimage-alpine:3.12 as buildstage

RUN \
  apk add --no-cache \
    git && \
    git clone --depth=1 https://github.com/tfutils/tfenv.git /root-layer/app/tfenv

COPY root/ /root-layer/

FROM scratch
COPY --from=buildstage /root-layer/ /
