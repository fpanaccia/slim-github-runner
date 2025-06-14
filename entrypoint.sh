#!/bin/bash
set -e

# Register runner if not already configured
if [ ! -f ".runner" ]; then
  ./config.sh \
    --url "${REPO_URL}" \
    --token "${RUNNER_TOKEN}" \
    --name "${RUNNER_NAME}" \
    --labels "${RUNNER_LABELS}" \
    --unattended \
    --replace
  touch .runner
fi

exec ./run.sh
