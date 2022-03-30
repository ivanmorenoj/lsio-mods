FROM lsiobase/ubuntu:bionic as buildstage

ARG UDP2RAW_VERSION=20200818.0

RUN \
  echo " ****  Installing udp2raw ****" && \
  mkdir -p /root-layer/usr/local/bin /tmp/udp2raw/ && \
  curl -fsSL "https://github.com/wangyu-/udp2raw/releases/download/${UDP2RAW_VERSION}/udp2raw_binaries.tar.gz" | \
    tar -xz -C /tmp/udp2raw/ && \
  chmod +x /tmp/udp2raw/udp2raw* && \
  mv /tmp/udp2raw/udp2raw* /root-layer/usr/local/bin/
  
COPY root/ /root-layer/

# runtime stage
FROM scratch

LABEL maintainer="Ivan Moreno"

# Add files from buildstage
COPY --from=buildstage /root-layer/ /
