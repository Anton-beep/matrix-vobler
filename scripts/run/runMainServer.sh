#!/bin/bash

docker load -i frp-tunnel.tar

docker compose -f deployments/docker-compose.main-server.yml -p matrix-main-server up -d --build
