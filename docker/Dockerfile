# syntax=docker/dockerfile:1

# ---- main: slim Node runtime with the MCP server ----
FROM node:20-slim AS main

WORKDIR /app

# Install production dependencies first (better layer caching).
COPY package.json package-lock.json ./
RUN npm ci --omit=dev

# App source + manifest.
COPY src ./src
COPY tool-manifest.json ./
COPY README.md ./

# Entrypoint that links the mounted config/.env into the app root.
COPY docker/entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

# config/ (holds .env) is mounted at runtime. Mark it as a volume like the
# reference bots.
RUN mkdir -p /app/config && chown -R node:node /app
VOLUME [ "/app/config" ]

ENV NODE_ENV=production \
    APP_ROOT=/app

# Run as the NFS share owner (1000:1000) so /app/config is readable/writable
# on the NAS-backed config volume without relying on a securityContext override.
# node:20-slim already ships the "node" user with uid/gid 1000.
USER node

ENTRYPOINT [ "entrypoint.sh" ]