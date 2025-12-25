#!/bin/bash

docker compose -f deployments/docker-compose.public-ip-server.yml -p matrix-public-ip-server down
