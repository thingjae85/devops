#!/usr/bin/env bash
# Educational watchdog: run one instance on the host, from Linux/WSL.
# Start the full stack first; this loop reconciles only web container count.
set -u
cd -- "$(dirname -- "${BASH_SOURCE[0]}")" || exit 1
command -v docker >/dev/null 2>&1 || { echo "docker is required" >&2; exit 1; }
docker compose config --quiet || exit 1
trap 'exit 0' INT TERM
while :; do
  # Reuse existing containers, start stopped ones, create missing replicas,
  # and reduce excess replicas. Do not rebuild or restart dependencies.
  if ! docker compose up -d --no-deps --no-build --no-recreate --scale web=3 web; then
    echo "web=3 reconciliation failed; retrying after 5 seconds" >&2
  fi
  sleep 5
done
