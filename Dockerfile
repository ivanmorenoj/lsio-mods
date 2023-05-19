FROM lsiobase/ubuntu:focal as buildstage

ENV AWS_CLI_VERSION=2.4.16
ENV KUBECTL_VERSION=v1.23.3
ENV HELM_VERSION=v3.8.0

RUN \
  echo " ****  Installing AWS CLI tool ****" && \
  apt-get update && \
  apt-get install \
    unzip && \
  mkdir -p /root-layer/usr/local/ /tmp/awscli /tmp/helm && \
  curl -o /tmp/awscli.zip \
    "https://awscli.amazonaws.com/awscli-exe-linux-x86_64-$AWS_CLI_VERSION.zip" && \
  unzip /tmp/awscli.zip -d /tmp/awscli/ && \
  /tmp/awscli/aws/install \
    --bin-dir /usr/local/bin \
    --install-dir /usr/local/aws-cli && \
  cp -ra /usr/local/bin /usr/local/aws-cli /root-layer/usr/local && \
  echo " **** Installing kubectl ****" && \
  curl -sL "https://dl.k8s.io/release/$KUBECTL_VERSION/bin/linux/amd64/kubectl" \
    -o /root-layer/usr/local/bin/kubectl && \
  chmod +x /root-layer/usr/local/bin/kubectl && \
  echo " **** Installing helm ****" && \
  curl -sL "https://get.helm.sh/helm-$HELM_VERSION-linux-amd64.tar.gz" \
    -o /tmp/helm.tar.gz && \
  tar -zxvf /tmp/helm.tar.gz -C /tmp/helm && \
  cp -a /tmp/helm/linux-amd64/helm /root-layer/usr/local/bin/ && \
  chmod +x /root-layer/usr/local/bin/helm
  
COPY root/ /root-layer/

# runtime stage
FROM scratch

LABEL org.opencontainers.image.source https://github.com/ivanmorenoj/lsio-mods

# Add files from buildstage
COPY --from=buildstage /root-layer/ /
