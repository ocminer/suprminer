# suprminer

Multi-algorithm GPU/CPU miner for Suprnova pools and beyond. One binary, many algorithms —
NVIDIA CUDA first (RTX 20xx "Turing" sm_75 through RTX 50xx "Blackwell" sm_120, plus
datacenter A100/H100/B200), AMD/OpenCL for selected algorithms, CPU for the memory-hard ones.

Binary name: `suprminer-neptune` (historical). Releases:
https://github.com/ocminer/suprminer/releases

## Suprminer 1.9.47 — faster trained NEB models and TLS

**NEB 1.0.1 mainnet is live.** Use `-a neb`.
Native slots **0 = Kepler** and **1 = TESS** both use exact KEP1 integer math
and the verified 16.1 MB dataset. Recognized old dataset caches update automatically.
Every submitted share is checked against the CPU reference. **0% miner fee.**

NVIDIA now selects exact kernels for each trained model on the tested RTX 5090,
RTX 5080, RTX 3070 and RTX 4070 Ti SUPER. It avoids redundant integer work where
model bounds prove this is safe, measures candidate schedules on the GPU, and
retains the previous path when the model cannot use the optimization. Other GPU
models retain their existing dispatch. No floating-point approximation or relaxed
share validation.

NEB supports **`stratum+tcp://`** for plaintext and **`stratum+ssl://`** for TLS.
TLS verifies the server certificate and hostname; a failed TLS connection never
falls back to plaintext. Suprnova offers TLS on ports 7806 (PPLNS) and 7807 (solo)
in Europe and Asia; see the setup guide below.

AMD retains the qualified OpenCL backend: exact INT8 matrix instructions on tested
RDNA3 cards, the faster measured portable integer path on MI50, and a portable
fallback for unknown hardware/compilers. CPU reference checks remain enabled.

Linux, Windows, HiveOS, mmpOS, SMOS and Docker have separate NVIDIA and AMD packages.
AMD names retain `quantus-opencl` / `_opencl`; they now include NEB as well.
The `quantus-vulkan` Linux package uses OpenCL for NEB. Physical Windows GPU
execution and unlisted AMD generations remain unqualified.

[Download 1.9.47](https://github.com/ocminer/suprminer/releases/tag/v1.9.47) ·
[NEB setup](docs/NEB_RELEASE_GUIDE.md) · [NEB pool](https://neb.suprnova.cc/)

Windows archives include **`start-neb.bat`**: enter your NEB wallet address and
start mining at `neb.suprnova.cc:7804`. No miner fee; the pool charges 1%.

<!-- NEB1947_BENCHMARKS:BEGIN -->
### NEB trained models: before / after

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
Later releases select new kernels on qualified cards. These are historical
performance references, **not new TESS results or a repeated 1.9.47 fleet
sweep**. Rates vary with models and settings.

| GPU | Power limit | Kepler KEP1 reference |
|---|---:|---:|
| RTX 5090 | 450 W | **139.31 MH/s** |
| RTX 5090 | 600 W | **170.74 MH/s** |
| RTX 4070 Ti SUPER | 285 W | **58.24 MH/s** |
| RTX 5080 | 360 W | **99.12 MH/s** |
| RTX 3070 | 240 W | **16.43 MH/s** |
| RTX 3070 | 240 W | **16.43 MH/s** |
| RTX 5080 | 360 W | **98.02 MH/s** |
| RTX 5070 Ti | 300 W | **81.53 MH/s** |
| RTX 5090 | 420 W | **130.92 MH/s** |
| RTX 3070 | 220 W | **16.39 MH/s** |
| CMP 170HX | 300 W | **31.67 MH/s** |

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
**136.00 to 139.19 MH/s (+2.35%)** in 1.9.43. This optimization is preserved.
The current trained-model and historical genesis-model measurements are listed above. Historical RET2 figures below
are for the old network and must not be interpreted as TESS performance.

## Quick start

```bash
./suprminer-neptune -a pearl -o stratum+tcp://prl.suprnova.cc:3373 -u <wallet>.<worker> -p x
./suprminer-neptune -a sha3t -o stratum+tcp://bc3.suprnova.cc:7700 -u <wallet>.<worker> -p x
./suprminer-neptune -a noid  -o stratum+tcp://noid.suprnova.cc:3337 -u <NOID_ADDRESS>.<worker>
```

Run as root if you want the miner to manage power limits / clocks (`--power-limit`,
`--core-clock`, `--mem-clock`, `--fan-speed` — all reset to defaults on exit).
Stop with SIGINT (Ctrl-C) for a clean shutdown; PearlHash requires it.

## Supported algorithms

| `-a` name | Aliases | Coin / PoW | Backend |
|---|---|---|---|
| `pearl` | `pearlhash`, `prl` | Pearl — noised INT8 GEMM (tensor cores) | NVIDIA sm_75+ |
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
| `nock` | `nockchain` | Nockchain — TIP5 ZK-STARK | NVIDIA |
| `noid` | `parano1d`, `poseidon2b` | NOID / Parano1d — Poseidon2b over GF(2¹²⁸) | NVIDIA sm_80 / sm_86 / sm_89 / sm_90 / sm_120; experimental sm_75 (GTX 16xx / RTX 20xx) |
| `npt` | `neptune`, `neptune-cash` | Neptune Cash — HardforkDelta PoW, negotiated suffix search (`npt_suffix_v1`) with legacy fallback | NVIDIA sm_80+ (RTX 30xx, CMP 170HX, RTX 40xx/50xx, A100/H100) |
| `xnt` | `neptune-privacy` | Neptune Privacy — commitment-seeded 2^27-leaf memory tree (~10.7 GB VRAM) | NVIDIA sm_80+ with >= 12 GB (CMP 170HX, RTX 3080 12G+, 40xx/50xx, A100/H100) |
| `neb` | `nebcoin`, `pot` | NEB 1.0.1 nebhash v2 — KEP1 Kepler/TESS proof-of-training | NVIDIA sm_75+ / AMD OpenCL |

`./suprminer-neptune --help` prints the full flag reference and a per-algorithm footer.

## NEB (proof-of-training)
```bash
./suprminer-neptune -a neb -o stratum+tcp://neb.suprnova.cc:7804 -u <neb-address>.<worker> -p x
```
**Suprminer 1.9.47 supports NEB 1.0.1: KEP1 on both Kepler and TESS.**
Use native dataset indices 0/1 and the new pinned 16.1 MB file; old cache
containers and RET2 work are incompatible. The automatic downloader upgrades
recognized old caches. Each card keeps separate KEP1 sample and model caches
for the two datasets. New jobs and every submitted share are checked against
the CPU reference. CUDA device code remains encrypted.
See [the NEB guide](docs/NEB_RELEASE_GUIDE.md) for setup and dataset controls.

### Historical NEB 1.0.0 performance — 1.9.43

1.9.43 adds a measured RTX 5090 path with vectorized writes and
lower-cost integer reductions. Other cards retain their existing kernels.

| GPU / power limit | Architecture | 1.9.42 kernels | 1.9.43 kernels | Gain |
|---|---|---:|---:|---:|
| RTX 5090 / 450 W | KEP1 | 136.00 MH/s | 139.19 MH/s | +2.35% |
| RTX 5090 / 450 W | RET2 | 60.51 MH/s | 62.08 MH/s | +2.60% |

Measured on Linux, CUDA 13.3, on 2026-11-17 with the actual mainnet genesis
models and dataset. Each architecture had 45 seconds of warmup followed by
30-second A/B/B/A arms; the table averages the two arms per build. No power or
clock changes. These are timed kernel-pipeline measurements from the qualified development
build used for 1.9.43, not a performance claim for unmeasured cards. The integrated
native kernels match the measured machine code; complete tickets remain exact.
[Individual measurements](docs/benchmarks/neb-mainnet-2026-11-17-5090.csv).
The historical table below uses different fixed models and is not this A/B baseline.

### NEB v0.3.0 measurements (1.9.42)

1.9.42 computes each dataset sample once per model, and every attempt runs in one
warp from these cached results on tensor cores. Shares and blocks are
bit-identical to the reference algorithm.

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


## XNT (Neptune Privacy)
```bash
./suprminer-neptune -a xnt -o <host>:<port> -u <xnt-address>.<worker> -p x -d 0
```
Plain TCP only. One pool session and one ~10.7 GB memory tree per GPU (>= 12 GB VRAM). The tree is
rebuilt only when the puzzle changes; a `no_work_available` pause keeps the GPU idle without
discarding it. Every GPU share is re-verified on the CPU before it is submitted. A session with no
pool traffic for `XNT_NOTIFY_WATCHDOG_S` seconds (default 90) reconnects. Offline GPU gate (no
pool): `-a xnt --xnt-gpu-selfcheck 8 -d <gpu>`. Compile-time switch: on in every CUDA build;
`-no-xnt` drops it (feature `xnt`). Details: `docs/xnt/XNT-ON-MAIN.md`.

## NPT (Neptune Cash)
```bash
./suprminer-neptune -a npt -o stratum+tcp://npt.suprnova.cc:6453 -u <account>.<worker> -p x -d 0,1
```
Plain TCP only (the pool's TLS ports are not supported). One pool session per GPU; when the pool
acknowledges `npt_suffix_v1` the fast suffix-search kernel is used, otherwise the legacy nonce kernel.
The pool repeats `no_work_available` or re-sends the job as a heartbeat; a session with no pool traffic for
`NPT_NOTIFY_WATCHDOG_S` seconds (default 90) reconnects. Offline GPU gates (no pool): `-a npt --npt-gpu-echo 7,0`,
`-a npt --npt-gpu-selfcheck 24`, `-a npt --npt-gpu-bench 20`, each with `--npt-meta <saved mining.notify metadata JSON>` and `-d <gpu>`.
Compile-time switch: on in every CUDA build; `./build.sh -prod -no-npt` drops it (feature `npt`).
The pre-fork `neptune` code was removed in 1.9.28; XNT is back as its own `-a xnt` (see above).

## Quantus

Quantus uses CryptoNote-style TCP Stratum (`login`, `job`, `submit`, `keepalived`).
It is a separate algorithm from QuBitcoin/QHash and NOID/Poseidon2b.

```bash
# Suprnova pool
./suprminer-neptune -a quantus -o stratum+tcp://quantus.suprnova.cc:7071 -u <ADDRESS>.<WORKER> -d 0

# TLS
./suprminer-neptune -a quantus -o stratum+ssl://quantus.suprnova.cc:7074 -u <ADDRESS>.<WORKER> -d 0

# CPU mining
./suprminer-neptune -a quantus -o quantus.suprnova.cc:7071 -u <ADDRESS>.<WORKER> --no-gpu --cpu-threads 4

# Offline GPU/CPU correctness check, no pool required
./suprminer-neptune --quantus-test -d 0
```

Use your Quantus payout address, optionally followed by `.worker`.

GPU batches adapt to a 50 ms budget. The automatically selected RTX PRO 6000
Blackwell Server Edition and H100 80GB HBM3 profiles allow up to 67,108,864 nonces;
other profiles retain the 16,777,216-nonce ceiling. A100 SXM4 80 GB and CMP 170HX each
select their own measured kernel schedule. Selection uses the exact model, CUDA architecture and SM count.
`QUANTUS_BATCH` sets a lower ceiling when needed. `QUANTUS_SUBMIT_RESULT=1` adds the 64-byte hash
for gateways that require it; the default submits the full nonce without a result field.
Normal production and HiveOS builds include `quantus-gpu`; CPU-only development builds
can enable `quantus`. AMD and GTX 1080 Ti/Pascal use the Quantus OpenCL variant,
built with `./build.sh -prod -quantus-opencl-only`. It uses the installed vendor
OpenCL driver and requires no CUDA libraries. Device indices in that variant are
OpenCL indices; it selects OpenCL automatically, with `--opencl` available explicitly.
The same `--quantus-test -d 0` check works on both variants. Both embed encrypted
device code. See the [download and pool setup instructions](docs/QUANTUS_GETTING_STARTED.md)
and [protocol and hash details](docs/QUANTUS_INTEGRATION.md).

## NOID (Parano1d) and TAPE (Retro Boomer)

NOID uses the Poseidon2b proof-of-work over GF(2¹²⁸). suprminer mines it with native
CUDA kernels for Ampere, Ada, Hopper and Blackwell and needs **no developer fee**.

```bash
# TAPE / Retro Boomer
./suprminer-neptune -a noid -o stratum+tcp://tape.suprnova.cc:3351 -u YOUR_TAPE_ADDRESS.rig1 -p x --no-cpu

# NOID plain stratum (ports 3337-3340)
./suprminer-neptune -a noid \
  -o stratum+tcp://noid.suprnova.cc:3337 \
  -u o1yournoidaddress....rig01

# TLS (port 3341)
./suprminer-neptune -a noid \
  -o stratum+ssl://noid.suprnova.cc:3341 \
  -u o1yournoidaddress....rig01

# pick specific GPUs
./suprminer-neptune -a noid -o stratum+tcp://noid.suprnova.cc:3337 \
  -u o1yournoidaddress....rig01 --devices 0,1
```

The username is your **bech32m NOID address** (`o1...`), optionally followed by `.workername`.
No password is required — leave `-p` unset. A static difficulty can be requested with
`-p d=<number>`; otherwise the pool applies VarDiff automatically.

**Requirements**

| | |
|---|---|
| GPU | NVIDIA RTX 30xx/40xx/50xx, A100/H100 and CMP 170HX; experimental GTX 16xx/RTX 20xx support |
| Driver | 610.x or newer |
| CUDA (build only) | 13.3 or newer — earlier `ptxas` cannot assemble the `clmad` instruction |

Version 1.9.35 reduces NOID/TAPE CPU overhead while GPU mining, including when
`--no-cpu` is set. This helps rigs where several GPUs share a small CPU.

GTX 16xx and RTX 20xx (`sm_75`, Turing) support is experimental. Arithmetic,
target handling and nonce recovery were checked using Turing-targeted code on
a newer GPU. A physical GTX 1660 Super was unavailable for validation, so no
Turing hashrate or hardware compatibility result is claimed.

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

Pool endpoints: `noid.suprnova.cc:3337` … `:3340` (plain), `:3341` (TLS).

## Common flags

```
-a, --algo <ALGO>          algorithm (table above)
-o, --url <URL>            pool, stratum+tcp://host:port
-u, --user <USER>          wallet or account (append .worker for a worker name)
-p, --pass <PASS>          pool password (default: x)
-d, --devices <LIST>       GPU selection, comma-separated (0,1,2); default = all
-i, --intensity <18-28>    batch size = 2^intensity
    --core-clock <MHZ,..>  lock core clocks, per device index
    --mem-clock <MHZ,..>   lock memory clocks, per device index
    --power-limit <W,..>   set power limits (needs root; restored on exit)
    --fan-speed <PCT,..>   set fan speeds (0 = leave untouched; restored on exit)
    --api-port <PORT>      HTTP stats API, HiveOS-compatible (default 4068)
    --sha3t-test           sha3t GPU-vs-CPU byte-exact self-test, then exit
    --test-vectors         verify hashes against pool implementations
```

Device numbering follows CUDA's "fastest first" order by default — export
`CUDA_DEVICE_ORDER=PCI_BUS_ID` to make `-d` match `nvidia-smi` indices.

Algorithm tuning is available through environment variables (e.g. `PEARL_*` for PearlHash);
these are documented in the per-algorithm docs under `docs/`.

PRL proof submissions use gzip before base64 whenever compression reduces the payload size.
The pool must support automatic gzip detection in `plain_proof`. Set `PEARL_PROOF_GZIP=0`
to send raw base64 proofs to older pools. Submission logs show the encoding and byte savings.

## Building

Always build through the script (never raw cargo):

```bash
./build.sh -prod -sha3t        # release build: all archs, packed, PearlHash + sha3t
./build.sh -no-pearl -sha3t    # sha3t-only, faster build
./build-hiveos.sh              # HiveOS/mmpOS packages (Docker cross-compile, glibc 2.31)
scripts/build-linux-portable.sh <target-dir> -prod  # generic Linux release binary (Ubuntu 20.04 container: glibc 2.31, static libstdc++)
```

Requires CUDA 12.9+ (13.x preferred); Pascal support requires a CUDA 12.x toolchain plus the
opt-in `SUPRMINER_SHA3T_PASCAL=1` (sha3t only).

## Docker (octa.space / any NVIDIA docker host)

An env-driven image is published as
[`ocminersupr/suprminer-base`](https://hub.docker.com/r/ocminersupr/suprminer-base):

```bash
docker run -d --gpus all --restart unless-stopped \
  -e COIN=PRL -e USERNAME=<wallet> -e WORKER=rig1 \
  ocminersupr/suprminer-base:latest
```

`COIN=PRL|NOID|BC3|QUANTUS` selects the algorithm and Suprnova pool automatically; other settings are configurable
via env (`ALGO`, `POOL_URL`, `DEVICES`, `POWER_LIMIT`, `EXTRA_ARGS`, …). See
[`docker/octa/README.md`](docker/octa/README.md) for the full contract.

## HiveOS / mmpOS

Release tarballs include HiveOS custom-miner packages (`_u2004`/`_u2204`) and an mmpOS
package — see the release assets and `hiveos/` in this repo. Stats API on `:4068`.
