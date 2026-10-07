# PRL + NOCK merged mining — Suprminer 1.9.28

On a compatible pool, Suprminer can mine PRL and also submit NOCK proofs from
the same GPU work. Ordinary PRL share submission continues while an auxiliary
proof is prepared. Your pool determines NOCK accounting and payout availability;
merged-mining support does not by itself mean that a pool has enabled payouts.

## Linux NVIDIA

Extract the complete NVIDIA package and keep `suprminer-prl-nock-prover` next
to the miner. Use a supported NVIDIA GPU and at least **24 GiB available system
RAM** (32 GiB or more installed is recommended). Proving also uses CPU time;
GPU VRAM does not replace this system-memory requirement.

```sh
./suprminer-neptune -a pearl --nock-merge --no-cpu \
  -o stratum+tcp://prl.suprnova.cc:3373 \
  -u 'YOUR_PRL_ADDRESS+YOUR_NOCK_ADDRESS.rig1' -p x
```

Replace both addresses with your own. If using individual downloads, rename the
helper to `suprminer-prl-nock-prover`, put it beside the miner and make both files
executable. The Linux helper supports Ubuntu 20.04 and newer.

Start without `--nock-merge` for ordinary PRL mining. A pool that supplies no
merged-mining work continues as PRL-only. The log reports when the auxiliary
helper is configured and when a proof is submitted. A submitted proof is not
necessarily an accepted block. Proofs for replaced or expired work are cancelled.

The defaults allow one pending proof and up to 16 CPU threads. If the host also
runs other services, set `PEARL_AUX_THREADS` to a lower number. Advanced users
can set `PEARL_AUX_PROVER` to the matching helper's path and `PEARL_AUX_SPOOL`
to a private writable directory. Keep enough free RAM for the OS and other work.

## HiveOS, mmPOS and SMOS

Install the NVIDIA package that matches your OS. Set the algorithm to `pearl`,
use the combined `PRL_ADDRESS+NOCK_ADDRESS.worker` wallet format, and add
`--nock-merge` to the miner's extra arguments. The helper is included in these
NVIDIA packages; retain all extracted files.

## Docker, Octa.Space and Vast.ai

Use `ocminersupr/suprminer-base:1.9.28` with NVIDIA GPU access:

```sh
docker run --rm --gpus all \
  -e COIN=PRL \
  -e POOL_URL=stratum+tcp://prl.suprnova.cc:3373 \
  -e USERNAME='YOUR_PRL_ADDRESS+YOUR_NOCK_ADDRESS' \
  -e WORKER=rig1 -e PASSWORD=x -e EXTRA_ARGS=--nock-merge \
  ocminersupr/suprminer-base:1.9.28
```

Cloud templates use the same environment variables. Allocate enough container
RAM for proving. The image includes the helper and this guide at
`/app/MERGED_MINING.md`.

## Windows and other backends

The Windows downloads are native Windows executables built in GitHub CI.
The NVIDIA package supports ordinary PRL, NOID, Quantus and its other listed
algorithms. **The auxiliary NOCK proof helper is Linux-only in this release**;
use a Linux NVIDIA package for PRL + NOCK merged mining.

The OpenCL and Vulkan release variants support Quantus; they do not include
PRL/NOCK merged mining. GPU and pool testing is performed on Linux. Windows
compilation, command-line and CPU protocol checks do not constitute a Windows
GPU mining test.
