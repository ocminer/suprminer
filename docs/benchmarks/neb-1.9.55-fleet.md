# Suprminer 1.9.55 NEB fleet benchmarks

Measured on 22 November 2026 using identical frozen trained Kepler/TESS models
and protected Linux development builds. Release kernels are checked against these
tested kernels before publication. Rates change with model training. These are
evaluated-attempt rates, not a prediction of payouts or future model performance.

## Matched comparisons with 1.9.54

Four 220-second arms per card, two runs of each version in A/B/B/A order
(opposite roles on the second card of a pair). Each arm contains 100-second TESS
and Kepler intervals. Statistics exclude the first 60 seconds of each interval
to allow table construction and warm-up. Automatic boost, memory and fan settings
are unchanged; power allowances are the cards' full existing firmware maximum.

All rates below are MH/s. Each slash separates **Kepler / TESS**.

| GPU | Allowance | 1.9.54 | 1.9.55 kernels | Change | Measured watts, before → after |
|---|---:|---:|---:|---:|---:|
| Tesla V100 16 GB | 300 W | 108.71 / 948.16 | 112.43 / 988.51 | +3.43% / +4.26% | 297.4/272.2 → 297.7/275.1 |
| H100 80GB | 700 W | 288.87 / 4280.38 | 291.72 / 4280.38 | +0.99% / +0.00% | 523.6/596.1 → 521.0/593.0 |
| RTX PRO 6000 Blackwell 96 GB #1 | 600 W | 471.79 / 6880.12 | 471.08 / 7077.50 | -0.15% / +2.87% | 599.7/600.0 → 600.0/600.0 |
| RTX PRO 6000 Blackwell 96 GB #2 | 600 W | 470.17 / 6872.88 | 470.21 / 7054.00 | +0.01% / +2.64% | 599.8/600.0 → 599.7/599.9 |
| RTX 3070 #1 | 250 W | 82.41 / 726.12 | 83.42 / 734.81 | +1.22% / +1.20% | 248.2/249.1 → 248.7/248.8 |
| RTX 3070 #2 | 250 W | 83.88 / 740.82 | 84.95 / 748.87 | +1.28% / +1.09% | 248.1/248.7 → 248.2/248.0 |
| RTX 5080 | 400 W | 253.14 / 2431.62 | 253.31 / 2434.25 | +0.07% / +0.11% | 399.9/399.4 → 399.7/399.3 |

The measured development kernels are checked against the final packages before
publication. Both models passed correctness checks. H100 Kepler improved about 1% on average (0.60% in the
conservative worst-candidate versus best-baseline comparison). Changes of roughly
0.1% on the RTX 5080, and small Kepler differences on RTX PRO 6000, are run variation,
not claimed speedups. V100 NEB support is Linux-only.

## Other observations and limits

- RTX 5090, 600 W allowance: the development build measured **437.20 / 5637.00 MH/s**.
  The initial 1.9.54 comparison was 438.44 / 5702.13 MH/s; its first run had higher
  boost clocks than the later runs. This comparison does not establish a gain.
  A warm repeat measured 436.59 / 5627.13 before and 438.09 / 5683.25 after,
  with boost rising in a later candidate run. The opposite signs of the cold
  and warm comparisons do not establish a new steady-rate gain. The existing
  configuration is retained on this card.
- RTX 4070 Ti SUPER, 285 W allowance: **174.78 / 1796.75 MH/s** versus
  174.50 / 1798.00 MH/s with 1.9.54. An existing GPU service remained running;
  Kepler varied by about 5% between runs. These are shared-context observations,
  not an exclusive performance claim.
- CMP 170HX: **94.17 / 814.76 MH/s** in shared diagnostics with its verifier
  running and the existing 250 W allowance unchanged. This is not an exclusive
  full-power benchmark and establishes no version-to-version gain.
- RX 7900 XTX: model preparation fell from roughly
  0.60–0.63 s to 0.25 s on the measured Kepler model, and 0.085–0.090 s to
  0.035–0.036 s on TESS. Earlier full-miner measurements were within noise.
  The final four-arm steady-rate comparison stopped at the temperature guard
  in its last baseline arm; no sustained AMD hashrate gain is claimed.

The independent upstream CPU reference checked the fixed-model shares. Synthetic
test shares establish hash correctness, not on-chain credit. Separate real-pool
TLS runs cover actual acceptance. No physical Windows GPU was available for these
benchmarks; Windows qualification covers native CI, host tests and kernel identity.

## Exact workload

- Dataset SHA-256: `57e22a4b8aacecb2ebae62f76307ddccb04198ed5c4ba15c1dee90ca7a7c2174`.
- Kepler domain-separated model BLAKE3: `bdad8728f70cb75a47e5227aa3a42df1ebbe8cbfbbdbbe4128d769b018a01d99`.
- TESS domain-separated model BLAKE3: `049efe848752b8b3cbed39139af87bcf102a3886214aea09d36c45fb25c28e2c`.

## Live pool prediction crossover

On 22 November 2026, two 10-minute arms exchanged enabled/disabled roles
between two cards of each type. Only complete rounds sharing the same model
hash were compared, excluding initial startup. TESS prediction preparation
was enabled, Kepler preparation disabled, with unchanged clocks and full
existing firmware allowances. The equal-arm geometric gain was **+0.75% on
the RTX 3070 pair** (17 matched complete rounds; pooled work/time +0.84%) and
**+1.58% on the RTX PRO 6000 pair** (19 rounds; pooled +1.62%). These results
include the cost of preparing the next model while mining the current one.
They depend on model changes and pool delivery timing, and are not additional
steady-state kernel gains. Do not add them to the frozen-model percentages.

Across these trials and a separate RTX 5090 TLS check, miner and pool logs
agreed on 469 accepted shares and six stale `job not found` submissions,
with no invalid-hash rejects. No block was found in this window.
