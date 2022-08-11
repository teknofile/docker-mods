FROM ghcr.io/linuxserver/baseimage-alpine:3.12 as buildstage
ENV PYTHONUSERBASE /app
ENV PATH "$PATH:/app/bin/"

WORKDIR /app/

RUN apk add --no-cache \
  libffi \
  py3-pip

RUN apk add --no-cache --virtual .build \
  build-base libffi-dev

RUN pip3 install --user --no-cache-dir --prefer-binary setuptools
RUN pip3 install --user --no-cache-dir --prefer-binary  \
        --find-links https://wheels.home-assistant.io/alpine-3.14/amd64/ \
        --find-links https://wheels.home-assistant.io/alpine-3.14/aarch64/ \
        checkov

COPY root/ /root-layer/

FROM scratch
COPY --from=buildstage /root-layer/ /
COPY --from=buildstage /app /app
