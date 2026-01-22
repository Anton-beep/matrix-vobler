#!/bin/bash

read -p "Are you sure you want to deploy changes to production? (y/N): " confirm
if [[ "$confirm" != "y" && "$confirm" != "Y" ]]; then
  echo "Deployment aborted."
  exit 1
fi

bash scripts/build/buildFrpTunnel.sh

source scripts/deploy/mainServer.env

ssh "$SERVER_USER@$SERVER_HOST" "if [ -e \"$TARGET_DIR/scripts/stop/stopMainServer.sh\" ]; then
  echo "Stopping existing Main Server..."
  cd \"$TARGET_DIR\"
  chmod +x ./scripts/stop/stopMainServer.sh
  ./scripts/stop/stopMainServer.sh
fi"

ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p \"$TARGET_DIR\""

FILES_TO_COPY=(
  "frp-tunnel.tar"
  "configs/nginxMainServer/nginx.conf"
  "deployments/docker-compose.main-server.yml"
  "scripts/run/runMainServer.sh"
  "scripts/stop/stopMainServer.sh"
  "scripts/postgres-init/postgres-init.sh"
  "mainServer.env"
  "publicIPServer.env"
  "certificates/mainServer"
  "synapseFiles"
  "configs/matrixAuthenticationServer/config.yaml"
  "configs/livekit.yaml"
)

source scripts/utils/copyFilesToServer.sh
copyFilesToServer

ssh "$SERVER_USER@$SERVER_HOST" "cd $TARGET_DIR && chmod +x ./scripts/run/runMainServer.sh && ./scripts/run/runMainServer.sh"
