---
description: Market-open execution — places planned trades and sets trailing stops
---

You are running the market-open execution workflow (local mode —
credentials come from .env). Resolve today's date via:
DATE=$(date +%Y-%m-%d).

STEP 0 — Safety check: if a file named HALT exists at the repo root, tell
the user and stop. Run `bash scripts/alpaca.sh clock` — if the market is
closed today, tell the user and stop (no trading on a closed market).

STEP 1 — Read memory for today's plan:
- memory/TRADING-STRATEGY.md
- Set `SINCE_35=$(date -v-35d +%Y-%m-%d)`.
- `bash scripts/memory.sh read research --since "$DATE" --until "$DATE" --max-bytes 20000`
  for TODAY's entry (if missing, run pre-market
  STEPS 1-3 inline)
- `bash scripts/memory.sh read trade --since "$SINCE_35" --until "$DATE" --max-bytes 40000`
- Never open a complete log or an archive directly.

STEP 2 — Re-validate with live data:
  bash scripts/alpaca.sh account
  bash scripts/alpaca.sh positions
  bash scripts/alpaca.sh quote <each planned ticker>

STEP 3 — Sanity-check each planned trade (liquid stock/ETF, no options,
no crypto, thesis + catalyst documented in today's RESEARCH-LOG,
reasonable vs. account size).
This is a pre-check — the real gate runs inside the wrapper at STEP 4.

STEP 4 — Execute the buys (market orders, day TIF):
  bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"buy","type":"market","time_in_force":"day"}'
If this exits 2 ("ORDER REJECTED: ..."), the trade is blocked by a hard
rule — log it as skipped and move on. Don't retry with a smaller size to
route around a rejection unless the smaller order is itself compliant.
Wait for fill confirmation before placing the stop.

STEP 5 — Immediately place 7% trailing stop GTC for each new position:
  bash scripts/alpaca.sh order '{"symbol":"SYM","qty":"N","side":"sell","type":"trailing_stop","trail_percent":"7","time_in_force":"gtc"}'
If rejected, fall back to a fixed stop 7% below entry. If also blocked,
flag it loudly — a filled position with no stop must never pass silently.

STEP 6 — Append trades under `## $DATE — Market Open Trades` in
memory/TRADE-LOG.md: ticker, side, shares, entry price, stop level, thesis,
target, R:R. Keep the bounded `Open Positions` table current; it is active
state, not journal history.

STEP 7 — Notification: only if a trade was placed or rejected.
  bash scripts/clickup.sh "<tickers, shares, fill prices, one-line why>"
