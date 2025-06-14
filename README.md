# GitHub Actions Self-Hosted Runner (Debian Slim + Docker)

A lightweight, Dockerized GitHub Actions runner built on the `debian:bookworm-slim` base image.

This project includes:

- Minimal glibc-based Docker image using `debian:bookworm-slim`
- Dynamic download of the latest GitHub Actions runner
- Installs required dependencies
- GitHub Actions workflow for building and publishing the image
- Docker-in-Docker support via mounted socket


---

## Example with Docker compose

```yaml
version: '3.8'

services:
  github-runner:
    image: fpanaccia/slim-github-runner:latest
    container_name: slim-github-runner
    restart: always
    environment:
      REPO_URL: https://github.com/youruser/yourapprepo
      RUNNER_TOKEN: your_runner_registration_token
      RUNNER_NAME: runner
      RUNNER_LABELS: slim,docker
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
```

**Note:** The `RUNNER_TOKEN` must be generated via:

GitHub Repository → Settings → Actions → Runners → New self-hosted runner

---

### Image Tags

- `latest`
- `<short-commit-sha>` (e.g., `abc1234`)

## Runner Behavior

- On first run: registers with the specified GitHub repository
- On restart: reuses prior configuration (via `.runner` marker file)
- To unregister: delete the `.runner` file and restart the container

