# Verification matrix — La Palma staging source

| Check | Status | Evidence or remaining work |
|---|---|---|
| Uploaded six Jupyter sources read as valid notebook JSON | PASS | All six parsed in the source audit |
| Saved code-cell output records show no exception output | PASS (archived metadata only) | **Not** a fresh Run All execution |
| 35 GAMS UC/security equation definitions identical between uploaded LP35 and historical weekly model after whitespace normalization | PASS (static) | Source text diff, not solver run |
| 46.5 Hz explicit constraint in LP35 GAMS | PASS (static) | `lpNadirHz` assertion |
| GDX previous-day campaign/method/season/day identity checks present | PASS (static) | `state.gdx` handoff |
| Source-to-exported cuts and Big-M equality | NOT RUN | Requires `LP35_Calibrated.inc` and frozen model artifacts |
| Internal numerical include file content and fingerprints | NOT RUN | `inc.zip` binary could not be opened here |
| Actual GAMS source fingerprint equality to LP35 deployment | NOT RUN | Raw-byte reconciliation needed |
| Full notebook clean-kernel runs | NOT RUN | Local execution service unavailable; original working data also needed |
| GAMS 24.9 native compile/solve on Windows | NOT RUN | Must be executed in user's GAMS IDE |
| Objective / 336-daily schedule parity | NOT RUN | Frozen GDX/Excel results not part of staging |
| Historical SFR field validation | NOT APPLICABLE | SFR is an archived model comparator, not field truth |
| Redistributions rights & licence sign-off | NOT RUN | Third-party archive excluded |
| Public Zenodo DOI assigned | NOT APPLICABLE | No archive published |

**Release designation:** *source stage only*. It is incorrect to describe this branch as fully reproducible, independently validated, physically calibrated or publication-final.

### Solver version note
Recorded input (p^\star) thresholds, nadir definitions and coefficient IDs are frozen. Do not refit or change parameters merely to silence a test failure.
