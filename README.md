# Suprminer

A multi-algorithm miner for NVIDIA GPUs, with separate Quantus OpenCL packages
for AMD and NVIDIA devices, plus an AMD Vulkan package.

## Suprminer 1.9.27

This release speeds up Quantus on NVIDIA RTX 40-series (Ada) GPUs with a rescheduled
protected Ada kernel. All other kernels, PRL, NOID and PRL + NOCK merged mining are
unchanged from 1.9.26; the bundled helper is unchanged.

[Download 1.9.27](https://github.com/ocminer/suprminer/releases/tag/v1.9.27) ·
[Release notes](https://github.com/ocminer/suprminer/releases/tag/v1.9.27) ·
[Merged mining](MERGED_MINING.md) · [PRL and NOID](docs/PRL_NOID_RELEASE_GUIDE.md) ·
[Quantus](docs/QUANTUS_RELEASE_GUIDE.md) · [Docker and cloud hosting](docker/README.md)

## Choose a download

| Platform | Package |
|---|---|
| Linux NVIDIA, Ubuntu 24.04+ | Complete `suprminer-1.9.27-linux-x86_64.tar.gz` bundle |
| Linux NVIDIA, Ubuntu 20.04 / 22.04 | Matching `linux-x86_64-u2004` / `u2204` executable; helper is also available separately |
| Linux AMD, Ubuntu 24.04+, Quantus | Optional `quantus-vulkan-linux-x86_64` executable; add `--vulkan` |
| Windows NVIDIA | Native `windows-x86_64-nvidia.zip` |
| Windows AMD / Pascal Quantus | Native `windows-x86_64-quantus-opencl.zip` |
| HiveOS | NVIDIA or OpenCL `_u2004.tar.gz` / `_u2204.tar.gz` custom package |
| mmPOS | NVIDIA or OpenCL `mmpos_1.9.27` external-miner package |
| SMOS | NVIDIA or OpenCL `smos-…-u2004.zip` / `u2204.zip` custom package |
| Docker, Octa.Space, Vast.ai | `ocminersupr/suprminer-base:1.9.27` |

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

# Quantus
./suprminer-neptune -a quantus -o stratum+ssl://quantus.suprnova.cc:7074 -u YOUR_QUANTUS_ADDRESS.rig1 -p x
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
| `noid` | `parano1d`, `poseidon2b` | NOID / Parano1d — Poseidon2b over GF(2¹²⁸) | NVIDIA sm_80 / sm_86 / sm_120 (RTX 30xx, CMP 170HX, RTX 50xx) |

Algorithm support depends on the selected backend and GPU. The PRL/NOID guide
lists their requirements. Saved GPU profiles are selected automatically.

## Mining operating systems

Use the NVIDIA HiveOS, mmPOS or SMOS package for PRL/NOID. Configure the algorithm,
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
  ocminersupr/suprminer-base:1.9.27
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
