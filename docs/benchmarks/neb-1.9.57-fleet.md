# Suprminer v1.9.57 NEB measurements

Each row compares the same GPU on the same trained mainnet Kepler model at height 7652, replayed on Linux. Rates are warm measurements and vary with model weights.

| GPU | Power allowance | v1.9.56 | v1.9.57 | Gain |
| --- | ---: | ---: | ---: | ---: |
| RTX 5090 | 420 W | 177.05 MH/s | **247.99 MH/s** | +40.1% |
| RTX 5080 | 400 W | 135.85 MH/s | **193.37 MH/s** | +42.3% |
| RTX 3070 | 250 W | 29.50 MH/s | **42.01 MH/s** | +42.4% |

**RTX 5090.** Two warm comparisons on the same board at its existing 420 W allowance.

**RTX 5080.** Two runs per version on the same board. Each run contributed five warm five-second jobs.

**RTX 3070.** Dense Kepler followed by TESS on the same board. Warm Kepler windows lasted about six seconds.

[Download the measurements as CSV](neb-1.9.57-fleet.csv)
