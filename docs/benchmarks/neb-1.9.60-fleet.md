# Suprminer v1.9.60 NEB benchmarks

Each card ran the same recorded Kepler and TESS models on Linux at its maximum board power limit, for 60 seconds per model. Each figure is the median of four completed ten-second jobs after warm-up. Both RTX 5080 rows use the Linux hotfix. Hashrate varies with the block. All submitted shares passed independent verification.

| GPU | Power limit | Kepler 9266 (MH/s) | TESS 9317 (MH/s) |
|---|---:|---:|---:|
| RTX 5090 | 600 W | 1,208.90 | 7,034.94 |
| RTX 5080 (PCIe ×16) | 400 W | 642.92 | 3,047.62 |
| RTX 5080 (PCIe ×1) | 400 W | 617.24 | 3,081.40 |
| RTX 5070 Ti | 350 W | 485.40 | 2,514.87 |
| RTX 4070 Ti SUPER | 285 W | 451.18 | 2,138.99 |
| RTX 3070 | 250 W | 224.83 | 928.06 |
| RX 7900 XTX | 350 W | 370.84 | 1,880.43 |

The RTX 4070 Ti SUPER started with 212 MiB of GPU memory allocated to a background process.

On the ×1 RTX 5080, Kepler 9266 measured 10.21 MH/s with the original Linux v1.9.60 defaults, 589.44 MH/s with the manual override, and 617.24 MH/s with the automatic hotfix. Published v1.9.59 reached 588.24 MH/s on the same card at 400 W.

## Matched comparisons with v1.9.59

The RTX 5070 Ti at 350 W gained **38.7% on Kepler 9098** (243.44 to 337.77 MH/s) and completed **14.1% more hashes in the first 36 seconds of TESS 7653** after switching from Kepler. The RX 7900 XTX at 350 W gained **131.1% on Kepler 10464** and **45.1% on TESS 10669** in matched 50-second tests. All comparisons used the published Linux v1.9.59 and v1.9.60 binaries.

| GPU | Power limit | Kepler 10464, v1.9.59 → v1.9.60 (MH/s) | TESS 10669, v1.9.59 → v1.9.60 (MH/s) |
|---|---:|---:|---:|
| RX 7900 XTX | 350 W | 60.06 → 138.82 (+131.1%) | 1,758.33 → 2,551.32 (+45.1%) |

The XTX rates above are medians of three completed ten-second jobs per model. TESS was still ramping up during the 50-second runs. The 350 W limit applies to this comparison.
