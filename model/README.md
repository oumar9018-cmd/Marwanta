# MARWANTA — TLA+ Model (Authorized Configuration Only, Frozen A19)

**Authorization:** Approval Record 2026-11-05
(`model/authorization/MARWANTA_MODEL_AUTHORIZATION_APPROVAL_RECORD.md`,
decision log in `model/authorization/MARWANTA_L0_DECISION_SHEET.md`).
Authorized configuration: (Alternative A, FC-1, prospective, n/a,
specified-test, Convention A, boolean-quorumLost,
NORMAL / NEGATIVE-CONTROL / CRASH / PARTITION families,
bounds: 4 validators, heights 0..4).
Families NOT authorized: MIGRATION, OUT-OF-ASSUMPTION.
Model construction scope: Model Authorization Sheet §2–§8.
This directory is the model directory, separate from the spec
(`../spec/`) and from the frozen prototype (`../prototype-local/`).

## Files

- `Marwanta.tla` — the model spec, **A19, 922 lines** (md5
  `47fd0e5a1c2ccfabcad9502ca5ce2353`). Single state record `st`.
- `MarwantaDiag.tla` — diagnostic variant, A19, 980 lines (md5
  `a0bf7883e1b8f1ed6873e324c8530090`). Consensus-only actions;
  same Init, subset Next, same invariants. See its header for the
  subset argument.
- `configs/` — family configs (MaxSteps 10: NORMAL, CRASH,
  PARTITION, NEGATIVE-CONTROL) and diagnostic configs (TRACE-S,
  GAP-TRACE, TRACE-S-BothFinal, SELPROBE, GAP-PREFIX).
- `raw-output-10/` — TLC raw output for the authorized family runs.
- `raw-output-diag/` — TLC raw output + run log for the diagnostics.
- `evidence/` — `MODEL_EVIDENCE_REPORT.md`, `evidence.json`,
  `FIDELITY_MATRIX_REVERIFIED.md`.
- `traces/` — counterexample / proof traces produced by TLC.

## Tooling

- TLC: tla2tools.jar, version 2026.10.30.154139.
- Java: Temurin JRE 17.0.21.
- Runs use `-deadlock` (it DISABLES deadlock checking — the flag's
  double-negative naming; TLC checks for deadlock by default). The
  bounded model has intentional terminal states (MaxSteps reached),
  so a terminal state is expected, not an error. A run launched
  without the flag stops early on a false deadlock report (observed
  2026-11-05).
- Heap: `-Xmx5g` for the large runs. `-Xmx768m` collapses throughput
  once the on-disk state store grows past ~110M states.

## How to run

```sh
java -Xmx5g -XX:+UseParallelGC -cp tla2tools.jar tlc2.TLC -deadlock \
  -checkpoint 5 -workers 2 -config configs/GAP-TRACE.cfg MarwantaDiag
```

Expected results are recorded per run in `evidence/evidence.json`
and in `MODEL_EVIDENCE_REPORT.md`. State checkpoints (`states/`,
tens of GB) are not included in this repository.

## What the model checks (and does not check)

Checked as TLC invariants (per config, see configs): I-Safety,
I-Prefix, I-PathGateEdge, I-Lock, I-GC, I-QC, I-P0-ClaimOrder,
I-RecoveryNoWrongLock, I-SafeModeNoVotes, I-FreezeNoTransition,
I-NoWallClockAbort, I-RecoveryTermination (conditional, vacuous in
bounds while DeadlineD = 10 is unreachable), I-ContiguousLogPrefix,
NeverKnown, NoExit / NoExitExceptApproved, StaleNeverFinalises,
plus S7Containment and StaleContainment in NEGATIVE-CONTROL runs.

NOT checked / NOT claimed by this model (see fidelity matrix):
general theorems (bounded checks support, never close, general
claims); real replay, DA bound, weakest-validator feasibility,
real storage/WAL/fsync semantics, real SafeMode enforcement, real
S7 correctness, gap formation liveness, consumer completeness,
aggregation security (A3, separate), B_eff in reality (R1 only),
deadline expiry (D = 10 test blocks, unreachable within heights
0..4 — Convention A arithmetic verified by calculation, not by a
TLC trace), migration (family not authorized), fork-choice at vote
time (FC-1 applied at finalisation only), QC-derived lock
derivation (lock = highest-view voted block, A2).

## Model status (frozen 2026-11-06)

- NORMAL / CRASH / PARTITION @ MaxSteps 10: PASS, complete — but
  VACUOUS for finalisation (no non-genesis block can finalise
  within 10 steps; minimum attempt is 13 actions).
- NEGATIVE-CONTROL re-run @10: INCOMPLETE (134.6M distinct states
  explored, no violation found, state graph not exhausted).
- TRACE-S A19 (main chain): PASS, complete, IPrefix HOLDS.
- GAP-TRACE A19 (gap edge): PASS, complete, IPrefix HOLDS.
- TRACE-S-BothFinal A19: h1+h2 finalise consecutively (proof trace
  in `traces/`).
- Settlement safety (C1–C4): WITHHELD pending its mandatory
  verification blocker.
