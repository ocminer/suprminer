# Suprminer v1.9.59 AMD NEB benchmarks

Linux OpenCL measurements against the published v1.9.58 AMD binary. Each row uses the same GPU, trained mainnet model, replayed headers and share target. Rates are millions of evaluated attempts per second. The power column gives the existing firmware allowance.

| GPU | Power | Height and model | v1.9.58 MH/s | v1.9.59 MH/s | Change |
|---|---:|---|---:|---:|---:|
| RX 7900 XTX | 350 W | 7652 Kepler | 18.86 | 30.78 | +63.21% |
| RX 7900 XTX | 350 W | 7653 TESS | 982.61 | 1,085.72 | +10.49% |
| RX 7900 XTX | 350 W | 7948 Kepler | 220.03 | 239.46 | +8.83% |
| RX 7900 XTX | 350 W | 7949 TESS | 1,252.62 | 1,377.44 | +9.97% |
| RX 7600 XT | 165 W | 7652 Kepler | 5.52 | 12.91 | +133.71% |
| RX 7600 XT | 165 W | 7653 TESS | 321.69 | 375.41 | +16.70% |
| Instinct MI50 | 225 W | 7652 Kepler | 5.61 | 9.75 | +73.62% |
| Instinct MI50 | 225 W | 7653 TESS | 342.55 | 366.35 | +6.95% |

Kepler 7652 exercises the dense path. Other trained models on the same card can run at very different speeds. The MI50 final comparison uses the same six-second warm job on both versions, with one Kepler seed and two TESS seeds. An earlier two-seed Kepler crossover measured 5.62 → 9.78 MH/s. The CSV gives timing windows and matched seed counts for each row.

The RX 7600 XT Kepler result uses the final protected development binary. The other rows were recorded on protected candidates that contain the same active compute kernels for those measurements. Timing and share counts are from the physical runs.

The RX 9070 XT was unavailable for this hardware sweep. The [v1.9.60 benchmarks](neb-1.9.60-fleet.md) include its full-power Kepler and TESS rates.
