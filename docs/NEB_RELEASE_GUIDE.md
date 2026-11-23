# NEB with Suprminer 1.9.57

NEB (Neural Engine Byte) is proof-of-training: every mining attempt is one exact
integer training step of a small neural network on 16 samples of the chain's
dataset. Suprminer mines NEB on NVIDIA CUDA and AMD OpenCL GPUs with the algorithm name `neb`.
Suprminer 1.9.57 supports **NEB 1.0.1 mainnet**, using nebhash v2 KEP1
convolutional networks in both slots. The command remains `-a neb`.

Mainnet launched on **18 November 2026 at 14:00 UTC**. Slot **0 is Kepler**
(even heights); slot **1 is TESS** (odd heights). Both `set_model` and `notify`
must use these native indices. Both models have 13,000 packed weight bytes.
The former 2/3 mapping and RET2 models are rejected. Models and cached forward
passes remain separate for the two datasets, even though their architecture
is the same. Every model's weight hash and size are checked.

**1.9.43 and earlier are incompatible with NEB 1.0.1.** Its new genesis is
`da2f5af7bb4c5e2bcc8d558b2f4f01d4c88557a943e6cff9cd035638fe9439ae`.
The miner follows the pool's supplied model, index and timestamp, including
shifted timestamps on private rehearsal chains.

Download the archive for your operating system from the
[1.9.57 release page](https://github.com/ocminer/suprminer/releases/tag/v1.9.57):
Linux, Windows, HiveOS (Ubuntu 20.04 or 22.04 base), mmpOS or SMOS. Each archive
holds two builds: `suprminer-neptune` for NVIDIA cards and `suprminer-neptune-amd`
(OpenCL) for AMD cards (`miner` and `miner-amd` in the SMOS archive). Both mine NEB
with the same options. On Windows start `start-neb.bat` (NVIDIA) or
`start-neb-amd.bat` (AMD). The HiveOS and mmpOS launchers start the AMD build on a
rig without an NVIDIA card; `--amd` or `--nvidia` in the extra arguments forces one.

## Supported GPUs

| GPU | Kernel |
|---|---|
| AMD RX 7600 XT / RX 7900 XTX | exact INT8 WMMA OpenCL kernel |
| AMD MI50 | exact portable integer OpenCL kernel |
| Other OpenCL GPUs | portable integer fallback; not yet hardware-qualified |
| NVIDIA compute capability 7.5 and newer (GTX 16xx, RTX 20/30/40/50 series, A100/H100 and compatible datacenter GPUs) | exact integer KEP1 CUDA kernel |
| NVIDIA Tesla V100 (compute capability 7.0), Linux packages | exact integer KEP1 CUDA kernel (from 1.9.54) |

Use a current NVIDIA driver (610 or newer recommended), or an AMD driver with a working OpenCL ICD. At startup, each GPU
checks complete tickets against the CPU reference for both datasets. New
job headers are checked before mining, and every found share is recomputed on
the CPU before submission. A mismatch stops that GPU.

Both slots use KEP1 but have different samples and model weights. Compare rates
with the same model, dataset and settings. Old RET2 rates are not TESS rates.
GPU waits sleep or use blocking events, with two queued batches to keep CPU use low.
AMD telemetry is read-only on Linux; unavailable Windows AMD hardware telemetry is left blank.

## Dataset file

Suprminer 1.9.57 requires the **NEB 1.0.1** `neb-datasets.bin`: **16,087,037
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

For an encrypted connection with certificate and hostname verification:

```sh
./suprminer-neptune -a neb -o stratum+ssl://neb.suprnova.cc:7806 -u YOUR_NEB_ADDRESS.rig01 -p x
```

| Region | TLS PPLNS | TLS solo |
|---|---|---|
| Europe | `stratum+ssl://neb.suprnova.cc:7806` | `stratum+ssl://neb.suprnova.cc:7807` |
| Asia | `stratum+ssl://stratum-apac.suprnova.cc:7806` | `stratum+ssl://stratum-apac.suprnova.cc:7807` |

Use `stratum+tcp://` for an unencrypted port and `stratum+ssl://` for an encrypted
port. TLS certificate or hostname errors fail the connection; the miner does not
silently downgrade it to plaintext. These URLs work with the CUDA and OpenCL
packages and the same pool option in Windows, HiveOS, mmpOS, SMOS and Docker.

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
| Installation URL | the `_u2004.tar.gz` / `_u2204.tar.gz` package matching your base (NVIDIA and AMD in one package) |
| Hash algorithm | `neb` |
| Wallet and worker template | `YOUR_NEB_ADDRESS.%WORKER_NAME%` |
| Pool URL | `stratum+tcp://neb.suprnova.cc:7804` |
| Pass | `x` |

The dataset is downloaded into the miner directory on the first start.

## mmpOS and SMOS

Use the NVIDIA or AMD OpenCL package, algorithm `neb`, pool `stratum+tcp://neb.suprnova.cc:7804`,
user `YOUR_NEB_ADDRESS.rig01` and password `x`.

## Docker, Octa.Space and Vast.ai

```sh
docker run -d --name suprminer-neb --gpus all --restart unless-stopped \
  -e COIN=NEB -e USERNAME=YOUR_NEB_ADDRESS -e WORKER=rig01 \
  -e PASSWORD=x -e STARTUP_SCRIPT_URL= \
  ocminersupr/suprminer-base:1.9.57
```

`COIN=NEB` selects `neb.suprnova.cc:7804`.

## Options

| Option | Meaning |
|---|---|
| `--neb-kernel auto\|reference` | automatic per-card kernel or portable reference; CUDA also accepts `k0` |
| `--neb-dataset PATH` | dataset file |
| `--neb-test` | compares GPU results with the CPU reference on both datasets, then benchmarks and exits |
| `--api --api-port 4068` | HiveOS/mmpOS-compatible statistics, including the current share difficulty |

## Licenses

The NEB reference and GPU code is adapted from NEB v0.3.0 (Apache License 2.0).
The dataset file is redistributed unmodified; it contains data derived from the
NASA Exoplanet Archive (Kepler) and Astronet-Triage-v2 (TESS, Tey et al. 2023, CC BY 4.0). See
`THIRD_PARTY_NOTICES` and `licenses/`.

## Mainnet qualification

On the same trained Kepler model, v1.9.57 improved Linux throughput by 40–42% on the tested desktop RTX 3070, 5080 and 5090. The GPU and the current model determine the rate. [1.9.57 benchmark data](benchmarks/neb-1.9.57-fleet.md)

Suprminer checks each supplied model and verifies found shares on the CPU before submission. The 1.9.56 Linux benchmarks cover two desktop RTX 3070s and two RTX 5090s using captured Kepler and TESS models. The results include rates for each slot and the overall throughput through a sequence of model changes. [1.9.56 benchmark data](benchmarks/neb-1.9.56-fleet.md)

Earlier Linux OpenCL tests covered the RX 7600 XT, RX 7900 XTX and MI50. The report lists driver versions and test conditions. [AMD OpenCL measurements](NEB_OPENCL.md)

## AMD Docker

The `1.9.57-amd` tag (moving alias `amd`) includes the AMD OpenCL runtime,
NEB dataset and the same executable as the portable AMD package. The host
needs the `amdgpu` kernel driver; the image does not install a host driver.
NEB uses OpenCL; the container does not include a Vulkan NEB backend.

```sh
docker run --rm --device=/dev/kfd --device=/dev/dri \
  -e COIN=NEB -e USERNAME=YOUR_NEB_ADDRESS -e WORKER=rig01 \
  -e PASSWORD=x -e STARTUP_SCRIPT_URL= \
  ocminersupr/suprminer-base:1.9.57-amd
```

Use `DEVICES=0,2` to select OpenCL ordinals. Check device enumeration before
mining on a mixed rig. GPU clocks and power settings are not changed.

## Windows quick start

The combined Windows archive includes `start-neb.bat` for NVIDIA and
`start-neb-amd.bat` for AMD. Replace
`YOUR_NEB_WALLET_ADDRESS` with your address, then double-click the file. It uses
`neb.suprnova.cc:7804` and your computer name as the worker. Edit the pool or
worker fields if desired. The launcher refuses to run with the placeholder.

## NEB changes in 1.9.56

Desktop RTX 3070 and RTX 5090 cards mine faster on the trained Kepler and TESS models we tested. The NVIDIA startup display shows available clock and fan readings. A rate sample spanning both models is labelled as mixed. Shutdown gives completed shares time to reach the pool. [Measured rates and test conditions](benchmarks/neb-1.9.56-fleet.md)

### Early model delivery

TESS preparation is enabled by default when the pool provides early models.
Kepler preparation is disabled by default because a net speed gain has not been
established. Set `NEB_PREPARE_KEPLER=1` to opt in; the per-model disable flag
still takes precedence. `NEB_PREPARE_AHEAD=0` disables all background preparation
as an environment alternative to the global CLI flag. Pools without early
models continue normal mining.

Supporting pools can provide early model updates. Suprminer validates them and
continues normal mining if an update is missing or changes. Benefits depend on
model changes and pool timing; pools without this feature work as before.

Prediction controls are regular command-line options on NVIDIA and AMD:

| Option | Effect |
|---|---|
| `--disable-neb-predictions` | Disable all predicted-model preparation. Overrides both per-model settings. |
| `--disable-neb-tess-predictions` | Disable preparation of a predicted TESS model. |
| `--disable-neb-kepler-predictions` | Disable preparation of a predicted Kepler model. |

The per-model names refer to the model being prepared, regardless of which
model is currently being mined. These options preserve normal mining and the
model cache: the pool may send a model once, ahead of the job that needs it.
They do not tell the pool to stop sending model messages.

Append the option to the miner command on Linux or to the command in the
Windows `.bat` launcher. In HiveOS put it in **Extra config arguments**.
For Docker pass `-e EXTRA_ARGS="--disable-neb-predictions"`, or one of the
per-model options. Both per-model options may be supplied together.
