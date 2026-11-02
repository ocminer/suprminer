# Suprminer

A multi-algorithm miner for NVIDIA GPUs, with separate Quantus OpenCL packages
for AMD and NVIDIA devices, plus an AMD Vulkan package.

## Suprminer 1.9.34

NOID/TAPE uses larger batches at easier share targets to reduce launch overhead,
while retaining complete candidate recovery and CPU share validation. The benefit
is small and depends on share difficulty; see the measured results below.
Linux packages support Ubuntu 20.04 and newer without system C++ or OpenSSL libraries.
The automatic Linux RTX 5090 memory-clock setting from 1.9.33 is retained;
`--no-auto-mem-lock` disables it.

[Download 1.9.34](https://github.com/ocminer/suprminer/releases/tag/v1.9.34) ·
[Release notes](https://github.com/ocminer/suprminer/releases/tag/v1.9.34) ·
[Merged mining](MERGED_MINING.md) · [PRL and NOID](docs/PRL_NOID_RELEASE_GUIDE.md) ·
[Quantus](docs/QUANTUS_RELEASE_GUIDE.md) · [Docker and cloud hosting](docker/README.md)

## TAPE / NOID performance — 1.9.34

Measured on Linux with the full release executables on 2026-11-02. Each version
ran twice for 150 seconds on the same card in A/B/B/A order, with the first
40 seconds of mining excluded. All runs used the same captured TAPE work at a
share target corresponding to 50,000,000 hashes per share. Rates below are measured
from nonce progress, with every submitted share checked against a CPU reference.
Watts and clocks are GPU telemetry averages; watts do not include the rest of the rig.

| GPU | Limit W | 1.9.33 MH/s | 1.9.34 MH/s | GPU W | SM MHz | Memory MHz | MH/s/W |
|---|---:|---:|---:|---:|---:|---:|---:|
| RTX 5090 | 600 | 271.04 | **270.81** | 600.0 | 2610 | 810 | 0.451 |
| RTX 5080 | 360 | 144.77 | **144.68** | 360.0 | 2813 | 14801 | 0.402 |
| RTX 5070 Ti | 300 | 118.69 | **118.66** | 276.7 | 2767 | 13801 | 0.429 |
| RTX 5090 | 420 | 227.05 | **226.24** | 420.0 | 2319 | 810 | 0.539 |

RTX 5090 tests use the existing Linux 810 MHz memory profile, applied equally to
both versions; applying it requires clock-control permissions. The other cards
use automatic stock clocks. No core offsets or
voltage changes were applied. The 600 W row uses the card's maximum supported
power limit. Results depend on card cooling, power settings and pool difficulty.

At the easier target of 4,194,304 hashes per share, a separate matched RTX 5090
600 W test with normal memory clocks measured **266.49 → 268.74 MH/s**
(**+0.84%**). This is a target-dependent reduction in launch overhead;
the normal-difficulty results above remain close to 1.9.33. Small differences
should be read in the context of normal boost and thermal variation.

## Choose a download

| Platform | Package |
|---|---|
| Linux NVIDIA, Ubuntu 20.04+ | Complete `suprminer-1.9.34-linux-x86_64.tar.gz` bundle |
| Linux NVIDIA, Ubuntu 20.04 / 22.04 | Matching `linux-x86_64-u2004` / `u2204` executable; helper is also available separately |
| Linux AMD, Ubuntu 20.04+, Quantus | Optional `quantus-vulkan-linux-x86_64` executable; add `--vulkan` |
| Windows NVIDIA | Native `windows-x86_64-nvidia.zip` |
| Windows AMD / Pascal Quantus | Native `windows-x86_64-quantus-opencl.zip` |
| HiveOS | NVIDIA or OpenCL `_u2004.tar.gz` / `_u2204.tar.gz` custom package |
| mmPOS | NVIDIA or OpenCL `mmpos_1.9.34` external-miner package |
| SMOS | NVIDIA or OpenCL `smos-…-u2004.zip` / `u2204.zip` custom package |
| Docker, Octa.Space, Vast.ai | `ocminersupr/suprminer-base:1.9.34` |

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
| `noid` | `parano1d`, `poseidon2b` | NOID / Parano1d — Poseidon2b over GF(2¹²⁸) | NVIDIA sm_80 / sm_86 / sm_89 / sm_90 / sm_120 (RTX 30xx/40xx/50xx, CMP 170HX, A100/H100) |
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
  ocminersupr/suprminer-base:1.9.34
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
