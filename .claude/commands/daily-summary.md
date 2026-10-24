---
description: Daily summary — computes P&L and sends one EOD recap
---

You are running the daily summary workflow (local mode — credentials come
from .env). Resolve today's date via: DATE=$(date +%Y-%m-%d).

STEP 0 — Safety check: still produce today's summary even if HALT is
present or the market was closed — note it in the message. Silence should
never be the only signal something is wrong.

STEP 1 — Read memory for continuity:
- `bash scripts/memory-sync.sh pull` first — logs live on branch
  claude/memory; rules stay on main. Don't commit memory/ logs to main.
- Set `MONDAY=$(date -v-mon +%Y-%m-%d)` and
  `SINCE_14=$(date -v-14d +%Y-%m-%d)`.
- `bash scripts/memory.sh read trade --since "$SINCE_14" --until "$DATE" --max-bytes 30000`
  (most recent EOD snapshot -> yesterday's
  equity, needed for Day P&L — a cosmetic display number only)
- Count TRADE-LOG entries dated today
- Count trades Mon-today this week
- Never open a complete log or an archive directly.

STEP 2 — Pull final state of the day:
  bash scripts/alpaca.sh account
  bash scripts/alpaca.sh positions
  bash scripts/alpaca.sh orders

STEP 3 — Compute metrics:
- Day P&L ($ and %) = today_equity - yesterday_equity
- Phase cumulative P&L ($ and %) = today_equity - starting_equity (Day 0
  baseline in TRADE-LOG.md)
- Trades today (list or "none")
- Trades this week (running total)

STEP 4 — Append EOD snapshot to memory/TRADE-LOG.md:
## YYYY-MM-DD — EOD Snapshot (Day N, Weekday)
**Portfolio:** $X | **Cash:** $X (X%) | **Day P&L:** ±$X (±X%) | **Phase P&L:** ±$X (±X%)
| Ticker | Shares | Entry | Close | Day Chg | Unrealized P&L | Stop |
**Notes:** one-paragraph plain-english summary.

STEP 5 — Send ONE ClickUp message (always, even on no-trade days). <= 15
lines:
  bash scripts/clickup.sh "EOD MMM DD
  Portfolio: \$X (±X% day, ±X% phase)
  Cash: \$X
  Trades today: <list or none>
  Open positions:
    SYM ±X.X% (stop \$X.XX)
  Tomorrow: <one-line plan>"

STEP 6 — Save logs to claude/memory (never to main):
  bash scripts/memory-sync.sh push "EOD snapshot $DATE"
If it exits non-zero, show the user the error. Never force-push.
