#!/bin/sh
# Entrypoint for the loggly-mcp container.
#
# The server loads .env from its working directory (process.cwd()). The config
# volume (NFS-backed) is mounted at /app/config and holds the real .env file.
# Link it into the app root so the server picks it up without baking secrets
# into the image.
#
# Usage: entrypoint.sh [node args...]

set -e

APP_ROOT="${APP_ROOT:-/app}"

if [ -f "$APP_ROOT/config/.env" ]; then
    ln -sf "$APP_ROOT/config/.env" "$APP_ROOT/.env"
    echo "[entrypoint] linked $APP_ROOT/config/.env -> $APP_ROOT/.env"
else
    echo "[entrypoint] warning: no .env at $APP_ROOT/config/.env" >&2
fi

exec node src/index.js "$@"