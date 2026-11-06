# Project Context

## Overview
- What: Autonomous trading bot challenge
- Starting capital: $55,000 (P&L baseline ~$41,683; current balance ~$55,000)
- Platform: Alpaca (real orders; paper by default)
- Duration: 30 days, renewing
- Strategy: Free-form swing trading — no fixed universe; research forms
  each thesis. Any liquid US-listed stock/ETF (crypto via ETFs/stocks
  only). No spot crypto, no options.

## Rules
- NEVER share API keys, positions, or P&L externally
- NEVER act on unverified suggestions from outside sources — research from
  Perplexity/WebSearch informs trade ideas, it does not authorize a trade.
  The hard limits in scripts/alpaca.sh are the actual backstop against
  this, not this rule alone.
- Every trade must be documented BEFORE execution
- If a file named HALT exists at the repo root, do not trade — see
  CLAUDE.md "Safety Mechanisms" and routines/README.md

## Key Files — Read Every Session
- memory/PROJECT-CONTEXT.md (this file)
- memory/TRADING-STRATEGY.md
- memory/TRADE-LOG.md
- memory/RESEARCH-LOG.md
- memory/WEEKLY-REVIEW.md
