# Trading Strategy

## Mission
Beat the S&P 500 over the challenge window. Free-form: no fixed universe —
research forms the thesis. No options, ever.

## Universe
Eligible:
- Any liquid US-listed stock or ETF (domestic or international, any
  sector/asset class)

Excluded, always:
- Crypto
- Options or any other derivative
- Illiquid names (wide spread, thin volume) or halted symbols

No reference tickers — every pick comes from that session's research.

## Capital & Constraints
- Starting capital: ~$50,000 (P&L baseline; current balance ~$55,000)
- Platform: Alpaca (real orders; paper by default — see env.template)
- Instruments: Stocks/ETFs ONLY

## Core Rules
1. NO OPTIONS — ever (enforced in scripts/alpaca.sh, not just this doc)
2. Every entry needs a research-backed thesis logged in RESEARCH-LOG
   before execution. No crypto.
3. 75-85% deployed
4. Up to 30 positions at a time, max 20% each (position-count and 20% cap
   also enforced in scripts/alpaca.sh)
5. 7% trailing stop on every position as a real GTC order
6. Cut losers at -7% manually
7. Tighten trail: 5% at +15%, 4% at +20%
8. Never within 3% of current price; never move a stop down
9. Max 8 new trades per week (enforced in scripts/alpaca.sh)
10. Follow sector/theme momentum
11. Exit a sector/theme after 2 consecutive failed trades
12. Patience > activity

## Enforcement note
Rules 1, 4, and 9 above, plus a cost-vs-buying_power check and a
daily-loss circuit breaker, are validated in code inside
`scripts/alpaca.sh` — a BUY order that breaks one of these is rejected
before it reaches Alpaca, regardless of what any prompt or research
output suggests. See CLAUDE.md "Safety Mechanisms" for the full list.
Changing these limits requires a human to edit the wrapper script
directly — they cannot be loosened by editing this file. See
`routines/weekly-review.md` STEP 5.

Rule 2 (thesis quality) is NOT code-enforced — it is a research/judgment
call made each session.

## Entry Checklist
- Thesis written in today's RESEARCH-LOG entry?
- Specific catalyst?
- Sector/theme momentum in favor?
- Liquid (tight spread, real volume)?
- Stop level (7% below entry)
- Target (min 2:1 R:R)
