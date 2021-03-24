FROM hashicorp/terraform:0.12.29 as terraform

FROM golang:1.14.6-buster as go

RUN GO111MODULE=on go get github.com/raviqqe/liche

FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
  &&  apt-get install -y --no-install-recommends \
  git make openssh-client \
  default-mysql-client \
  python3-minimal ruby \
  awscli \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/*

COPY --from=terraform /bin/terraform /usr/bin

ENV GO_BIN /go/bin
ENV PATH "$GO_BIN:$PATH"

COPY --from=go /go/bin $GO_BIN

ENV BIN_3SCALE /opt/3scale/bin
ENV PATH "$BIN_3SCALE:$PATH"

ADD bin/ $BIN_3SCALE
RUN chmod -R 0755 $BIN_3SCALE
