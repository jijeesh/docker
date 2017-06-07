#!/usr/bin/env bash
docker run -it --rm --name haproxy-syntax-check jijeesh/haproxy haproxy -c -f /usr/local/etc/haproxy/haproxy.cfg