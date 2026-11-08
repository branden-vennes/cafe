#!/usr/bin/env bash
# Deploys/updates the baking (bakers-percent) container on cafe-host, joined to
# cafe-net, plus one-time bootstrap for the network and Caddy container if missing.
#
# Assumes the localhost/b-vennes/bakers-percent:latest image is already built/loaded
# on the server (via the BakersPercent repo's flake.nix, out of scope here).
set -euo pipefail

SERVER="$USER@$COMPUTER"

scp Caddyfile "$SERVER:$CAFE_DIR/Caddyfile"

ssh "$SERVER" "
set -e
cd $CAFE_DIR

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

echo '--- (re)starting baking container ---'
podman rm -f baking 2>/dev/null || true
podman run -d --name baking --network cafe-net localhost/b-vennes/bakers-percent:latest

echo '--- reloading caddy ---'
podman exec caddy caddy reload --config /etc/caddy/Caddyfile --adapter caddyfile

echo '--- status ---'
podman ps -a --filter name=baking --filter name=caddy
"

curl -sk -o /dev/null -w "baking.branden.cafe -> %{http_code}\n" https://baking.branden.cafe
