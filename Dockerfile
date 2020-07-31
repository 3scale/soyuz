FROM hashicorp/terraform:0.12.29 as terraform


FROM debian:stable-slim

ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
  &&  apt-get install -y --no-install-recommends \
  git make openssh-client \
  default-mysql-client \
  python3-minimal\
  awscli \
  ruby \
  && apt-get clean autoclean \
  && apt-get autoremove -y --purge \
  && rm -rf /var/lib/apt/lists/*

COPY --from=terraform /bin/terraform /usr/bin

RUN apk add --update \
  git openssh-client \
  make build-base bash \
  mysql-client \
  busybox-extras \
  go \
  ruby python python-dev py-pip \
  && pip install --upgrade pip \
  && pip install awscli==$AWSCLI_VERSION --upgrade \
  && apk --purge -v del py-pip \
  && rm -rf /var/cache/apk/* \
  && rm -rf $HOME/.cache

RUN go get -u github.com/dmitry-at-hyla/liche

ENV BIN_3SCALE /opt/3scale/bin

ENV PATH "$BIN_3SCALE:$PATH"

ADD bin/ $BIN_3SCALE

RUN chmod -R 0755 $BIN_3SCALE
