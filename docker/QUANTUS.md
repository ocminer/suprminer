# Mine Quantus with Docker

Use `ocminersupr/suprminer-base` on a host with an NVIDIA GPU, a working NVIDIA
driver, and the NVIDIA Container Toolkit. The examples below pin the
`1.9.23` image so a new deployment selects this miner version. See the
[Docker user guide](https://github.com/ocminer/suprminer/blob/main/docker/README.md)
for Octa app guide links, Vast.ai launch modes, and all supported environment
variables. Both guides are bundled at `/app/README.md` and `/app/QUANTUS.md` in
the documentation refresh of the image.

## Start mining on Suprnova

Create a file named `quantus.env`. Replace `YOUR_QUANTUS_WALLET_ADDRESS` with your
own Quantus payout address and choose a worker name for this machine:

```dotenv
COIN=QUANTUS
ALGO=quantus
POOL_URL=stratum+tcp://quantus.suprnova.cc:7071
USERNAME=YOUR_QUANTUS_WALLET_ADDRESS
WORKER=octa-rig-01
PASSWORD=x
STARTUP_SCRIPT_URL=
```

Start the container:

```bash
docker run -d \
  --name suprminer-quantus \
  --gpus all \
  --restart unless-stopped \
  --env-file quantus.env \
  ocminersupr/suprminer-base:1.9.23
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

## Octa.Space and other container hosting panels

Select `ocminersupr/suprminer-base:1.9.23` as the container image and allocate the
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

If the panel requires an explicit startup command, use `/entrypoint.sh`. Remove
old template fields such as `GPU_ALGO`, `GPU_POOL`, `GPU_USER`, and `CPU_*`; the
built-in launcher does not read them. In particular, `GPU_ALGO=xelis` does not
select Xelis or override `ALGO=quantus`.

On Vast.ai, choose **docker ENTRYPOINT** mode. For SSH or Jupyter mode, follow
the [Vast.ai startup instructions](https://github.com/ocminer/suprminer/blob/main/docker/README.md#vastai)
because those modes replace the image's startup command.

## Choose GPUs and optional settings

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

## Verify mining and apply changes

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
