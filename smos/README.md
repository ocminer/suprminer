# SimpleMining / SMOS

Choose **CUSTOM** in the miner configuration. Put the public ZIP URL first in
Miner OPTIONS, followed by the usual Suprminer arguments. For Quantus, after
the release is published:

```text
https://github.com/ocminer/suprminer/releases/download/v1.9.26/suprminer-neptune-1.9.26-smos-nvidia-u2204.zip -a quantus -o stratum+tcp://quantus.suprnova.cc:7071 -u YOUR_QUANTUS_ADDRESS.rig1 -p x
```

Use the `opencl` ZIP for AMD or Pascal Quantus mining. Each backend has Ubuntu
20.04 (`u2004`, glibc 2.31 or newer) and Ubuntu 22.04 (`u2204`, glibc 2.35 or newer)
packages. Match the package to the rig's OS and installed GPU driver. Both NVIDIA
packages include PRL and NOID. OpenCL packages mine Quantus only.

For PRL, use `-a pearl -o stratum+tcp://prl.suprnova.cc:3373 -u YOUR_PRL_ADDRESS.rig1 -p x`.
For NOID, use `-a noid -o stratum+tcp://noid.suprnova.cc:3337 -u YOUR_NOID_ADDRESS.rig1 -p x`.
NOID requires a supported Ampere or newer NVIDIA GPU.

TLS uses `stratum+ssl://quantus.suprnova.cc:7074`; `-d 0,1` selects devices.
The archive contains one directory with the executable named `miner`, supporting
licenses and these instructions. Versioned ZIP names avoid the platform's
download cache retaining an older package. Use a new version for changed assets.

The format follows the [SimpleMining maintainer's published custom-miner
instructions](https://bitcointalk.org/index.php?topic=1541084.msg49730705).
Archive layout, version, permissions and payload checksums are validated during
packaging. A real SMOS installation has not been tested; this is a custom package,
not a claim of inclusion in SimpleMining's managed miner list or dashboard parser.

Build the Linux variants with `./build-hiveos.sh`, then package with
`python3 package-smos.py --2204` or `--2004`, adding `--opencl` as appropriate.
