#!/bin/bash

bash scripts/build/buildFrpTunnel.sh

source scripts/deploy/publicIPServer.env

ssh "$SERVER_USER@$SERVER_HOST" "if [ -e \"$TARGET_DIR/scripts/stop/stopPublicIPServer.sh\" ]; then
  cd \"$TARGET_DIR\"
  chmod +x ./scripts/stop/stopPublicIPServer.sh
  ./scripts/stop/stopPublicIPServer.sh
fi"

ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p \"$TARGET_DIR\""

FILES_TO_COPY=(
  "frp-tunnel.tar"
  "deployments/docker-compose.public-ip-server.yml"
  "publicIPServer.env"
  "scripts/run/runPublicIPServer.sh"
  "scripts/stop/stopPublicIPServer.sh"
)

source scripts/utils/copyFilesToServer.sh
copyFilesToServer

ssh "$SERVER_USER@$SERVER_HOST" "cd $TARGET_DIR && chmod +x ./scripts/run/runPublicIPServer.sh && ./scripts/run/runPublicIPServer.sh"
