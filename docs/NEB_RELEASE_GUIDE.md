# NEB with Suprminer 1.9.39

NEB (Neural Engine Byte) is proof-of-training: every mining attempt is one exact
integer training step of a small neural network on 16 samples of the chain's
dataset. Suprminer mines NEB on NVIDIA GPUs with the algorithm name `neb`.
NEB version 0.2.1 currently runs a test network.

Download the NVIDIA package for your operating system from the
[1.9.39 release page](https://github.com/ocminer/suprminer/releases/tag/v1.9.39).
The full NVIDIA Linux packages (`u2004` and `u2204`), the NVIDIA Windows package
and the Docker image include NEB. The Quantus-only OpenCL and Vulkan packages do not.

## Supported GPUs

| GPU | Kernel |
|---|---|
| RTX 30xx, 40xx, 50xx, A100/H100, CMP 170HX (compute capability 8.0 or newer) | tensor cores (K1, K1P, K1X, K2 or K3, selected automatically) |
| GTX 16xx and RTX 20xx (compute capability 7.5) | dp4a (K0) |

Use a current NVIDIA driver (610 or newer recommended). Every share the GPU finds
is checked again with the NEB reference code on the CPU before it is submitted.

At start, `auto` checks each tensor-core kernel against the CPU reference on the
card and times the ones that pass; on each new job it times them again on the
job's model and keeps the fastest. A kernel that does not match the reference is
never used.

## Dataset file

NEB needs the chain's training data, `neb-datasets.bin` (37.6 MB). The miner looks
for it in the working directory and next to the executable. When it is missing,
the miner downloads it automatically over HTTPS from the NEB release (with the
Suprminer release as a mirror), checks its BLAKE3 hash
`b1008b970f87083179a7b297b8f0fbec4cfc8cc66f605cf2fb2c03bad8b6f37a` and saves it
next to the executable. No `curl` or `wget` is needed. The Docker image already
contains the file.

- Use `--neb-dataset PATH` to choose a file.
- Set `NEB_DATASET_URL=<url>` to try your own mirror first.
- Set `NEB_NO_DOWNLOAD=1` to disable the download.

Without internet access, download
`https://github.com/SilasEigen/neb/releases/download/v0.2.1/neb-datasets.bin`
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
next to the executable. Since 1.9.38, GPU work is submitted differently on
Windows and WSL2 to address a much lower NEB hashrate reported there with
earlier versions. Windows GPU mining has not been tested on hardware.

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
  ocminersupr/suprminer-base:1.9.39
```

`COIN=NEB` selects `neb.suprnova.cc:7804`.

## Options

| Option | Meaning |
|---|---|
| `--neb-kernel auto\|k0\|k1\|k1p\|k1x\|k2\|k3` | GPU kernel; `auto` picks the fastest verified tensor-core kernel on compute capability 8.0 and newer, K0 below |
| `--neb-dataset PATH` | dataset file |
| `--neb-test` | compares GPU results with the CPU reference on both datasets, then benchmarks and exits |
| `--api --api-port 4068` | HiveOS/mmpOS-compatible statistics, including the current share difficulty |

## Licenses

The NEB reference and GPU code is adapted from NEB v0.2.1 (Apache License 2.0).
The dataset file is redistributed unmodified; it contains data derived from the
NASA Exoplanet Archive (Kepler) and OCTMNIST (MedMNIST v2, CC BY 4.0). See
`THIRD_PARTY_NOTICES` and `licenses/`.
