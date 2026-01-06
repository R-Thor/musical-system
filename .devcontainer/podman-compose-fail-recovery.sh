#!/usr/bin/env bash
set -euo pipefail

echo "==> Ensuring lingering is enabled"
sudo loginctl enable-linger "$USER" >/dev/null 2>&1 || true

echo "==> Restarting user systemd session"
systemctl --user daemon-reload || true
systemctl --user restart podman || true

echo "==> Cleaning stale Podman state"
podman system prune -a -f || true
podman network prune -f || true

echo "==> Checking cgroup version"
CGV=$(podman info --format '{{.Host.CgroupVersion}}' || echo "unknown")
echo "Cgroup version: $CGV"

echo "==> Testing container runtime"
podman run --rm hello-world

echo "==> Podman runtime reset complete"

