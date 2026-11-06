# MARWANTA — MODEL AUTHORIZATION SHEET (PROPOSAL)

**Status:** PROPOSAL ONLY. REVIEW REQUIRED. MODEL CONSTRUCTION NOT
AUTHORIZED BY THIS SHEET. Model construction starts only after the
founder approves this sheet in an explicit message (see Approval
block, §7), AND the prerequisites in §1 are satisfied. Approving this
sheet authorizes MODEL CONSTRUCTION ONLY, under the scope below. It
does NOT approve the protocol, does NOT select any alternative,
fork-choice, or founder decision (those are selected only in the L0
Decision Sheet log), does NOT authorize prototype expansion, testnet,
mainnet, or token work, and does NOT close any RI issue, BL blocker,
invariant, obligation, or assumption.
**Companion documents (same authorization, same turn):**
`MARWANTA_L0_DECISION_SHEET.md` and
`MARWANTA_MODEL_FIDELITY_REDESIGN_BLUEPRINT_CORRECTED_REISSUE.md`.
**Model language (proposed, model-scope choice, not protocol):**
TLA+ with TLC, continuing Phase 2 tooling (tla2tools, as previously
verified: Java OpenJDK 17, tla2tools v1.8.0 — tool versions to be
re-verified at construction time and recorded in the model evidence;
if tool versions differ, the difference is recorded, not hidden). If
the founder wants a different modelling language, his approval message
must state it; otherwise TLA+/TLC is the authorized model language
for this scope only.

## 1. Prerequisites (all must be satisfied before construction starts)

- **P-1 L0 Decision Log completed.** The L0 Decision Sheet log has
  one row per decision L0-01–L0-19: select, conditional runs (with
  exact configuration set), or defer + scope note. No row blank.
  A blank row means construction cannot start for the features that
  row governs.
- **P-2 Corrected blueprint approved (BL1).** The founder has
  approved the Corrected Blueprint Re-issue after review. Construction
  from the uncorrected original blueprint is NOT authorized under
  this sheet (it would inherit the defects the correction reports
  identify).
- **P-3 Configuration set authorized (BL2).** The founder has
  authorized the exact configuration tuple set the model may run
  (see §2). "Run the model" without a tuple set is not authorized.
- **P-4 Trace registration disposition (BL11).** For every trace the
  model will cite as an Appendix B trace, either (a) it is registered
  in Appendix B with its full setup (separate approval), or (b) it is
  explicitly labelled as a model trace, NOT an Appendix B trace, and
  never cited as Appendix B evidence. NT-S4, NT-S5, NT-M2, NT-QC-DBL,
  PrefixCheck/candidate traces, TOCTOU/STALE-COMMIT traces, WAL
  traces, and reconciliation traces fall under (a) or (b) with no
  third option.
- **P-5 Bounds + feasibility rule authorized (BL10, see §3).** The
  founder has authorized the bounds and the stop rule for
  infeasible runs (INCOMPLETE, never silently re-bounded).
If any prerequisite is unsatisfied, construction does not start for
the affected scope. Partial satisfaction authorizes only the
satisfied scope, with the unsatisfied scope recorded as excluded —
it does not authorize construction for the excluded scope.

## 2. Model scope (M1–M10 as corrected, configuration-bound)

- **Components (all required, per Corrected Re-issue):** M1
  candidate/final split + PrefixCheck as invariant + I-PrefixRaw
  diagnostic; M2 claim-order P0 guard (Layer 2 only, real replay NOT
  modelled); M3 Path S / Path H recovery + WAL replay R1–R7 +
  safeModeRec (commit marker per L0-16 decision); M4 SafeModeGuard on
  every finalisation-affecting action + D-N1 exit outline as
  BLOCKED-gated traces (no NORMAL exit trace until D-N1 decided) +
  per-action S7 recheck + S7-CONTRADICTORY handling; M5 pair-specific
  gap accountability + at-use validity recheck; M6 QC counting vs
  aggregation split (aggregationValid INPUT flag); M7 C1–C4 partition
  machine (Item 9 traces FIRST within settlement scope); M8
  migration/epoch with freeze + computed audit diff; M9 configuration
  tuples; M10 fidelity matrix F1–F4.
- **Configuration tuples (M9, required on every result):**
  `(finalisationAlternative, forkChoice, invalidationVariant,
  B3SemanticsIfB3, gapFormatThresholdIfSpecified, deadlineConvention,
  partitionModel, family, bounds)`. B unsubvarianted is NOT a value.
  Families (NORMAL / NEGATIVE-CONTROL / PARTITION / CRASH / MIGRATION
  / OUT-OF-ASSUMPTION) never merged. A result without a tuple is
  unlabelled evidence and must not be cited.
- **Trace suite:** Baseline + T1–T14 (comparative design) across the
  authorized configurations, PLUS, once registered or labelled per
  P-4: TOCTOU traces R-G1–R-G5, STALE-COMMIT traces per §1.3 action
  row (detectable + residual variants), WAL traces T-WAL-1/2/3,
  reconciliation traces C1–C8, NT traces once registered, and
  Item 9 traces (NORMAL + negative controls, including forced-firing
  wall-clock control). A trace suite that omits a family without a
  scope note is incomplete, not passing.
- **What the model is NOT:** It is not a prototype, not an
  implementation, not a testnet, and not a proof. Model code
  (`.tla`, `.cfg`) is model code, not protocol implementation code,
  and must be kept in a model directory separate from any prototype
  or implementation directory. Model results must never be cited as
  implementation evidence, and implementation results must never be
  cited as model evidence.

## 3. Bounds and feasibility rule (BL10, PROPOSED — requires authorization)

**Proposed starting bounds (model bounds, NOT protocol values):**
4 validators (equal power, as in prior TLC package, unless the L0
stake decisions require a different test configuration — if so, the
authorized configuration must state it); heights 0..4 (prior package:
0..3 — the extension to 4 is PROPOSED and must be feasibility-tested,
not assumed); views bounded per trace (gap traces: views sufficient
to cover one skipped view + pair, not unbounded view ranges);
AttestGap restricted per trace and labelled as a bound, never as a
protocol rule (prior restriction: view 2 only — any wider restriction
must be stated per trace).
**Feasibility rule (binding if authorized):** TLC runs are bounded
checks with explicit step/depth limits recorded per run. If a run
does not complete within its stated resource limit (time, memory,
states — limits recorded before the run, not after), the run is
reported **INCOMPLETE** with the depth/states reached and the limit
hit. It is NEVER silently re-bounded to a smaller scope and reported
as a pass. Prior limits are preserved as facts and must be cited
alongside any new bound: SAFE MaxSteps 10 killed at depth 7–8 (three
attempts preserved); BEFF conflicting-finals safety control killed at
depth 9 (only conflicting-finals evidence remains the Python
two-lock-loss trace, non-TLC); SAFE_COMBINED_TLC_B NOT RUN. A new
bound that is smaller than a prior bound for the same configuration
requires a written justification + fidelity impact note (M10) —
otherwise it is scope reduction, not feasibility management, and the
run is invalid as evidence.
**Stop rule for model work (binding if authorized):** If a
configuration cannot be bounded feasibly without scope reduction,
model work for that configuration STOPS and is reported as
INFEASIBLE-FOR-CONFIGURATION with the attempted bounds and the
failure mode. Work on other configurations continues only if their
bounds remain authorized and feasible; infeasibility of one
configuration never justifies silently dropping its invariants from
another configuration's results.

## 4. Fidelity re-verification (M10, required deliverable of model work)

After construction, and before any model result is cited as evidence,
the model must be re-verified row by row against M10 Tables F1–F4
(variables, actions, guards, 21 invariant rows), with each row
justified as FAITHFUL / ABSTRACTION (limit stated) / INPUT / 
ORACLE-FORBIDDEN-IN-NORMAL / NOT-MODELLED (obligation left open).
**Requirements:**
- Every V1 Finding 5 PROPOSED addition (candidateFinalSet,
  candidateJustification, prefixCheckResult, logVisibleSet,
  justificationKind, transitiveCount, voteHistory,
  attestationHistory, pathSOutcome, pathHOutcome, crashPoint,
  configuration-tuple variables, B_f, snapshotDiff, expectedDiff,
  aggregationValid; actions CandidateFinalise, EvaluatePrefix,
  RecordJustification, CheckEligibilityAtUse, RecoverFromStorage,
  RecoverFromHistory; guards PrefixCheck, RecoveryAgreementGuard,
  SinglePathRecordingGuard) must be verified present in the built
  model, or explicitly listed as absent with a scope note. An
  addition cited in a result but absent from the model is a fidelity
  defect.
- Improvement over 0/25 must be shown row by row with justification.
  A row removed from scope is a scope note, not a pass. A row
  labelled FAITHFUL without trace + guard + variable evidence is a
  defect.
- ORACLE-FORBIDDEN-IN-NORMAL check: no NORMAL run may use an oracle
  (e.g. durableLock = lockTrue stand-in, or any equivalent) to
  satisfy a recovery/lock invariant. Oracle use, if any, belongs in
  NEGATIVE-CONTROL or explicitly labelled oracle-sensitivity runs
  only, never in NORMAL evidence.
- The re-verified fidelity matrix is a deliverable of model work,
  not an afterthought: model results without a re-verified matrix
  must not be cited.

## 5. Evidence package (proposed standard, requires authorization)

Every model run's evidence must contain:
- **E-M1 Configuration record:** Full tuple set authorized + tuple
  per run + bounds per run + tool versions (TLA+/TLC, Java) +
  L0 log rows cited + BL1 approval reference + P-4 disposition per
  trace family.
- **E-M2 Trace results:** Per trace: setup, inputs (including
  INPUT flags: aggregationValid, claim flags, gap certificates,
  invalidation timing), expected outcome, actual outcome, pass /
  fail / INCOMPLETE, depth + states generated/distinct (TLC) or
  trace steps (scripted), and the configuration tuple. Negative
  controls reported as traces, not narrative. INCOMPLETE runs
  reported with limits hit (see §3).
- **E-M3 Fidelity matrix re-verified:** Per M10 §4, row by row.
- **E-M4 Item 9 evidence (if settlement scope included):** Item 9
  NORMAL traces + negative controls, with the C1–C4 blocker status
  stated explicitly: either Item 9 evidence presented, or the
  verbatim disclaimer "SETTLEMENT-SAFETY CLAIM WITHHELD pending the
  C1–C4 mandatory verification blocker (Item 9)" retained. No
  combined settlement-safety claim without one of the two.
- **E-M5 Non-claims statement:** The report must state what it does
  NOT claim (see §6), not merely omit claims by silence. A report
  without a non-claims statement is incomplete evidence.
- **E-M6 Stop / defect log:** Any §3 infeasibility, §4 fidelity
  defect, §8 model-defect stop, or scope change, with the trace +
  stop/report record, or explicit "no stop triggered" with trace
  results cited. Unrecorded scope changes invalidate the evidence
  package.

## 6. What the model must NOT claim (any such claim is a report DEFECT)

- General theorems (Safety O-S1/O-C8, Prefix O-S2/O-C9, Lock O-S4/S5,
  GC multi-gap O-S6, C1–C4 O-M6/O-C10, containment P-GT-3, atomicity
  P-GT-5): bounded checks SUPPORT, never close, general claims.
- Real-world facts: B_eff < W/3 in reality, real replay correctness,
  DA recovery bound, weakest-validator feasibility, real storage /
  WAL / fsync semantics, real SafeMode enforcement, real S7 source
  correctness, real gap formation liveness, real consumer completeness.
- Cryptographic facts: aggregation security (A3, separate
  deliverable), slashing enforcement, attestation unforgeability
  beyond the model's INPUT assumptions.
- Protocol decisions: any L0 decision not selected in the L0 log;
  any alternative/fork-choice/semantics not in the authorized tuple
  set; KNOWN/KNOWN-NONE as achieved; global atomicity as established;
  finality reversion or rollback of finalised state.
- Performance or scale claims: no TPS, latency, throughput, or
  scalability number may be derived from model runs.
- Testnet/mainnet readiness: model results alone never change the
  readiness verdicts (Readiness Assessment §5). A passing bounded
  check does NOT make private testnet ready.

## 7. Stop criteria for model work (binding if authorized — stop = report, no waiver)

- **S-M1 Guard missing:** A finalisation-affecting action without
  its SafeModeGuard / recheck guard in the model → STOP, report
  MODEL DEFECT, fix guard or record scope exclusion; do not report
  results for that action as guarded.
- **S-M2 Configuration merging:** Results merged across tuples, or
  a result cited without a tuple → STOP evidence claims for the
  merged result; re-run with tuples or discard the result.
- **S-M3 Oracle in NORMAL:** Oracle value satisfying a NORMAL-run
  invariant → STOP, report MODEL DEFECT; oracle runs relabelled
  or discarded, never cited as NORMAL evidence.
- **S-M4 Silent scope reduction:** Bound reduced without
  justification + fidelity impact note, or a family/trace omitted
  without a scope note → STOP, report SCOPE DEFECT; prior results
  under the reduced scope are invalid until re-justified.
- **S-M5 Unlabelled / unregistered citation:** An NT ID or new trace
  cited as Appendix B evidence without registration (P-4) → STOP
  that citation; relabel as model trace or register, then re-cite.
- **S-M6 Blocker closure by model result:** Any claim that a model
  result closes a BL blocker, invariant, obligation, assumption, or
  founder decision → STOP that claim; closure requires the evidence
  type in Readiness Assessment §1/§2 (proof, implementation
  validation, real-world evidence, or founder decision, as applicable),
  never a bounded check alone.
No stop may be waived as a "known issue" without founder
re-authorization with a new scope. A stop does not close any
RI/BL/invariant/obligation/decision — it stops model work for the
affected scope and requires a new authorization to retry with
changed scope/bounds.

## 8. Approval block (founder approval required — construction starts only after this block is approved)

**Approval is given ONLY by the founder's explicit message approving
this sheet, with P-1–P-5 satisfied.** Examples of approving messages
(copy-paste style):
- "Model authorization sheet approved, L0 log completed, corrected blueprint approved, configuration set as authorized, model construction shuru karo"
- "Model construction approved as per authorization sheet, configurations [list tuples], bounds as proposed"
Any approval message must be read as approving THIS SHEET'S scope
(§2–§8) and NOTHING beyond it. If the founder wants different
configurations, bounds, or scope, his approval message must state
the differences — construction will follow the APPROVED differences,
and this proposal's values will not be used where they differ.
**Approval of this sheet does NOT approve:** the protocol, any L0
decision not in the completed L0 log, testnet, mainnet, token work,
prototype expansion, or any general proof / real-world / cryptographic
claim.
**After approval, the sequence is:**
1. Create a model directory separate from prototype-local and from
   any implementation directory (directory created only after
   approval; its path recorded in E-M1).
2. Build the model per Corrected Re-issue M1–M10 + §1, for the
   authorized tuple set only.
3. Run bounded checks + trace suite per §2–§3, with evidence per §5.
4. Re-verify fidelity per §4 before citing any result.
5. Stop on any §7 stop criterion and report — no silent continuation.
**Before approval, the sequence is:** NO model construction. NO
`.tla`, `.cfg`, or model execution. Documentation and preparation
only (this sheet, the L0 sheet, and the Corrected Re-issue are
preparation, not model construction).

## Freeze confirmation for this sheet

- Existing documents (v0.4, original blueprint, V1, V2, V2.1, V2.2,
  V2.3, Challenge, Global TOCTOU Correction, Proof Closure Plan,
  Invariant Traceability Matrix, Readiness Assessment, Prototype
  Authorization Sheet, prototype-local evidence, L0 Decision Sheet,
  Corrected Blueprint Re-issue): NOT MODIFIED by this sheet.
- No v0.5. No ".tla", ".cfg", ".py" or executable files: NOT CREATED
  by this sheet. No TLC, simulation, or model execution: NOT
  PERFORMED for this sheet.
- BL1–BL16: OPEN. All 21 invariants, 53 obligations, 34 assumptions,
  founder decisions: OPEN. KNOWN / KNOWN-NONE: BLOCKED.
- This sheet is a PROPOSAL. It authorizes no model construction by
  itself.

MODEL AUTHORIZATION SHEET — REVIEW REQUIRED. MODEL CONSTRUCTION NOT AUTHORIZED.
