# NEB GPU benchmarks for Suprminer 1.9.56

### NEB benchmarks by GPU

Each cell gives **Kepler / TESS** in MH/s on the same captured model pair. A and B are two different mainnet snapshots. Power is the board allowance, and the runs used automatic clocks. Linux package rows compare the published binaries. Two additional RTX 5090 rows show earlier measurements with the selected release kernels.

| GPU | Power allowance | Model pair | 1.9.55 MH/s | 1.9.56 MH/s | Change K / T | Measurement |
| --- | ---: | ---: | ---: | ---: | ---: | --- |
| RTX 5090 | 600 W | A | 395.08 / 5207.38 | **414.54 / 5585.91** | +4.9% / +7.3% | Linux package |
| RTX 5080 | 400 W | A | 230.63 / 2231.57 | **230.76 / 2234.79** | +0.1% / +0.1% | Linux package |
| RTX 5070 Ti | 350 W | A | 191.27 / 1837.52 | **191.93 / 1845.47** | +0.3% / +0.4% | Linux package |
| RTX 4070 Ti SUPER | 285 W | A | 151.92 / 1675.04 | **162.98 / 1674.07** | +7.3% / -0.1% | Linux package, shared |
| Radeon RX 7900 XTX | 350 W | A | 50.93 / 688.14 | **50.51 / 945.39** | -0.8% / +37.4% | Linux OpenCL |
| RTX 3070 A | 250 W | A | 55.58 / 686.06 | **66.09 / 701.49** | +18.9% / +2.3% | Linux package, dual-GPU |
| RTX 3070 A | 250 W | B | 126.06 / 905.98 | **137.97 / 913.81** | +9.5% / +0.9% | Linux package, dual-GPU |
| RTX 3070 B | 250 W | A | 55.99 / 699.05 | **67.12 / 713.70** | +19.9% / +2.1% | Linux package, dual-GPU |
| RTX 3070 B | 250 W | B | 128.68 / 922.02 | **140.46 / 929.61** | +9.2% / +0.8% | Linux package, dual-GPU |
| RTX 5090 | 600 W | A | 387.71 / 5099.50 | **405.65 / 5468.66** | +4.6% / +7.2% | Release kernels, prepackaging |
| RTX 5090 | 600 W | B | 627.23 / 6703.60 | **730.22 / 7084.72** | +16.4% / +5.7% | Release kernels, prepackaging |

Across 192 seconds including startup and four model visits, the two RTX 3070s each gained **12.4%**, from 376.80 to 423.63 MH/s and from 383.50 to 431.16 MH/s. Single-run differences under 1% are within normal variation.

For the RTX 5090, RTX 5080, RTX 5070 Ti, RTX 4070 Ti SUPER and RX 7900 XTX, each miner ran 72 seconds on TESS followed by 72 seconds on Kepler with the same sequence of six-second jobs. Both backends count completed work over the four jobs ending at seconds 48, 54, 60 and 66 of each slot. On these five boards the independent upstream implementation verified 5,069 tickets from 1.9.55 and 5,692 from 1.9.56, with zero rejects. An existing GPU process remained on the RTX 4070 Ti SUPER for both versions. Each comparison used one run per version. Small differences can reflect boost or run variation.

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

### Last measured on earlier releases

These cards were measured on earlier trained models. Each row gives the release actually tested. As the network trains its models, the rate on the same card can change substantially.

| GPU | Power allowance | Tested version | Kepler MH/s | TESS MH/s | Test conditions |
| --- | ---: | ---: | ---: | ---: | --- |
| RTX PRO 6000 Blackwell 96 GB #1 | 600 W | 1.9.55 | 471.08 | 7077.5 | Release kernels |
| RTX PRO 6000 Blackwell 96 GB #2 | 600 W | 1.9.55 | 470.21 | 7054 | Release kernels |
| H100 80 GB | 700 W | 1.9.55 | 291.72 | 4280.38 | Release kernels |
| Tesla V100 16 GB | 300 W | 1.9.55 | 112.43 | 988.51 | Release kernels, Linux only |
| CMP 170HX | 250 W | 1.9.55 | 94.17 | 814.76 | Shared with verifier |
| A100 SXM4 80 GB | 400 W | 1.9.51 | 305 | 2100 | Release executable |
| Radeon RX 7600 XT | 165 W | 1.9.51 | 78.5 | 269 | OpenCL |
| Radeon Instinct MI50 | 225 W | 1.9.51 | — | 284 | OpenCL, TESS only |
| Radeon Instinct MI50 | 225 W | 1.9.49 | 19.9 | 287 | OpenCL, short thermal-limited run |

The fleet has measurements for the **RTX 4070 Ti SUPER** and **RTX 5070 Ti**. The base RTX 4070 and RTX 5070 have no verified measurement here.

Historical benchmarks and their test conditions are recorded with each release. [22 November models](neb-1.9.55-fleet.md) · [21 November models](https://github.com/ocminer/suprminer/blob/v1.9.52/README.md) · [19 November models](https://github.com/ocminer/suprminer/blob/v1.9.49/README.md) · [All cards (CSV)](neb-1.9.56-card-coverage.csv)

## Workloads

| Pair | Kepler model hash | TESS model hash |
|:---:|---|---|
| A | `29c0260f417e34d2ecfb2f558e2a9a2602f1e5c331a8a7240ce13fbf75415cf9` | `ffe15bbc078468fdd1eec160a64c68201daab84aa2aa05ce7b684716e46bd0c2` |
| B | `af945631629b2128f545f94f8f9eab1d8d919e34d0523070402ede5cfe0e45c7` | `1b61e38033d17a1c887a1cca1704c04a68cb835b41cc6152162ac6cc4dea57cf` |

The dataset was the NEB 1.0.1 mainnet `neb-datasets.bin`. Network training changes the rates of both slots. For data from other cards and earlier weights, see the v1.9.55 fleet measurements. [CSV for 1.9.56](neb-1.9.56-fleet.csv) · [Earlier fleet measurements](neb-1.9.55-fleet.md)
