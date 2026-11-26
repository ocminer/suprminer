# Suprminer v1.9.61 NEB benchmarks

## Radeon RX 9070 XT, v1.9.60 against v1.9.61

Same card at 280 W on Linux, the same recorded Kepler and TESS models in every arm, medians of matched 60-second arms.

| GPU | Power limit | Kepler, v1.9.60 → v1.9.61 (MH/s) | TESS, v1.9.60 → v1.9.61 (MH/s) |
|---|---:|---:|---:|
| RX 9070 XT | 280 W | 235.0 → 285.5 (+21.5%) | 932.9 → 1,390.5 (+49.0%) |

A pool run measured Kepler 204.63 → 269.17 MH/s (+31.5%) with no invalid shares. Hashrate varies with the block: on the Kepler models of blocks 12210 and 12212 the card ran at the same rate with both versions.

## NVIDIA and the other Radeon cards

NEB on NVIDIA and on the other Radeon cards uses the same GPU code as v1.9.60, so the v1.9.60 measurements below apply to v1.9.61. The Linux NVIDIA builds of v1.9.61 contain the PCIe ×1 handling that v1.9.60 shipped as a separate Linux hotfix.

### v1.9.60 measurements

Each card ran the same recorded Kepler and TESS models on Linux at its maximum board power limit, for 60 seconds per model. Each figure is the median of four completed ten-second jobs after warm-up. Both RTX 5080 rows use the Linux hotfix. Hashrate varies with the block. All submitted shares passed independent verification.

| GPU | Power limit | Kepler 9266 (MH/s) | TESS 9317 (MH/s) |
|---|---:|---:|---:|
| RTX 5090 | 600 W | 1,208.90 | 7,034.94 |
| RTX 5080 (PCIe ×16) | 400 W | 642.92 | 3,047.62 |
| RTX 5080 (PCIe ×1) | 400 W | 617.24 | 3,081.40 |
| RTX 5070 Ti | 350 W | 485.40 | 2,514.87 |
| RTX 4070 Ti SUPER | 285 W | 451.18 | 2,138.99 |
| RTX 3070 | 250 W | 224.83 | 928.06 |
| RX 9070 XT | 340 W | 248.80 | 961.41 |
| RX 7900 XTX | 350 W | 370.84 | 1,880.43 |

The RX 9070 XT completed both models in one run at its 340 W limit. All 96 Kepler shares and 386 TESS shares passed verification.

The RTX 4070 Ti SUPER started with 212 MiB of GPU memory allocated to a background process.

On the ×1 RTX 5080, Kepler 9266 measured 10.21 MH/s with the original Linux v1.9.60 defaults, 589.44 MH/s with the manual override, and 617.24 MH/s with the automatic hotfix. Published v1.9.59 reached 588.24 MH/s on the same card at 400 W.

## Matched comparisons with v1.9.59

The RTX 5070 Ti at 350 W gained **38.7% on Kepler 9098** (243.44 to 337.77 MH/s) and completed **14.1% more hashes in the first 36 seconds of TESS 7653** after switching from Kepler. The RX 7900 XTX at 350 W gained **131.1% on Kepler 10464** and **45.1% on TESS 10669** in matched 50-second tests. All comparisons used the published Linux v1.9.59 and v1.9.60 binaries.

| GPU | Power limit | Kepler 10464, v1.9.59 → v1.9.60 (MH/s) | TESS 10669, v1.9.59 → v1.9.60 (MH/s) |
|---|---:|---:|---:|
| RX 7900 XTX | 350 W | 60.06 → 138.82 (+131.1%) | 1,758.33 → 2,551.32 (+45.1%) |

The XTX rates above are medians of three completed ten-second jobs per model. TESS was still ramping up during the 50-second runs. The 350 W limit applies to this comparison.

## Earlier GPUs and estimated v1.9.60 rates

The measured column gives the earlier Linux result. The estimated column models v1.9.60 on those same earlier blocks. The current fleet table above uses blocks 9266 and 9317.

| GPU | Power limit | Measured version | Kepler / TESS models | Measured MH/s, K / T | Estimated v1.9.60 MH/s, K / T |
|---|---:|---:|---:|---:|---:|
| A100 SXM4 80 GB | 400 W | 1.9.51 | 3976 / 21 Nov TESS | 305 / 2,100 | 310 / 2,300 |
| H100 80 GB | 700 W | 1.9.55 | 6232 / 6233 | 291.72 / 4,280.38 | 360 / 4,600–4,800 |
| RTX PRO 6000 Blackwell 96 GB #1 | 600 W | 1.9.55 | 6232 / 6233 | 471.08 / 7,077.50 | 580 / 7,500–7,900 |
| RTX PRO 6000 Blackwell 96 GB #2 | 600 W | 1.9.55 | 6232 / 6233 | 470.21 / 7,054 | 580 / 7,500–7,900 |
| Tesla V100 16 GB | 300 W | 1.9.55 | 6232 / 6233 | 112.43 / 988.51 | 140 / 1,100 |
| CMP 170HX (shared) | 300 W | 1.9.58 | 7652 / 7653 | 57.42 / 806.20 | 67 / 840 |
| RX 7600 XT | 165 W | 1.9.59 | 7652 / 7653 | 12.91 / 375.41 | 12.91 / 375.41 (carry-forward) |
| Instinct MI50 | 225 W | 1.9.59 | 7652 / 7653 | 9.75 / 366.35 | 9.75 / 366.35 (carry-forward) |

For each model, multiply the earlier GPU rate by the reference card’s v1.9.60 rate divided by its earlier rate on the same archived weights. The endpoints for the v1.9.55 rows show the spread between the two measured RTX reference gains. Actual rates can fall outside that range.

The RTX 5080 and RTX 5070 Ti are Blackwell references for the RTX PRO 6000. Applying their result to Hopper H100 or Volta V100 is a cross-architecture scenario with greater uncertainty. A100 and CMP 170HX use an RTX 3070 Ampere reference. The CMP shared its GPU with a verifier. RX 7600 XT and Instinct MI50 use their last measured rates as a working estimate with 0% additional gain assumed.

### Measured version changes on the reference cards

| Reference GPU | Limit | From version | Kepler / TESS models | Earlier measured MH/s, K / T | v1.9.60 measured MH/s, K / T | Measured change, K / T |
|---|---:|---:|---:|---:|---:|---:|
| RTX 3070 | 250 W | 1.9.51 | 3976 / 21 Nov TESS | 156.63/569.34 | 159.29/625.24 | +1.7% / +9.8% |
| RTX 5080 | 400 W | 1.9.55 | 6232 / 6233 | 253.64/2,388.01 | 313.26/2,546.98 | +23.5% / +6.7% |
| RTX 5070 Ti | 350 W | 1.9.55 | 6232 / 6233 | 210.44/1,890.86 | 258.61/2,106.22 | +22.9% / +11.4% |
| RTX 3070 | 250 W | 1.9.58 | 7652 / 7653 | 49.85/721.98 | 58.57/754.03 | +17.5% / +4.4% |

Both reference versions ran on the same physical GPU at its full board limit with the same models, seed, share difficulty and 60 seconds per model. The v1.9.51 comparison uses warm ten-second GPU display readings on both releases. The other comparisons use completed warm ten-second jobs. Each version ran once per reference card. Every submitted share passed independent verification. Boost and temperature can affect small differences. Estimates are rounded to about two significant digits. The 21 November A100 archive records Kepler height 3976 and TESS model `a248f95964f100ed`. The capture ended before the TESS job message recorded its height. The MI50 measurement used a six-second warm window.

[A100 and dated models](https://github.com/ocminer/suprminer/blob/v1.9.52/README.md) · [H100, RTX PRO 6000 and V100](neb-1.9.55-fleet.md) · [Shared CMP 170HX](neb-1.9.58-fleet.md) · [RX 7600 XT and MI50](neb-1.9.59-amd.md)
