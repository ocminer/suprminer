# NEB with Suprminer 1.9.44

NEB (Neural Engine Byte) is proof-of-training: every mining attempt is one exact
integer training step of a small neural network on 16 samples of the chain's
dataset. Suprminer mines NEB on NVIDIA GPUs with the algorithm name `neb`.
Suprminer 1.9.44 supports **NEB 1.0.1 mainnet**, using nebhash v2 KEP1
convolutional networks in both slots. The command remains `-a neb`.

Mainnet starts on **18 November 2026 at 14:00 UTC**. Slot **0 is Kepler**
(even heights); slot **1 is TESS** (odd heights). Both `set_model` and `notify`
must use these native indices. Both models have 13,000 packed weight bytes.
The former 2/3 mapping and RET2 models are rejected. Models and cached forward
passes remain separate for the two datasets, even though their architecture
is the same. Every model's weight hash and size are checked.

**1.9.43 and earlier are incompatible with NEB 1.0.1.** Its new genesis is
`da2f5af7bb4c5e2bcc8d558b2f4f01d4c88557a943e6cff9cd035638fe9439ae`.
The miner follows the pool's supplied model, index and timestamp, including
shifted timestamps on private rehearsal chains.

Download the NVIDIA package for your operating system from the
[1.9.44 release page](https://github.com/ocminer/suprminer/releases/tag/v1.9.44).
The full NVIDIA Linux packages (`u2004` and `u2204`), the NVIDIA Windows package
and the Docker image include NEB. The Quantus-only OpenCL and Vulkan packages do not.

## Supported GPUs

| GPU | Kernel |
|---|---|
| NVIDIA compute capability 7.5 and newer (GTX 16xx, RTX 20/30/40/50 series, A100/H100 and compatible datacenter GPUs) | exact integer KEP1 CUDA kernel |

Use a current NVIDIA driver (610 or newer recommended). At startup, each GPU
checks complete tickets against the CPU reference for both datasets. New
job headers are checked before mining, and every found share is recomputed on
the CPU before submission. A mismatch stops that GPU.

Both slots use KEP1 but have different samples and model weights. Compare rates
with the same model, dataset and settings. Old RET2 rates are not TESS rates.
GPU waits use blocking events and two queued batches to keep CPU use low.

## Dataset file

Suprminer 1.9.44 requires the **NEB 1.0.1** `neb-datasets.bin`: **16,087,037
bytes**, with 13,404 Kepler samples and 7,089 TESS samples. Its BLAKE3 hash is
`790b57fbd830f3dcbe7de9d1146aa89a0a20799118e30dd48a343a5c98f19e72`.

The miner looks in the working directory and next to the executable, then
downloads a verified copy over HTTPS if necessary. Recognized NEB 1.0.0 and
v0.3.0 caches are automatically upgraded, including at an explicit
`--neb-dataset` path. An unknown explicit file is preserved and rejected with
an error. `NEB_NO_DOWNLOAD=1` disables upgrades as well as downloads.
No `curl` or `wget` is needed. Docker includes the new dataset.

- Use `--neb-dataset PATH` to choose a file.
- Set `NEB_DATASET_URL=<url>` to try your own mirror first.
- Set `NEB_NO_DOWNLOAD=1` to disable the download.

Without internet access, download
`https://github.com/SilasEigen/neb/releases/download/v1.0.1/neb-datasets.bin`
on another computer and copy it next to the miner. A file with a different hash
is never used.

## Pool

Use port `7804` (variable difficulty for GPUs):

```sh
./suprminer-neptune -a neb -o stratum+tcp://neb.suprnova.cc:7804 -u YOUR_NEB_ADDRESS.rig01 -p x
```

Select GPUs with `-d 0,1`. The miner starts with a short benchmark and asks the
pool for a matching share difficulty.

## Windows

```bat
suprminer-neptune.exe -a neb -o stratum+tcp://neb.suprnova.cc:7804 -u YOUR_NEB_ADDRESS.rig01 -p x
```

Extract the whole archive into one writable folder, so the dataset can be saved
next to the executable. CUDA submissions are flushed before the host waits,
including under Windows WDDM and WSL2. Windows GPU mining has not been tested
on physical hardware for this release.

## HiveOS

Create a flight sheet with a custom miner:

| Field | Value |
|---|---|
| Miner name | `suprminer-neptune` |
| Installation URL | the `_u2004.tar.gz` or `_u2204.tar.gz` package matching your HiveOS base |
| Hash algorithm | `neb` |
| Wallet and worker template | `YOUR_NEB_ADDRESS.%WORKER_NAME%` |
| Pool URL | `stratum+tcp://neb.suprnova.cc:7804` |
| Pass | `x` |

The dataset is downloaded into the miner directory on the first start.

## mmpOS and SMOS

Use the NVIDIA package, algorithm `neb`, pool `stratum+tcp://neb.suprnova.cc:7804`,
user `YOUR_NEB_ADDRESS.rig01` and password `x`.

## Docker, Octa.Space and Vast.ai

```sh
docker run -d --name suprminer-neb --gpus all --restart unless-stopped \
  -e COIN=NEB -e USERNAME=YOUR_NEB_ADDRESS -e WORKER=rig01 \
  -e PASSWORD=x -e STARTUP_SCRIPT_URL= \
  ocminersupr/suprminer-base:1.9.44
```

`COIN=NEB` selects `neb.suprnova.cc:7804`.

## Options

| Option | Meaning |
|---|---|
| `--neb-kernel auto\|reference` | KEP1 CUDA kernel (`k0` is also accepted); old tensor-kernel overrides are unsupported |
| `--neb-dataset PATH` | dataset file |
| `--neb-test` | compares GPU results with the CPU reference on both datasets, then benchmarks and exits |
| `--api --api-port 4068` | HiveOS/mmpOS-compatible statistics, including the current share difficulty |

## Licenses

The NEB reference and GPU code is adapted from NEB v0.3.0 (Apache License 2.0).
The dataset file is redistributed unmodified; it contains data derived from the
NASA Exoplanet Archive (Kepler) and Astronet-Triage-v2 (TESS, Tey et al. 2023, CC BY 4.0). See
`THIRD_PARTY_NOTICES` and `licenses/`.

## Mainnet development qualification

This release accepts only the pinned NEB 1.0.1 dataset and native indices 0/1. The RTX 5090 selects the measured vector
write and integer reduction kernels; other device names retain the existing
entry points. Startup logs identify the RTX5090 path. For controlled regression
tests, `NEB_DISABLE_5090_TUNING=1` selects the preserved kernels. It does not
change clocks, power, models or consensus arithmetic.

Use CUDA 13.3 for NEB device compilation, including when a platform requires an
older host toolchain (`NEB_NVCC`). The measured gains must not be attributed to
CUDA 12.9 device code. Native Linux and HiveOS executables passed full reference checks on both
datasets, including forced PTX and preserved fallback paths. The final Linux
executable also passed a live private-chain test against NEB 1.0.1. Windows
GPU execution was not tested on physical hardware. The README distinguishes
fresh 1.0.1 measurements from the historical fleet reference table.
