#!/usr/bin/env bash
# One-time: put a protective GTC stop on every long position that has none,
# based on entry price. All API calls go through scripts/alpaca.sh.
#   - price <= entry -7%  -> close now at market (already through the stop)
#   - price <= entry      -> fixed stop at entry -7%
#   - price >  entry      -> trailing stop 7% (5% at +15%, 4% at +20%),
#                            which always sits above entry -7%
# Positions that already have a stop order are left alone. Safe to run while
# the market is closed: orders queue for the next open.
# Usage: bash scripts/set-stops.sh [--dry-run]

set -euo pipefail

ROOT="$(cd "$(dirname "$0")/.." && pwd)"
export ALPACA_SH="$ROOT/scripts/alpaca.sh"

if [[ -f "$ROOT/HALT" ]]; then
  echo "HALT file present -- no orders placed."
  exit 3
fi

exec python3 - "$@" <<'PY'
import json, math, os, subprocess, sys

DRY = "--dry-run" in sys.argv[1:]
STOP_TYPES = {"stop", "trailing_stop", "stop_limit"}

def alpaca(*args):
    r = subprocess.run(["bash", os.environ["ALPACA_SH"], *args], capture_output=True, text=True)
    if r.returncode != 0:
        raise RuntimeError((r.stderr or r.stdout).strip() or f"exit {r.returncode}")
    return json.loads(r.stdout) if r.stdout.strip() else None

def stopped_symbols():
    return {o["symbol"] for o in alpaca("orders") or []
            if o.get("side") == "sell" and o.get("type") in STOP_TYPES}

def floor_price(p):
    # Alpaca tick: 2 decimals >= $1, 4 below. Round down for a sell stop.
    return f"{math.floor(p * 100) / 100:.2f}" if p >= 1 else f"{math.floor(p * 10000) / 10000:.4f}"

pre = "[dry-run] " if DRY else ""
if not alpaca("clock")["is_open"]:
    # GTC stops are accepted now and go live at the open; closes queue as
    # market orders for the open. Decisions use the last trade price.
    print("Market closed -- orders will queue for the next open (prices below are last trade).")
has_stop = stopped_symbols()
out, bad, cut = [], [], set()

for p in alpaca("positions") or []:
    sym = p["symbol"]
    entry, cur = float(p["avg_entry_price"]), float(p["current_price"])
    gain = cur / entry - 1
    tag = f"{sym} entry ${entry:.2f} now ${cur:.2f} ({gain:+.1%})"
    try:
        if p.get("side") != "long":
            bad.append(f"{sym}: short position -- skipped")
        elif cur <= entry * 0.93:
            if not DRY:
                alpaca("close", sym)  # cancels its open orders first
            out.append(f"{pre}CUT   {tag} -- at/below entry -7%, closed at market")
            cut.add(sym)
        elif sym in has_stop:
            out.append(f"OK    {tag} -- already has a stop")
        else:
            qty = int(float(p["qty_available"]))  # whole shares; GTC can't be fractional
            if qty <= 0:
                bad.append(f"CRITICAL {tag}: 0 shares available (reserved by other sell orders)")
                continue
            if qty < float(p["qty"]):
                bad.append(f"{sym}: stop covers {qty} of {p['qty']} shares (fractional/reserved remainder unprotected)")
            order = {"symbol": sym, "qty": str(qty), "side": "sell", "time_in_force": "gtc"}
            if cur > entry:
                pct = "4" if gain >= 0.20 else "5" if gain >= 0.15 else "7"
                order |= {"type": "trailing_stop", "trail_percent": pct}
                desc = f"trailing {pct}% (~${cur * (1 - int(pct) / 100):.2f})"
            else:
                stop = floor_price(entry * 0.93)
                order |= {"type": "stop", "stop_price": stop}
                desc = f"stop ${stop} (entry -7%)"
            if not DRY:
                alpaca("order", json.dumps(order))
            out.append(f"{pre}STOP  {tag} -- {qty} sh, {desc}")
    except RuntimeError as e:
        bad.append(f"CRITICAL {sym}: order failed -- {e}")

if not DRY:
    held = {p["symbol"] for p in alpaca("positions") or [] if p.get("side") == "long"}
    for sym in sorted(held - stopped_symbols() - cut):
        bad.append(f"CRITICAL {sym}: still has NO open stop order")

print("\n".join(out + bad) or "No positions.")
sys.exit(1 if any(l.startswith("CRITICAL") for l in bad) else 0)
PY
