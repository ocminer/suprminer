# Suprminer v1.9.62 NEB benchmarks

## Block starts on RTX 50 cards, v1.9.61 against v1.9.62

Recorded pool blocks 12352 to 12359 (four Kepler and four TESS blocks; TESS 12353, 12357 and 12359 each
bring a new model) were replayed on Linux with their original announcement times. Each card ran at its
maximum board power limit. Shares were counted at a fixed difficulty of 67,108,864 and every share was
verified on the CPU. Left of each arrow is the published v1.9.61 Linux build, right is v1.9.62.

| GPU | Power limit | First 5 s of TESS 12353 / 12357 / 12359 (shares) | TESS work (Ghash) | Kepler work (Ghash) | All shares |
|---|---:|---:|---:|---:|---:|
| RTX 5090 | 600 W | 126 / 540 / 740 → 419 / 772 / 750 (+38.1%) | 538.3 → 572.8 (+6.4%) | 57.35 → 57.33 (0.0%) | 8,833 → 9,334 (+5.7%) |
| RTX 5080 (PCIe ×16) | 400 W | 51 / 120 / 187 → 207 / 430 / 380 (+184.1%) | 239.4 → 310.5 (+29.7%) | 22.29 → 31.22 (+40.0%) | 3,803 → 5,147 (+35.3%) |
| RTX 5070 Ti | 350 W | 54 / 121 / 125 → 166 / 315 / 315 (+165.3%) | 200.5 → 255.6 (+27.5%) | 23.90 → 26.23 (+9.7%) | 3,281 → 4,161 (+26.8%) |

Shares per block (K = Kepler, T = TESS; block lengths 17.3, 2.8, 14.1, 8.2, 7.2, 30.2, 45.0 and 15.0 s):

| GPU | K12352 | T12353 | K12354 | T12355 | K12356 | T12357 | K12358 | T12359 |
|---|---:|---:|---:|---:|---:|---:|---:|---:|
| RTX 5090 | 316 → 286 | 126 → 419 | 125 → 111 | 1,248 → 1,237 | 62 → 44 | 4,386 → 4,578 | 306 → 359 | 2,264 → 2,300 |
| RTX 5080 (PCIe ×16) | 103 → 113 | 51 → 207 | 36 → 72 | 351 → 707 | 6 → 33 | 2,083 → 2,508 | 192 → 230 | 981 → 1,277 |
| RTX 5070 Ti | 110 → 97 | 54 → 166 | 50 → 60 | 380 → 584 | 26 → 17 | 1,719 → 2,033 | 159 → 206 | 783 → 998 |

Kepler 12358, a heavy model mined for 45 s after the six preceding blocks: RTX 5090 458.8 → 513.2 MH/s
(+11.8%), RTX 5080 266.3 → 345.7 MH/s (+29.8%), RTX 5070 Ti 224.0 → 291.7 MH/s (+30.2%).

Short Kepler blocks before a new TESS model give a little work to the preparation of that model.
`--disable-neb-tess-predictions` turns the advance preparation off. The measurements are from Linux.

## Other cards

NEB on the other NVIDIA cards and on Radeon uses the same GPU code as v1.9.61. [v1.9.61 measurements](neb-1.9.61-fleet.md)
