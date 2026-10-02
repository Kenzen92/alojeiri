# syntax=docker/dockerfile:1.7
# Builds the SPA and serves it with Caddy, which also reverse-proxies the API (see deploy/staging/Caddyfile).
# Build context must be the repository root:  docker build -f frontend/web/Dockerfile .
FROM node:26-alpine AS build
RUN corepack enable
WORKDIR /repo
COPY package.json pnpm-workspace.yaml pnpm-lock.yaml .npmrc ./
COPY frontend/web/package.json frontend/web/
COPY frontend/mobile/package.json frontend/mobile/
COPY frontend/packages/api-client/package.json frontend/packages/api-client/
COPY frontend/packages/config/package.json frontend/packages/config/
COPY frontend/packages/design-tokens/package.json frontend/packages/design-tokens/
COPY frontend/packages/i18n/package.json frontend/packages/i18n/
RUN --mount=type=cache,target=/root/.local/share/pnpm/store \
    pnpm install --frozen-lockfile --filter @alojeiri/web...
COPY frontend/web frontend/web
COPY frontend/packages frontend/packages
RUN pnpm --filter @alojeiri/web build

FROM caddy:2-alpine AS production
COPY --from=build /repo/frontend/web/dist /srv
