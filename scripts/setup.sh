#!/usr/bin/env bash
# One-time developer setup. Works on Linux, macOS and WSL.
set -euo pipefail
cd "$(dirname "${BASH_SOURCE[0]}")/.."

need() {
  command -v "$1" >/dev/null 2>&1 || { echo "Missing '$1'. $2" >&2; missing=1; }
}
missing=0
need docker "Install Docker (Docker Desktop on macOS/Windows with WSL integration, Docker Engine on Linux)."
need uv "Install: https://docs.astral.sh/uv/getting-started/installation/"
need node "Install Node 22+ (see .nvmrc), e.g. with nvm, fnm or mise."
need pnpm "Install: corepack enable (bundled with Node 22) or https://pnpm.io/installation"
[ "$missing" -eq 0 ] || exit 1

echo "==> Backend dependencies (uv)"
(cd backend && uv sync)

echo "==> Frontend dependencies (pnpm)"
pnpm install

echo "==> Git hooks (pre-commit)"
uv run --project backend pre-commit install --install-hooks

echo
echo "Done. Start the backend with:  make up"
echo "Start the web app with:         make web"
