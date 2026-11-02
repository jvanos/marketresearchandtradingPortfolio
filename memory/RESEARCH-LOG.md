# Research Log

Daily pre-market research entries will be appended here.
Format each entry:

## YYYY-MM-DD — Pre-market Research

### Account
- Equity: $X
- Cash: $X
- Buying power: $X

### Market Context
- S&P 500 futures:
- US Dollar Index (DXY):
- VIX:
- WTI / Brent:
- TIPS spread:
- Bond curve yields:
- Gold / oil / broad commodities:
- Today's catalysts:
- Earnings before open:
- Economic calendar:
- Regional / asset-class momentum:
- Sector momentum:


### Trade Ideas
1. TICKER — catalyst, entry $X, stop $X, target $X, R:R X:1
2. ...

### Risk Factors
- ...

### Decision
TRADE or HOLD (default HOLD if no edge)

## 2026-10-27 — Pre-market Research (Tuesday)

### Account
- Equity: $79,363.60
- Cash: $38,772.19 (48.9%)
- Buying power: $268,744.72 (4x margin); RegT $118,135.79
- Position mkt value: $40,590.97 (51.1% deployed — below the 75-90% band)
- 30 positions. Live Alpaca orders show 30 trailing-stop SELLs, but at **5% trail, TIF=day, expiring today 20:00 UTC (4pm ET)** — they vanish at today's close. **Discrepancy to reconcile (execution routine):** TRADE-LOG logs the Oct-26 stop backfill as DRY-RUN (no stops placed), and rulebook rule 5 now specifies **7% GTC**. Confirm which stops are authoritative and re-place as 7% GTC.

### Market Context
- S&P 500 futures: ES ~7,718 (+0.05%) — early overnight read only (7pm ET Oct 26), stale
- US Dollar Index (DXY): ~102.0-102.1 (+0.1-0.2%), firming 3rd session — dollar strength = headwind for intl equities & gold
- VIX: ~18.4 (-5%) — calm
- WTI / Brent: WTI ~$100.8 (-0.9%), Brent ~$114.6 (-1.0%) — pulling back on easing Saudi-Iran tension, still elevated/backwardated
- TIPS spread: 10yr breakeven ~2.35% — Oct Treasury selloff was real-rate driven, not inflation
- Bond curve yields: 10yr ~4.98-4.99% (eased from Oct ~5.3% peak); 2yr ~4.70% (bull-flattening). **Real 10yr yield ~2.9% — highest since 2008** (headwind for gold/silver/TIPS). Bund 3.37%, French 10yr 4.90%
- Gold / oil / broad commodities: gold ~$4,017 (flat; support $4,000/$3,930, resist $4,140/$4,227; record ETF holdings ~101.5M oz). Silver ~$53.85 (-0.2%, weakest; G/S ratio ~73). Copper ~$6.51/lb
- Today's catalysts: FOMC begins (decision Wed Oct 28, hold expected). Durable goods 7:30am (+1.8% exp vs 0.0%), Consumer Confidence 9am (80.5 exp vs 81.9), new-home sales
- Earnings before open: BA, KO, NVS, GLW, FCX, HCA, UPS, NXPI, BKR, SPGI, HSBC. **Mega-caps this week: MSFT/GOOGL Wed, AMZN/AAPL Thu — book HOLDS GOOGL, AMZN, AAPL**
- Regional / asset-class momentum: Europe firmest (STOXX +0.7% wk, +0.77% Oct 26). Japan weak (chip-led). Korea weakest/high-beta. China bear market (CSI300 -20% from peak, 10 straight down weeks). EM vulnerable; Brazil shock (-13.9% Bovespa, real -8.1% post-runoff)
- Sector momentum: no clear leader. Gold miners (RING) event-driven rebound. Analyst: Goldman Buy AngloGold, Barclays raised Agnico target; CIBC cut Barrick + silver forecasts. Semis/AI high event-risk into mega-cap earnings

### Position Risk Status
- Past/at -7% cut line: WULF -7.56%, SIVR -7.02% → cut candidates (execution routine)
- Other laggards: BTC -5.54%, HODL -5.44%, AMZN -5.25%, GOOGL -4.87%
- Winners thin: REZ +2.38%, SCHD +1.93%, XLE +1.83%, BRK.B +1.21% (none >= +15%, no tighten)

### Trade Ideas
1. RISK MGMT FIRST (not a new entry): reconcile + re-place stops as 7% GTC (today's live 5% stops are DAY orders expiring 4pm ET); cut WULF (-7.56%) and SIVR (-7.02%) per -7% rule. Highest-value action; belongs to market-open/midday execution.
2. VGK (Europe) — STOXX strongest since June + earnings optimism; catalyst = relative strength. BUT firming dollar + FOMC Wed are headwinds. Add-on-dip ONLY after Fed. Entry ~$86, stop ~$80 (7%), target ~$93, R:R ~1:1 — thin. Conditional/wait.
3. GLDM — gold holding $4,000 support w/ record ETF inflows; catalyst = ETF demand + Fed hold. BUT real yields ~2.9% + firm dollar cap upside; already largest position ($9.5k). No add until gold reclaims $4,140. HOLD.

### Risk Factors
- FOMC decision Wed + mega-cap earnings (GOOGL/AMZN Wed, AAPL Thu — 3 held) = concentrated event risk all week; adding pre-Fed is low-edge
- Dollar firming (DXY ~102) + real 10yr yields ~2.9% (highest since 2008) = simultaneous headwind for intl equities, gold, silver, TIPS
- Silver (SIVR, -7%) weakest metal; a break below gold $4,000 worsens the setup
- China bear market, EM vulnerable, Brazil shock — EM/intl beta risk
- Stops as-placed are 5% DAY orders expiring 4pm ET today → overnight-gap exposure returns tonight unless re-placed GTC

### Decision
HOLD on new entries — do not add risk into FOMC + mega-cap-earnings week (3 held names report Wed/Thu) on thin R:R. Deployment is low (51% vs 75-90% band) but patience > forcing a pre-Fed trade. Actionable priority is defensive: reconcile and re-place 7% GTC stops, and cut WULF/SIVR past the -7% line (execution routines). Patience > activity.

## 2026-11-02 — Pre-market Research (Monday — relief bounce into midterms, oil reverses down)

> **Branch reconciliation note:** This branch's logs end **10-27** (30-position book). The **live Alpaca account** (pulled this run) has since moved to **17 positions** via stop-outs across 10-28→10-30 that were NOT recorded on this branch. Account/Position sections below reflect **live** state; the 10-28→10-30 narrative + TRADE-LOG reconciliation is owed (human/execution task — see note at end).

### Account (live)
- Equity: $78,790.75
- Cash: $57,145.64 (72.5%)
- Buying power: $57,145.64 (1x, no margin extended)
- Position mkt value: $21,645.11 (**27.5% deployed — well below the 75-90% band; underdeployment is the main drag**)
- Overnight: equity +$3.85 (+0.00%) vs last_equity $78,786.90 — flat
- 17 positions, 15 live trailing stops at **non-standard 3-5% trail** (NOT the rule-5 7% GTC). **2 fractional remnants carry NO stop: QQQM 0.5sh (-4.0%), SPMO 0.008sh (-4.0%)** — close/cover owed.

### Market Context
- Relief bounce after Wall St's worst week in months: S&P 500 futures ~7,648-7,655 (**+0.4 to +0.5%**), Nasdaq-100 **+0.8%**, Dow **+0.3%** as AI/megacap steadies. Fragile — sits one day ahead of the midterm vote. VIX **18.83 (-0.59)**, cooling.
- US Dollar Index (DXY): ~101.75 (**-0.2 to -0.3%**), euro strongest major (EUR/USD ~1.12); risk-on softness. Mild tailwind for intl/metals, but only ~3 days old amid a de-risk unwind.
- WTI / Brent: WTI **~$100-101 (-3%)**, Brent **~$108-110 (-3 to -4%)** — reverses Friday's $104/$117 spike on US-Iran de-escalation hopes (diplomacy may extend post-midterms). OPEC+ held output through Dec. Hormuz keeps 2-way upside risk. **Energy momentum (the week's #1 sector) cooling.**
- Gold / metals: gold **~$3,896-3,905, +~0.5-1% today** but still **below $4,000** (broke $4k Fri, -3.7% recent). Silver weak (~11-mo low). Copper ~$6.48 recovering. **GDX +4.1% on the day.**
- Bond yields: US 2yr **4.59% (+1bp)**, 10yr **~4.91% (-1bp)**, 30yr **~5.29% (-2bp)** — modest bear-steepening; Dec Fed hike still priced possible; structurally ~5%. Bund 3.32%, OAT 4.97% (Fitch cut France outlook to negative), JGB ~3.08%.
- Today's catalysts: **Midterm elections Tue Nov 3** (dominant — fiscal/regulatory/trade + US-Iran policy). **AAPL + PLTR earnings tonight (after close).** JOLTS Tue, **jobs report Fri Nov 6**. No CPI/PPI/FOMC this week (CPI Nov 10, PPI Nov 13, FOMC Dec 8-9).
- Earnings before open: mostly US (Marriott, Entergy, IDEXX, PSEG). **Ryanair (RYAAY) beat** — modestly green. **Book holds AAPL (reports tonight).**
- Regional / sector momentum: International **negative across the board past month** — Japan weakest (MSCI Japan Momentum -7.5%, Nikkei -7.65%), Europe -2.49% 1mo (but +10.4% YTD), EM least-bad (-3.9%). China Oct factory activity back in **contraction** (EM/industrial headwind). Nikkei -0.33%, FTSE +0.07%, Euro Stoxx 50 -1.23% Fri. **BoE expected +25bp to 4.00% this week** (sterling/UK catalyst). US value/dividend (SCHD, VTV, XLB) holding relative strength; semis/AI just purged, high event-risk.

### Position Risk Status (live)
- **No holding past the -7% cut line** (worst QQQM/SPMO remnants -4.0%). Book stabilized after last week's stop-out purge.
- **No winner >= +15%** — no trail-tighten (best XLB +3.3%, SCHD +3.3%, VTV +1.5%).
- 15 of 17 carry stops (3-5%, non-standard); QQQM 0.5sh & SPMO 0.008sh unprotected.
- Holdings: AAPL, VOO, VTI, VTV, SCHD, BRK.B, COWZ, SGOV, XLB/XLE/XLI, QQQM, SPMO (US) + FLJP, VGK, EWG, VNQI (intl). No crypto-linked left (BTC/HODL exited last week). All in-universe under free-form rules.

### Trade Ideas
1. **RISK MGMT / HOUSEKEEPING FIRST (execution routines, not new entries):** (a) standardize live trails to **7% GTC** per rule 5 (currently 3-5%); (b) **close QQQM 0.5sh & SPMO 0.008sh unstopped remnants**; (c) reconcile TRADE-LOG (ends 10-26) to the live 17-position book. Highest-value actions today.
2. **Gold miners GDX (or RING)** — catalyst: GDX +4.1% today, gold rebounding toward $3,900 off the $4k break; analysts tactically cautious / medium-term bullish, seniors cheap (~6.8x fwd CF vs 8.8x 5yr avg); softer dollar + lower long yields help; miner earnings this week (Wheaton Nov 5). Entry on a gold reclaim of **$4,000** that holds; stop -7%, target +15% (R:R ~2:1). **BUT** gold sub-$4k, Dec-hike repricing, GDX -13% past month (high beta). **Conditional / watch — not into a binary midterm.**
3. **Value/dividend relative-strength (add to SCHD/VTV, or XLB materials)** — catalyst: these held green through last week's rout; lower-beta way to lift deployment toward the 75-90% band. Entry on confirmation the bounce holds post-midterms; stop -7%, target +10%. Low conviction but the cleanest momentum in the book. **Conditional / watch.**
- **Avoid:** fresh energy adds (momentum reversing as oil drops) and semis/AI re-entry (just purged — rule 11, sector burned on consecutive failed trades).

### Risk Factors
- **Midterm elections Tue Nov 3 = binary event risk** — today's relief bounce can reverse; adding risk the day before is low-edge.
- **AAPL earnings tonight** (6sh held) + PLTR; **jobs report Fri** — two-sided week.
- **Oil 2-way** (de-escalation vs Hormuz re-escalation); the energy/commodity momentum that led is fading as oil reverses down.
- **Gold sub-$4k, silver 11-mo low, Dec-hike repricing** keep metals/miners soft and high-beta; yields structurally ~5%.
- **International momentum negative past month** across Europe/Japan/EM (Japan worst); **China factory contraction** = EM/industrial headwind. No clean positive-momentum setup today.
- **Underdeployed at 27.5% vs 75-90% band** — biggest drag; needs a defined, momentum-backed re-entry plan post-midterms.
- **Housekeeping debt:** live trails are 3-5% not 7% GTC; 2 unstopped remnants; TRADE-LOG stale (ends 10-26) vs live 17-position book.

### Decision
**HOLD on new entries.** No clean edge: a fragile relief bounce into a binary midterm vote (Tue), AAPL earnings tonight and Fri jobs make fresh risk low-edge, and sector/theme momentum is weak-to-reversing (energy rolling over, intl negative, gold sub-$4k). The one-day dollar-weakness tailwind isn't enough alone. Priority is defensive and belongs to execution routines: standardize 7% GTC stops, close QQQM/SPMO remnants, and reconcile the trade log to live. Watch GDX (needs gold to reclaim $4,000) and value/dividend relative strength as the cleanest redeploy candidates once the bounce holds post-midterms — redeploying toward the 75-90% band is the week's main objective. Patience > activity.
