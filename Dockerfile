FROM golang:alpine

ENV GOPATH=/go PATH=$PATH:/go/bin
RUN apk update \
  && apk add git gcc make libcap-dev btrfs-progs-dev libc-dev libseccomp-dev

RUN mkdir -p $GOPATH/src/github.com/opencontainers && cd $GOPATH/src/github.com/opencontainers \
  && git clone https://github.com/opencontainers/runc && cd runc \
  && go build -buildmode=pie  -ldflags "-X main.gitCommit="91e979501348cb4cb13b5fb4437cc5d9ecd94b5d" -X main.version=1.0.0-rc4+dev " -tags "seccomp" -o runc . \
  && cp runc /usr/bin/

RUN go get -u github.com/containerd/containerd && cd $GOPATH/src/github.com/containerd/containerd \
  && make && make install

# build and run containerd container
FROM alpine:latest

COPY --from=0 /usr/local/bin /usr/local/bin
COPY --from=0 /usr/bin/runc /usr/bin/

RUN apk update \
  && apk add ca-certificates libseccomp-dev \
  && update-ca-certificates

VOLUME ["/var/lib/containerd"]

COPY containerd-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["/bin/sh"]

