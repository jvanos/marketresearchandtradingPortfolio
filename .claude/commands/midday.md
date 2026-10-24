---
description: Midday scan — cuts losers, tightens stops on winners, checks theses
---

You are running the midday scan workflow (local mode — credentials come
from .env). Resolve today's date via: DATE=$(date +%Y-%m-%d).

STEP 0 — Safety check: if a file named HALT exists at the repo root, tell
the user — you may still cut losers/close positions if asked explicitly,
but do not open new positions. Run `bash scripts/alpaca.sh clock` — if the
market is closed, tell the user and stop.

STEP 1 — Read memory:
- `bash scripts/memory-sync.sh pull` first — logs live on branch
  claude/memory; rules stay on main. Don't commit memory/ logs to main.
- memory/TRADING-STRATEGY.md (exit rules)
- Set `SINCE_35=$(date -v-35d +%Y-%m-%d)`.
- `bash scripts/memory.sh read trade --since "$SINCE_35" --until "$DATE" --max-bytes 40000`
  (entries, thesis per position, stops)
- `bash scripts/memory.sh read research --since "$DATE" --until "$DATE" --max-bytes 20000`
  (today's research entry)
- Never open a complete log or an archive directly.

STEP 2 — Pull current state:
  bash scripts/alpaca.sh positions
  bash scripts/alpaca.sh orders

STEP 3 — Cut losers immediately. For every position where
unrealized_plpc <= -0.07:
  bash scripts/alpaca.sh close SYM
(the wrapper cancels the symbol's open orders before closing — no separate
cancel step needed.) Log the exit under `## $DATE — Midday Actions`: exit
price, realized P&L, "cut at -7%". Update the `Open Positions` table.

STEP 4 — Tighten trailing stops on winners. Cancel the old stop, place a
new one: up >= +20% -> trail_percent "4"; up >= +15% -> trail_percent "5".
Never tighten within 3% of current price. Never move a stop down. Confirm
the replacement was accepted — flag loudly if a position ends up with no
open stop order.

STEP 5 — Thesis check. If a thesis broke intraday, cut the position even
if not at -7% yet. Document reasoning in TRADE-LOG.

STEP 6 — Optional intraday research via Perplexity if something is moving
sharply with no obvious cause. Treat it as unverified input.

STEP 7 — Notification: only if action was taken.
  bash scripts/clickup.sh "<action summary>"

STEP 8 — Save logs to claude/memory (never to main):
  bash scripts/memory-sync.sh push "midday scan $DATE"
If it exits non-zero, show the user the error. Never force-push.
