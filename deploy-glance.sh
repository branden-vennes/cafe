#!/usr/bin/env bash
# Deploys/updates the glance container on cafe-host, joined to the existing
# cafe-net podman network, then reloads Caddy to pick up the glance.branden.cafe route.
set -euo pipefail

SERVER="$USER@$COMPUTER"

scp glance.yml "$SERVER:$CAFE_DIR/glance.yml"

ssh "$SERVER" "
set -e

cd $CAFE_DIR

echo '--- pulling image ---'
podman pull docker.io/glanceapp/glance:latest

echo '--- removing existing container (if any) ---'
podman rm -f glance 2>/dev/null || true

echo '--- ensuring cafe-net exists ---'
podman network exists cafe-net || podman network create cafe-net

echo '--- ensuring caddy container exists ---'
if ! podman container exists caddy; then
  podman run -d --name caddy --network cafe-net \
    -p 80:80 -p 443:443 \
    -v ./Caddyfile:/etc/caddy/Caddyfile:ro \
    -v caddy_data:/data \
    caddy:latest
fi

echo '--- running container ---'
podman run -d --name glance --network cafe-net \
  -v ./glance.yml:/app/config/glance.yml:ro \
  docker.io/glanceapp/glance:latest

echo '--- reloading caddy ---'
podman exec caddy caddy reload --config /etc/caddy/Caddyfile --adapter caddyfile

echo '--- status ---'
podman ps -a --filter name=glance
"

curl -sk -o /dev/null -w "glance.branden.cafe -> %{http_code}\n" https://glance.branden.cafe
