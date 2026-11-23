# Suprminer v1.9.57 NEB measurements

Each row compares the same GPU on the same trained mainnet Kepler model at height 7652, replayed on Linux. Rates are warm measurements and vary with model weights.

| GPU | Power allowance | v1.9.56 | v1.9.57 | Gain |
| --- | ---: | ---: | ---: | ---: |
| RTX 5090 | 600 W | 229.48 MH/s | **306.69 MH/s** | +33.6% |
| RTX 5080 | 400 W | 135.85 MH/s | **193.37 MH/s** | +42.3% |
| RTX 3070 | 250 W | 29.50 MH/s | **42.01 MH/s** | +42.4% |

**RTX 5090.** The published Linux executables ran successively for 40 seconds each on the same board at its 600 W maximum. The median of the final three complete Kepler jobs rose from 229.48 to 306.69 MH/s. All 521 submissions from v1.9.56 and all 725 from v1.9.57 passed the CPU reference.

**RTX 5080.** Two runs per version on the same board. Each run contributed five warm five-second jobs.

**RTX 3070.** Dense Kepler followed by TESS on the same board. Warm Kepler windows lasted about six seconds.

[Download the measurements as CSV](neb-1.9.57-fleet.csv)
