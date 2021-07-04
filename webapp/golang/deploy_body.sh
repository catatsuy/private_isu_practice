#!/bin/bash

set -x

echo "start deploy ${USER}"
GOOS=linux GOARCH=amd64 go build -o app_linux
for server in isu-app; do
  ssh -t $server "sudo systemctl stop isu-go"
  rsync -vau templates/ $server:/home/isucon/private_isu/webapp/golang/templates/
  scp ./app_linux $server:/home/isucon/private_isu/webapp/golang/app
  ssh -t $server "sudo systemctl start isu-go"
done

echo "finish deploy ${USER}"
