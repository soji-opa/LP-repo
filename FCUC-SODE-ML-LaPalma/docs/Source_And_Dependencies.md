# Source authority, dependencies and preservation policy

## Authoritative primary identity
- Manuscript: SEGAN-D-26-02403.
- Executed LP35 campaign: `LP35_6259c70d0303`.
- Dynamic model identity: `0899f2bc59cecb10`.
- Primary minimum frequency: **46.5 Hz**; historical limit: **47 Hz**.
- The accepted LP35 post-processing notebook references 336 accepted ML daily schedules (four seasons, seven days, 12 model/threshold variants) and 56 reused BC/RESERVE schedules. The 28 archival SP days originate separately and must not be relabelled as new LP35 GAMS solves.

## Required dependencies (not all redistributed)
```text
Data_LaPalma/LP_Case.json                [NOT PACKAGED]
Data_LaPalma/Corrected/<old-model>/...   [NOT PACKAGED]
         |
Notebooks_LaPalma/01_LP35_Prepare_Labels.ipynb
         |  -- Data_LaPalma/Threshold35/<LP35-model>/LP_SODE_Labels.csv
Notebooks_LaPalma/02_LP35_Train_and_Export.ipynb
         |  -- GAMS_LaPalma/inc/LP35_Calibrated.inc      [NOT PACKAGED]
         |  -- GAMS_LaPalma/inc/LP35_Jobs.inc            [NOT PACKAGED]
         |  -- GAMS_LaPalma/LP35_Deployment.json
GAMS_LaPalma/Run_LaPalma_35Hz.gms
         |  -- inc/LP35_Jobs.inc
         v
GAMS_LaPalma/LaPalma_FCUC_35Hz.gms
         +-- Input_Data_LaPalma_Weekly.gms
         |     +-- numeric input `.inc` tables         [NOT PACKAGED]
         +-- inc/LP35_Calibrated.inc
         +-- GAMS 24.9 / CPLEX option file               [NOT PACKAGED]
         +-- previous day state.gdx (days 2-7)
         v
Notebooks_LaPalma/03_LP35_Process_and_Plot.ipynb
         +-- LP35 results, historic BC/RESERVE, SP and SFR [NOT PACKAGED]
```

## Named numerical table includes
`block_max.inc`, `k.inc`, `start_up_sw.inc`, `start_up_sl.inc`, `aux2.inc`, `aux3.inc`, `aux4.inc`, `aux5.inc`, `aux6.inc`, `aux7.inc`, `aux8.inc`, `aux9.inc`, `aux10.inc`, `auxinertia.inc`, `auxmbase.inc`, `auxk.inc`, `d_seasons.inc`, `RES_seasons.inc`. Their expected hashes are in `LP35_Deployment.json`. These are referenced by the GAMS input source, but have not been republished by this source-stage.

## Scientific source policy
Each .ipynb code cell from the uploaded user notebook remains identical. GitHub copies strip saved *outputs* and execution counters (which can contain personal Windows paths and older intermediate figures) and insert introductory explanatory Markdown cells only. The original uploaded notebook files are not altered. The GAMS copies only add `$ontext`/comment sections before existing statements; the mathematical statements and solver flow are unchanged. This is a curation claim about source text, not numerical reproduction.

**No original Raja archive is republished.** The archival SP GAMS material is kept as source history for provenance, and redistribution permission for any Raja-derived `.inc` material must be confirmed before a final licensed software release.
