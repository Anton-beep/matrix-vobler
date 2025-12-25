#!/bin/bash

docker load -i frp-tunnel.tar

docker compose -f deployments/docker-compose.public-ip-server.yml -p matrix-public-ip-server up -d
