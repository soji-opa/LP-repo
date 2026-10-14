# La Palma: mathematical formulation and software correspondence

**Scope.** The model described here follows the inspected `LaPalma_FCUC_35Hz.gms` and LP35 notebook text. Symbols are mapped to the actual source variables. It is not a plant-validated dynamic frequency model.

## 1. Indices, decisions and units
Let (t\in\{1,\dots,24\}) denote an hourly interval; (i\in\{1,\dots,11\}) a dispatchable generator; (b) a production-cost block; (j) a start-up category. (x_{ti}\in\{0,1\}) is generator commitment, (y_{ti}) startup and (z_{ti}) shutdown; (g_{ti}\) is dispatch [MW], `g_lin(t,i,b)` its piecewise blocks, and `curt(t)` renewable curtailment [MW]. Native objective coefficients are **kEUR**; the export multiplies costs by 1000 for EUR.

## 2. Objective and hourly adequacy
The source's `totalCost` equation minimizes
\[
 C=\sum_{ti}a_ix_{ti}+\sum_{tib}k_{ib}g_{tib}
   +\sum_{tij}c^{SU}_{ij}\,suc_{tij}
   +c^{curt}\sum_t curt_t.
\]
Demand balance (`powerBalance`) is
\[
 \sum_i g_{ti}+P_t^{RES}-curt_t=d_t.
\]
Here `RES_det(t)` is renewable availability, **not** generator reserve. Generation satisfies `sumBlocks`, `minimumGeneration`, and `blockLimits`, while the commitment transition is (x_{ti}-x_{t-1,i}=y_{ti}-z_{ti}). `minimumUpTime` and `minimumDownTime` enforce temporal logic; `rampUpFirst`/`rampDownFirst` apply the previous-day output, and subsequent equations couple within-day dispatch. Startup categories use `suc_sl` age thresholds and binary `suc(t,i,j)`.

## 3. Post-outage features
For a credible trip of generator (i) at time (t), the source defines surviving aggregate inertia energy [MW s],
\[
 H^{post}_{ti}=\sum_{k\ne i}H_k S_k x_{tk}.
\]
The corresponding gain [MW/Hz] is
\[
 G^{post}_{ti}=\sum_{k\ne i}\frac{K_kS_k}{50}x_{tk},
\]
while surviving nominal headroom [MW] is
\[
 R^{post}_{ti}=\sum_{k\ne i}(\overline{P}_kx_{tk}-g_{tk}).
\]
The loss magnitude is (L_{ti}=g_{ti}) [MW]. In the code these are `Hafter`, `Gafter`, `Rafter`, and `g(t,i)`. Crucially, the source excludes the tripped unit from all *surviving* aggregates, and includes all eleven generators in the available fleet.

## 4. RoCoF and quasi-steady-state security
The source imposes (`rocof`) (2H^{post}_{ti}\times 2.5/50\geq L_{ti}). This corresponds to (\lvert\mathrm{RoCoF}(0^+)\rvert\leq 2.5\,\mathrm{Hz/s}) in the model convention. Its reserve sufficiency rule (`qss`) is (R^{post}_{ti}\geq L_{ti}), with no damping credit in the active GAMS equation. This must not be silently conflated with the damping convention in the dynamic SODE response.

## 5. Second-order frequency-response model (Python)
With (Δ f=f-f_0) [Hz], a generator outage (L) [MW], surviving inertia energy (E) [MW s] and delivered primary-response powers (r_k^{del}) [MW], the notebook documents
\[
\frac{2E}{f_0}\frac{d\Delta f}{dt}
=\sum_{k\ne i} r_k^{del}(t)-L-D_{Hz}\Delta f(t).
\]
The documented single-generator transfer function is
\[
 \frac{r_k(s)}{\Delta f(s)}
 =-G_k\frac{1+b_{1k}s}{1+a_{1k}s+a_{2k}s^2}.
\]
The accepted model caps delivered unit response by available headroom **at the output**, not by mutating the numerical ODE state. Source damping convention: (D_{Hz}=0.01P_D/50) [MW/Hz]. This differs from a literal 1% of load per Hz. The 3.5-Hz classification threshold is (f_{min}\geq 46.5\) Hz. The correct numerical integration tolerances and nadir-refinement strategy belong to the frozen notebook and case parameter contract; neither has been changed by this curation.

## 6. Calibrated affine ML constraint
Let raw four-feature input (\phi_{ti}=(L,H^{post},G^{post},R^{post})). Calibration maps a linear score to a nominal probability; requiring (p\geq p^\star) produces a linear inequality when the calibrated sigmoid slope is positive. The actual deployed GAMS expression is
\[
 k_0+k_EH^{post}_{ti}+k_GG^{post}_{ti}
 +k_LL_{ti}+k_RR^{post}_{ti}
 +M_i(1-x_{ti})\geq0.
\]
`lpK0`, `lpKE`, `lpKG`, `lpKL`, `lpKR` and `lpBigM` are read from frozen `LP35_Calibrated.inc`; they are **not** inferred from this document. The (M_i) term relaxes the inequality when the candidate generator is offline; valid source bounds and the sign of calibration must be checked.

The principal probability screening threshold is (p^\star=0.99). The `REF050`, `REF090` and `REF095` sensitivity runs reuse the source's explicitly recorded SGD-Log reference fitting decision. Probability 0.99 is **not** a certified physical risk bound.

## 7. Grouping and statistical scope
The accepted LP35 scheme uses parent-grouped out-of-fold calibration with three inner folds, and repeated outer assessment of the whole fitting/calibration procedure. Parent grouping prevents dispatch/outage siblings from leaking between train and validation. Original source population is rare-event: the handover reports 50 unsafe 3.5-Hz labels, only six unsafe events in the held-out test, and two retained noninformative outer-fold failures. This matters when discussing uncertainty and false-negative risk.

## 8. Rolling 24-hour linkage
One season consists of seven linked 24-h optimizations. The final (x_i), (g_i), consecutive on-hours and off-hours of day (d) are saved to `state.gdx` and loaded for day (d+1), with method/campaign/season/day identity checks. Excel-rounded state is not used for this handoff. A failed previous day blocks the next day; no default state is fabricated.

## 9. What is not implemented
No aggregate-frequency model can certify regional inertia distribution, locational RoCoF or field behaviour. No network-constrained OPF or independent high-fidelity plant validation is demonstrated by this La Palma GAMS source. Synthetic inertia, batteries, alternative mixed-integer solvers and new nadir models are future extension points, not released capabilities.
