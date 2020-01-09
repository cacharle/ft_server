#!/bin/sh

cd /root
mkdir ssl
cd ssl

curl -L https://github.com/FiloSottile/mkcert/releases/download/v1.1.2/mkcert-v1.1.2-linux-amd64 > mkcert
chmod +x mkcert
./mkcert -install
./mkcert localhost
