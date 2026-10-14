# GAMS 24.9 IDE execution guide (Windows)

**Do not use this source stage to launch a 336-solve campaign until the missing dependencies have been supplied and checked.**

1. Extract the repository. The model expects `GAMS_LaPalma` and `Data_LaPalma` at the same project root, with the primary notebook folder named `Notebooks_LaPalma`. These names have been retained deliberately because `find_project()` in the notebooks searches for them.
2. Place the exact, permitted source `.inc` tables into `GAMS_LaPalma/inc/`. Preserve original names and bytes. Do not regenerate tables from undocumented assumptions.
3. Restore original `Data_LaPalma/LP_Case.json`, accepted corrected source data, and saved parent-label library. The archived LP35 label preparation notebook reclassifies saved dynamics; it does **not** generate raw source points.
4. Run `01_LP35_Prepare_Labels.ipynb`, then `02_LP35_Train_and_Export.ipynb` **only when intentionally reconstructing the trained model**. For a source-only inspection, skip these computational stages. They may be time-consuming and their original training artifacts are not supplied here.
5. Confirm `GAMS_LaPalma/inc/LP35_Calibrated.inc` and `GAMS_LaPalma/inc/LP35_Jobs.inc` exist, and compare source and cut fingerprints with `GAMS_LaPalma/LP35_Deployment.json`.
6. Open the GAMS 24.9 IDE, set `GAMS_LaPalma` as the working directory, open `Run_LaPalma_35Hz.gms` and press **F9**. It invokes `inc/LP35_Jobs.inc`, which schedules the model; individual days require correct previous-day accepted `state.gdx`.
7. Inspect `Results_35Hz/<campaign>/<method>/<season>/d<day>/`. The source writes `search_incumbent.gdx`, `results.gdx`, `state.gdx`, Excel workbooks and acceptance/failure markers. If Excel export alone fails, the source supports `EXPORT_ONLY=1` recovery from already accepted GDX files. Do not delete or overwrite accepted states.
8. Inspect `search_modelstat`, `search_solvestat`, objective, unrestricted best bound, MIP gap, primal/integer residuals, and whether fixed-commitment polishing was invoked. A suboptimal but independently feasible incumbent is not automatically a failure. Equally, a low MIP gap does not prove the returned point satisfies the model constraints.
9. After all native jobs finish, run `03_LP35_Process_and_Plot.ipynb` to check all saved workbooks, daily identities, dynamic assessments and historical SP/SFR comparisons. Do not run this notebook on a partial week and report that partial result as complete.

## Executed-source settings dispute
The originally uploaded `LP35_Deployment.json` records `gap_target=0.0125`, `reslim_seconds=1200`, `polish_reslim_seconds=600`. The later saved native source-check in the processed notebook reports executed `SEARCH_GAP=0.005`, `SEARCH_SECONDS=1200`, and `POLISH_SECONDS=300` for the 336 completed LP35 jobs. The readable primary GAMS source defaults to the later settings. This is a **provenance discrepancy**, not permission to alter the accepted settings or overwrite records. A full release needs the frozen compiled-source / job-override receipt.

## Historical branch is separate
The archival `LaPalma_FCUC_Weekly.gms` uses a 47 Hz criterion and includes a separate analytical SP source block. Its targeted recovery launcher is **not** part of the 46.5 Hz ML-only campaign. Do not run either historical launcher to validate primary LP35 results.
