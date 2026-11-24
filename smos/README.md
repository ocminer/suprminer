# SimpleMining / SMOS

Choose **CUSTOM** in the miner configuration. Put the public ZIP URL first in
Miner OPTIONS, followed by the usual Suprminer arguments. For Quantus, use

```text
https://github.com/ocminer/suprminer/releases/download/v1.9.58/suprminer-neptune-1.9.58-smos.zip -a quantus -o stratum+tcp://quantus.suprnova.cc:7071 -u YOUR_QUANTUS_ADDRESS.rig1 -p x
```

There is one SMOS ZIP. It needs glibc 2.31 or newer (Ubuntu 20.04 base and later).
`miner` is the NVIDIA build (Quantus, NEB, PRL, NOID); `miner-amd` is the OpenCL
build for AMD or Pascal cards (Quantus and NEB).

For PRL, use `-a pearl -o stratum+tcp://prl.suprnova.cc:3373 -u YOUR_PRL_ADDRESS.rig1 -p x`.
For NOID, use `-a noid -o stratum+tcp://noid.suprnova.cc:3337 -u YOUR_NOID_ADDRESS.rig1 -p x`.
NOID supports Ampere and newer NVIDIA GPUs. GTX 16xx / RTX 20xx support is experimental and has not been tested on physical Turing hardware.

TLS uses `stratum+ssl://quantus.suprnova.cc:7074`; `-d 0,1` selects devices.
The archive contains one directory with the executable named `miner`, supporting
licenses and these instructions. Versioned ZIP names avoid the platform's
download cache retaining an older package. Use a new version for changed assets.

The format follows the [SimpleMining maintainer's published custom-miner
instructions](https://bitcointalk.org/index.php?topic=1541084.msg49730705).
Archive layout, version, permissions and payload checksums are validated during
packaging. A real SMOS installation has not been tested; this is a custom package,
not a claim of inclusion in SimpleMining's managed miner list or dashboard parser.
