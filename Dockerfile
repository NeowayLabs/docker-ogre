FROM debian:jessie

ENV DOCKER_VERSION 17.05.0~ce-0~debian-jessie
ENV NODEJS_VERSION 8.x
ENV GOLANG_VERSION 1.8.3

ENV GOPATH /go
ENV PATH $GOPATH/bin:/usr/local/go/bin:$PATH

ENV BUILD_PACKAGES "apt-transport-https python-pip"
ENV RUNTIME_PACKAGES "git curl build-essential ca-certificates fontconfig"

RUN apt-get update \
    && apt-get install -y --no-install-recommends $BUILD_PACKAGES $RUNTIME_PACKAGES \
    && echo "deb https://apt.dockerproject.org/repo debian-jessie main" > /etc/apt/sources.list.d/docker.list \
    && apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D \
    && apt-get update \
    && apt-get install -y --no-install-recommends docker-engine=$DOCKER_VERSION \
    && pip install docker-compose \
    && curl -sL https://deb.nodesource.com/setup_$NODEJS_VERSION | bash \
    && apt-get install -y --no-install-recommends nodejs \
    && npm install -g --unsafe-perm bower gulp phantomjs-prebuilt \
    && curl -fsSL "https://golang.org/dl/go$GOLANG_VERSION.linux-amd64.tar.gz" -o golang.tar.gz \
    && echo "1862f4c3d3907e59b04a757cfda0ea7aa9ef39274af99a784f5be843c80c6772  golang.tar.gz" | sha256sum -c - \
    && tar -C /usr/local -xzf golang.tar.gz \
    && rm golang.tar.gz \
    && mkdir -p "$GOPATH/src" "$GOPATH/bin" \
    && chmod -R 777 "$GOPATH" \
    && apt-get remove --purge -y $BUILD_PACKAGES \
    && rm -rf /var/lib/apt/lists/*
