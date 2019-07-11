#!/bin/bash
apt update -y
apt install -y docker.io
docker run -dt --name ss -p 443:6443 mritd/shadowsocks -s "-s 0.0.0.0 -p 6443 -m chacha20-ietf-poly1305 -k test123"
