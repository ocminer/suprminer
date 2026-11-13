# Suprminer

A multi-algorithm miner for NVIDIA GPUs, with separate Quantus OpenCL packages
for AMD and NVIDIA devices, plus an AMD Vulkan package.

## Suprminer 1.9.41 — faster NEB v0.3.0

> [!IMPORTANT]
> **For NEB, start using 1.9.41 when your pool activates the v0.3.0 fork.**
> KEP1 starts at block **8800** and RET2 at block **8801**; activation follows
> block height, not a fixed time. Until then, keep using **1.9.39** for NEB
> (Docker: `ocminersupr/suprminer-base:1.9.39`). Versions 1.9.40 and 1.9.41 reject
> old NEB jobs. Other supported algorithms can be used immediately.

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

## Suprminer 1.9.40 — NEB v0.3.0 (previous release)


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
| Linux NVIDIA, Ubuntu 20.04+ | Complete `suprminer-1.9.41-linux-x86_64.tar.gz` bundle |
| Linux NVIDIA, Ubuntu 20.04 / 22.04 | Matching `linux-x86_64-u2004` / `u2204` executable; helper is also available separately |
| Linux AMD, Ubuntu 20.04+, Quantus | Optional `quantus-vulkan-linux-x86_64` executable; add `--vulkan` |
| Windows NVIDIA | Native `windows-x86_64-nvidia.zip` |
| Windows AMD / Pascal Quantus | Native `windows-x86_64-quantus-opencl.zip` |
| HiveOS | NVIDIA or OpenCL `_u2004.tar.gz` / `_u2204.tar.gz` custom package |
| mmPOS | NVIDIA or OpenCL `mmpos_1.9.41` external-miner package |
| SMOS | NVIDIA or OpenCL `smos-…-u2004.zip` / `u2204.zip` custom package |
| Docker, Octa.Space, Vast.ai | `ocminersupr/suprminer-base:1.9.41` |

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

# NEB v0.3.0 only — switch when the pool activates the fork
./suprminer-neptune -a neb -o stratum+tcp://neb.suprnova.cc:7804 -u YOUR_NEB_ADDRESS.rig1 -p x
```

On Windows, use `.\suprminer-neptune.exe` in PowerShell. Add `-d 0,1` to select
GPUs. Stop with Ctrl+C. Use `--help` for all supported options.

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
| `noid` | `parano1d`, `poseidon2b` | NOID / Parano1d — Poseidon2b over GF(2¹²⁸) | NVIDIA sm_80 / sm_86 / sm_89 / sm_90 / sm_120; experimental sm_75 (GTX 16xx / RTX 20xx) |
| `npt` | `neptune`, `neptune-cash` | Neptune Cash — HardforkDelta PoW, negotiated suffix search | NVIDIA sm_80+ (RTX 30xx, CMP 170HX, RTX 40xx/50xx, A100/H100, RTX PRO 6000) |
| `neb` | `nebcoin`, `pot` | NEB v0.3.0 — KEP1/RET2 proof-of-training | NVIDIA sm_75+ |

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
  ocminersupr/suprminer-base:1.9.41
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
