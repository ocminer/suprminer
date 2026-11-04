# Suprminer

A multi-algorithm miner for NVIDIA GPUs, with separate Quantus OpenCL packages
for AMD and NVIDIA devices, plus an AMD Vulkan package.

## Suprminer 1.9.35

NOID/TAPE GPU mining now uses substantially less CPU, improving throughput on
CPU-limited rigs while preserving CPU share verification and nonce recovery.
Experimental GTX 16xx / RTX 20xx support is included; physical Turing hardware
has not been tested. See the measurements and limitations below.
Portable Linux packages support Ubuntu 20.04 and newer without system C++ or OpenSSL libraries.
The automatic Linux RTX 5090 memory-clock setting is retained;
`--no-auto-mem-lock` disables it.

[Download 1.9.35](https://github.com/ocminer/suprminer/releases/tag/v1.9.35) ·
[Release notes](https://github.com/ocminer/suprminer/releases/tag/v1.9.35) ·
[Merged mining](MERGED_MINING.md) · [PRL and NOID](docs/PRL_NOID_RELEASE_GUIDE.md) ·
[Quantus](docs/QUANTUS_RELEASE_GUIDE.md) · [Docker and cloud hosting](docker/README.md)

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
| Linux NVIDIA, Ubuntu 20.04+ | Complete `suprminer-1.9.35-linux-x86_64.tar.gz` bundle |
| Linux NVIDIA, Ubuntu 20.04 / 22.04 | Matching `linux-x86_64-u2004` / `u2204` executable; helper is also available separately |
| Linux AMD, Ubuntu 20.04+, Quantus | Optional `quantus-vulkan-linux-x86_64` executable; add `--vulkan` |
| Windows NVIDIA | Native `windows-x86_64-nvidia.zip` |
| Windows AMD / Pascal Quantus | Native `windows-x86_64-quantus-opencl.zip` |
| HiveOS | NVIDIA or OpenCL `_u2004.tar.gz` / `_u2204.tar.gz` custom package |
| mmPOS | NVIDIA or OpenCL `mmpos_1.9.35` external-miner package |
| SMOS | NVIDIA or OpenCL `smos-…-u2004.zip` / `u2204.zip` custom package |
| Docker, Octa.Space, Vast.ai | `ocminersupr/suprminer-base:1.9.35` |

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

Algorithm support depends on the selected backend and GPU. The PRL/NOID guide
lists their requirements. Saved GPU profiles are selected automatically.

## Mining operating systems

Use the NVIDIA HiveOS, mmPOS or SMOS package for PRL/NOID/NPT. Configure the algorithm,
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
  ocminersupr/suprminer-base:1.9.35
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
