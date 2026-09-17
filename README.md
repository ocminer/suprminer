# suprminer

Multi-algorithm GPU/CPU miner for Suprnova pools and beyond. One binary, many algorithms —
NVIDIA CUDA first (RTX 20xx "Turing" sm_75 through RTX 50xx "Blackwell" sm_120, plus
datacenter A100/H100/B200), AMD/OpenCL for selected algorithms, CPU for the memory-hard ones.

Binary name: `suprminer-neptune` (historical). Releases:
https://github.com/ocminer/suprminer/releases

## Version 1.9.24

This release improves PRL throughput on several GPU families and NOID hashing
on RTX 3070 and RTX 5090. GPU profiles are selected automatically.

[Downloads](https://github.com/ocminer/suprminer/releases/tag/v1.9.24) ·
[PRL and NOID setup](docs/PRL_NOID_RELEASE_GUIDE.md) ·
[Docker, Octa.Space and Vast.ai](docker/README.md).

## Quick start

```bash
./suprminer-neptune -a pearl -o stratum+tcp://prl.suprnova.cc:3373 -u <wallet>.<worker> -p x
./suprminer-neptune -a sha3t -o stratum+tcp://bc3.suprnova.cc:7700 -u <wallet>.<worker> -p x
./suprminer-neptune -a noid  -o stratum+tcp://noid.suprnova.cc:3337 -u <NOID_ADDRESS>.<worker>
```

Run as root if you want the miner to manage power limits / clocks (`--power-limit`,
`--core-clock`, `--mem-clock`, `--fan-speed` — all reset to defaults on exit).
Stop with SIGINT (Ctrl-C) for a clean shutdown; PearlHash requires it.

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
| `nock` | `nockchain` | Nockchain — TIP5 ZK-STARK | NVIDIA |
| `noid` | `parano1d`, `poseidon2b` | NOID / Parano1d — Poseidon2b over GF(2¹²⁸) | NVIDIA sm_80 / sm_86 / sm_120 (RTX 30xx, CMP 170HX, RTX 50xx) |
| `npt` / `xnt` | `neptune` | Neptune — **deprecated**, opt-in `-with-neptune` builds only | — |

`./suprminer-neptune --help` prints the full flag reference and a per-algorithm footer.

## Quantus

Quantus uses CryptoNote-style TCP Stratum (`login`, `job`, `submit`, `keepalived`).
It is a separate algorithm from QuBitcoin/QHash and NOID/Poseidon2b.

```bash
# Suprnova pool
./suprminer-neptune -a quantus -o stratum+tcp://quantus.suprnova.cc:7071 -u <ADDRESS>.<WORKER> -d 0

# TLS
./suprminer-neptune -a quantus -o stratum+ssl://quantus.suprnova.cc:7074 -u <ADDRESS>.<WORKER> -d 0

# CPU mining
./suprminer-neptune -a quantus -o quantus.suprnova.cc:7071 -u <ADDRESS>.<WORKER> --no-gpu --cpu-threads 4

# Offline GPU/CPU correctness check, no pool required
./suprminer-neptune --quantus-test -d 0
```

Use your Quantus payout address, optionally followed by `.worker`.

GPU batches adapt to a 50 ms budget. The automatically selected RTX PRO 6000
Blackwell Server Edition and H100 80GB HBM3 profiles allow up to 67,108,864 nonces;
other profiles retain the 16,777,216-nonce ceiling. A100 SXM4 80 GB and CMP 170HX each
select their own measured kernel schedule. Selection uses the exact model, CUDA architecture and SM count.
`QUANTUS_BATCH` sets a lower ceiling when needed. `QUANTUS_SUBMIT_RESULT=1` adds the 64-byte hash
for gateways that require it; the default submits the full nonce without a result field.
Normal production and HiveOS builds include `quantus-gpu`; CPU-only development builds
can enable `quantus`. AMD and GTX 1080 Ti/Pascal use the Quantus OpenCL variant,
built with `./build.sh -prod -quantus-opencl-only`. It uses the installed vendor
OpenCL driver and requires no CUDA libraries. Device indices in that variant are
OpenCL indices; it selects OpenCL automatically, with `--opencl` available explicitly.
The same `--quantus-test -d 0` check works on both variants. Both embed encrypted
device code.

## NOID (Parano1d) on noid.suprnova.cc

NOID uses the Poseidon2b proof-of-work over GF(2¹²⁸). suprminer mines it with native
Ampere and Blackwell kernels and needs **no developer fee**.

```bash
# plain stratum (ports 3337-3340)
./suprminer-neptune -a noid \
  -o stratum+tcp://noid.suprnova.cc:3337 \
  -u o1yournoidaddress....rig01

# TLS (port 3341)
./suprminer-neptune -a noid \
  -o stratum+ssl://noid.suprnova.cc:3341 \
  -u o1yournoidaddress....rig01

# pick specific GPUs
./suprminer-neptune -a noid -o stratum+tcp://noid.suprnova.cc:3337 \
  -u o1yournoidaddress....rig01 --devices 0,1
```

The username is your **bech32m NOID address** (`o1...`), optionally followed by `.workername`.
No password is required — leave `-p` unset. A static difficulty can be requested with
`-p d=<number>`; otherwise the pool applies VarDiff automatically.

**Requirements**

| | |
|---|---|
| GPU | NVIDIA `sm_120` (RTX 50xx), `sm_86` (RTX 30xx) and `sm_80` (A100 / CMP 170HX) |
| Driver | 610.x or newer |
| CUDA (build only) | 13.3 or newer — earlier `ptxas` cannot assemble the `clmad` instruction |

The kernel is built on the native carry-less multiply (`clmad`), which CUDA 13.3 assembles for
`sm_80` and later. GA100 uses a 160 KiB shared-memory table; GA10x and Blackwell use a 96 KiB one.
Turing (`sm_75`) is **not** supported — it caps at 64 KiB of opt-in shared memory and cannot host
the table, so those cards report an initialisation error rather than silently running slowly.

Measured at stock clocks, no core/memory offsets or voltage changes:

| GPU | hashrate | power |
|---|---:|---:|
| RTX 5090 | 213-223 MH/s | 600 W |
| RTX 5080 | 108-111 MH/s | 300-325 W |
| RTX 5070 Ti | 90 MH/s | 237 W |
| RTX 3070 | 39-40 MH/s | 224-231 W |
| CMP 170HX | 27.6 MH/s | 123 W |

Pool endpoints: `noid.suprnova.cc:3337` … `:3340` (plain), `:3341` (TLS).

## Common flags

```
-a, --algo <ALGO>          algorithm (table above)
-o, --url <URL>            pool, stratum+tcp://host:port
-u, --user <USER>          wallet or account (append .worker for a worker name)
-p, --pass <PASS>          pool password (default: x)
-d, --devices <LIST>       GPU selection, comma-separated (0,1,2); default = all
-i, --intensity <18-28>    batch size = 2^intensity
    --core-clock <MHZ,..>  lock core clocks, per device index
    --mem-clock <MHZ,..>   lock memory clocks, per device index
    --power-limit <W,..>   set power limits (needs root; restored on exit)
    --fan-speed <PCT,..>   set fan speeds (0 = leave untouched; restored on exit)
    --api-port <PORT>      HTTP stats API, HiveOS-compatible (default 4068)
    --sha3t-test           sha3t GPU-vs-CPU byte-exact self-test, then exit
    --test-vectors         verify hashes against pool implementations
```

Device numbering follows CUDA's "fastest first" order by default — export
`CUDA_DEVICE_ORDER=PCI_BUS_ID` to make `-d` match `nvidia-smi` indices.

Algorithm tuning is available through environment variables (e.g. `PEARL_*` for PearlHash);
run `./suprminer-neptune --help` for the full per-algorithm flag and env-var reference.

PRL proof submissions use gzip before base64 whenever compression reduces the payload size.
The pool must support automatic gzip detection in `plain_proof`. Set `PEARL_PROOF_GZIP=0`
to send raw base64 proofs to older pools. Submission logs show the encoding and byte savings.

## Building

Always build through the script (never raw cargo):

```bash
./build.sh -prod -sha3t        # release build: all archs, packed, PearlHash + sha3t
./build.sh -no-pearl -sha3t    # sha3t-only, faster build
./build-hiveos.sh              # HiveOS/mmpOS packages (Docker cross-compile, glibc 2.31)
```

Requires CUDA 12.9+ (13.x preferred); Pascal support requires a CUDA 12.x toolchain plus the
opt-in `SUPRMINER_SHA3T_PASCAL=1` (sha3t only).

## Docker (octa.space / any NVIDIA docker host)

An env-driven image is published as
[`ocminersupr/suprminer-base`](https://hub.docker.com/r/ocminersupr/suprminer-base):

```bash
docker run -d --gpus all --restart unless-stopped \
  -e COIN=PRL -e USERNAME=<wallet> -e WORKER=rig1 \
  ocminersupr/suprminer-base:latest
```

`COIN=PRL|NOID|BC3|QUANTUS` selects algo + suprnova pool automatically; the username is
`USERNAME=<wallet/address>` and `WORKER=<name>` (do not use a plain account name — the
pool authorizes on the wallet). Everything else is configurable via env (`ALGO`, `POOL_URL`,
`DEVICES`, `POWER_LIMIT`, `EXTRA_ARGS`, …), or point `STARTUP_SCRIPT_URL` at your own launcher.

## HiveOS / mmpOS

Release tarballs include HiveOS custom-miner packages (`_u2004`/`_u2204`) and an mmpOS
package — see the release assets and `hiveos/` in this repo. Stats API on `:4068`.
