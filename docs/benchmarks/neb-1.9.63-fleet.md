# Suprminer v1.9.63 NEB benchmarks

## Kepler on RTX 50 cards and the RTX 3070, v1.9.62 against v1.9.63

Recorded pool models of 27 November 2026 were replayed on Linux, each Kepler block for 45 s followed by its TESS
block for 15 s. Each card ran at its maximum board power limit. The Kepler figure is the settled 10-second
hashrate; the TESS figure is the average over the first 15 s of the TESS block. Shares were counted at a fixed
difficulty of 67,108,864 and every share was verified on the CPU. Left of each arrow is the published v1.9.62
Linux build, right is v1.9.63, on the same card.

| GPU | Power limit | Kepler 13038 (MH/s) | TESS 13039 (GH/s) |
|---|---:|---:|---:|
| RTX 5090 | 600 W | 512.7 → 643.2 (+25.5%) | 10.77 → 10.73 (-0.4%) |
| RTX 5080 (PCIe ×16) | 400 W | 356.8 → 397.2 (+11.3%) | 5.68 → 5.66 (-0.4%) |
| RTX 5080 (PCIe ×1 riser) | 400 W | 366.7 → 402.8 (+9.8%) | 5.66 → 5.71 (+0.9%) |
| RTX 5070 Ti | 350 W | 297.5 → 334.3 (+12.4%) | 4.46 → 4.47 (+0.3%) |
| RTX 3070 | 250 W | 85.2 → 95.0 (+11.5%) | 1.49 → 1.50 (+0.2%) |

The Kepler hashrate depends on the model of the block. Further Kepler models of the same day (MH/s, settled):

| GPU | Kepler block | v1.9.62 | v1.9.63 | Change |
|---|---|---:|---:|---:|
| RTX 5090 | 13042 | 517.5 | 636.9 | +23.1% |
| RTX 5090 | 13146 | 487.5 | 594.3 | +21.9% |
| RTX 5090 | 13144 | 1,331.7 | 1,428.5 | +7.3% |
| RTX 5090 | 13142 | 1,460.0 | 1,545.7 | +5.9% |
| RTX 5090 | 13094 | 889.7 | 913.7 | +2.7% |
| RTX 5090 | 13090 | 778.6 | 779.0 | +0.1% |
| RTX 5080 (PCIe ×16) | 13052 | 394.7 | 442.9 | +12.2% |
| RTX 5080 (PCIe ×16) | 13066 | 383.5 | 428.8 | +11.8% |
| RTX 5080 (PCIe ×16) | 13306 | 685.1 | 738.9 | +7.9% |
| RTX 5080 (PCIe ×16) | 13136 | 787.6 | 850.1 | +7.9% |
| RTX 5080 (PCIe ×16) | 13304 | 524.5 | 556.7 | +6.1% |
| RTX 5080 (PCIe ×16) | 13132 | 576.5 | 607.2 | +5.3% |
| RTX 5080 (PCIe ×1 riser) | 13090 | 418.4 | 452.3 | +8.1% |
| RTX 5080 (PCIe ×1 riser) | 13304 | 532.8 | 540.9 | +1.5% |
| RTX 5080 (PCIe ×1 riser) | 13132 | 583.5 | 590.5 | +1.2% |
| RTX 5080 (PCIe ×1 riser) | 13268 | 540.8 | 546.9 | +1.1% |
| RTX 5080 (PCIe ×1 riser) | 13306 | 694.5 | 695.0 | +0.1% |
| RTX 5070 Ti | 13090 | 341.3 | 372.7 | +9.2% |
| RTX 5070 Ti | 13094 | 388.8 | 412.7 | +6.1% |
| RTX 5070 Ti | 13204 | 653.4 | 677.7 | +3.7% |
| RTX 5070 Ti | 13196 | 984.7 | 1,020.0 | +3.6% |
| RTX 5070 Ti | 13206 | 750.9 | 778.3 | +3.6% |
| RTX 5070 Ti | 13194 | 864.1 | 894.7 | +3.5% |
| RTX 5070 Ti | 13268 | 439.2 | 444.8 | +1.3% |
| RTX 3070 | 13052 | 108.9 | 120.8 | +10.9% |
| RTX 3070 | 13060 | 107.6 | 119.1 | +10.7% |
| RTX 3070 | 13042 | 99.4 | 107.8 | +8.5% |
| RTX 3070 | 13094 | 176.9 | 181.4 | +2.5% |
| RTX 3070 | 13194 | 413.6 | 412.5 | -0.3% |

On the RTX 5090 part of the gain on lighter Kepler models needs 20 GiB of free system memory and a PCIe link of
×8 or wider; without them the card uses its video memory alone. The measurements are from Linux.

## Other cards

NEB on the other NVIDIA cards and on Radeon uses the same GPU code as v1.9.62.
[v1.9.62 measurements](neb-1.9.62-fleet.md) · [v1.9.61 measurements](neb-1.9.61-fleet.md)
