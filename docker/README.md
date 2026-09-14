# Suprminer Docker user guide

`ocminersupr/suprminer-base` runs Suprminer on NVIDIA GPUs using environment
variables. It includes the miner and starts mining automatically when the
container starts. Use it on Octa.Space, Vast.ai, or a Docker host with the NVIDIA
Container Toolkit.

- Image: [`ocminersupr/suprminer-base`](https://hub.docker.com/r/ocminersupr/suprminer-base)
- Current release: [`1.9.23`](https://github.com/ocminer/suprminer/releases/tag/v1.9.23)
- Tags: `1.9.23` selects this miner version; `latest` follows new releases.
- [Quantus setup guide](https://github.com/ocminer/suprminer/blob/main/docker/QUANTUS.md)
- [Public copy of this guide](https://github.com/ocminer/suprminer/blob/main/docker/README.md)

The image requires an x86_64 Linux host, a CUDA 13 compatible NVIDIA driver, and
an NVIDIA GPU supported by the miner (Turing/sm_75 and newer). Pascal GPUs are not
supported by this image. GPU memory requirements depend on the algorithm.

## Quick start: Quantus

Replace `YOUR_QUANTUS_WALLET_ADDRESS` with your own payout address:

```bash
docker run -d --name suprminer-quantus \
  --gpus all --restart unless-stopped \
  -e COIN=QUANTUS \
  -e USERNAME=YOUR_QUANTUS_WALLET_ADDRESS \
  -e WORKER=rig1 \
  ocminersupr/suprminer-base:1.9.23
```

This selects `quantus.suprnova.cc:7071`. For TLS, also set
`POOL_URL=stratum+ssl://quantus.suprnova.cc:7074`.
Quantus uses `COIN=QUANTUS`; Qubitcoin/QHash is a different coin and algorithm.

Always set your own `USERNAME`. The image's default `suprnova.octa` is not your
payout address. When `WORKER` is set, the miner connects as `USERNAME.WORKER`.
Leave `WORKER` empty if your username already includes the worker suffix.

## Octa.Space

Configure your custom app or container with these settings:

| Setting | Value |
|---|---|
| Container image | `ocminersupr/suprminer-base:1.9.23` |
| GPU | Allocate the NVIDIA GPU or GPUs to the container |
| Startup command | Use the image default, `/entrypoint.sh` |
| `COIN` | `QUANTUS` |
| `ALGO` | `quantus` |
| `POOL_URL` | `stratum+tcp://quantus.suprnova.cc:7071` |
| `USERNAME` | Your Quantus payout address |
| `WORKER` | A name such as `octa-rig-01` |
| `PASSWORD` | `x` |
| `STARTUP_SCRIPT_URL` | Leave empty |
| `NVIDIA_VISIBLE_DEVICES` | `all` (lowercase), unless the platform assigns a specific GPU list |

Enter environment variables as separate names and values, without `-e` prefixes
or surrounding quotes. Preserve the image's startup command; if the panel
requires an explicit command, enter `/entrypoint.sh`. Mining needs an outbound
pool connection and no published inbound ports.

### Upgrading an old app template

The older script-based template used `GPU_ALGO`, `GPU_POOL`, `GPU_USER`,
`GPU_PASS`, and `CPU_*` fields. The current built-in launcher uses the names
below:

| Old field | Current field |
|---|---|
| `GPU_ALGO` | `ALGO` |
| `GPU_POOL` | `POOL_URL` |
| `GPU_USER` | `USERNAME` |
| `GPU_PASS` | `PASSWORD` |
| `CPU_*` | Not consumed by the built-in launcher |

Remove the old fields and enter the current ones. `GPU_ALGO=xelis` is ignored;
it does not override the default `COIN=PRL`. To select Xelis, set `ALGO=xelis`
**and** the matching `POOL_URL`, plus your `USERNAME` and optional `WORKER`.
For Xelis, use the pool's `host:port` form, for example `xel.suprnova.cc:3333`.
Changing `ALGO` alone does not change the pool selected by `COIN`.

Clear any existing `STARTUP_SCRIPT_URL`. A nonempty value downloads and runs that
script **instead of** the built-in launcher, so that script controls which
environment variables are used. The built-in launcher starts one miner command;
it does not launch the old separate CPU-mining script.

Recreate or redeploy the container after editing its environment. Restarting an
existing Docker container retains the environment it was created with.

### Linking this guide from an Octa app

Use this public URL for the app's User Guide:

```text
https://github.com/ocminer/suprminer/blob/main/docker/README.md
```

Octa's public catalog includes guide links in app metadata as `extra.guide`.
For an app maintainer, the relevant metadata value is:

```json
{
  "extra": {
    "guide": "https://github.com/ocminer/suprminer/blob/main/docker/README.md"
  }
}
```

Merge this field into the app's existing `extra` settings, retaining its logo,
disk size, and hardware requirements. This is app metadata, not an environment
variable. The app owner or Octa catalog maintainer must attach it to the app;
publishing a Docker image or Docker Hub overview does not edit the Octa app.
The [public catalog API](https://api.octa.space/apps) and
[application listing](https://cube.octa.computer/marketplace/apps) show the Nexus
app using this field for its User Guide link.

## Vast.ai

Set the image to `ocminersupr/suprminer-base:1.9.23`. Choose the
**docker ENTRYPOINT** launch mode and use `/entrypoint.sh` as the command if an
explicit command is required. In API templates, use `runtype: "args"` with
`args_str: "/entrypoint.sh"`. Add these Docker options, replacing the address:

```text
-e COIN=QUANTUS -e ALGO=quantus -e POOL_URL=stratum+tcp://quantus.suprnova.cc:7071 -e USERNAME=YOUR_QUANTUS_WALLET_ADDRESS -e WORKER=vast-rig-01 -e PASSWORD=x -e STARTUP_SCRIPT_URL=
```

Vast's SSH and Jupyter launch modes replace the image's startup command. If you
use one of those modes, call `/entrypoint.sh` from the **On-start Script**:

```bash
nohup /entrypoint.sh > /var/log/suprminer.log 2>&1 &
```

Then read `/var/log/suprminer.log` in the instance to check mining. Run the launcher
once per container startup. Vast template documentation lives in its separate
**ReadMe** field; paste this guide there or link to the public guide above.
See Vast's [launch-mode settings](https://docs.vast.ai/guides/templates/template-settings)
and [template API](https://docs.vast.ai/api-reference/creating-and-using-templates-with-api).

## Environment variables

| Variable | Default | Meaning |
|---|---|---|
| `COIN` | `PRL` | Preset algorithm and pool; see below |
| `ALGO` | From `COIN` | Explicit algorithm; overrides the preset algorithm only |
| `POOL_URL` | From `COIN` | Explicit pool; required with an algorithm that has no matching preset |
| `USERNAME` | `suprnova.octa` | Your wallet address or pool account |
| `WORKER` | Empty | Appended as `USERNAME.WORKER` |
| `PASSWORD` | `x` | Pool password |
| `DEVICES` | All visible GPUs | Comma-separated indices, passed to `-d` |
| `INTENSITY` | Empty | Optional intensity, passed to `-i` |
| `CORE_CLOCK`, `MEM_CLOCK`, `POWER_LIMIT`, `FAN_SPEED` | Empty | Optional hardware settings passed to the corresponding miner flags; leave empty to retain existing settings |
| `EXTRA_ARGS` | Empty | Additional space-separated miner arguments; shell quotes inside the value are not interpreted |
| `ROOT_PASSWORD` | `suprminer` | Root SSH password; set your own if exposing the image's SSH server |
| `STARTUP_SCRIPT_URL` | Empty | Downloads and runs a script instead of the built-in launcher |

| `COIN` preset | Algorithm | Default pool |
|---|---|---|
| `PRL` | `pearl` | `stratum+tcp://prl.suprnova.cc:3373` |
| `BC3` | `sha3t` | `stratum+tcp://bc3.suprnova.cc:7700` |
| `QUANTUS` | `quantus` | `stratum+tcp://quantus.suprnova.cc:7071` |

For other algorithms, set `ALGO` and `POOL_URL` explicitly. Algorithm tuning
environment variables are inherited directly by the miner. Verthash requires
its data file, supplied through a volume and the relevant miner argument.

## Check mining and read the bundled docs

```bash
docker logs --tail 100 -f suprminer-quantus
```

Check the selected algorithm, pool, nonzero hashrate, and accepted shares. A
running container alone does not confirm successful mining. The launcher retries
the miner after an exit with a ten-second delay. If no algorithm or pool can be
resolved, it reports the configuration error and leaves SSH available for
debugging.

The documentation refresh includes these files inside the image:

```bash
docker exec suprminer-quantus cat /app/README.md
docker exec suprminer-quantus cat /app/QUANTUS.md
```

Read the README without starting the miner:

```bash
docker run --rm --runtime=runc -e NVIDIA_VISIBLE_DEVICES=void \
  --entrypoint cat ocminersupr/suprminer-base:1.9.23 /app/README.md
```

Stop cleanly with:

```bash
docker stop -t 30 suprminer-quantus
```

After updating the image or environment file, recreate the container to use the
new settings and files. Already running containers keep their original image.

## Build and release

The build context must contain `Dockerfile`, `entrypoint.sh`, `README.md`,
`QUANTUS.md`, and the release binary named `suprminer-neptune`.

```bash
docker build -t ocminersupr/suprminer-base:1.9.23 docker/octa
docker push ocminersupr/suprminer-base:1.9.23
```

The Docker Hub overview is maintained separately from the files inside the
image. Use this README as its content and retain the public documentation links.
