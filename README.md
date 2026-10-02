# Al Ojeiri platform

Monorepo for the Al Ojeiri digital platform revamp (website, iOS, Android, Wear OS, watchOS and the shared backend).
Requirements come from the RFQ; see [docs/architecture.md](docs/architecture.md) for how they map onto this layout.

```
.
├── backend/              Django 6 + DRF REST API, PostgreSQL, uv-managed, dockerised
│   ├── apps/             Domain apps (calendars, prayer_times, markets, planner, store, ...)
│   ├── config/           Settings (base/dev/staging/test), URLs, WSGI/ASGI
│   └── compose.yaml      One-command dev stack (API + Postgres)
├── frontend/             pnpm + Turborepo workspace (TypeScript)
│   ├── web/              React + Vite SPA
│   ├── mobile/           React Native (Expo dev client) for iOS and Android
│   └── packages/         Shared: api-client, i18n (ar/en), design-tokens, config (tsconfig/eslint)
├── wearables/            Native companions: watchos/ (SwiftUI), wearos/ (Compose)
├── widgets/              Native home-screen widgets: ios/ (WidgetKit), android/ (Glance)
├── deploy/staging/       Hostinger VPS compose stack + Caddyfile
├── docs/                 Architecture and deployment guides
├── scripts/              Cross-platform helper scripts
└── .github/              CI, staging deploy, Dependabot, PR template
```

## Quick start

Works the same on Linux, macOS and WSL2 (keep the clone inside the WSL filesystem, not `/mnt/c`).

Prerequisites: [Docker](https://docs.docker.com/get-docker/) (with WSL integration on Windows), [uv](https://docs.astral.sh/uv/),
Node 22+ (see `.nvmrc`) and pnpm (`corepack enable`).

```bash
make setup      # installs backend + frontend deps and git hooks (once)
make up         # backend + Postgres at http://localhost:8000  (API docs: /api/docs/)
make web        # web app at http://localhost:5173 (proxies /api to the backend)
```

`make help` lists every command. `make check` runs everything CI runs.

| Task                 | Command                             |
| -------------------- | ----------------------------------- |
| Backend tests        | `make test-backend`                 |
| Migrations           | `make makemigrations` / `make migrate` |
| Django shell / admin user | `make shell` / `make superuser` |
| Regenerate API types | `make gen-api` (backend must be up) |
| Mobile dev server    | `make mobile`                       |

### Platform notes

- **iOS / watchOS / iOS widgets** need macOS + Xcode (or EAS cloud builds for the React Native app). Everything else is buildable on Linux/WSL.
- **Android / Wear OS** use Android Studio. From WSL, run the emulator on the Windows host and connect `adb` over TCP.
- Django runs only inside Docker by default, so no local Python install beyond `uv` is needed for tooling.

## Delivery pipeline

PRs run `CI / backend` and `CI / frontend`. On merge to `main`, the same suites run again, then images are built, pushed to GHCR
and deployed to the staging VPS. See [docs/deployment.md](docs/deployment.md).
