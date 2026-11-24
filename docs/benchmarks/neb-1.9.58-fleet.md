# Suprminer v1.9.58 NEB benchmarks

The same physical GPU ran both versions on identical captured mainnet weights in each row. All tests used Linux, the NEB 1.0.1 dataset, the listed board power allowance and automatic GPU boost. Rates are millions of evaluated attempts per second. The chain trains its models over time, so compare versions within a row.

## Dedicated cards

| GPU | Power allowance | Mainnet model | v1.9.57 MH/s | v1.9.58 MH/s | Change |
|---|---:|---|---:|---:|---:|
| RTX 5090 | 600 W | Kepler 7812 | 488.59 | **573.08** | +17.3% |
| RTX 5080 | 400 W | Kepler 7652 | 195.99 | **196.35** | +0.2% |
| RTX 5080 | 400 W | TESS 7653 | 2,290.55 | **2,366.59** | +3.3% |
| RTX 5080 | 400 W | Kepler 7650 | 324.84 | **415.57** | +27.9% |
| RTX 5080 | 400 W | TESS 7651 | 2,596.58 | **2,687.78** | +3.5% |
| RTX 5080 | 400 W | Kepler 7752 | 452.95 | **502.61** | +11.0% |
| RTX 5080 | 400 W | TESS 7753 | 2,204.20 | **2,278.33** | +3.4% |
| RTX 5070 Ti | 350 W | Kepler 7652 | 115.21 | **163.10** | +41.6% |
| RTX 5070 Ti | 350 W | TESS 7653 | 1,887.02 | **1,953.44** | +3.5% |
| RTX 5070 Ti | 350 W | Kepler 7650 | 266.96 | **345.32** | +29.4% |
| RTX 5070 Ti | 350 W | TESS 7651 | 2,144.66 | **2,215.36** | +3.3% |
| RTX 5070 Ti | 350 W | Kepler 7752 | 372.09 | **414.35** | +11.4% |
| RTX 5070 Ti | 350 W | TESS 7753 | 1,819.00 | **1,878.11** | +3.2% |
| RTX 3070 A | 250 W | Kepler 7652 | 41.34 | **49.78** | +20.4% |
| RTX 3070 A | 250 W | TESS 7653 | 674.32 | **699.40** | +3.7% |
| RTX 3070 A | 250 W | Kepler 7650 | 141.41 | **141.70** | +0.2% |
| RTX 3070 A | 250 W | TESS 7651 | 793.03 | **795.50** | +0.3% |
| RTX 3070 B | 250 W | Kepler 7652 | 41.78 | **49.65** | +18.8% |
| RTX 3070 B | 250 W | TESS 7653 | 697.44 | **710.98** | +1.9% |
| RTX 3070 B | 250 W | Kepler 7650 | 143.72 | **143.52** | -0.1% |
| RTX 3070 B | 250 W | TESS 7651 | 809.91 | **806.27** | -0.4% |
| RTX 3070 C | 240 W | Kepler 7652 | 41.16 | **49.81** | +21.0% |
| RTX 3070 C | 240 W | TESS 7653 | 722.16 | **713.31** | -1.2% |
| RTX 3070 C | 240 W | Kepler 7650 | 141.60 | **141.14** | -0.3% |
| RTX 3070 C | 240 W | TESS 7651 | 803.74 | **800.86** | -0.4% |

The RTX 5090 ran the published v1.9.57 Linux binary and the final v1.9.58 qualification binary in reversed order on two header sequences. The rate is the mean of the two per-run medians across eight complete six-second jobs from seconds 24–72. Valid shares arriving before the next job rose from **22,199 to 25,896 (+16.7%)** at difficulty 2²¹. The original NEB CPU implementation verified all **73,833** submissions.

The remaining rows use Linux development builds measured during v1.9.58 qualification against the published v1.9.57 binary. They give warm medians on the same captured model and board per comparison. The 250 W RTX 3070s each ran all four models for 36 seconds per model. The third RTX 3070 has a 240 W board limit. Rates close to parity can change with boost and the short measurement windows.

## TESS slowdown fixed

Two captured TESS models exposed a large slowdown in v1.9.57. These numbers measure recovery on those specific weights. Other TESS models in the table above show more typical changes.

| GPU | Power allowance | Mainnet model | v1.9.57 MH/s | v1.9.58 MH/s | Change |
|---|---:|---|---:|---:|---:|
| RTX 5080 | 400 W | TESS 7949 | 69.44 | **3,009.00** | +4233.2% |
| RTX 5070 Ti | 350 W | TESS 7969 | 52.46 | **2,740.62** | +5124.2% |
| RTX 3070 A | 250 W | TESS 7949 | 10.22 | **775.80** | +7491.0% |
| RTX 3070 B | 250 W | TESS 7949 | 10.22 | **789.56** | +7625.6% |

The RTX 5080 produced 3,009–3,015 MH/s across its v1.9.58 readings. The table uses the lower value.

## Shared CMP 170HX

| GPU | Power allowance | Mainnet model | v1.9.57 MH/s | v1.9.58 MH/s | Change |
|---|---:|---|---:|---:|---:|
| CMP 170HX | 300 W | Kepler 7652 | 57.60 | **57.42** | -0.3% |
| CMP 170HX | 300 W | TESS 7653 | 806.70 | **806.20** | -0.1% |
| CMP 170HX | 300 W | Kepler 7650 | 152.96 | **152.28** | -0.4% |
| CMP 170HX | 300 W | TESS 7651 | 909.69 | **910.45** | +0.1% |

The verifier kept running on this card. Each version ran separately for up to 24 seconds per model, with cooling between runs. Rates use the last one or two complete job measurements. Peak temperature was 80–82 °C, and all 1,376 shares from the eight slices passed the reference check. Variation was under 0.5% on these short shared runs.

[All rows and available model hashes (CSV)](neb-1.9.58-fleet.csv) · [Release download](https://github.com/ocminer/suprminer/releases/tag/v1.9.58) · [NEB pool](https://neb.suprnova.cc/)
