# NEB with Suprminer 1.9.41

NEB (Neural Engine Byte) is proof-of-training: every mining attempt is one exact
integer training step of a small neural network on 16 samples of the chain's
dataset. Suprminer mines NEB on NVIDIA GPUs with the algorithm name `neb`.
Suprminer 1.9.41 supports **NEB v0.3.0 only**: KEP1 and RET2 convolutional
networks (nebhash v2). It replaces the old NEB algorithm; the product remains
Suprminer and the command is still `-a neb`.

On the public NEB network, KEP1 starts at block **8800**, followed by RET2 at
**8801**. Use the previous Suprminer release for pre-fork mining, and switch to
1.9.41 when your pool starts sending the new jobs. This version reports old jobs
as unsupported and waits for compatible work. Height determines activation;
the miner follows the dataset index sent by the pool, including on private chains.

Download the NVIDIA package for your operating system from the
[1.9.41 release page](https://github.com/ocminer/suprminer/releases/tag/v1.9.41).
The full NVIDIA Linux packages (`u2004` and `u2204`), the NVIDIA Windows package
and the Docker image include NEB. The Quantus-only OpenCL and Vulkan packages do not.

## Supported GPUs

| GPU | Kernel |
|---|---|
| NVIDIA compute capability 7.5 and newer (GTX 16xx, RTX 20/30/40/50 series, A100/H100 and compatible datacenter GPUs) | exact integer KEP1/RET2 CUDA kernel |

Use a current NVIDIA driver (610 or newer recommended). At startup, each GPU
checks complete tickets against the CPU reference for both architectures. New
job headers are checked before mining, and every found share is recomputed on
the CPU before submission. A mismatch stops that GPU.

The new convolutional networks do substantially more work per attempt than the
old network. Their kH/s figures must not be compared with pre-fork MH/s figures.
GPU waits use blocking events and two queued batches to keep CPU use low.

## Dataset file

NEB needs the chain's training data, `neb-datasets.bin` (259.9 MB). The miner looks
for it in the working directory and next to the executable. When it is missing,
the miner downloads it automatically over HTTPS from the NEB release (with the
Suprminer release as a mirror), checks its BLAKE3 hash
`296a174edbf67339fa0af341f063154292bba224b3d2cacf5b18b31c70da80eb` and saves it
next to the executable. The old 37.6 MB file cannot be used. An explicitly
selected `--neb-dataset` file must already contain the new data. No `curl` or
`wget` is needed. The Docker image already
contains the file.

- Use `--neb-dataset PATH` to choose a file.
- Set `NEB_DATASET_URL=<url>` to try your own mirror first.
- Set `NEB_NO_DOWNLOAD=1` to disable the download.

Without internet access, download
`https://github.com/SilasEigen/neb/releases/download/v0.3.0/neb-datasets.bin`
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
  ocminersupr/suprminer-base:1.9.41
```

`COIN=NEB` selects `neb.suprnova.cc:7804`.

## Options

| Option | Meaning |
|---|---|
| `--neb-kernel auto\|reference` | KEP1/RET2 CUDA kernel (`k0` is also accepted); old tensor-kernel overrides are unsupported |
| `--neb-dataset PATH` | dataset file |
| `--neb-test` | compares GPU results with the CPU reference on both datasets, then benchmarks and exits |
| `--api --api-port 4068` | HiveOS/mmpOS-compatible statistics, including the current share difficulty |

## Licenses

The NEB reference and GPU code is adapted from NEB v0.3.0 (Apache License 2.0).
The dataset file is redistributed unmodified; it contains data derived from the
NASA Exoplanet Archive (Kepler) and OCTMNIST (MedMNIST v2 / MedMNIST+, CC BY 4.0). See
`THIRD_PARTY_NOTICES` and `licenses/`.
