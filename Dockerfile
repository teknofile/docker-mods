FROM ghcr.io/linuxserver/baseimage-alpine:3.12 as buildstage

RUN \
  apk add --no-cache \
    curl \ 
    git && \
    git clone https://github.com/cunymatthieu/tgenv.git /root-layer/app/tgenv


COPY root/ /root-layer/


FROM scratch
COPY --from=buildstage /root-layer/ /
