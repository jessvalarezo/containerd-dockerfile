# build and run containerd container
FROM alpine:latest

# update to alpine get
RUN apk update \
      #&& apk add wget unzip \
      && apk add ca-certificates wget unzip \
      &&   update-ca-certificates \
      wget -c https://github.com/containerd/containerd/releases/download/v1.0.0-rc.0/containerd-1.0.0-rc.0.linux-amd64.tar.gz -O /tmp/ctrd.tar.gz \
      tar -C /usr/local/ -zxf /tmp/ctrd.tar.gz \
      wget https://github.com/crosbymichael/runc/releases/download/ctd-7/runc -O /bin/runc \
      chmod +x /bin/runc

VOLUME ["/var/lib/containerd"]

COPY containerd-entrypoint.sh /entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]

CMD ["bin/sh"]

