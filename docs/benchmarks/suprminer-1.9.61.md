# Suprminer v1.9.61 measurements

All figures are our own measurements on Linux, 26 November 2026. Each card ran at the board power
limit shown; the miner does not change clocks, fans or power limits.

## SVY (Solvyren, `-a svy`)

Pool runs of 70 to 90 seconds on `svy.suprnova.cc`. Every share was recomputed on the CPU before it
was submitted; the pool rejected none.

| GPU | Power limit | SVY (MH/s) | Notes |
|---|---:|---:|---|
| RTX 5090 | 600 W | 3.80–3.91 | |
| RTX 5080 | 400 W | 2.02–2.09 | two cards |
| RTX 4070 Ti SUPER | 285 W | 1.49–1.51 | |
| RTX 3070 | 250 W | 0.74–0.75 | two cards, one process together with an RTX 5080 |
| CMP 170HX | 250 W | 0.87–0.90 | card shared with another workload |

## NEB on Radeon RX 9070 XT

Same card at 280 W, the same recorded Kepler and TESS models in every arm, medians of matched
60-second arms, v1.9.60 against v1.9.61.

| GPU | Power limit | Kepler v1.9.60 → v1.9.61 (MH/s) | TESS v1.9.60 → v1.9.61 (MH/s) |
|---|---:|---:|---:|
| RX 9070 XT | 280 W | 235.0 → 285.5 (+21.5%) | 932.9 → 1,390.5 (+49.0%) |

A pool run on `neb.suprnova.cc` measured Kepler 204.63 → 269.17 MH/s (+31.5%) with no invalid
shares; the pool sent too few TESS jobs in that run to measure TESS. Hashrate varies with the block: on the
Kepler models of blocks 12210 and 12212 the card ran at the same rate with both versions.
Other Radeon cards use the same code path as in v1.9.60.

## PRL

Same card, A/B/B/A on the pool, before and after the change.

| GPU | Power limit | Before (TH/s) | v1.9.61 (TH/s) | Change |
|---|---:|---:|---:|---:|
| RTX 5090 | 600 W | 381.5 | 393.5 | +3.1% |
| RTX 5080 | 400 W | 224.3 | 226.8 | +1.1% |
| RTX 3070 | 250 W | 76.1 | 77.8 | +2.2% |

The RTX 5070 Ti at 350 W kept its rate and drew 15 W less.

Share size on the wire: about 177 KB before, 1,441 bytes with zstd and 3,612 bytes with gzip. The pool
accepted shares with zstd, gzip and without compression.

[CSV](suprminer-1.9.61.csv)
