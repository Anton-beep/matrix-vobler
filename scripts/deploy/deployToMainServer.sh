#!/bin/bash

bash scripts/build/buildFrpTunnel.sh

source scripts/deploy/mainServer.env

FILES_TO_COPY=(
  "frp-tunnel.tar"
  "configs/nginx/mainServer.conf"
  "deployments/docker-compose.main-server.yml"
  "scripts/run/runMainServer.sh"
  "mainServer.env"
  "certificates/mainServer/"
)

for FILE in "${FILES_TO_COPY[@]}"; do
  # Create parent directory for the file on the server
  DIR_ON_SERVER=$(dirname "$FILE")
  ssh "$SERVER_USER@$SERVER_HOST" "mkdir -p \"$TARGET_DIR/$DIR_ON_SERVER\""

  # Copy file to server inside the target directory
  scp -r "$FILE" "$SERVER_USER@$SERVER_HOST:$TARGET_DIR/$FILE"
done

ssh "$SERVER_USER@$SERVER_HOST" "chmod +x $TARGET_DIR/scripts/run/runMainServer.sh && cd $TARGET_DIR && ./scripts/run/runMainServer.sh"
