FROM debian:bookworm-slim

# Install Docker CLI + Compose plugin (client only)
RUN apt-get update && apt-get install -y --no-install-recommends \
    ca-certificates curl gnupg

RUN install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    chmod a+r /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" \
    > /etc/apt/sources.list.d/docker.list

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash git jq curl \
    libicu-dev libstdc++6 libgcc-s1 \
    docker-ce-cli docker-compose-plugin \
 && rm -rf /var/lib/apt/lists/*

# Create non-root runner user
RUN useradd -m runner
USER runner
WORKDIR /home/runner

# Download GitHub Actions runner
RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r .tag_name | sed 's/^v//') && \
    curl -L -o actions-runner.tar.gz https://github.com/actions/runner/releases/download/v${LATEST_VERSION}/actions-runner-linux-x64-${LATEST_VERSION}.tar.gz && \
    tar xzf actions-runner.tar.gz && \
    rm actions-runner.tar.gz

COPY --chown=runner:runner entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
