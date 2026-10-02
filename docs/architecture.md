# Architecture & layout decisions

## Stack

| Concern            | Choice                                                                 |
| ------------------ | ---------------------------------------------------------------------- |
| Backend            | Django 6.1, Django REST Framework, drf-spectacular (OpenAPI), PostgreSQL 17 |
| Python tooling     | uv only (lockfile `backend/uv.lock`), ruff, mypy + django-stubs, pytest |
| JS tooling         | pnpm workspaces + Turborepo, TypeScript 6, ESLint (flat config), Prettier, Vitest |
| Web                | React 19 + Vite SPA, served by Caddy on the staging VPS                |
| Mobile             | React Native via Expo (dev client + prebuild); `ios/` and `android/` are generated, not committed |
| Wearables / widgets | Native Swift (watchOS, WidgetKit) and Kotlin (Wear OS, Glance), outside the JS workspace |
| Staging            | Docker Compose on Hostinger: Postgres, Django (gunicorn), Caddy (TLS + SPA + reverse proxy) |

Deliberately **not** included yet (can be added when a feature needs them): Redis/Celery, Mailpit, object storage.

## Contract between clients and backend

The backend publishes an OpenAPI schema at `/api/schema/`. `frontend/packages/api-client` generates TypeScript types from it
(`make gen-api`), and the native wearables generate Swift/Kotlin clients from the same schema, so one source of truth feeds all platforms.

## RFQ to code map

| RFQ requirement                                   | Where it lands                                    |
| ------------------------------------------------- | ------------------------------------------------- |
| Multi-market data model (calc params, calendars, languages per country) | `backend/apps/markets` |
| Hijri/Gregorian calendar, "happened this day", seasons, crops, palm | `backend/apps/calendars` |
| Prayer times, next-prayer countdown, Qibla        | `backend/apps/prayer_times` |
| Moon, sun, tides, marine forecast, weather, humidity | `backend/apps/astronomy` |
| Task management and prayer-linked reminders      | `backend/apps/planner` |
| Merchandise store                                 | `backend/apps/store` |
| Selling/licensing data via API or export          | `backend/apps/data_sales` |
| Contact messages routed to email with reply-from-email | `backend/apps/contact` |
| Users / auth                                      | `backend/apps/accounts` |
| Arabic/English + accessibility                    | `frontend/packages/i18n`, Django `LANGUAGES`, RTL in clients |
| One design system across platforms                | `frontend/packages/design-tokens` |
| Widgets                                           | `widgets/` |
| watchOS / Wear OS                                 | `wearables/` |

## Conventions

- Backend: one Django app per domain under `backend/apps/`; API routes versioned under `/api/v1/` and registered in `config/api_v1.py`.
- Settings are env-driven (`django-environ`); `staging.py` refuses to boot without a secret key.
- All line endings are LF (`.gitattributes`), so WSL/macOS/Linux checkouts behave identically inside containers.
- React for mobile is pinned to the version Expo SDK 57 / React Native 0.86 requires (19.2.3); web tracks the latest React (19.3.0).
