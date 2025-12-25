#!/bin/bash

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
)

for FILE in "${FILES_TO_COPY[@]}"; do
  # Create parent directory for the file on the server
  DIR_ON_SERVER=$(dirname "$FILE")
  ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p \"$TARGET_DIR/$DIR_ON_SERVER\""

  # Copy file to server inside the target directory
  scp -r "$FILE" "$SERVER_USER@$SERVER_HOST:$TARGET_DIR/$FILE"
done

ssh "$SERVER_USER@$SERVER_HOST" "cd $TARGET_DIR && chmod +x ./scripts/run/runMainServer.sh && ./scripts/run/runMainServer.sh"
