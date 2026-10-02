# Staging deployment (Hostinger VPS)

Flow: PR merged to `main` -> backend + frontend CI re-run -> images built and pushed to GHCR -> GitHub Action SSHs into the VPS,
pulls the new images, runs migrations and restarts the stack. Branch protection should require `CI / backend` and `CI / frontend` on PRs.

## One-time VPS setup

1. Install Docker Engine + the compose plugin; create a deploy user in the `docker` group and add its SSH public key.
2. `mkdir -p /opt/alojeiri` and copy `deploy/staging/.env.example` to `/opt/alojeiri/.env`; fill in real values
   (generate the secret with `python -c "import secrets; print(secrets.token_urlsafe(64))"`).
3. Point the staging domain's DNS A record at the VPS; ports 80/443 must be open (Caddy obtains certificates automatically).

## GitHub configuration

Create a `staging` environment with:

| Name               | Kind     | Purpose                                  |
| ------------------ | -------- | ---------------------------------------- |
| `STAGING_HOST`     | secret   | VPS hostname or IP                       |
| `STAGING_USER`     | secret   | Deploy user                              |
| `STAGING_SSH_KEY`  | secret   | Private key for the deploy user          |
| `STAGING_SSH_PORT` | secret   | Optional, defaults to 22                 |
| `STAGING_PATH`     | variable | Optional, defaults to `/opt/alojeiri`    |

Also enable "Read and write permissions" for `GITHUB_TOKEN` packages, or allow the workflow to publish to GHCR.

## Manual deploy / rollback

Run the *Deploy / staging* workflow manually, or on the VPS:

```bash
cd /opt/alojeiri
BACKEND_IMAGE=ghcr.io/<owner>/<repo>/backend:<sha> WEB_IMAGE=ghcr.io/<owner>/<repo>/web:<sha> docker compose up -d
```
