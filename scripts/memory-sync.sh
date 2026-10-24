#!/usr/bin/env bash
# Logs live on branch claude/memory; rules, scripts, and HALT live on main.
# Every run stays checked out on main and syncs only the log files.
# Usage:
#   bash scripts/memory-sync.sh pull            # copy latest logs into memory/
#   bash scripts/memory-sync.sh push "<msg>"    # commit logs to claude/memory
# Never commits to main. Never force-pushes.

set -euo pipefail

BRANCH="claude/memory"
LOGS=(memory/TRADE-LOG.md memory/RESEARCH-LOG.md memory/WEEKLY-REVIEW.md memory/archive)

cd "$(git rev-parse --show-toplevel)"
BASE_FILE="$(git rev-parse --git-dir)/memory-sync-base"

git fetch -q origin
remote_rev() { git rev-parse -q --verify "refs/remotes/origin/$BRANCH" || true; }

case "${1:-}" in
  pull)
    rev="$(remote_rev)"
    if [[ -z "$rev" ]]; then
      echo "memory-sync: no $BRANCH yet -- using main's logs"
      echo none > "$BASE_FILE"
      exit 0
    fi
    for p in "${LOGS[@]}"; do
      if git cat-file -e "$rev:$p" 2>/dev/null; then
        git checkout "$rev" -- "$p"
        git reset -q -- "$p"   # working tree only; keep main's index clean
      fi
    done
    echo "$rev" > "$BASE_FILE"
    echo "memory-sync: logs pulled from $BRANCH @ ${rev:0:7}"
    ;;

  push)
    msg="${2:?usage: memory-sync.sh push \"<commit message>\"}"
    rev="$(remote_rev)"
    base="$(cat "$BASE_FILE" 2>/dev/null || true)"
    # Copying logs over the branch is only safe if they started from its tip.
    if [[ "$base" != "${rev:-none}" ]]; then
      echo "memory-sync: REFUSED -- $BRANCH moved since last pull (or pull never ran). Run pull, redo the log edits, then push." >&2
      exit 2
    fi

    MEM="$(mktemp -d)"
    trap 'git worktree remove --force "$MEM" >/dev/null 2>&1 || true; rm -rf "$MEM"' EXIT
    git worktree add -q --detach "$MEM" "${rev:-origin/main}"

    for p in "${LOGS[@]}"; do
      [[ -e "$p" ]] || continue
      mkdir -p "$MEM/$(dirname "$p")"
      cp -R "$p" "$MEM/$(dirname "$p")/"
    done

    git -C "$MEM" add -A memory
    if git -C "$MEM" diff --cached --quiet; then
      echo "memory-sync: no log changes to push"
      exit 0
    fi
    git -C "$MEM" commit -q -m "$msg"

    for _ in 1 2 3; do
      if git -C "$MEM" push -q origin "HEAD:refs/heads/$BRANCH"; then
        git fetch -q origin
        remote_rev > "$BASE_FILE"
        echo "memory-sync: pushed to $BRANCH"
        exit 0
      fi
      git -C "$MEM" pull -q --no-rebase --no-edit origin "$BRANCH" || {
        echo "memory-sync: merge with $BRANCH failed -- needs a human" >&2
        exit 1
      }
    done
    echo "memory-sync: push to $BRANCH failed after retries" >&2
    exit 1
    ;;

  *)
    echo "usage: memory-sync.sh pull | push \"<commit message>\"" >&2
    exit 64
    ;;
esac
