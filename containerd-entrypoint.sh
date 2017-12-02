#!/bin/sh

/usr/local/bin/containerd &> /var/log/containerd.log &

exec "$@"
