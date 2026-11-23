# Mine Quantus with Suprminer 1.9.57

Mine Quantus on Suprnova with NVIDIA or AMD GPUs. Use a Quantus wallet address and a
worker name of your choice. The algorithm setting is `quantus` (Poseidon2 Goldilocks).

[Download Suprminer 1.9.57](https://github.com/ocminer/suprminer/releases/tag/v1.9.57)

## Linux

Download `suprminer-<version>-linux-x86_64.tar.gz` from the release page (Ubuntu 20.04 or newer) and
unpack it. It holds two builds:

| GPU | Program |
| --- | --- |
| NVIDIA RTX 20/30/40/50 series | `suprminer-neptune` |
| AMD or NVIDIA GTX 10 series (OpenCL) | `suprminer-neptune-amd` |

Install the GPU vendor's Linux driver; the OpenCL download also needs the vendor's OpenCL
runtime. Unpack the archive and start the program for your cards (the examples use the NVIDIA name):

```bash
chmod +x suprminer-neptune
```

Replace `YOUR_QUANTUS_ADDRESS` with your wallet address and `rig01` with your worker name:

```bash
./suprminer-neptune -a quantus -o stratum+tcp://quantus.suprnova.cc:7071 -u YOUR_QUANTUS_ADDRESS.rig01 -p x
```

For an encrypted connection:

```bash
./suprminer-neptune -a quantus -o stratum+ssl://quantus.suprnova.cc:7074 -u YOUR_QUANTUS_ADDRESS.rig01 -p x
```

The miner uses all available GPUs by default. Add `-d 0` for the first GPU or `-d 0,1`
for two selected GPUs. OpenCL builds use OpenCL device indices. Stop with `Ctrl+C`.

## HiveOS

Create a flight sheet, choose **Custom miner**, and enter:

| Field | Value |
| --- | --- |
| Miner name | `suprminer-neptune` |
| Hash algorithm | `quantus` |
| Wallet and worker template | `%WAL%.%WORKER_NAME%` |
| Pool URL | `stratum+tcp://quantus.suprnova.cc:7071` |
| Password | `x` |
| Extra configuration | Optional, for example `-d 0,1` |

Use the installation URL matching your HiveOS base. The package holds the NVIDIA and the AMD (OpenCL)
build; on a rig without an NVIDIA card the AMD build starts. For GTX 10 series cards add `--opencl` to the
extra configuration.

| Platform | Installation URL |
| --- | --- |
| Ubuntu 20.04 | [Installation URL](https://github.com/ocminer/suprminer/releases/download/v1.9.57/suprminer-neptune-1.9.57_u2004.tar.gz) |
| Ubuntu 22.04 | [Installation URL](https://github.com/ocminer/suprminer/releases/download/v1.9.57/suprminer-neptune-1.9.57_u2204.tar.gz) |

For TLS, change the pool URL to `stratum+ssl://quantus.suprnova.cc:7074`.

## mmPOS

Add an external miner using the
[mmpOS package](https://github.com/ocminer/suprminer/releases/download/v1.9.57/suprminer-neptune-mmpos_1.9.57.tar.gz).
It holds the NVIDIA and the AMD (OpenCL) build; without an NVIDIA card the AMD build starts, and `--opencl`
among the arguments selects it for GTX 10 series cards.

Set algorithm `quantus`, pool `stratum+tcp://quantus.suprnova.cc:7071`, user
`YOUR_QUANTUS_ADDRESS.rig01`, and password `x`. TLS uses
`stratum+ssl://quantus.suprnova.cc:7074`.

## Docker and Octa.Space

Use `ocminersupr/suprminer-base` on a host with an NVIDIA GPU, a working NVIDIA
driver, and the NVIDIA Container Toolkit. The examples below pin the
`1.9.57` image so a container restart does not unexpectedly change miner versions.

### Start mining on Suprnova

Create a file named `quantus.env`. Replace `YOUR_QUANTUS_WALLET_ADDRESS` with your
own Quantus payout address and choose a worker name for this machine:

```dotenv
COIN=QUANTUS
ALGO=quantus
POOL_URL=stratum+tcp://quantus.suprnova.cc:7071
USERNAME=YOUR_QUANTUS_WALLET_ADDRESS
WORKER=octa-rig-01
PASSWORD=x
```

Start the container:

```bash
docker run -d \
  --name suprminer-quantus \
  --gpus all \
  --restart unless-stopped \
  --env-file quantus.env \
  ocminersupr/suprminer-base:1.9.57
```

The miner connects with `YOUR_QUANTUS_WALLET_ADDRESS.octa-rig-01`. Put the address
alone in `USERNAME` when using `WORKER`; otherwise the worker suffix is appended
twice. Set your own address explicitly: the image's default username is not your
payout address. Mining needs an outbound pool connection and no published Docker
ports.

For TLS, change the pool value to:

```dotenv
POOL_URL=stratum+ssl://quantus.suprnova.cc:7074
```

### Octa.Space and other container hosting panels

Select `ocminersupr/suprminer-base:1.9.57` as the container image and allocate the
NVIDIA GPU or GPUs to the container. Enter each row below as a separate environment
variable. Enter the value directly, without a shell `-e` prefix or surrounding
quotes.

| Variable | Value |
|---|---|
| `COIN` | `QUANTUS` |
| `ALGO` | `quantus` |
| `POOL_URL` | `stratum+tcp://quantus.suprnova.cc:7071` |
| `USERNAME` | Your Quantus payout address |
| `WORKER` | A name for this instance, such as `octa-rig-01` |
| `PASSWORD` | `x` |

Use the image's default startup command. Leave `STARTUP_SCRIPT_URL` empty: setting
it replaces the built-in environment-variable launcher with that script. A hosting
panel that accepts an environment file can use the same `quantus.env` shown above.

### Choose GPUs and optional settings

The default is to mine on all NVIDIA GPUs visible inside the container. To select
GPU indices within the container, add, for example:

```dotenv
DEVICES=0,1
```

Container GPU indices may differ from the host's indices when the hosting platform
exposes only part of a machine. Check the devices available to this container:

```bash
docker exec suprminer-quantus nvidia-smi -L
```

The miner selects its applicable GPU profile automatically. Start with the default
tuning settings before adding overrides.

| Variable | Effect |
|---|---|
| `COIN` | Selects the algorithm and default pool; `QUANTUS` selects Quantus on Suprnova. |
| `ALGO` | Overrides the algorithm selected by `COIN`; use `quantus` here. |
| `POOL_URL` | Overrides the pool selected by `COIN`. Changing `ALGO` alone does not change the pool. |
| `USERNAME` | Payout address or pool account, passed to the miner's `-u` option. |
| `WORKER` | Appended to `USERNAME` with a dot. Leave empty if the username already includes it. |
| `PASSWORD` | Pool password, passed to `-p`; defaults to `x`. |
| `DEVICES` | Comma-separated device indices, passed to `-d`; empty selects all visible devices. |
| `INTENSITY` | Optional miner intensity override, passed to `-i`. |
| `CORE_CLOCK`, `MEM_CLOCK`, `POWER_LIMIT`, `FAN_SPEED` | Optional hardware settings passed to the corresponding miner options. Leave empty to retain existing settings. |
| `EXTRA_ARGS` | Additional space-separated miner arguments. Shell quoting inside this value is not interpreted as a separate command line. |
| `STARTUP_SCRIPT_URL` | Replaces this launcher with a downloaded startup script; leave empty for the examples in this guide. |

### Verify mining and apply changes

Watch the pool connection, reported hashrate, and accepted shares:

```bash
docker logs --tail 100 -f suprminer-quantus
```

The logs should identify the Quantus algorithm and the Suprnova endpoint, show a
nonzero hashrate, and then report accepted shares as work meets the pool target.
A running container alone does not confirm that shares are being accepted.

Stop mining cleanly:

```bash
docker stop -t 30 suprminer-quantus
```

Editing `quantus.env` does not change an existing container's environment. To apply
new values, stop the container, remove that stopped container, and repeat the
`docker run` command above:

```bash
docker rm suprminer-quantus
```

In a hosting panel, apply the equivalent container recreation or redeployment
after changing its environment variables.

## Windows

Extract the entire `windows-x86_64.zip` and keep the included DLLs beside the programs:
`suprminer-neptune.exe` for NVIDIA GPUs, `suprminer-neptune-amd.exe` for AMD/OpenCL.

```powershell
.\suprminer-neptune.exe -a quantus -o stratum+tcp://quantus.suprnova.cc:7071 -u YOUR_QUANTUS_ADDRESS.rig01 -p x
```

These Windows packages pass compilation and CPU protocol tests; mining on
physical Windows GPU hardware has not yet been tested.

## SimpleMining / SMOS

Select **CUSTOM** and enter the SMOS ZIP URL first in Miner OPTIONS,
followed by the miner arguments:

```text
https://github.com/ocminer/suprminer/releases/download/v1.9.57/suprminer-neptune-1.9.57-smos.zip -a quantus -o stratum+tcp://quantus.suprnova.cc:7071 -u YOUR_QUANTUS_ADDRESS.rig01 -p x
```

The ZIP contains a versioned directory with the executable `miner` (NVIDIA) and
`miner-amd` (OpenCL build for AMD cards). It runs on Ubuntu 20.04 and newer bases.
Package layout is checked; mining on an actual SMOS installation remains untested.
