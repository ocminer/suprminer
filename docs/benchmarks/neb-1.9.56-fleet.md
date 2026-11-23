# NEB GPU benchmarks for Suprminer 1.9.56

Linux tests used two desktop RTX 3070s and two RTX 5090s on 23 November 2026. Each measurement used the card's full firmware power allowance and automatic clocks. Rates count millions of completed evaluation attempts per second (MH/s).

## Same-card results against 1.9.55

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
