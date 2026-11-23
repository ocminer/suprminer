# NEB GPU benchmarks for Suprminer 1.9.56

Linux tests used two desktop RTX 3070s, two RTX 5090s and one Radeon RX 7900 XTX on 23 November 2026. Each measurement used the card's full firmware power allowance and automatic clocks. Rates count millions of completed evaluation attempts per second (MH/s).

## Linux release packages

The Linux production binaries mined the same captured models on the same physical cards, with automatic clocks. Rates below are **Kepler / TESS**, in millions of completed attempts per second after warm-up. Model pair A and pair B are different mainnet snapshots.

| GPU | Power allowance | Model pair | 1.9.55 MH/s | 1.9.56 MH/s | Difference |
|---|---:|:---:|---:|---:|---:|
| RTX 3070 A | 250 W | A | 55.58 / 686.06 | **66.09 / 701.49** | +18.9% / +2.3% |
| RTX 3070 A | 250 W | B | 126.06 / 905.98 | **137.97 / 913.81** | +9.5% / +0.9% |
| RTX 3070 B | 250 W | A | 55.99 / 699.05 | **67.12 / 713.70** | +19.9% / +2.1% |
| RTX 3070 B | 250 W | B | 128.68 / 922.02 | **140.46 / 929.61** | +9.2% / +0.8% |

Across the first 192 seconds, including startup and all four model visits, the RTX 3070 results were 376.80 → **423.63 MH/s** (+12.4%) and 383.50 → **431.16 MH/s** (+12.4%).

One miner process ran both RTX 3070 boards simultaneously. Each of the four model visits lasted 48 seconds. Warm rates use the final four complete six-second jobs of each visit. The 192-second comparison counts completed jobs from process launch. Across the full 199-second runs, the fixture recomputed all 6,371 tickets against the upstream NEB reference. Every ticket was valid and unique within its run.

Both versions used the NEB 1.0.1 mainnet dataset.

Linux NVIDIA executable SHA-256 was `fd341e0ea8b1506538de36c9364622b668c26ed8eda11cd0ae50171c432f8541` for 1.9.55 and `1b9cd473879e85d9f319a09f57efa5c7e40c296c2294c449ce2206764be2e812` for 1.9.56. [Release-package CSV](neb-1.9.56-packaged.csv)

### AMD OpenCL

The packaged Linux OpenCL executable completed both slots on a Radeon RX 7900 XTX with its 350 W firmware allowance. The upstream reference verified 238 Kepler and 4,925 TESS tickets with zero rejects. A separate live TLS test returned 16 accepted shares and one job-change stale. A short 24-second visit per slot gave one warm rate reading each, 46.19 MH/s for Kepler and 930.97 MH/s for TESS on model pair A.

## Release-kernel benchmarks before packaging

Values are **Kepler / TESS**. Both versions used the same captured weights on the same physical board in separate runs. Pair A and pair B are different mainnet snapshots. The 1.9.55 rates come from the published Linux miner. The 1.9.56 measurements come from protected Linux builds of the selected release kernels.

| GPU | Power allowance | Model pair | 1.9.55 MH/s | 1.9.56 MH/s | Difference |
|---|---:|:---:|---:|---:|---:|
| RTX 3070 A | 250 W | A | 55.70 / 680.70 | **65.37 / 697.20** | +17.4% / +2.4% |
| RTX 3070 B | 250 W | A | 56.08 / 697.42 | **66.73 / 707.11** | +19.0% / +1.4% |
| RTX 5090 | 600 W | A | 387.71 / 5099.50 | **405.65 / 5468.66** | +4.6% / +7.2% |
| RTX 5090 | 600 W | B | 627.23 / 6703.60 | **730.22 / 7084.72** | +16.4% / +5.7% |

The differences above compare warm throughput. The 1.9.55 figures use the miner's reported steady rates. For 1.9.56, the RTX 3070 figures divide completed work by elapsed time during seconds 24–48 of each model's 48-second visit. The RTX 5090 figures average the warm completed-work rates of two runs per model, using the first visit to each model in each run. Those runs used 60- and 40-second visits with the first 20 seconds excluded. Automatic boost and the length of the warm windows can affect the observed change.

## Additional 1.9.56 measurements

| GPU | Model pair | Kepler MH/s | TESS MH/s |
|---|:---:|---:|---:|
| RTX 3070 A | B | 136.60 | 907.46 |
| RTX 3070 B | B | 140.06 | 928.32 |
| RTX 5090, shared | A | 431.34 | 4632.08 |
| RTX 5090, shared | B | 777.10 | 6207.94 |

The shared RTX 5090 ran alongside another GPU workload, with 16 GiB reserved for mining tables and a 600 W board allowance. The dedicated RTX 5090 used all available memory. Both RTX 3070s ran exclusively at 250 W. An empty 1.9.55 field in the CSV means there is no comparable baseline for that card, workload and configuration.

## Throughput through model changes

Each RTX 3070 started a fresh process and replayed both model pairs. These rates include startup, model changes, and the final batch of completed work over the nominal test duration.

| Job sequence | RTX 3070 A | RTX 3070 B |
|---|---:|---:|
| 155 s, alternating 18 s of TESS and 6 s of Kepler | 569.34 MH/s | 582.87 MH/s |
| 209 s, four 48 s visits followed by 17 s on TESS | 436.73 MH/s | 445.74 MH/s |

During the 209-second runs, the RTX 3070s averaged 248.11 and 248.23 W, with average core clocks of 1,804 and 1,843 MHz. An independent reference checked submitted tickets on both slots. A separate RTX 3070 mainnet run on Suprnova received 25 Kepler and two TESS share acceptances with zero rejects.

## Workloads

| Pair | Kepler model hash | TESS model hash |
|:---:|---|---|
| A | `29c0260f417e34d2ecfb2f558e2a9a2602f1e5c331a8a7240ce13fbf75415cf9` | `ffe15bbc078468fdd1eec160a64c68201daab84aa2aa05ce7b684716e46bd0c2` |
| B | `af945631629b2128f545f94f8f9eab1d8d919e34d0523070402ede5cfe0e45c7` | `1b61e38033d17a1c887a1cca1704c04a68cb835b41cc6152162ac6cc4dea57cf` |

The dataset was the NEB 1.0.1 mainnet `neb-datasets.bin`. Network training changes the rates of both slots. For data from other cards and earlier weights, see the v1.9.55 fleet measurements. [CSV for 1.9.56](neb-1.9.56-fleet.csv) · [Earlier fleet measurements](neb-1.9.55-fleet.md)
