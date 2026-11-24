# Suprminer

A multi-algorithm miner for NVIDIA GPUs, with separate NEB/Quantus OpenCL packages
for AMD devices, plus a Quantus Vulkan option.

## Suprminer 1.9.58 — faster NEB mining

Kepler is faster on the tested RTX cards. This release also fixes a large slowdown on certain trained TESS models and improves continuity when the pool updates a job.

| GPU | Power allowance | Mainnet model | v1.9.57 MH/s | v1.9.58 MH/s | Change |
|---|---:|---|---:|---:|---:|
| RTX 5090 | 600 W | Kepler 7812 | 488.59 | **573.08** | +17.3% |
| RTX 5080 | 400 W | Kepler 7650 | 324.03 | **416.36** | +28.5% |
| RTX 5070 Ti | 350 W | Kepler 7652 | 113.97 | **166.70** | +46.3% |
| RTX 3070 A | 250 W | Kepler 7652 | 41.41 | **49.29** | +19.0% |
| RTX 3070 B | 250 W | Kepler 7652 | 41.88 | **49.41** | +18.0% |

Each card ran both versions on two matched header sequences in reverse order on Linux. The RTX 5090 also delivered **16.7% more on-time shares** across its two matched runs. The [full benchmark table](docs/benchmarks/neb-1.9.58-fleet.md) includes TESS, the shared CMP 170HX and the test conditions. [CSV](docs/benchmarks/neb-1.9.58-fleet.csv)

**0% NEB miner fee · 1% Suprnova PPLNS pool fee.** NEB supports NVIDIA CUDA and AMD OpenCL on Linux, Windows, HiveOS, mmpOS, SMOS and Docker. [Download v1.9.58](https://github.com/ocminer/suprminer/releases/tag/v1.9.58) · [Pool](https://neb.suprnova.cc/) · [Discord](https://discord.gg/29RHZwvVPN)

## Suprminer 1.9.57 — Pearl FP8 and faster NEB mining

Suprminer 1.9.57 prepares PRL miners for Pearl's FP8 upgrade. `-a prl` (or `pearl`) now follows the pool: it mines today's PRL scheme and switches by itself to the FP8 scheme with the pool's first FP8 job, so one command line works before and after the upgrade. `-a prlold` mines only the scheme before the upgrade.

The FP8 scheme runs on RTX 50 series and RTX PRO Blackwell cards. Rates on Pearl's FP8 test network, Linux, each card at its stock power allowance:

| GPU | Power allowance | PRL FP8 |
| --- | ---: | ---: |
| RTX 5090 | 600 W | 344-371 TH/s |
| RTX 5090 | 420 W | 266 TH/s |
| RTX 5080 | 400 W | 199-206 TH/s |
| RTX 5070 Ti | 350 W | 173 TH/s |

TH/s is 10^12 FP8 products per second. The cards run at their power limit in this workload, so cooling changes the rate by several percent. Every share is checked with Pearl's own verifier before it is sent, and the miner needs about a quarter of a CPU core per card. A card that reaches 90 °C rests while the others keep mining (`PEARL_FP8_MAX_TEMP`). The Windows build has not been run on a physical GPU. [Download 1.9.57](https://github.com/ocminer/suprminer/releases/tag/v1.9.57)

### NEB mainnet performance

Faster dense Kepler mining on selected NVIDIA cards. Suprminer also retries when GPU memory pressure temporarily prevents it from preparing a model. **0% NEB miner fee.**

| GPU | Power allowance | v1.9.56 | v1.9.57 | Gain |
| --- | ---: | ---: | ---: | ---: |
| RTX 5090 | 600 W | 229.48 MH/s | **306.69 MH/s** | +33.6% |
| RTX 5080 | 400 W | 135.85 MH/s | **193.37 MH/s** | +42.3% |
| RTX 3070 | 250 W | 29.50 MH/s | **42.01 MH/s** | +42.4% |

Each row compares the same GPU on the same trained mainnet Kepler model at height 7652, replayed on Linux. Rates are warm measurements and vary with model weights. [Measurement details](docs/benchmarks/neb-1.9.57-fleet.md) · [NEB pool](https://neb.suprnova.cc/)

## Suprminer 1.9.56 — faster NEB on RTX 3070 and RTX 5090

Suprminer 1.9.56 improves NEB mining on desktop RTX 3070 and RTX 5090 cards. The NVIDIA startup display shows available clock and fan readings. A ten-second rate sample that includes both slots now reads `rate window Kepler + TESS`. On shutdown, completed shares have time to reach the pool. **0% NEB miner fee.**

### NEB benchmarks by GPU

Each cell gives **Kepler / TESS** in MH/s on the same captured model pair. A and B are two different mainnet snapshots. Power is the board allowance, and the runs used automatic clocks. Linux package rows compare the published binaries. Two additional RTX 5090 rows show earlier measurements with the selected release kernels.

| GPU | Power allowance | Model pair | 1.9.55 MH/s | 1.9.56 MH/s | Change K / T | Measurement |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| RTX 5090 | 600 W | A | 395.08 / 5207.38 | **414.54 / 5585.91** | +4.9% / +7.3% | Linux package |
| RTX 5080 | 400 W | A | 230.63 / 2231.57 | **230.76 / 2234.79** | +0.1% / +0.1% | Linux package |
| RTX 5070 Ti | 350 W | A | 191.27 / 1837.52 | **191.93 / 1845.47** | +0.3% / +0.4% | Linux package |
| RTX 4070 Ti SUPER | 285 W | A | 151.92 / 1675.04 | **162.98 / 1674.07** | +7.3% / -0.1% | Linux package, shared |
| Radeon RX 7900 XTX | 350 W | A | 50.93 / 688.14 | **50.51 / 945.39** | -0.8% / +37.4% | Linux OpenCL |
| RTX 3070 A | 250 W | A | 55.58 / 686.06 | **66.09 / 701.49** | +18.9% / +2.3% | Linux package, dual-GPU |
| RTX 3070 A | 250 W | B | 126.06 / 905.98 | **137.97 / 913.81** | +9.5% / +0.9% | Linux package, dual-GPU |
| RTX 3070 B | 250 W | A | 55.99 / 699.05 | **67.12 / 713.70** | +19.9% / +2.1% | Linux package, dual-GPU |
| RTX 3070 B | 250 W | B | 128.68 / 922.02 | **140.46 / 929.61** | +9.2% / +0.8% | Linux package, dual-GPU |
| RTX 5090 | 600 W | A | 387.71 / 5099.50 | **405.65 / 5468.66** | +4.6% / +7.2% | Release kernels, prepackaging |
| RTX 5090 | 600 W | B | 627.23 / 6703.60 | **730.22 / 7084.72** | +16.4% / +5.7% | Release kernels, prepackaging |

Across 192 seconds including startup and four model visits, the two RTX 3070s each gained **12.4%**, from 376.80 to 423.63 MH/s and from 383.50 to 431.16 MH/s. Single-run differences under 1% are within normal variation.

### Last measured on earlier releases

These cards were measured on earlier trained models. Each row gives the release actually tested. As the network trains its models, the rate on the same card can change substantially.

| GPU | Power allowance | Tested version | Kepler MH/s | TESS MH/s | Test conditions |
| --- | ---: | ---: | ---: | ---: | --- |
| RTX PRO 6000 Blackwell 96 GB #1 | 600 W | 1.9.55 | 471.08 | 7077.5 | Release kernels |
| RTX PRO 6000 Blackwell 96 GB #2 | 600 W | 1.9.55 | 470.21 | 7054 | Release kernels |
| H100 80 GB | 700 W | 1.9.55 | 291.72 | 4280.38 | Release kernels |
| Tesla V100 16 GB | 300 W | 1.9.55 | 112.43 | 988.51 | Release kernels, Linux only |
| CMP 170HX | 250 W | 1.9.55 | 94.17 | 814.76 | Shared with verifier |
| A100 SXM4 80 GB | 400 W | 1.9.51 | 305 | 2100 | Release executable |
| Radeon RX 7600 XT | 165 W | 1.9.51 | 78.5 | 269 | OpenCL |
| Radeon Instinct MI50 | 225 W | 1.9.51 | — | 284 | OpenCL, TESS only |
| Radeon Instinct MI50 | 225 W | 1.9.49 | 19.9 | 287 | OpenCL, short thermal-limited run |

The fleet has measurements for the **RTX 4070 Ti SUPER** and **RTX 5070 Ti**. The base RTX 4070 and RTX 5070 have no verified measurement here.

[Benchmark methods and model hashes](docs/benchmarks/neb-1.9.56-fleet.md) · [All cards (CSV)](docs/benchmarks/neb-1.9.56-card-coverage.csv) · [Linux package comparisons (CSV)](docs/benchmarks/neb-1.9.56-packaged.csv)

NVIDIA CUDA and AMD OpenCL for NEB. Packages for Linux, Windows, HiveOS, mmpOS and SMOS, plus NVIDIA and AMD Docker images. Tesla V100 support is available on Linux. [Download 1.9.56](https://github.com/ocminer/suprminer/releases/tag/v1.9.56) · [NEB setup](docs/NEB_RELEASE_GUIDE.md) · [Pool](https://neb.suprnova.cc/)

### Previous release: 1.9.55 — NEB performance and stability update

**0% miner fee. NVIDIA and AMD.** Faster NEB mining on selected cards,
smoother model changes, and improved stability when pool work changes.
TESS predictions are enabled by default on supporting pools.

Matched Linux benchmarks: **Kepler / TESS, MH/s**, identical trained models and unchanged clocks.

| GPU | Power allowance | 1.9.54 | 1.9.55 | Update benefit |
|---|---:|---:|---:|---|
| RTX PRO 6000 Blackwell (96 GB) | 600 W | 471.79 / 6880.12 | **471.08 / 7077.50** (+ predictions†) | **+2.87% TESS** |
| RTX 5090 | 600 W | 436.59 / 5627.13 | **438.09 / 5683.25** (+ predictions†) | Retained steady speed; improved model switching |
| H100 (80 GB) | 700 W | 288.87 / 4280.38 | **291.72 / 4280.38** (+ predictions†) | **+0.99% Kepler** |
| RTX 5080 | 400 W | 253.14 / 2431.62 | **253.31 / 2434.25** (+ predictions†) | Retained steady speed; prediction support |
| RTX 4070 Ti SUPER² | 285 W | 174.50 / 1798.00 | **174.78 / 1796.75** (+ predictions†) | Retained steady speed; prediction support |
| CMP 170HX² | 250 W | — | **94.17 / 814.76** (+ predictions†) | Prediction support; shared measurement |
| RTX 3070 | 250 W | 82.41 / 726.12 | **83.42 / 734.81** (+ predictions†) | **+1.22% Kepler / +1.20% TESS** |
| Tesla V100 (16 GB) | 300 W | 108.71 / 948.16 | **112.43 / 988.51** (+ predictions†) | **+3.43% Kepler / +4.26% TESS** |

† **Optional, variable prediction potential**, not included in the displayed steady rates. The benefit depends on GPU, models and pool timing; it is not a guaranteed gain on every card. Paired live tests measured **+0.75% combined throughput on RTX 3070** and **+1.58% on RTX PRO 6000** with predictions enabled. These are separate tests, not percentages to add to the static gains.
² The 4070 Ti SUPER and CMP measurements shared their GPUs with another service. RTX 5090 warm-repeat rates are shown; its steady-rate difference varied with boost. Rates change with network models. [Full test conditions](docs/benchmarks/neb-1.9.55-fleet.md).

Prediction controls: `--disable-neb-predictions`,
`--disable-neb-tess-predictions`, `--disable-neb-kepler-predictions`.
CPU share checks and verified TLS remain enabled.

Linux, Windows, HiveOS, mmpOS, SMOS and NVIDIA/AMD Docker builds.
V100 NEB support is Linux-only.

[Download 1.9.55](https://github.com/ocminer/suprminer/releases/tag/v1.9.55) ·
[NEB setup](docs/NEB_RELEASE_GUIDE.md) · [NEB pool](https://neb.suprnova.cc/)

### Previous release: 1.9.54 — NEB tables on Tesla V100 and Turing cards, table use decided by measurement

**NEB 1.0.1 mainnet.** Use `-a neb`. **0% miner fee.**

- **Tesla V100** mines NEB now (earlier versions refused the card): TESS 942
  MH/s, Kepler 131 MH/s on the models of 22 November (16 GB card, 300 W
  allowance, Linux; the Windows package has no kernels for this card).
- **Turing cards** (RTX 20, GTX 16, CMP 30HX / 40HX / 50HX) use the attempt
  selection and the result tables now instead of the plain kernel. We have no
  Turing card: their code path was run on an RTX 5090 through the driver's
  compiler (all shares valid), so no Turing rate is claimed. Every model is
  checked against the plain kernel on the card itself and the miner keeps the
  plain kernel when that check fails; `NEB_DISABLE_NONCE_SELECTION=1` forces it.
- **Table use is measured.** When a large table is complete the miner times the
  scan with and without it on that card and keeps the faster one. On cards with
  much memory a table that adds few attempts could cost speed.
- All other cards run the kernels of 1.9.53.

<!-- NEB1954:BEGIN -->
| GPU | Power allowance | Kepler | TESS | Before |
|---|---:|---:|---:|---|
| Tesla V100 (16 GB) | 300 W | 131 MH/s | 942 MH/s | not supported |

Models of 22 November 2026, Linux, unchanged clocks, every share checked against
the CPU reference, none rejected. Rates depend on the model of each block.
<!-- NEB1954:END -->

[Download 1.9.54](https://github.com/ocminer/suprminer/releases/tag/v1.9.54) ·
[NEB setup](docs/NEB_RELEASE_GUIDE.md) · [NEB pool](https://neb.suprnova.cc/)

### Previous release: 1.9.53 — faster NEB on dense Kepler models, one download per platform

**NEB 1.0.1 mainnet.** Use `-a neb`. **0% miner fee.**

- **NEB, Kepler:** since 21 November the network's Kepler model is much denser,
  and most of the work is the full evaluation of an attempt. That evaluation is
  10-13% faster on RTX 40 and RTX 50 cards, RTX PRO 6000, H100 and CMP 170HX
  (the A100 uses the same code and was not measured again). RTX 30 cards and
  TESS are unchanged.
- **One download per platform.** Linux, Windows, HiveOS (Ubuntu 20.04 and 22.04
  base), mmpOS and SMOS each have a single archive that holds the NVIDIA build
  and the AMD (OpenCL) build `suprminer-neptune-amd`. HiveOS and mmpOS start the
  AMD build on rigs without an NVIDIA card; `--amd` or `--nvidia` in the extra
  arguments forces one. On Windows use `start-neb.bat` (NVIDIA) or
  `start-neb-amd.bat` (AMD). Docker keeps the `-amd` tag. `SHA256SUMS` lists all
  checksums.

<!-- NEB1953:BEGIN -->
Kepler model of 21 November 2026 (evening, dense), same work for both versions:

| GPU | Power allowance | 1.9.52 | 1.9.53 | Gain |
|---|---:|---:|---:|---:|
| RTX PRO 6000 (96 GB) | 600 W | 390 MH/s | **429 MH/s** | +10% |
| RTX 5090 | 600 W | 368 MH/s | **405 MH/s** | +10% |
| H100 (80 GB) | firmware maximum | 217 MH/s | **241 MH/s** | +11% |
| RTX 5080 | 400 W | 206 MH/s | **231 MH/s** | +12% |
| RTX 4070 Ti SUPER | 285 W | 139.5 MH/s | **154.5 MH/s** | +11% |
| CMP 170HX (memory-unlocked) | 250 W | 80.5 MH/s | **91 MH/s** | +13% |
| RTX 3070 | 250 W | 59 MH/s | 59 MH/s | unchanged |

Linux, unchanged clocks, every share checked against the CPU reference, none
rejected. Rates on this model are lower than the earlier tables for every card
because the model changed; rates of different days cannot be compared.
<!-- NEB1953:END -->

- `NEB_QUAD_PACK=0` selects the previous evaluation, `1` forces the new one.
- AMD (OpenCL) and all other algorithms are unchanged from 1.9.52.
- Physical Windows GPU execution and unlisted AMD generations remain unqualified.

[Download 1.9.53](https://github.com/ocminer/suprminer/releases/tag/v1.9.53) ·
[NEB setup](docs/NEB_RELEASE_GUIDE.md) · [NEB pool](https://neb.suprnova.cc/)

### Previous release: 1.9.52 — ccminer-style API (`-b`), full NEB table from the first block

**NEB 1.0.1 mainnet.** Use `-a neb`. **0% miner fee.**

- **`-b [ADDR:]PORT`** (also `--api-bind`) turns on the API the way ccminer does:
  `-b 4068` listens on this computer only, `-b 0.0.0.0:4068` on all interfaces,
  `-b 0` turns it off. The port answers the ccminer text commands `summary`,
  `threads` and `pool` (`echo -n summary | nc 127.0.0.1 4068`) and, as before,
  HTTP JSON for HiveOS, mmpOS and SMOS.
- **NEB:** in 1.9.51 the result table of the first model of a session was about
  10% too small on cards with up to 32 GB until the next model change. It has
  its full size from the start now (RTX 5090: TESS 4.33 to 4.60 GH/s during
  that time; the rate afterwards is unchanged).
- **NEB:** after a GPU error that leaves a card unusable for the running
  process (illegal memory access, launch failure) the miner now starts itself
  again with the same arguments instead of retrying forever with idle cards.
- **A100 80 GB** measured: Kepler 305 MH/s, TESS 2.10 GH/s.

<!-- NEB1952:BEGIN -->
All cards on the Kepler and TESS models of 21 November 2026 (Kepler / TESS):

| GPU | Power allowance | Kepler | TESS |
|---|---:|---:|---:|
| RTX PRO 6000 (96 GB) | 600 W | 917 MH/s | 5.90 GH/s |
| RTX 5090 | 600 W | 804 MH/s | 4.60 GH/s |
| H100 (80 GB) | firmware maximum | 533 MH/s | 3.68 GH/s |
| A100 (80 GB) | 400 W | 305 MH/s | 2.10 GH/s |
| RTX 5080 | 400 W | 428 MH/s | 1.91 GH/s |
| RTX 4070 Ti SUPER | 285 W | 325 MH/s | 1.42 GH/s |
| CMP 170HX (memory-unlocked) | 250 W | 183 MH/s | 1.29 GH/s |
| RTX 3070 | 250 W | 157 MH/s | 576 MH/s |
| RX 7900 XTX (OpenCL) | 350 W | 241 MH/s | 760 MH/s |
| RX 7600 XT (OpenCL) | 165 W | 78.5 MH/s | 269 MH/s |
| Radeon Instinct MI50 (OpenCL) | 225 W | not measured | 284 MH/s |

Measured on Linux with unchanged clocks, the same work for every card (90 s
per model), every share checked against the CPU reference, none rejected. The
NEB kernels are those of 1.9.51; the RTX 5090 was run again with this release,
the other rates are those measured for 1.9.51 (A100: 1.9.51 release executable;
PRO 6000, H100, CMP 170HX: development build with the same kernels). Rates
depend on the model of each block and cannot be compared between days. A100,
H100 and CMP 170HX run at their maximum clock below their power allowance:
this integer work is limited by the number of cores and their clock.
<!-- NEB1952:END -->

Linux, Windows, HiveOS, mmpOS, SMOS and Docker have separate NVIDIA and AMD packages.
Physical Windows GPU execution and unlisted AMD generations remain unqualified.

[Download 1.9.52](https://github.com/ocminer/suprminer/releases/tag/v1.9.52) ·
[NEB setup](docs/NEB_RELEASE_GUIDE.md) · [NEB pool](https://neb.suprnova.cc/)

### Previous release: 1.9.51 — NEB result tables on H100 and CMP 170HX, a second table on cards with much memory


**NEB 1.0.1 mainnet.** Use `-a neb`. **0% miner fee.**

The miner keeps tables of exact results in GPU memory and only evaluates the
attempts they cover. Until now this was limited to RTX 30 / 40 / 50 class
chips; on Hopper (H100) and on the CMP 170HX every nonce was still evaluated
the slow way. Both use the tables now. On cards where the table of one model
does not need all the memory, the other model gets a table of its own from
what is left, so Kepler blocks are faster there.

<!-- NEB1951:BEGIN -->
| GPU | Power allowance | 1.9.50 Kepler / TESS | 1.9.51 Kepler / TESS | Gain Kepler / TESS |
|---|---:|---:|---:|---:|
| H100 (80 GB) | firmware maximum (about 590 W drawn) | 92 MH/s / 76 MH/s | **533 MH/s / 3.68 GH/s** | **5.8x / 48x** |
| CMP 170HX (memory-unlocked, 48 GB free) | 250 W | 62 MH/s / 70 MH/s | **183 MH/s / 1.29 GH/s** | **2.9x / 18x** |
| RTX PRO 6000 (96 GB) | 600 W | 813 MH/s / 5.86 GH/s | **917 MH/s / 5.90 GH/s** | **+12.8% / +0.7%** |
| RTX 5090 (32 GB) | 600 W | 797 MH/s / 4.53 GH/s | 795 MH/s / 4.51 GH/s | within run variation |

Measured on Linux on 21 November 2026 with the Kepler and TESS models the main
network had that day, the same work for both versions (90 s per model),
unchanged clocks, one run per version and card. H100, PRO 6000 and CMP 170HX
rates of 1.9.51 are from the development build with the same kernels; the
RTX 5090 pair was run back to back. The CMP 170HX shared its card with another
program that held 16 GB and ran at 84-85 C, so its Kepler rate fell from 190
to 181 MH/s during the run. Every returned share passed an independent CPU
reference; none was rejected. Rates are for two fixed models and depend on the
model of each block; the reported hashrate counts only evaluated attempts.
An H100 has fewer and slower-clocked cores for this integer work than an
RTX 5090, so it stays below it despite its memory.
<!-- NEB1951:END -->

All cards measured with 1.9.51 on the models of 21 November 2026 (Kepler / TESS):

| GPU | Power allowance | Kepler | TESS |
|---|---:|---:|---:|
| RTX PRO 6000 (96 GB) | 600 W | 917 MH/s | 5.90 GH/s |
| RTX 5090 | 600 W | 804 MH/s | 4.58 GH/s |
| H100 (80 GB) | firmware maximum | 533 MH/s | 3.68 GH/s |
| RTX 5080 | 400 W | 428 MH/s | 1.91 GH/s |
| RTX 4070 Ti SUPER | 285 W | 325 MH/s | 1.42 GH/s |
| CMP 170HX (memory-unlocked) | 250 W | 183 MH/s | 1.29 GH/s |
| RTX 3070 | 250 W | 157 MH/s | 576 MH/s |
| RX 7900 XTX (OpenCL) | 350 W | 241 MH/s | 760 MH/s |
| RX 7600 XT (OpenCL) | 165 W | 78.5 MH/s | 269 MH/s |
| Radeon Instinct MI50 (OpenCL) | 225 W | not measured | 284 MH/s |

RTX 5090, 5080, 4070 Ti SUPER, 3070 and the AMD cards ran the final release
executables; PRO 6000, H100 and CMP 170HX the development build with the same
kernels. Same work for every card (90 s per model, TESS rate after both models
were loaded), every share checked against the CPU reference, none rejected.
The MI50 reached its 100 C limit after one minute at 225 W in our open test
bench and was stopped before its Kepler phase. The tables of the earlier
releases further down were measured on the models of earlier days; rates of
different days cannot be compared (the same RTX 5090 gave 362 MH/s on the
Kepler model of 20 November and 804 MH/s on that of 21 November).

- RTX 5090 and other cards with up to 32 GB: the table of one model already
  fills the memory, so the default rates are those of 1.9.50. With
  `NEB_TRIPLE_POLICY=follow` the large table goes to whichever model is being
  mined and is rebuilt at every change: the same RTX 5090 then gave 864 MH/s on
  Kepler in a long run with one model. With the network's alternating blocks
  this lowered the rate of both models in our measurement, so it is off by
  default.
- The large table is built about 1.4 times faster (RTX 5090: 310 to 440 million
  rows per second), so the full rate returns sooner after a model change.
- Right after a start, while only one of the two models has arrived, the table
  is about 10% smaller than in 1.9.50; it grows to full size at the next model
  change.
- Kepler models with more than 5461 active samples can use the large table now
  (it was silently left out for them before).
- Turing cards (GTX 16, RTX 20, CMP 30HX / 40HX / 50HX) still use the previous
  path.
- `NEB_DISABLE_QUAD_BUILD=1` builds the table with the previous kernel.
- **Do not run other programs on the same GPU while mining NEB**: the tables take
  the free memory. `NEB_TRIPLE_RESERVE_MB=<n>` keeps n MiB free instead,
  `NEB_TRIPLE_TABLE_GB=<n>` limits the first table, `NEB_DISABLE_TRIPLE_TABLE=1`
  turns the large tables off.
- Every method is checked against the original kernel at each model change and
  every submitted share against the CPU reference, as before.
- AMD (OpenCL) and all other algorithms are unchanged from 1.9.50.

Linux, Windows, HiveOS, mmpOS, SMOS and Docker have separate NVIDIA and AMD packages.
AMD names retain `quantus-opencl` / `_opencl`; they include NEB as well.
The `quantus-vulkan` Linux package uses OpenCL for NEB. Physical Windows GPU
execution and unlisted AMD generations remain unqualified.

[Download 1.9.51](https://github.com/ocminer/suprminer/releases/tag/v1.9.51) ·
[NEB setup](docs/NEB_RELEASE_GUIDE.md) · [NEB pool](https://neb.suprnova.cc/)

Windows archives include **`start-neb.bat`**: enter your NEB wallet address and
start mining at `neb.suprnova.cc:7804`. No miner fee; the pool charges 1%.

### Previous release: 1.9.50 — larger and denser result table

The table of exact results that the miner keeps in GPU memory now holds more:
its rows take 28 instead of 32 bytes, and it uses all free memory of the card
except about 0.4 GiB (1 GiB on Windows). More attempts are answered from the
table, so more attempts are evaluated per second on TESS blocks.

<!-- NEB1950:BEGIN -->
| GPU | Power allowance | 1.9.49 Kepler / TESS | 1.9.50 Kepler / TESS | Gain Kepler / TESS |
|---|---:|---:|---:|---:|
| RTX 5090 | 600 W | 361 MH/s / 5.11 GH/s | **362 MH/s / 5.37 GH/s** | **0% / +5.0%** |
| RTX 5080 | 400 W | 206 MH/s / 2.14 GH/s | **211 MH/s / 2.34 GH/s** | **+2.3% / +8.9%** |
| RTX 3070 | 250 W | 69.9 MH/s / 669 MH/s | **69.9 MH/s / 712 MH/s** | **0% / +6.4%** |

Measured on Linux on 20 and 21 November 2026 with the Kepler and TESS models
the main network had on 20 November 2026, the same work for both versions (90 s
per model), unchanged clocks, maximum firmware power. RTX 5090: mean of an
A/B/B/A sequence on a warm card; RTX 5080 (two cards) and RTX 3070 (two cards):
one run per version. Every returned share passed an independent CPU reference;
none was rejected. Rates are for two fixed models and depend on the model of
each block; the reported hashrate counts only evaluated attempts.
<!-- NEB1950:END -->

- **Do not run other programs on the same GPU while mining NEB**: the table takes
  the free memory. `NEB_TRIPLE_RESERVE_MB=<n>` keeps n MiB free instead,
  `NEB_TRIPLE_TABLE_GB=<n>` limits the table, `NEB_DISABLE_TRIPLE_TABLE=1` turns
  it off.
- The table stays in place when the network alternates between Kepler and TESS
  blocks, and is updated only where a model changed.
- Blackwell cards (RTX 50) use a larger register budget in the scan kernels.
- Every method is checked against the original kernel at each model change and
  every submitted share against the CPU reference, as before.
- HiveOS: the miner log is now written to the file HiveOS reads (`miner log`).
- AMD (OpenCL) and all other algorithms are unchanged from 1.9.49.

### Previous release: 1.9.49 — NEB attempt selection for AMD, faster table updates

**AMD (OpenCL)** now uses the exact attempt selection that 1.9.48 introduced on
NVIDIA: the miner finds the attempts that are cheap for the model of the current
block, takes their exact result from a table and does not start the expensive
ones. The reported hashrate counts only evaluated attempts.

<!-- NEB1949_AMD:BEGIN -->
| GPU (OpenCL) | Power allowance | 1.9.48 Kepler / TESS | 1.9.49 Kepler / TESS | Gain Kepler / TESS |
|---|---:|---:|---:|---:|
| RX 7900 XTX | 350 W | 21.0 / 21.3 MH/s | **97.6 / 874 MH/s** | **4.6x / 41x** |
| RX 7600 XT | 165 W | 6.1 / 6.5 MH/s | **29.8 / 311 MH/s** | **4.9x / 48x** |
| Radeon Instinct MI50 | 225 W | 5.1 / 5.6 MH/s | **19.9 / 287 MH/s** | **3.9x / 51x** |

Measured on Linux on 20 November 2026 with the Kepler and TESS models the main
network had on 19 November 2026, the same work for both versions (90 s per
model), unchanged clocks. Every returned share passed an independent CPU
reference; none was rejected. These short runs reached the cards' temperature
limits (100 °C junction and more on these air-cooled test cards); sustained
rates depend on cooling. The selection is checked against the previous kernel on
real nonces at every model change and used only when it is faster.
`NEB_DISABLE_NONCE_SELECTION=1` restores the 1.9.48 behaviour.
<!-- NEB1949_AMD:END -->

**NVIDIA** keeps the 1.9.48 kernels and rates on a fixed model. When the network
changes a model, the large table is now updated only where the model's training
rows changed instead of being rebuilt, and it grows into the memory that is
still free once both models are loaded.

### Previous release: 1.9.48 — NEB attempt selection on NVIDIA

Every NEB attempt is one training step on 16 sampled rows, and its cost depends
strongly on those rows. Suprminer 1.9.48 finds, for the model of each block, the
attempts that are cheap to evaluate, evaluates them **exactly**, and does not
start the expensive ones. Every attempt has the same chance to meet the target,
so more evaluated attempts mean proportionally more shares.

- The reported hashrate counts **only attempts that were actually evaluated**.
- The rate now differs a lot between Kepler and TESS blocks and changes as the
  network trains its models; the miner picks the fastest exact method per model
  and card at every block (`adaptive selection` in the log).
- Enabled on RTX 30, RTX 40 and RTX 50 series GPUs (compute capability 8.6, 8.9
  and 12.0); measured on the cards listed below. Other NVIDIA GPUs keep the
  1.9.47 path (AMD follows in 1.9.49, above).
- Every method is checked against the original kernel at each model change, and
  every submitted share is checked against the CPU reference. No floating-point
  approximation and no relaxed validation.
- The miner keeps tables of exact results in GPU memory and by default uses the
  free memory of the card except about 3 GB (more memory = more cheap attempts,
  so cards with more VRAM gain more). `NEB_TRIPLE_TABLE_GB=<n>` limits the large
  table, `NEB_DISABLE_TRIPLE_TABLE=1` turns it off.
- `NEB_DISABLE_NONCE_SELECTION=1` restores the 1.9.47 behaviour.

The pool must let the miner vary the extranonce (standard Stratum, as on
Suprnova): the fast methods use up the 2^32 nonces of one header in a fraction
of a second.

NEB supports **`stratum+tcp://`** and **`stratum+ssl://`** (certificate and
hostname verified, never a silent plaintext fallback). Suprnova offers TLS on
ports 7806 (PPLNS) and 7807 (solo) in Europe and Asia; see the setup guide.

<!-- NEB1948_BENCHMARKS:BEGIN -->
### NEB 1.9.47 → 1.9.48 on the same trained models

Measured on Linux on 20 November 2026 with the Kepler and TESS models the main
network had on 19 November 2026, the same dataset and the same work cadence for
both versions (90 s per model). Every card ran at its maximum firmware power
allowance with unchanged clocks. Rates are evaluated attempts per second
(Kepler / TESS).

| GPU | Maximum power allowance | 1.9.47 Kepler / TESS | 1.9.48 Kepler / TESS | Gain Kepler / TESS |
|---|---:|---:|---:|---:|
| RTX 5090 | 600 W | 237.1 / 279.0 MH/s | **361.6 MH/s / 4.88 GH/s** | **+53% / 17.5x** |
| RTX 5080 | 400 W | 141.9 / 161.0 MH/s | **204.1 MH/s / 2.01 GH/s** | **+44% / 12.5x** |
| RTX 4070 Ti SUPER | 285 W | 84.2 / 96.4 MH/s | **149.3 MH/s / 1.55 GH/s** | **+77% / 16.1x** |
| RTX 3070 | 250 W | 36.0 / 44.3 MH/s | **63.4 MH/s / 626.9 MH/s** | **+76% / 14.1x** |

Every returned share (7,298 in these runs) passed an independent CPU reference;
none was rejected. The share counts confirm the displayed rates; the
[complete CSV](docs/benchmarks/neb-1948-selection.csv) lists both, with actual
watts, clocks and temperatures, and the second RTX 5080 and RTX 3070. The
TESS rates include the large table sized from each card's free memory (26.8 GB
on the RTX 5090, 10.4 GB on the RTX 5080, 2.7 GB on the RTX 3070). The
RTX 5070 Ti is enabled as well (it used the general path in 1.9.47) but has no
undisturbed measurement yet. Protected development executables
provide these measurements; the release packages contain the same kernels.

These are gross hashing rates on two fixed models, not payout measurements. The
gain depends on the model: the fewer of its training rows still produce a
gradient, the more attempts are cheap. On the live network the rate therefore
moves from block to block and over time. Power allowance is not actual
consumption. The miner does not change clocks or power settings.
<!-- NEB1948_BENCHMARKS:END -->

### Previous release: 1.9.47

<!-- NEB1947_BENCHMARKS:BEGIN -->
### NEB trained models: 1.9.46 → 1.9.47

Measured on Linux on 19 November 2026 using the same frozen trained Kepler and
TESS models, dataset and work cadence. Every card used its maximum firmware
power allowance; clock settings were unchanged. These trained-model rates are
separate from the historical genesis-model measurements below.

| GPU | Maximum power allowance | 1.9.46 Kepler / TESS | 1.9.47 Kepler / TESS | Gain Kepler / TESS |
|---|---:|---:|---:|---:|
| RTX 5090 | 600 W | 178.68 / 126.54 MH/s | **218.99 / 241.04 MH/s** | **+22.56% / +90.49%** |
| RTX 5080 | 400 W | 111.53 / 85.33 MH/s | **136.85 / 145.93 MH/s** | **+22.71% / +71.02%** |
| RTX 4070 Ti SUPER | 285 W | 57.91 / 48.97 MH/s | **79.74 / 87.26 MH/s** | **+37.70% / +78.19%** |
| RTX 3070 | 250 W | 16.18 / 12.24 MH/s | **28.75 / 39.41 MH/s** | **+77.71% / +222.08%** |

Another RTX 3070 independently measured **28.55 / 38.68 MH/s**
(Kepler / TESS) at its 250 W maximum allowance. Both tested 3070 cards selected
their kernels automatically; the before/after row above uses one matched card.

Each before/after figure averages two arm medians, with baseline runs bracketing
the candidate runs. Stable per-interval windows are 45–85 seconds after the
first job for TESS and 120–175 seconds after the same job for Kepler. Every returned
share passed an independent upstream CPU reference. Protected development
executables provide these measurements; final release GPU instructions are
checked against the measured kernels, with packaged runtime checks as well.
These are gross hashing rates, not payout measurements. Rates change as the
network models train, and unmeasured future models can select a different path.

The [complete CSV](docs/benchmarks/neb-1947-trained-abba.csv) records actual
watts, clocks, temperatures and miner CPU usage. Power allowance is not actual
consumption. The miner does not change clocks or power settings.
<!-- NEB1947_BENCHMARKS:END -->

<!-- NEB1946_BENCHMARKS:BEGIN -->
### Historical genesis-model comparison — 1.9.45 to 1.9.46

Measured on Linux on 18 November 2026 with the actual Kepler and TESS genesis
models, the same dataset and work cadence, and each card's maximum supported
power setting. Clock settings were unchanged. Protected development executables
use the kernels qualified for 1.9.46; final release native instructions are checked
against those measured kernels.

| GPU | Maximum power setting | 1.9.45 Kepler / TESS | 1.9.46 Kepler / TESS | Gain Kepler / TESS |
|---|---:|---:|---:|---:|
| RTX 5090 | 600 W | 169.69 / 170.43 MH/s | **175.85 / 175.78 MH/s** | **+3.63% / +3.14%** |
| RTX 5080 | 400 W | 100.99 / 101.35 MH/s | **112.72 / 113.12 MH/s** | **+11.61% / +11.61%** |
| RTX PRO 6000 Blackwell Server Edition | 600 W | 188.33 / 189.08 MH/s | **206.26 / 206.98 MH/s** | **+9.52% / +9.47%** |
| A100 SXM4 80GB | 400 W | 50.45 / 51.20 MH/s | **55.59 / 56.90 MH/s** | **+10.19% / +11.13%** |
| H100 80GB HBM3 | 700 W | 96.41 / 96.65 MH/s | **107.75 / 107.65 MH/s** | **+11.76% / +11.37%** |

Four arms per card (1.9.45 / candidate / candidate / 1.9.45). Each result averages
two arm medians, with six 10-second intervals per model after warmup. Every found
share passed the independent upstream CPU reference. These are gross mining rates,
not pool payout measurements; rates change as network models train.

Power settings are not actual consumption. The [complete CSV](docs/benchmarks/neb-1946-mainnet101-abba.csv)
includes sampled watts, core/memory clocks, CPU usage and exact comparison figures.
Each cloud row measures one card; the RTX PRO row is not a multi-card total.
The tested datacenter driver 580.178.04 runs the shipped native kernels; forced
CUDA 13.3 PTX JIT is unavailable on that driver, including with v1.9.45.

<!-- NEB1946_BENCHMARKS:END -->

### AMD and NVIDIA reference measurements — v1.9.45

Actual NEB 1.0.1 genesis models and dataset, measured on Linux on 18 November
2026 using the final protected release executables. Each dataset has a fixed
60-second measurement window after warmup. These are initial AMD results and
an NVIDIA regression check, not release-over-release gains.

| GPU | Limit W | Kepler MH/s | TESS MH/s | Mean W | CPU, % of one core |
|---|---:|---:|---:|---:|---:|
| RX 7600 XT | 165 | **6.97** | **6.99** | 160.9 | 5.72 |
| MI50 | 150 | **4.92** | **4.99** | 147.3 | 5.47 |
| RX 7900 XTX | 272 | **18.53** | **19.62** | 274.7 | 9.04 |
| RTX 5090 | 450 | **137.96** | **139.24** | 449.9 | 1.73 |

Limits are configured settings; mean watts are sampled consumption. Clocks
were unchanged. The MI50 and RX 7900 XTX tests used cooler limits of 150 W
and 272 W. CPU use is the miner process after startup, expressed as a percentage
of one CPU core; it includes CPU share validation and depends on share difficulty.
Rates depend on the model, driver and cooling.

[Measured clocks, watts and method (CSV)](docs/benchmarks/neb-1945-mainnet101.csv).
All synthetic benchmark shares passed the independent upstream CPU reference.
The earlier development measurements, including the short 225 W MI50 result,
remain in [AMD qualification details](docs/NEB_OPENCL.md).

Final AMD executables produced **60 accepted shares, zero rejects and zero CPU-invalid shares** on an isolated NEB 1.0.1 chain. All three cards covered both datasets; 60 exact block IDs were independently reconstructed and appeared as parents in later node work. The final NVIDIA executable added 8 accepted shares with zero rejects. This verifies the consensus path, not pool payouts or accounting.

Known Quantus limitation: the OpenCL target-boundary self-test fails on the tested RX 7600 XT and MI50 with AMD OpenCL 3649.0. The same failure was reproduced with the published v1.9.44 binary, and the Quantus kernel and host path are unchanged. Quantus on these card/driver combinations is not qualified by this release. This does not affect the NEB checks, which passed independently on both cards; RX 7900 XTX passed the Quantus check. The new AMD Docker image also fails this Quantus self-test on RX 7900 XTX with its bundled ROCm 6.4.3 runtime, including when the published v1.9.44 executable is used. Use the AMD Docker image for NEB; Quantus GPU operation in that image is not qualified.

### Fleet KEP1 reference measurements

These results reuse the **1.9.43 Linux executable, NEB 1.0.0 Kepler genesis
model and dataset**, measured on 17 November 2026. The Kepler samples are unchanged, but 1.0.1 has new starting weights and
later releases select new kernels on qualified cards. These are historical
performance references, **not new TESS results or a repeated 1.9.47 fleet
sweep**. Rates vary with models and settings.

| GPU | Limit W | KEP1 reference MH/s | Mean W | Mean core MHz | Memory MHz |
|---|---:|---:|---:|---:|---:|
| RTX 5090 | 450 | **139.31** | 449.9 | 1764 | 13801 |
| RTX 5090 | 600 | **170.74** | 599.9 | 2193 | 13801 |
| RTX 4070 Ti SUPER | 285 | **58.24** | 284.4 | 2640 | 10251 |
| RTX 5080 | 360 | **99.12** | 359.7 | 2604 | 14801 |
| RTX 3070 | 240 | **16.43** | 238.2 | 1871 | 6801 |
| RTX 3070 | 240 | **16.43** | 238.6 | 1896 | 6801 |
| RTX 5080 | 360 | **98.02** | 360.0 | 2574 | 14801 |
| RTX 5070 Ti | 300 | **81.53** | 299.9 | 2578 | 13801 |
| RTX 5090 | 420 | **130.92** | 419.7 | 1660 | 13801 |
| RTX 3070 | 220 | **16.39** | 219.2 | 1846 | 6801 |
| CMP 170HX | 300 | **31.68** | 212.6 | 1295 | 1728 |

Fixed measurement windows follow warmup; each card's shares were checked with
the upstream CPU reference, with zero invalid shares. Clocks were unchanged.
Power limits are settings, not measured consumption; actual mean watts and
clocks are in the [CSV](docs/benchmarks/neb-1944-fleet-kep1-reference.csv).
The RTX 4070 Ti SUPER retained another application's GPU context. Repeated
5080 and 3070 rows represent separate physical cards. The CMP completed the
full measurement at a 300 W limit with native thermal throttling active at
85 C (87 C peak memory); Kepler mean draw was 212.6 W. Its rate reflects
that cooling condition. Original power and verifier service were restored.

The earlier matched RTX 5090 kernel A/B/B/A at 450 W improved KEP1 from
**136.00 to 139.19 MH/s (+2.35%)** in 1.9.43. This optimization is preserved;
The current trained-model gains and historical genesis-model gains are listed above. Historical RET2 figures below
are for the old network and must not be interpreted as TESS performance.


## Historical Suprminer 1.9.43 measurements — NEB 1.0.0

### Mainnet before / after — RTX 5090

| GPU / power limit | Architecture | 1.9.42 kernels | 1.9.43 kernels | Gain |
|---|---|---:|---:|---:|
| RTX 5090 / 450 W | KEP1 | 136.00 MH/s | **139.19 MH/s** | **+2.35%** |
| RTX 5090 / 450 W | RET2 | 60.51 MH/s | **62.08 MH/s** | **+2.60%** |

Measured on Linux, CUDA 13.3, on 17 November 2026 with the mainnet genesis
models and dataset. After 45 seconds of warmup per architecture, four 30-second
A/B/B/A arms were averaged by build. Power limit and clocks were unchanged.
These are kernel-pipeline measurements from the qualified development build
used for 1.9.43; rates depend on the model and GPU settings.
[Individual measurements](docs/benchmarks/neb-mainnet-2026-11-17-5090.csv).

The final Linux 1.9.43 executable measured **138.43 MH/s KEP1 and 61.71 MH/s
RET2** on the same mainnet models, with CPU use of **1.45% of one core**. All
56 submitted test shares matched the upstream CPU reference. This is a controlled synthetic
workload, not a pool earnings measurement.

Both architectures also mined on an isolated chain using the real NEB 1.0.0
mainnet consensus. Physical Windows GPU performance and other cards were not
remeasured for this optimization. The 1.9.42 table below is historical, using
different fixed models; it is not the baseline for this mainnet comparison.

## Suprminer 1.9.42 — historical NEB v0.3.0 measurements


New CUDA kernels compute each NEB attempt in one warp without shared-memory
staging, and RET2 layer 3 reads precomputed tensor-core operands. Shares and
blocks are bit-identical to the reference algorithm; every submitted share is
still checked on the CPU.

[Download 1.9.42](https://github.com/ocminer/suprminer/releases/tag/v1.9.42) ·
[NEB setup guide](docs/NEB_RELEASE_GUIDE.md)

### NEB v0.3.0 measurements — 1.9.42

| GPU | Power limit | KEP1 | RET2 | 1.9.41 (KEP1 / RET2) |
|---|---:|---:|---:|---:|
| RTX PRO 6000 | 600 W | **193.2 MH/s** | **82.1 MH/s** | 139.0 / 66.6 MH/s |
| RTX 5090 | 575 W | **163.9 MH/s** | **72.2 MH/s** | 120.9 / 56.2 MH/s |
| RTX 5090 | 450 W | **139.4 MH/s** | **61.1 MH/s** | 102.4 / 47.3 MH/s |
| RTX 5080 | 360 W | **99.7 MH/s** | **38.1 MH/s** | 71.8 / 32.4 MH/s |
| RTX 5070 Ti | 300 W | **82.4 MH/s** | **28.1 MH/s** | 59.3 / 25.0 MH/s |
| RTX 3070 | 240 W | **16.5 MH/s** | **7.9 MH/s** | 3.9 / 3.3 MH/s |

Measured on Linux on 2026-11-13 with the built-in `--neb-test` benchmark (fixed
seeded models, 12 to 60 seconds per network; the 450 W row is the final release
executable). Clocks were unchanged; the power
limit is the card's configured limit. Each row is one run. Actual pool rates
alternate between KEP1 and RET2 blocks and vary with the model.

The full `--neb-test` (complete tickets, boundary nonces, hit sets and queued
batches for two models of each network) passed on the RTX 5090, RTX PRO 6000,
5080, 5070 Ti and 3070, and on the final Linux and both HiveOS executables,
including forced PTX compilation. The final Linux executable mined on the NEB
v0.3.0 network with 0 rejected shares at 1.4% of one CPU core. Quantus, NPT and
XNT regression checks passed and their kernels are unchanged. Physical Windows GPU
mining was not tested.

## Suprminer 1.9.41 — NEB v0.3.0 (previous release)


1.9.41 mines NEB v0.3.0 more than a thousand times faster than 1.9.40. Each
dataset sample is computed once per model and every attempt is built from these
cached results; shares and blocks are bit-identical to the reference algorithm.
Every submitted share is still checked on the CPU.

[Download 1.9.41](https://github.com/ocminer/suprminer/releases/tag/v1.9.41) ·
[NEB setup guide](docs/NEB_RELEASE_GUIDE.md) ·
[Pre-fork 1.9.39](https://github.com/ocminer/suprminer/releases/tag/v1.9.39)

### NEB v0.3.0 measurements — 1.9.41

| GPU | Power limit | KEP1 | RET2 |
|---|---:|---:|---:|
| RTX 5090 | 575 W | **120.9 MH/s** | **56.2 MH/s** |
| RTX 5090 | 450 W | **102.4 MH/s** | **47.3 MH/s** |
| RTX 5080 | 360 W | **71.8 MH/s** | **32.4 MH/s** |
| RTX 5070 Ti | 300 W | **59.3 MH/s** | **25.0 MH/s** |
| RTX 3070 | 240 W | 3.9 MH/s | 3.3 MH/s |

For comparison, 1.9.40 reached 0.075 MH/s (KEP1) and 0.020 MH/s (RET2) on the
RTX 5090 at 450 W.

Measured on Linux with the 1.9.41 CUDA build on 2026-11-13, using the built-in
`--neb-test` benchmark (fixed seeded models, 6 to 60 seconds per network). The
450 W row is the final release executable (60 seconds per network; the HiveOS
20.04 package measured 103.0 / 47.4 MH/s). Clocks were unchanged; the power limit
is the card's configured limit. Each row is one run. Actual pool rates alternate between KEP1 and RET2 blocks and vary with the
model. RTX 30-series cards have much smaller caches and are far slower on NEB v2.

The full `--neb-test` (complete tickets, boundary nonces, hit sets and queued
batches for two models of each network) passed on the RTX 5090, 5080, 5070 Ti and
3070, including the path without sparse tensor cores, and on the final Linux and
both HiveOS executables, including forced PTX compilation. On a private NEB v0.3.0
chain the final Linux executable mined four node-confirmed blocks through a pool;
a post-fork rehearsal pool accepted every share. 0 shares were rejected. Steady
pool CPU use was 2.0% of one core. Old NEB jobs are refused. Quantus, NPT and XNT
regression checks passed and their kernels are unchanged. Physical Windows GPU
mining was not tested.

## Suprminer 1.9.40 — NEB v0.3.0


**Required for NEB block 8800. This version supports only the new KEP1/RET2
algorithm. Keep 1.9.39 for pre-fork NEB jobs and switch when your pool activates
the fork.** Old NEB jobs are refused; the product remains Suprminer and the
command stays `-a neb`. KEP1 begins at block 8800, RET2 at block 8801.
For Docker NEB deployments before pool activation, pin
`ocminersupr/suprminer-base:1.9.39`; `latest` moves to 1.9.40.

The new 259.9 MB dataset downloads automatically with BLAKE3 verification.
NVIDIA Linux, Windows, HiveOS, mmpOS, SMOS and Docker packages include new NEB.
The Quantus OpenCL/Vulkan packages remain available for their existing algorithms.
Every submitted NEB share is checked on the CPU; queued GPU work uses blocking
waits to keep CPU usage low.

[Download 1.9.40](https://github.com/ocminer/suprminer/releases/tag/v1.9.40) ·
[NEB setup guide](docs/NEB_RELEASE_GUIDE.md) ·
[Pre-fork 1.9.39](https://github.com/ocminer/suprminer/releases/tag/v1.9.39)

### NEB v0.3.0 measurements — 1.9.40

Measured on Linux using the final 1.9.40 CUDA executables on 2026-11-11,
with a 60-second built-in benchmark and a fixed seeded model for each
architecture. The existing 450 W limit and clocks were unchanged. GPU watts and clocks
are sampled averages during the benchmark; CPU percentages refer to one core.
Each row is one run, not a matched A/B comparison. The Docker image contains the
same executable as the portable Linux bundle. These are initial post-fork
algorithm measurements, not an old/new speedup comparison. Actual pool rates
vary with the model and share difficulty.

| GPU | Build | Network | kH/s | Limit W | GPU W | Core MHz | Memory MHz | CPU % of one core |
|---|---|---|---:|---:|---:|---:|---:|---:|
| RTX 5090 | Portable Linux / Docker | KEP1 | **75.065** | 450 | 347.2 | 2837 | 13801 | 0.74 |
| RTX 5090 | Portable Linux / Docker | RET2 | **19.585** | 450 | 376.0 | 2806 | 13801 | 0.37 |
| RTX 5090 | HiveOS 20.04 | KEP1 | **65.571** | 450 | 355.7 | 2839 | 13801 | 0.55 |
| RTX 5090 | HiveOS 20.04 | RET2 | **22.808** | 450 | 450.2 | 2774 | 13801 | 0.25 |

The final Linux executable was tested on an RTX 5090 against NEB v0.3.0.
Both KEP1 and RET2 produced accepted shares and node-confirmed blocks.
Steady pool-test CPU use was 0.94% of one core. Old NEB
jobs were refused with a clear requirement message and zero reported mining rate.
Quantus, NPT and XNT regression checks passed, and unrelated algorithm kernels
were preserved. Native Windows builds and CPU protocol tests passed. Physical
Windows GPU mining and other GPU models were not tested in this release session.

The HiveOS 20.04 package also passed automatic replacement of the old cached
dataset and live statistics checks with curl 7.58.


New KEP1/RET2 kH/s figures are not comparable to the old NEB algorithm's MH/s figures.

## Suprminer 1.9.39

NEB: new GPU kernel K3. RTX 5070 Ti at 300 W: built-in benchmark 31.42 MH/s
(1.9.38: 21.57, +45.7%), live 36.81 MH/s on `neb.suprnova.cc:7804` (1.9.38:
22.02). RTX 5090 at 450 W: about 65 MH/s (1.9.38: 40.01); the 5090 figures are
development measurements of the same K3 code (65.9/66.5 MH/s benchmark, 65.4
MH/s live for 27 minutes, 65 accepted, 0 rejected), not of the release
download. `auto` picks the fastest kernel that matches the CPU reference. GPU
code of all other algorithms is unchanged from 1.9.38.

```sh
./suprminer-neptune -a neb -o stratum+tcp://neb.suprnova.cc:7804 -u YOUR_NEB_ADDRESS.rig01 -p x
```

[Download 1.9.39](https://github.com/ocminer/suprminer/releases/tag/v1.9.39) ·
[Release notes](https://github.com/ocminer/suprminer/releases/tag/v1.9.39) ·
[NEB](docs/NEB_RELEASE_GUIDE.md)

## Historical pre-fork NEB performance — 1.9.39

Release executable on Linux, stock clocks. Benchmark rows are the built-in
`--neb-test` benchmark (30 seconds per run, A/B/B/A order). The pool row is the
average of the miner's own rate over live mining on `neb.suprnova.cc:7804`
after the first 30 seconds. Watts and clocks are GPU averages while hashing.

| GPU | Limit W | Version, kernel | MH/s | GPU W | SM MHz | Pool shares |
|---|---:|---|---:|---:|---:|---|
| RTX 5070 Ti | 300 | 1.9.38 auto = K1X (benchmark) | 21.57 | 291.1 | 2744 | |
| RTX 5070 Ti | 300 | 1.9.39 auto = K3 (benchmark) | **31.42** | 294.2 | 2749 | |
| RTX 5070 Ti | 300 | 1.9.39 auto = K3 (pool, 26 min) | **36.81** | 299.4 | 2743 | 63 accepted, 0 rejected |

## Suprminer 1.9.38

NEB: new tensor-core kernel K1X and a fix for low NEB hashrates reported on
Windows and WSL2. Live NEB mining: RTX 5090 at 450 W 40.01 MH/s (1.9.37: 33.73,
+18.6%), RTX 5070 Ti at 300 W 22.02 MH/s (1.9.37: 18.95, +16.2%). `auto` checks
every tensor-core kernel against the CPU reference and keeps the fastest per
card and job. GPU code of all other algorithms is unchanged from 1.9.37.

```sh
./suprminer-neptune -a neb -o stratum+tcp://neb.suprnova.cc:7804 -u YOUR_NEB_ADDRESS.rig01 -p x
```

[Download 1.9.38](https://github.com/ocminer/suprminer/releases/tag/v1.9.38) ·
[Release notes](https://github.com/ocminer/suprminer/releases/tag/v1.9.38) ·
[NEB](docs/NEB_RELEASE_GUIDE.md)

## Historical pre-fork NEB performance — 1.9.38

Measured on Linux with the release executable on 2026-11-10/11, stock clocks,
no overclocking. Benchmark rows are the built-in `--neb-test` benchmark
(30 seconds per run, A/B/B/A order, four runs per kernel). Pool rows are
averages of the miner's own rate over live mining on `neb.suprnova.cc:7804`
after the first 30 seconds, with every share checked by the CPU reference.
Watts and clocks are GPU averages while hashing.

| GPU | Limit W | Kernel | MH/s | GPU W | SM MHz | Pool shares |
|---|---:|---|---:|---:|---:|---|
| RTX 5090 | 450 | K1P (benchmark) | 33.35 | 449.9 | 2193 | |
| RTX 5090 | 450 | K1X (benchmark) | **38.33** | 447.6 | 2014 | |
| RTX 5090 | 450 | auto = K1X (pool, 25 min) | **40.01** | 449.5 | 2026 | 57 accepted, 0 rejected |
| RTX 5070 Ti | 300 | auto = K1X (pool, 21 min) | **22.02** | 299.2 | 2761 | 61 accepted, 0 rejected |

Other GPUs were not measured with this release; their kernel is chosen by the
same check and timing.

## Suprminer 1.9.37

NEB: fixes the reconnect loop on Windows and on slow or remote connections with
a new stratum client. A network thread receives complete pool messages however
they are split, and the mining loop no longer reads from the connection. GPU code
is unchanged from 1.9.36 for all algorithms.

[Download 1.9.37](https://github.com/ocminer/suprminer/releases/tag/v1.9.37) ·
[Release notes](https://github.com/ocminer/suprminer/releases/tag/v1.9.37)

## Suprminer 1.9.36

Adds NEB (Neural Engine Byte) proof-of-training mining on NVIDIA GPUs (`-a neb`).
Each attempt is one exact integer training step of a small neural network; every
GPU share is checked again with the NEB reference code on the CPU. The 37.6 MB
dataset file is downloaded and hash-checked automatically. All other algorithms
are unchanged from 1.9.35. Portable Linux packages support Ubuntu 20.04 and newer
without system C++ or OpenSSL libraries.

```sh
./suprminer-neptune -a neb -o stratum+tcp://neb.suprnova.cc:7804 -u YOUR_NEB_ADDRESS.rig01 -p x
```

[Download 1.9.36](https://github.com/ocminer/suprminer/releases/tag/v1.9.36) ·
[Release notes](https://github.com/ocminer/suprminer/releases/tag/v1.9.36) ·
[NEB](docs/NEB_RELEASE_GUIDE.md) ·
[Merged mining](MERGED_MINING.md) · [PRL and NOID](docs/PRL_NOID_RELEASE_GUIDE.md) ·
[Quantus](docs/QUANTUS_RELEASE_GUIDE.md) · [Docker and cloud hosting](docker/README.md)

## Historical pre-fork NEB performance — 1.9.36

Measured on Linux with the full release executable on 2026-11-10, stock
clocks, no overclocking. The benchmark rows are the built-in `--neb-test`
benchmark (30 seconds per run, A/B/B/A order, four runs per kernel). The pool
rows are averages of the miner's own rate over live mining on
`neb.suprnova.cc:7804` after the first 30 seconds, with every share checked by
the CPU reference. Watts and clocks are GPU averages while hashing.

| GPU | Limit W | Kernel | MH/s | GPU W | SM MHz | Pool shares |
|---|---:|---|---:|---:|---:|---|
| RTX 5090 | 450 | K1 (benchmark) | 31.43 | 449.4 | 1835 | |
| RTX 5090 | 450 | K1P (benchmark) | **32.91** | 450.1 | 2172 | |
| RTX 5090 | 450 | auto = K1P (pool, 15 min) | **32.35** | 450.0 | 2278 | 41 accepted, 0 rejected |
| RTX 5070 Ti | 300 | auto = K1 (pool, 10 min) | **18.31** | 299.5 | 2685 | 24 accepted, 0 rejected |

K1P computes two attempts per thread block and loads each weight fragment once
for both, which cuts memory traffic. With the same 450 W limit the RTX 5090
runs at higher clocks and reaches 4.7% more attempts per second than K1. On the
RTX 5070 Ti, K1 is faster, so the start-up timing keeps K1 there. Both kernels
produce bit-identical results. Other GPUs (RTX 30xx/40xx, A100/H100, CMP 170HX,
GTX 16xx/RTX 20xx) were not measured; their kernel is chosen by the same timing.

While mining, the miner uses about 0.7% of one CPU core per GPU instead of
waiting in a busy loop.

## TAPE / NOID performance — 1.9.35

Measured on Linux with the full release executables on 2026-11-04. Each version
ran twice on the same card in A/B/B/A order: 150 seconds per run, or 210 seconds
for the RTX 3070. The first 40 seconds of mining are excluded. Every submitted
share was checked against an independent CPU reference; rates are measured from
nonce progress on identical captured TAPE work at 50,000,000 hashes per share.
Both versions used an external 810 MHz memory lock. No core offsets or voltage
changes were applied. Watts and clocks below are averages for 1.9.35; watts cover
the GPU, not the whole rig. The 600 W row uses the card's maximum supported limit.

| GPU | Limit W | 1.9.34 MH/s | 1.9.35 MH/s | GPU W | SM MHz | Memory MHz | MH/s/W |
|---|---:|---:|---:|---:|---:|---:|---:|
| RTX 5090 | 600 | 272.09 | **271.31** | 600.0 | 2617 | 810 | 0.452 |
| RTX 5080 #1 | 360 | 143.67 | **143.51** | 331.7 | 2794 | 810 | 0.433 |
| RTX 5080 #2 | 360 | 146.44 | **146.27** | 360.0 | 2849 | 810 | 0.406 |
| RTX 5070 Ti | 300 | 119.00 | **118.63** | 265.5 | 2772 | 810 | 0.447 |
| RTX 3070 | 240 | 50.91 | **50.85** | 238.3 | 1891 | 810 | 0.213 |
| RTX 5090 | 420 | 232.23 | **230.48** | 419.9 | 2362 | 810 | 0.549 |

The main improvement is CPU use and performance when CPU capacity is limited.
Normal peak GPU throughput remains close to 1.9.34; small differences include
normal boost and thermal variation.

In the unrestricted single-GPU runs, 1.9.34 used approximately 100% of one CPU core; 1.9.35 used **0.21–0.27%**.

Additional matched A/B/B/A tests constrained the miner's CPU availability, with
normal memory clocks and a target of 10,000,000 hashes per share. The 5080 used a
360 W limit. The three-GPU test used two 3070s at 240 W each plus a 5080 at 360 W,
with the process restricted to two physical CPU cores. Both tests used desktop
CPUs with software limits; a physical dual-core mining motherboard was not tested.
CPU percentages below are relative to one core, so 200% means two fully used cores.

| CPU-constrained setup | 1.9.34 MH/s | 1.9.35 MH/s | Change | 1.9.34 CPU | 1.9.35 CPU | GPU W, 1.9.34 → 1.9.35 |
|---|---:|---:|---:|---:|---:|---:|
| RTX 5080, 25% of one core | 111.87 | **143.04** | +27.9% | 25.00% | **0.42%** | 267.3 → 345.2 |
| Three GPUs, two cores | 245.74 | **245.39** | -0.1% | 199.98% | **0.84%** | 837.7 → 837.7 |

Results depend on the CPU, GPU cooling, power settings and share difficulty.
GTX 16xx / RTX 20xx NOID support is experimental: Turing-targeted arithmetic and
nonce recovery passed checks on a newer GPU, but a physical GTX 1660 Super was
unavailable. No Turing hardware hashrate or compatibility result is claimed.


## Choose a download

| Platform | Package |
|---|---|
| Linux NVIDIA, Ubuntu 20.04+ | Complete `suprminer-1.9.43-linux-x86_64.tar.gz` bundle |
| Linux NVIDIA, Ubuntu 20.04 / 22.04 | Matching `linux-x86_64-u2004` / `u2204` executable; helper is also available separately |
| Linux AMD, Ubuntu 20.04+, Quantus | Optional `quantus-vulkan-linux-x86_64` executable; add `--vulkan` |
| Windows NVIDIA | Native `windows-x86_64-nvidia.zip` |
| Windows AMD / Pascal Quantus | Native `windows-x86_64-quantus-opencl.zip` |
| HiveOS | NVIDIA or OpenCL `_u2004.tar.gz` / `_u2204.tar.gz` custom package |
| mmPOS | NVIDIA or OpenCL `mmpos_1.9.43` external-miner package |
| SMOS | NVIDIA or OpenCL `smos-…-u2004.zip` / `u2204.zip` custom package |
| Docker, Octa.Space, Vast.ai | `ocminersupr/suprminer-base:1.9.46` |

Verify the SHA-256 checksum before installation. Extract complete archives and
keep their supporting files beside the executable. Install the appropriate GPU
driver and choose a package compatible with the rig's OS.

PRL + NOCK requires a Linux NVIDIA package, a compatible pool, CPU capacity and
at least **24 GiB available system RAM**. The Windows miner is native and supports
ordinary PRL; the auxiliary NOCK helper is Linux-only in this release. NOCK
accounting and payouts depend on the pool. OpenCL and Vulkan packages support Quantus.

## Quick start

Replace each placeholder with your own payout address and worker name:

```sh
# PRL
./suprminer-neptune -a pearl -o stratum+tcp://prl.suprnova.cc:3373 -u YOUR_PRL_ADDRESS.rig1 -p x --no-cpu

# PRL + NOCK, Linux NVIDIA with the bundled helper
./suprminer-neptune -a pearl --nock-merge -o stratum+tcp://prl.suprnova.cc:3373 -u 'YOUR_PRL_ADDRESS+YOUR_NOCK_ADDRESS.rig1' -p x --no-cpu

# NOID
./suprminer-neptune -a noid -o stratum+tcp://noid.suprnova.cc:3337 -u YOUR_NOID_ADDRESS.rig1 -p x

# TAPE / Retro Boomer (the NOID algorithm)
./suprminer-neptune -a noid -o stratum+tcp://tape.suprnova.cc:3351 -u YOUR_TAPE_ADDRESS.rig1 -p x --no-cpu

# Quantus
./suprminer-neptune -a quantus -o stratum+ssl://quantus.suprnova.cc:7074 -u YOUR_QUANTUS_ADDRESS.rig1 -p x

# NPT (Neptune Cash) — plain TCP; the username is your pool account
./suprminer-neptune -a npt -o stratum+tcp://npt.suprnova.cc:6453 -u YOUR_POOL_ACCOUNT.rig1 -p x

# NEB 1.0.1 mainnet — Kepler and TESS
./suprminer-neptune -a neb -o stratum+tcp://neb.suprnova.cc:7804 -u YOUR_NEB_ADDRESS.rig1 -p x
```

On Windows, use `.\suprminer-neptune.exe` in PowerShell. Add `-d 0,1` to select
GPUs. Stop with Ctrl+C. Use `--help` for all supported options.

## Supported algorithms

| `-a` name | Aliases | Coin / PoW | Backend |
|---|---|---|---|
| `prl` | `pearl`, `pearlhash` | Pearl — follows the pool: noised INT8 GEMM today, FP8 tensor-core GEMM after the upgrade | INT8 scheme: NVIDIA sm_75+; FP8 scheme: RTX 50 / RTX PRO Blackwell |
| `prlold` | `pearlold` | Pearl before the FP8 upgrade only | NVIDIA sm_75+ |
| `sha3t` | `sha3d3`, `bc3`, `bitcoiniii` | BitcoinIII — triple NIST SHA3-256 | NVIDIA + AMD/OpenCL |
| `xelis` | `xel` | Xelis — XelisHash v2 | NVIDIA + CPU |
| `decred` | `dcr` | Decred — BLAKE3 | NVIDIA |
| `verthash` | `vtc`, `vertcoin` | Vertcoin — Verthash (needs `verthash.dat`, `--verthash-data`) | NVIDIA |
| `neoscrypt` | `neo` | NeoScrypt memory-hard | NVIDIA |
| `qhash` | `qtc`, `qubitcoin` | QuBitcoin — quantum-circuit PoW | NVIDIA |
| `quantus` | `poseidon2-goldilocks`, `qpow-poseidon2` | Quantus — Poseidon2 over Goldilocks | NVIDIA + AMD + CPU |
| `gap` | `gapcoin` | Gapcoin — prime gaps | NVIDIA |
| `qubit` | `dgb`, `digibyte-qubit` | DigiByte — Qubit 5-hash chain | NVIDIA |
| `groestl` | `grs`, `groestlcoin` | GroestlCoin — double Groestl-512 | NVIDIA |
| `yescrypt` | `yescryptr32`, `lpepe` | YescryptR32 memory-hard | CPU |
| `sha256mem` | `fairchain`, `fair` | Fairchain — memory-hard sha256mem | NVIDIA |
| `noid` | `parano1d`, `poseidon2b` | NOID / Parano1d — Poseidon2b over GF(2¹²⁸) | NVIDIA sm_80 / sm_86 / sm_89 / sm_90 / sm_120; experimental sm_75 (GTX 16xx / RTX 20xx) |
| `npt` | `neptune`, `neptune-cash` | Neptune Cash — HardforkDelta PoW, negotiated suffix search | NVIDIA sm_80+ (RTX 30xx, CMP 170HX, RTX 40xx/50xx, A100/H100, RTX PRO 6000) |
| `neb` | `nebcoin`, `pot` | NEB 1.0.1 — KEP1 Kepler/TESS proof-of-training | NVIDIA sm_75+ / AMD OpenCL |

Algorithm support depends on the selected backend and GPU. The PRL/NOID guide
lists their requirements; the NEB guide covers NEB. Saved GPU profiles are selected automatically.

## Mining operating systems

Use the NVIDIA HiveOS, mmPOS or SMOS package for PRL/NOID/NPT/NEB. Configure the algorithm,
pool and your own wallet address in the platform's custom miner settings.
For PRL + NOCK, use the combined wallet format and add `--nock-merge` to extra
arguments. The helper is bundled in the NVIDIA packages.

SMOS packages use its CUSTOM ZIP format. These are custom packages, not a claim
that Suprminer is included in a platform's managed miner list. Package checks and
Linux GPU testing do not replace validation of a particular mining OS installation.

## Docker

```sh
docker run -d --name suprminer --gpus all --restart unless-stopped \
  -e COIN=PRL -e USERNAME=YOUR_PRL_ADDRESS -e WORKER=rig1 \
  ocminersupr/suprminer-base:1.9.46
```

For merged mining, use `USERNAME=YOUR_PRL_ADDRESS+YOUR_NOCK_ADDRESS` and add
`-e EXTRA_ARGS=--nock-merge`. See the Docker guide for all environment settings.

## Status and support

Enable the local statistics API with `--api --api-port 4068`; read
`http://localhost:4068/summary`. Confirm accepted shares after changing a package
or pool. Use the GitHub issue tracker for problems and include the version, OS,
GPU model and relevant log excerpt. Do not post passwords, access tokens or
private configuration files.

Windows packages are compiled natively in GitHub CI and checked with command-line
and CPU protocol tests. Windows GPU mining has not been tested on hardware.
Third-party license notices are included in the downloads.
