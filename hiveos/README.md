# HiveOS Integration for suprminer-neptune

This folder contains the integration scripts for HiveOS.

## Quantus

Install the 1.9.29 `_u2004.tar.gz` package on Ubuntu 20.04, or `_u2204.tar.gz`
on Ubuntu 22.04. Select the `_opencl_` package for AMD or NVIDIA Pascal cards;
those packages contain the Quantus miner without CUDA dependencies.

Set the algorithm to `quantus`, wallet template to `%WAL%.%WORKER_NAME%`,
pool to `quantus.suprnova.cc:7071`, and password to `x`.
For TLS use `stratum+ssl://quantus.suprnova.cc:7074`.
Device selection is optional, for example `-d 0,1` in extra configuration.

## PRL and NOID

Both full NVIDIA packages include PRL and NOID. The Quantus-only OpenCL
packages do not. Choose the package matching your rig's Ubuntu version.

| Setting | PRL | NOID |
|---|---|---|
| Algorithm | `pearl` | `noid` |
| Pool | `prl.suprnova.cc:3373` | `noid.suprnova.cc:3337` |
| Wallet template | `%WAL%.%WORKER_NAME%` | `%WAL%.%WORKER_NAME%` |
| Password | `x` | `x` |

Use the wallet for the selected coin. NOID requires a supported Ampere or newer
NVIDIA GPU. The bundled `PRL_NOID.md` contains standalone and platform examples.

## Installation

### Method 1: Custom Miner (Recommended)

1. In HiveOS web interface, go to **Flight Sheets**
2. Create a new flight sheet or edit existing
3. For miner, select **Custom**
4. Configure:
   - **Miner name**: suprminer-neptune
   - **Installation URL**: URL to your suprminer-neptune.tar.gz
   - **Hash algorithm**: Select the coin's algorithm, for example `quantus`, `pearl`, `noid`, `sha3t`, `xelis`, or `qhash`
   - **Wallet and worker template**: `%WAL%.%WORKER_NAME%`
   - **Pool URL**: Your pool address (e.g., `pool.example.com:3333`)
   - **Extra config arguments**: (optional) additional CLI args

5. Apply the flight sheet to your rig

### Method 2: Manual Installation

1. SSH into your HiveOS rig
2. Extract the matching package to `/hive/miners/custom/`:
   ```bash
   mkdir -p /hive/miners/custom
   cd /hive/miners/custom
   tar -xzf /path/to/suprminer-neptune-1.9.29_u2004.tar.gz
   ```
3. Configure the flight sheet to use `suprminer-neptune`.

## Files

- `h-manifest.conf` - Miner metadata (name, supported algorithms, API port)
- `h-config.sh` - Parses flight sheet config into CLI arguments
- `h-run.sh` - Starts the miner
- `h-stats.sh` - Reports stats to HiveOS dashboard

## Supported Algorithms

| Algorithm | Description | Requirements |
|-----------|-------------|--------------|
| `xelis` | Xelis (XEL) | CPU or GPU |
| `quantus` | Quantus Poseidon2 Goldilocks | NVIDIA; AMD/Pascal with the OpenCL package |
| `pearl` | PearlHash (PRL) | Full NVIDIA package |
| `noid` | Parano1d Poseidon2b | Full NVIDIA package; supported Ampere or newer GPU |
| `qhash` | QHash (QuBitcoin) | GPU only |

## Extra Config Arguments

You can pass additional arguments through the flight sheet's "Extra config arguments" field:

| Argument | Description |
|----------|-------------|
| `--cpu-threads N` | Number of CPU threads for Xelis |
| `-i N` / `--intensity N` | GPU intensity (22-26) |
| `-d 0,1,2` | Select specific GPUs |
| `--no-gpu` | CPU-only mining (Xelis or Quantus) |
| `-D` | Enable debug output |

## API

The miner exposes a stats API on port 4068 (configurable with `--api-port`):

```bash
curl http://localhost:4068/
```

Returns JSON with hashrates, temperatures, shares, and uptime.

## Troubleshooting

### Miner not starting
- Check `/hive/miners/suprminer-neptune/suprminer.log`
- Verify binary is executable: `chmod +x suprminer-neptune`

### No stats in dashboard
- Ensure miner was built with `-hiveos` flag
- Check API is responding: `curl http://localhost:4068/`

### GPU not detected
- Verify CUDA drivers: `nvidia-smi`
- Try explicit device selection: `-d 0`
