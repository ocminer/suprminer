# NEB OpenCL in Suprminer 1.9.45

The v1.9.61 setup guide covers AMD installation. [NEB setup](NEB_RELEASE_GUIDE.md) · [Current benchmarks](benchmarks/neb-1.9.61-fleet.md)

The following installation notes and measurements describe v1.9.45.

Suprminer 1.9.45 adds NEB to the AMD OpenCL packages for Linux, Windows, HiveOS, mmpOS and SMOS. The historical `quantus-opencl` package names are retained for installer compatibility. NEB uses OpenCL, including in the Linux package that also offers Quantus Vulkan.

Download the AMD OpenCL package from the [release page](https://github.com/ocminer/suprminer/releases/tag/v1.9.45). It dynamically loads the system OpenCL runtime and has no CUDA or NVML dependency.

```sh
./suprminer-neptune --neb-test -d 0 --neb-dataset neb-datasets.bin
./suprminer-neptune -a neb -d 0 -o stratum+tcp://neb.suprnova.cc:7804 -u YOUR_NEB_ADDRESS.worker -p x
```

Use the pool's documented port. Device ordinals belong to the OpenCL GPU enumeration. `-d 0,2` selects only those two devices. The default dataset is downloaded and verified exactly as with the CUDA frontend. Only NEB 1.0.1 Kepler/TESS, native indices 0/1 and KEP1 are accepted.

Use the default settings for mining. The miner checks submitted shares for correctness.

GPU statistics on Linux are read through the OpenCL device's PCI identity and sysfs. Missing or ambiguous topology leaves telemetry unavailable; it never guesses a device or changes clocks, power, fans or driver settings.

The RX 7600 XT, RX 7900 XTX and MI50 were tested on Linux on 18 November 2026.

## Measured development results

Fixed NEB 1.0.1 genesis models and pinned mainnet dataset; about 10 seconds per dataset after warmup in the diagnostic backend harness. Rates are attempts per second. These are initial development measurements, not release-over-release improvements or a Windows benchmark.

| GPU | Test power limit | Kepler | TESS |
|---|---:|---:|---:|
| RX 7600 XT | 165 W | 7.03 MH/s | 7.09 MH/s |
| MI50 | 150 W | 5.04 MH/s | 5.06 MH/s |
| MI50 (short run) | 225 W | 5.69 MH/s | 5.73 MH/s |
| RX 7900 XTX | 272 W | 19.23 MH/s | 19.76 MH/s |

[CSV with sampled power and clocks](neb-opencl-benchmarks.csv). Telemetry summarizes the last 20 one-second samples, approximately the two benchmark windows including transitions. Clocks were not locked or modified. Reported power may briefly exceed the configured limit because of hardware averaging.

Earlier test settings measured 15.11/15.46 MH/s on the RX 7900 XTX at 272 W and 2.00/2.06 MH/s on the MI50 at 225 W (Kepler/TESS). These short benchmark windows are sensitive to cooling.

The original 303 W XTX and 225 W MI50 reached the junction-temperature guard during longer tests. Cooler bounded live checks passed at 272 W and 150 W respectively. The 225 W MI50 table row is a short benchmark and does not establish sustained thermal stability in the tested chassis. All original power/fan/clock settings were restored. The miner itself never changes them.

The final frontend produced **33 accepted shares, zero rejects and zero CPU-invalid shares** across all three cards on the owner's isolated NEB 1.0.1 fakenet. Every card covered both datasets; all 33 exact block IDs appeared as parents in later node work. An earlier two-card run added 4 accepted shares. This is real consensus-path testing on a private chain, not a payout/accounting test.

The development builds also passed 24 host tests and 65 additional correctness checks on each of the RX 7600 XT and MI50.

Steady CPU usage of the actual final miner, after the first 45 seconds, was 4.97% of one core on RX 7600 XT, 4.45% on MI50 and 6.79% on XTX. This includes the driver and CPU share verification, measured on the test hosts. The optional HTTP API (`--api`) was also checked on the MI50: hashrate, accepted/rejected counters, temperature, fan, power and clocks were populated without NVML.

These historical hardware results cover the listed Linux OpenCL cards.

## Final production executable qualification — v1.9.45

| GPU | Limit W | Kepler MH/s | TESS MH/s | Mean W | CPU, % of one core |
|---|---:|---:|---:|---:|---:|
| RX 7600 XT | 165 | **6.97** | **6.99** | 160.9 | 5.72 |
| MI50 | 150 | **4.92** | **4.99** | 147.3 | 5.47 |
| RX 7900 XTX | 272 | **18.53** | **19.62** | 274.7 | 9.04 |
| RTX 5090 | 450 | **137.96** | **139.24** | 449.9 | 1.73 |

Final AMD executables produced **60 accepted shares, zero rejects and zero CPU-invalid shares** on an isolated NEB 1.0.1 chain. All three cards covered both datasets; 60 exact block IDs were independently reconstructed and appeared as parents in later node work. The final NVIDIA executable added 8 accepted shares with zero rejects. This verifies the consensus path, not pool payouts or accounting.

All three Linux AMD executables (Ubuntu 20.04, Ubuntu 22.04 and the package containing Quantus Vulkan) passed NEB reference tests on RX 7600 XT, MI50 and RX 7900 XTX. The final AMD Docker image also passed NEB GPU reference checks and sustained mining on RX 7900 XTX. Its Quantus limitation is described below. Windows compiled successfully and passed host tests; physical Windows GPU execution was not tested.

[Final measurements and methodology](benchmarks/neb-1945-mainnet101.csv). The development figures above retain their original short-window method; do not treat them as a before/after comparison.

Known Quantus limitation: the OpenCL target-boundary self-test fails on the tested RX 7600 XT and MI50 with AMD OpenCL 3649.0. The same failure was reproduced with the published v1.9.44 binary, and the Quantus kernel and host path are unchanged. Quantus on these card/driver combinations is not qualified by this release. This does not affect the NEB checks, which passed independently on both cards; RX 7900 XTX passed the Quantus check. The new AMD Docker image also fails this Quantus self-test on RX 7900 XTX with its bundled ROCm 6.4.3 runtime, including when the published v1.9.44 executable is used. Use the AMD Docker image for NEB; Quantus GPU operation in that image is not qualified.
