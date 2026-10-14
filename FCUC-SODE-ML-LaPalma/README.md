# Frequency-Constrained Unit Commitment with SODE-Labelled Affine Surrogates
## La Palma research source — SEGAN-D-26-02403

**Status: source-curation preview; not an independently executed software release.**

This is the **La Palma 11-generator** component of the research manuscript *Frequency-constrained unit commitment using machine learning surrogates*. It preserves the accepted **LP35_6259c70d0303** campaign and its 50 Hz nominal / **46.5 Hz minimum frequency** (3.5 Hz maximum nadir-deviation) criterion. The separate **LP4S_74ee31255d0f** experiment used 47 Hz and is archived, not blended into the LP35 evidence.

This source-stage is provided now to make the model and notebooks visible and citable by a future release. **It is not yet a complete numerical-reproduction package.** The historical case parameter file `Data_LaPalma/LP_Case.json`, numeric `.inc` tables, generated `LP35_Calibrated.inc` and `LP35_Jobs.inc`, CPLEX option file, saved learning artifacts and frozen reference-results data are not included at this stage. Those exact dependencies must be reconciled from the original source archives and assessed for redistribution rights. Do not invent or substitute them.

### What is in this source stage
- The primary LP35 Jupyter sequence in `Notebooks_LaPalma/` (code cells unchanged; saved execution outputs removed to avoid publishing machine-local paths).
- The actual LP35 GAMS model and GAMS IDE launcher, annotated with explanatory GAMS comments, in `GAMS_LaPalma/`.
- The original 3.0 Hz notebooks and GAMS history under `historical_3Hz/`.
- The complete supplied JSON deployment manifests, recording campaign and coefficient identities and upstream file fingerprints.
- Mathematical derivations, file dependency maps, GAMS IDE instructions and the explicit verification limitations.

### Expected primary workflow (once dependencies are supplied and checked)
1. In Anaconda/Jupyter, open `Notebooks_LaPalma/01_LP35_Prepare_Labels.ipynb`. **It consumes the corrected 3-Hz source/label library; it does not simulate fresh trajectories.**
2. Open `Notebooks_LaPalma/02_LP35_Train_and_Export.ipynb`. It performs grouped OOF calibration and exports LP35 coefficients, deployment metadata and the GAMS job include. The attached source includes a numerical calibration repair; do not refit without a deliberate reproduction run.
3. In the **GAMS 24.9 IDE**, set the working directory to `GAMS_LaPalma`, open `Run_LaPalma_35Hz.gms` and press F9 **only if intentionally rerunning the full campaign**. The launcher schedules 336 individual 24-h solves; this is not a quick functionality test.
4. Open `Notebooks_LaPalma/03_LP35_Process_and_Plot.ipynb` to audit the saved LP35 schedules and compare against separately sourced BC/RESERVE and archived SP/SFR results, without rerunning GAMS.
5. For figures-only reproduction, use frozen verified plots/data when those datasets have been cleared for inclusion.

See [GAMS IDE guide](docs/GAMS_IDE_Guide.md), [mathematical formulation](docs/Mathematical_Formulation.md), [dependency map](docs/Source_And_Dependencies.md), and [verification matrix](verification/STATUS.md).

### The numerical model at a glance
Unit commitment is an aggregate 24-hour mixed-integer linear program (MILP) with thermal costs, startups, renewable curtailment, power balance, generation blocks, ramp limits, and up/down times. Each online generator is a candidate loss. The LP35 calibrated classifier supplies a linear security inequality using post-outage inertia energy, aggregate frequency-response gain, outage size and surviving generator headroom. The parent numerical frequency-response law is second order with unit-level response limits.

**No DC transmission network is optimized by this La Palma model.** The presence of historical network input sets should not be misrepresented as a DC power-flow constraint.

### Reproduction evidence and limitations
The original scientific run reported 336 ML schedules, 56 reused baseline days, 28 historical SP days, and 55,048 events in the current post-UC cohort, plus 4,131 SP events. These are **archived findings**, not numbers independently reproduced by this source-stage. All nine principal ML configurations had observed nadir crossings; no zero-violation claim is made. The external SFR comparison is model-to-model evidence, not field validation.

### Licences and data rights
This branch does **not** grant a licence to original third-party material, Raja's archives, GAMS, CPLEX, or proprietary input data. No blanket software licence or Zenodo DOI is asserted. The repository owner should establish copyright/permission before publishing the final archived release. Alternative solvers have not been tested.

### Publication and citation
Manuscript identity: SEGAN-D-26-02403, *Frequency-constrained unit commitment using machine learning surrogates*. Software citation and permanent release DOI are **pending**.
