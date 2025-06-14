FROM debian:bullseye-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
    bash curl ca-certificates git jq docker.io \
    libicu-dev \
 && rm -rf /var/lib/apt/lists/*

RUN useradd -m runner
USER runner
WORKDIR /home/runner

RUN LATEST_VERSION=$(curl -s https://api.github.com/repos/actions/runner/releases/latest | jq -r .tag_name | sed 's/^v//') && \
    curl -L -o actions-runner.tar.gz https://github.com/actions/runner/releases/download/v${LATEST_VERSION}/actions-runner-linux-x64-${LATEST_VERSION}.tar.gz && \
    tar xzf actions-runner.tar.gz && \
    rm actions-runner.tar.gz

COPY --chown=runner:runner entrypoint.sh .
RUN chmod +x entrypoint.sh

ENTRYPOINT ["./entrypoint.sh"]
