#!/bin/bash

source scripts/deploy/publicIPServer.env

PUBLIC_IP_SERVER_HOST="$SERVER_HOST"
PUBLIC_IP_SERVER_USER="$SERVER_USER"

source scripts/deploy/mainServer.env

ssh "$PUBLIC_IP_SERVER_USER@$PUBLIC_IP_SERVER_HOST" "docker stop nginx-reverse-proxy && certbot certonly --standalone   --config-dir /matrix-certs/letsencrypt   --work-dir /matrix-certs/letsencrypt/work   --logs-dir /matrix-certsletsencrypt/logs   -d matrix.vobler-tech.space --force-renewal --non-interactive && docker start nginx-reverse-proxy"

scp "$PUBLIC_IP_SERVER_USER@$PUBLIC_IP_SERVER_HOST:/matrix-certs/letsencrypt/live/matrix.vobler-tech.space/fullchain.pem" "certificates/mainServer/fullchain.pem"

scp "$PUBLIC_IP_SERVER_USER@$PUBLIC_IP_SERVER_HOST:/matrix-certs/letsencrypt/live/matrix.vobler-tech.space/privkey.pem" "certificates/mainServer/privkey.pem"

scp "certificates/mainServer/fullchain.pem" "$SERVER_USER@$SERVER_HOST:$TARGET_DIR/certificates/mainServer/fullchain.pem"

scp "certificates/mainServer/privkey.pem" "$SERVER_USER@$SERVER_HOST:$TARGET_DIR/certificates/mainServer/privkey.pem"

ssh "$SERVER_USER@$SERVER_HOST" "docker restart matrix-main-server-nginx-1"
