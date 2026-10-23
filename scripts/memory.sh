#!/usr/bin/env bash
# Deterministic, bounded access to the Markdown memory logs.
# Usage:
#   bash scripts/memory.sh read trade --since YYYY-MM-DD [--until YYYY-MM-DD]
#   bash scripts/memory.sh archive [all|trade|research|weekly] [--dry-run]

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
exec python3 "$ROOT/scripts/memory.py" "$@"
