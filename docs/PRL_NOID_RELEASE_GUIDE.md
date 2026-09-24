# PRL and NOID with Suprminer 1.9.25

Download the NVIDIA package for your operating system from the
[1.9.25 release page](https://github.com/ocminer/suprminer/releases/tag/v1.9.25).
The Quantus-only OpenCL and Vulkan packages do not include PRL or NOID.
Both full NVIDIA Linux packages (`u2004` and `u2204`) include PRL and NOID,
as do the NVIDIA Windows and Docker packages.
Use your own wallet address in place of the placeholders below.

## Linux

For the standalone Linux download, rename the downloaded file to
`suprminer-neptune` before running the commands below.

```bash
chmod +x suprminer-neptune
./suprminer-neptune -a pearl -o stratum+tcp://prl.suprnova.cc:3373 \
  -u YOUR_PRL_ADDRESS.worker -p x --no-cpu
```

For NOID, use a NOID address beginning with `o1`:

```bash
./suprminer-neptune -a noid -o stratum+tcp://noid.suprnova.cc:3337 \
  -u YOUR_NOID_ADDRESS.worker -p x --no-cpu
```

Add `-d 0,1` to select specific GPUs. Without `-d`, the miner uses the available
devices. Supported GPU settings are selected automatically. A100 80GB cards
automatically select their PRL profile; no tuning environment variables are needed.
NOID requires an Ampere or newer supported NVIDIA GPU. CMP170HX, RTX 30xx and
RTX 50xx cards are supported. Use a current NVIDIA driver suitable for the GPU.

## Windows

Extract the NVIDIA ZIP and run these commands in PowerShell from its directory:

```powershell
.\suprminer-neptune.exe -a pearl -o stratum+tcp://prl.suprnova.cc:3373 -u YOUR_PRL_ADDRESS.worker -p x --no-cpu
.\suprminer-neptune.exe -a noid -o stratum+tcp://noid.suprnova.cc:3337 -u YOUR_NOID_ADDRESS.worker -p x --no-cpu
```

Run one command for the algorithm you want. Add `-d 0,1` to select GPUs.

## HiveOS, mmPOS and SMOS

Choose the NVIDIA package matching the mining OS base: `u2004` for Ubuntu 20.04
or `u2204` for Ubuntu 22.04. Import its custom-miner archive or ZIP using that
platform's custom miner settings.

| Setting | PRL | NOID |
|---|---|---|
| Algorithm | `pearl` | `noid` |
| Pool | `stratum+tcp://prl.suprnova.cc:3373` | `stratum+tcp://noid.suprnova.cc:3337` |
| User | `YOUR_PRL_ADDRESS.worker` | `YOUR_NOID_ADDRESS.worker` |
| Password | `x` | `x` |

Keep any existing device selection or power settings you intend to use. After
starting, confirm that every selected GPU reports a hashrate and accepted shares.
The NOID statistics API reports per-GPU rates, accepted/rejected shares and GPU
telemetry. For standalone mining, enable it with `--api --api-port 4068` and read
`http://localhost:4068/summary`.

## Docker, Octa.Space and Vast.ai

Use `ocminersupr/suprminer-base:1.9.25` to pin this version. The `latest` tag follows
new releases.
Docker requires NVIDIA GPU access on the host.

```bash
docker run -d --name suprminer-prl --gpus all --restart unless-stopped \
  -e COIN=PRL -e USERNAME=YOUR_PRL_ADDRESS -e WORKER=rig01 \
  -e PASSWORD=x -e STARTUP_SCRIPT_URL= \
  ocminersupr/suprminer-base:1.9.25
```

For NOID, change `COIN=PRL` to `COIN=NOID`, use your NOID address, and choose a
different container name. Stop the previous container before assigning its GPUs
to another miner.

For an Octa.Space or Vast.ai template, use the same image and environment
variables. Select Docker Entrypoint mode and leave the container startup script
empty when using the built-in launcher.

| Environment variable | PRL | NOID |
|---|---|---|
| `COIN` | `PRL` | `NOID` |
| `USERNAME` | Your PRL address | Your NOID address |
| `WORKER` | A worker name | A worker name |
| `PASSWORD` | `x` | `x` |
| `STARTUP_SCRIPT_URL` | Empty | Empty |

`ALGO` and `POOL_URL` can override the preset. If using a different pool, set
both explicitly. Older `GPU_ALGO`, `GPU_POOL` and `GPU_USER` fields are not read
by this image. See the
[Docker user guide](https://github.com/ocminer/suprminer/blob/main/docker/README.md)
for device selection, SSH and detailed platform setup.
