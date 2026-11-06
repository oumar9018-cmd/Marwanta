# M10 Fidelity Matrix — Re-verification (Redesigned Model)

**Scope:** `Marwanta.tla` (A18, 890 lines, md5 `f7b081fbedfa248afa052725791728a2`) in `phase2-model/`, authorized
configuration (Alternative A, FC-1, prospective, n/a, specified-test,
Convention A, boolean-quorumLost, NORMAL / NEGATIVE-CONTROL / CRASH /
PARTITION families, bounds 4 validators, heights 0..4).
**Run results recorded 2026-11-05/06, plus the A17 and A18 addenda
(founder-authorized Option A fix, 2026-11-06; genesis base case + ID
tie-breaker, 2026-11-06).** See `MODEL_EVIDENCE_REPORT.md` for the per-run record.
**Classes:** FAITHFUL / ABSTRACTION (limit stated) / INPUT /
ORACLE-FORBIDDEN-IN-NORMAL / NOT-MODELLED (obligation left open) /
N/A (excluded by this run's authorization).
**Old verdict (prior package, 0/25 FAITHFUL) is NOT overturned by
this document.** It is improved only where a row below shows a
FAITHFUL result from a completed TLC run. Rows marked PENDING have
no result yet.

## F1 — State variables

| # | Variable (model) | Class | Notes |
|---|---|---|---|
| F1-1 | blocks (id, parent, view, gapSkipped, aggValid) | FAITHFUL | aggValid is an INPUT flag per M6 |
| F1-2 | votes (replay/da/stale claim flags) | ABSTRACTION | Claims model P0-ClaimOrder; real replay NOT modelled (M2) |
| F1-3 | attestations | FAITHFUL | Pair-specific per view |
| F1-4 | gapCerts (pair, attesters) | FAITHFUL | Multi-view pair-specific per M5 |
| F1-5 | candidateFinal / candidateJust | FAITHFUL | V1 Finding 5 addition, present |
| F1-6 | finalSet | FAITHFUL | |
| F1-7 | finalJust | FAITHFUL | |
| F1-8 | finalQC (voters + edgeGated at finalisation) | FAITHFUL | edgeGated recorded as history for I-PathGateEdge |
| F1-9 | lock / sLock / preCrashLock | ABSTRACTION | A2: operational lock (highest-view voted block); QC-derived lock derivation NOT-MODELLED |
| F1-10 | lastView | FAITHFUL | |
| F1-11 | hVotes / hState | FAITHFUL | History-path vote log; tail loss modelled |
| F1-12 | sState | ABSTRACTION | Storage state as flags (OK/TORN/CORRUPT), not real storage/WAL/fsync semantics |
| F1-13 | safeMode / smReasons | FAITHFUL | Per M4 |
| F1-14 | known / exitedSafeMode / approvedExit | FAITHFUL | known and exitedSafeMode FALSE by construction in this run (A8); verified by NeverKnown / NoExitExceptApproved invariants |
| F1-15 | opApproval | FAITHFUL | L0-14 / L0-15 option (c) |
| F1-16 | quorumLost / freeze / partitionCounter | FAITHFUL | Boolean-quorumLost partition model |
| F1-17 | settlement (state, bf, decideCounter) | FAITHFUL | B_f present as settlement.bf |
| F1-18 | version (chain, part, settle) | ABSTRACTION | A3: merged 3-component version vector, not 9-component Vg; conservative (rejects more, never accepts more) |
| F1-19 | recheckVer / recheckPresent / recheckOk | FAITHFUL | Per-action recheck per M4 / V2.2 |
| F1-20 | s7Chain / s7Rec | FAITHFUL | Global/local S7 separation per V2.2 |
| F1-21 | diagnostics | FAITHFUL | Diagnostic records; UNVERIFIED as evidence per V2.3 (records, not proof) |
| F1-22 | epoch / epochCounter | FAITHFUL | Finalised-block trigger only (L0-12) |
| F1-23 | invalidated / invGen / aggInvalid | FAITHFUL | Prospective invalidation per M6 / L0-06 |
| F1-24 | finalisedCounter | FAITHFUL | |
| F1-25 | causeExplained | FAITHFUL | S7 reconciliation cause requirement |
| F1-26 | lockViolated / viewViolated / safeModeVoted / freezeViolation / settledTerminal / recoveryLockOK / recovered | FAITHFUL | History flags for invariants; computed independently of action guards where possible |
| F1-27 | steps | FAITHFUL | Bound counter |
| F1-28 | prefixCheckResult | NOT-MODELLED | I-Prefix is a state invariant over finalSet (PrefixCheck as invariant, Corrected M1); no separate result variable |
| F1-29 | logVisibleSet | N/A | B3 moot under A (L0-03) |
| F1-30 | justificationKind | N/A | Under A there is a single justification kind (QC + child + edge gate); no B1/B2/B3 kinds |
| F1-31 | transitiveCount | N/A | B2 only |
| F1-32 | voteHistory / attestationHistory | ABSTRACTION | votes / attestations sets ARE the history; no separate history variables |
| F1-33 | pathSOutcome / pathHOutcome | ABSTRACTION | Recovery outcomes recorded via hState / sState / diagnostics / known flag, not separate outcome variables |
| F1-34 | crashPoint | NOT-MODELLED | CP1–CP6 are NOT distinguished as separate crash points; Crash is a single action (lock lost, vote-history tail loss optional). Obligation left open |
| F1-35 | configuration-tuple variables | FAITHFUL | Configuration recorded per run in the evidence (E-M1) and in config files, not in state |
| F1-36 | snapshotDiff / expectedDiff | N/A | Migration family not authorized |
| F1-37 | aggregationValid | INPUT | Block aggValid flag; aggregation security (A3) proven separately, not by this model |

## F2 — Actions

| Action (model) | Class | Notes |
|---|---|---|
| ProposeBlock | FAITHFUL | Contiguous main height; gap view only with >= Quorum attestations for the skipped view |
| ProposeFork | FAITHFUL | Once only; height 2 or 3; view = main view + 1 |
| Vote | FAITHFUL | Honest gates (claims, view monotonicity, lock conjunction, fresh recheck, safeMode/crash); Byzantine v4 ungated |
| AttestGap | FAITHFUL | No prior vote in that view; v1 fresh recheck; check + creation atomic in the action |
| FormGapCert | FAITHFUL | Pair-specific; >= Quorum attestations for EVERY skipped view |
| CandidateFinalise | FAITHFUL | Prefix-closed candidate set at the candidate step |
| FinaliseStep | FAITHFUL | Eager finalisation of ALL qualifying candidates; records finalQC + finalJust; FC-1 branch gate |
| Recheck | FAITHFUL | Stores recheckVer / recheckOk against current version |
| SettleCreate / SettleDecide / SettleApply / SettleAbort | FAITHFUL | Decide+apply same-block rule; abort only on finalised-block deadline (Convention A, D=10, unreachable in bounds — A7) |
| EpochAdvance | FAITHFUL | Finalised-block trigger only; no freeze; stale S7 record on advance |
| InvalidateQC | FAITHFUL | Prospective only (finalised blocks never revert) |
| SetAggInvalid | INPUT / NEGATIVE-CONTROL | Flips aggValid flag; adversarial-gated |
| GrantOperatorApproval | FAITHFUL | Durable approval record, L0-14 / L0-15 |
| Partition / RecoverQuorum / UpdateS7Record | FAITHFUL | Quorum-loss freeze; recovery on finalised-block event; record catch-up |
| DetectS7Disagreement | FAITHFUL | Validator-wide SAFE_MODE, reason preserved |
| SafeModeExit | FAITHFUL | Guard unsatisfiable in this run (Compatible FALSE) — fail-closed by design |
| ExplainCause / ReconcileS7 | FAITHFUL | Cause + approval + agreement; other reasons keep safeMode |
| Crash | ABSTRACTION | Single crash point (see F1-34); lock lost, vote-history tail loss optional |
| InjectStorageFault | ABSTRACTION | Storage fault as flag, not real storage semantics |
| RecoverFromStorageOK / RecoverFromStorageBad | FAITHFUL | Path S: lock only; faulty storage restores no lock; always SAFE_MODE INCOMPLETE |
| RecoverFromHistory | FAITHFUL | Path H: history only, NEVER a lock (V2.1); SAFE_MODE INCOMPLETE |
| VoteWithoutClaim | NEGATIVE-CONTROL | Vote record with FALSE claims; QC definition excludes it |
| ResidualCommit | NEGATIVE-CONTROL | Stale-recheck commit; containment via safeMode + stale vote exclusion |
| WallClockAbortAttempt | NEGATIVE-CONTROL | Records diagnostic; settlement unchanged |
| ExitWithoutApproval | NEGATIVE-CONTROL | Records diagnostic; safeMode unchanged |
| CorruptS7Record | NEGATIVE-CONTROL | Makes DetectS7Disagreement reachable in negative runs; sets s7Corrupt=TRUE (A15) |
| EvaluatePrefix | NOT-MODELLED | I-Prefix as invariant instead of an action |
| RecordJustification | FAITHFUL | finalJust / finalQC recorded in FinaliseStep |
| CheckEligibilityAtUse | FAITHFUL | HasQC re-evaluated at use; prospective invalidation |

## F3 — Guards

| Guard (corrected design) | Model disposition |
|---|---|
| PrefixCheck | Invariant form (IPrefix over finalSet) — PENDING run result |
| RecoveryAgreementGuard / compatibility | SafeModeExit guard: opApproval /\ Compatible /\ S7Agree; Compatible FALSE in this run, so exit never fires — fail-closed, verified by NoExitExceptApproved |
| S7 reconciliation guard (Challenge §3.5 L1-L8) | ReconcileS7: opApproval (L3) /\ S7Agree (L1) /\ causeExplained (L2) /\ ~s7Corrupt (L2(d)) /\ fresh recheck (L6) /\ s7Resolution record set (L4); exit only when last reason (L7) |
| SinglePathRecordingGuard | RecoverFromStorageOK / Bad / RecoverFromHistory always set safeMode TRUE (SAFE_MODE INCOMPLETE RECOVERY) |
| SafeModeGuard on finalisation-affecting actions | Present on Vote, AttestGap, CandidateFinalise, FinaliseStep, SettleDecide, SettleApply, EpochAdvance |
| FreezeGuard | Present on SettleDecide, SettleApply, SettleAbort, EpochAdvance |
| FreshRecheckGuard | Present on Vote (v1), AttestGap (v1), FinaliseStep, SettleDecide, SettleApply |
| Lock conjunction (corrected, Option 3C / Trace L4) | Present in Vote (v1) |
| View monotonicity | Present in Vote (honest) |
| Gap completeness | Present in ProposeBlock (gap) and FormGapCert |
| Quorum gate (HasQC, > 2W/3 = 3 of 4) | Present in FinaliseStep (Qualifying) and ChildOK |
| Edge gate (Alternative A) | Present in FinaliseStep via EdgeGated; recorded in finalQC |
| Branch gate (FC-1) | Present in FinaliseStep via OnSelectedBranch |
| Version equality (recheckVer = version) | Present as a guard at action time (detection); residual-window TOCTOU between recheck and commit is NOT modelled as separate steps (A9: TLA+ actions atomic by definition) — obligation open |

## F4 — Invariants (corrected-plan Table 1 order, 21 rows)

| # | Invariant | Model operator | Run result |
|---|---|---|---|
| 1 | I-Safety | ISafety | PASS on explored states — VACUOUS for finalisation. NORMAL/CRASH/PARTITION @10 complete (26.1M / 73.9M / 35.4M distinct); finalSet={genesis} in every explored state (no non-genesis block finalised), so the invariant was never tested on finalised blocks. NEGATIVE-CONTROL INCOMPLETE (134.6M distinct, no violation). See SelectedTipId defect note. |
| 2 | I-Prefix | IPrefix | VIOLATED under A17 (consecutive), HOLDS under A18 on the main-chain TRACE-S subspace, VIOLATED under A18 on the GAP subspace, **HOLDS under A19 on BOTH subspaces**. A17 TRACE-S: 15-action counterexample, h2 finalises, h1 never qualifies. A18 TRACE-S (genesis base case): complete, exit 0, 53,586 distinct, all 7 invariants hold; BothFinalised-negation trace proves h1+h2 finalise consecutively. A18 GAP-TRACE (single gap transition, attestations + formed GapCert): exit 12, 17-state trace, g finalises while parent h1 lacks a QC (gap cert substitutes for parent QC) — second IPrefix hole. **A19 GAP-TRACE (Option B prefix gate): complete, exit 0, 688,550 distinct, all 7 invariants hold — gap hole CLOSED. A19 TRACE-S: complete, exit 0, 53,586 distinct; BothFinalised-negation trace re-proves h1+h2 finalise consecutively (finalSet={genesis,h1,h2}, 15 actions).** Bounded diagnostic results, NOT family passes and NOT general proofs. |
| 3 | I-SingleCanonicalLog | — | NOT-MODELLED as a separate invariant. Ancestor closure + FC-1 branch selection + ISafety jointly address it; a single canonical log is NOT separately checked. Obligation open. |
| 4 | I-ForkSelection | — | ABSTRACTION. FC-1 applied at finalisation (OnSelectedBranch); no separate invariant; fork-choice correctness checked only via ISafety + IPrefix. Obligation open. |
| 5 | I-PathGateEdge | IPathGateEdge | PASS on explored states — VACUOUS for finalisation. finalQC is empty in every explored state (no finalisation), so the edge-gate history check never exercised a real record. Same runs as row 1. See SelectedTipId defect note. |
| 6 | I-Lock | ILock | PASS (genuinely exercised). NORMAL/CRASH/PARTITION @10 complete; votes and lock updates occurred in all families and lockViolated={} throughout. NEGATIVE-CONTROL INCOMPLETE (134.6M distinct, no violation). |
| 7 | I-GC | IGC | PASS on explored states — VACUOUS for finalisation. No finalised block with gapSkipped exists in any explored state, so the gap-certificate condition was never tested on a finalised block. Same runs as row 1. See SelectedTipId defect note. |
| 8 | I-QC | IQC | PASS on explored states — VACUOUS for finalisation. finalQC is empty in every explored state, so the QC-record check never exercised a real record. Same runs as row 1. See SelectedTipId defect note. |
| 9 | I-P0 | IP0ClaimOrder (+ IQC claims) | ABSTRACTION. I-P0-ClaimOrder only; real replay NOT modelled. Obligation open. |
| 10 | I-RecoveryNoWrongLock | IRecoveryNoWrongLock | PASS (genuinely exercised). CRASH @10 complete (73.9M distinct); recovery paths taken and recoveryLockOK held. Also NORMAL/PARTITION. NEGATIVE-CONTROL INCOMPLETE (134.6M distinct, no violation). |
| 11 | I-SafeModeNoVotes | ISafeModeNoVotes | PASS (genuinely exercised). safeMode entered in CRASH/PARTITION/NEGATIVE-CONTROL runs; no votes while in safeMode. NORMAL/CRASH/PARTITION @10 complete. NEGATIVE-CONTROL INCOMPLETE (134.6M distinct, no violation). |
| 12 | I-B_eff | — | NO MODEL ROW by construction (real-world assumption only, R1 reporting control). |
| 13 | I-MigComplete | — | N/A — MIGRATION family not authorized. |
| 14 | I-FreezeNoTransition | IFreezeNoTransition | PASS (genuinely exercised). PARTITION @10 complete (35.4M distinct); freeze states reached and no settlement transition finalised during them. |
| 15 | I-NoWallClockAbort | INoWallClockAbort | PASS (genuinely exercised). PARTITION @10 complete (35.4M distinct); wall-clock abort attempts blocked. |
| 16 | I-RecoveryTermination | IRecoveryTermination | VACUOUS in bounds (see below) — NOT a checked result. |
| 17 | I-ContiguousLogPrefix | IContiguousLogPrefix | PASS on explored states — VACUOUS for finalisation. finalSet={genesis} in every explored state, so the prefix condition held trivially. Same runs as row 1. See SelectedTipId defect note. |
| 18 | I-TransitiveJustificationWeakness | — | N/A under A (B2 only). |
| 19 | I-PredicateHoldsNotUsable | — | N/A under A (B1 only). |
| 20 | B3 LOG-FINAL monotonicity | — | N/A under A (L0-03). |
| 21 | B3 consumer separation | — | N/A under A (L0-03). |

**I-RecoveryTermination vacuity (recorded, not hidden):** the invariant
is `~ (settlement pending /\ ~quorumLost /\ finalisedCounter >
bf + DeadlineD + 2)`. With DeadlineD = 10 and heights 0..4,
finalisedCounter can reach at most 6, so `bf + 12` is unreachable
and the invariant is vacuously true in every reachable state of
this run. It must be labelled vacuous in the evidence, never
presented as a checked result. Deadline expiry itself is
NOT-MODELLED in this run (A7).

**NoExit scope (Option B, founder decision 2026-11-05):** the model
also checks NeverKnown (`~known`) and NoExitExceptApproved
(`~exitedSafeMode \/ approvedExit`). The unscoped NoExit (never exit
safeMode at all) is SUPERSEDED: it guards unauthorized/silent exits
only, and authorized S7 reconciliation (opApproval + agreement +
cause resolution, L1-L8) exiting safeMode is design-intended and a
valid recovery path. The old-spec NEGATIVE-CONTROL run FAILED the
unscoped NoExit with a 7-state trace; that trace is blocked by the
A15 guards and the invariant is now the scoped form. NORMAL and
CRASH use the stronger unscoped NoExit (no exit path reachable
there); NEGATIVE-CONTROL and PARTITION use the scoped form.

**SelectedTipId defect + @10 vacuity for finalisation (DECIDED 2026-11-06, machine-confirmed) — FIXED by A17, and the fix exposed the real finding:**
`SelectedTipId` (spec lines ~191–199) chose the FC-1 tip with a `CHOOSE` whose
predicate was unsatisfiable: for the winning tip `t`, the universal
quantification over `Tips` included `t`'s own record, and all three disjuncts
were false for it (`TipQCView` equal so not `<`; height not `<` itself;
`fork /\ ~fork` is false). The first finalisation attempt errored the model
checker (TRACE-S, 2026-11-06, exit 75, trace
`MarwantaDiag_TTrace_1793929019.tla`). **FIX (founder decision 2026-11-06,
Option A):** the predicate now carries the self-exclusion disjunct `r.id = t`
first (A17, 850 lines, md5 `7c76835eb42bc7f0c9864dd9f41e50a4`). **Re-run on the
fixed model (TRACE-S A17, 2026-11-06, exit 12) VIOLATED IPrefix in 15 actions:**
h2 finalises, h1 never qualifies — Q-M1 DECIDED, Alternative A does NOT
guarantee I-Prefix (trace `MarwantaDiag_TTrace_1793958042.tla`). The other 6
invariants in the TRACE-S config held on that run's 31,637 explored states
(bounded diagnostic result, not a family pass). **A17 LIMIT (open):** Option A
guarantees a satisfying tip only when the maximal tip is UNIQUE in (QC view,
height, fork status); a tie state (two QC-less tips at the same max height,
same QC view -1, same fork flag, while a QC'd candidate exists) would still
leave CHOOSE unsatisfiable — under test by the no-IPrefix variant BFS (result
pending); if a tie errors TLC, a full total order needs a further founder
decision. Any protocol fix for the IPrefix violation (e.g. special-casing the
genesis edge, or a prefix condition on finalisation) is a FOUNDER DECISION.
The @10 family PASSes remain vacuous for finalisation for the step-bound
reason (13 > 10) — the fix changes nothing at MaxSteps=10.

**A18 (2026-11-06, founder-authorized): the protocol fix was applied and
verified.** EdgeGated now treats genesis as the base case
(`ParentId(b) = GenesisId \/ HasQC(ParentId(b)) \/ GapCertForEdge(b)` — the
founder's formula translated with the spec's operators), so h1 qualifies and
h1+h2 finalise consecutively. TRACE-S A18: complete, exit 0, 53,586 distinct
states, all 7 invariants hold. The BothFinalised-negation trace proves h1+h2
both finalised (finalSet={genesis,h1,h2}, 15 actions). The SelectedTipId order
was completed with an ID tie-breaker expressed as `IdRank` comparison — the
literal `r.id < t.id` is unevaluable in TLC (tested, exit 75: "<" requires
integers); the rank form is injective on BlockIds and provably vacuous as a
deciding comparison (A17 was already total on distinct IDs), retained because
the founder ordered an explicit tie-breaker. The A17 tie question is closed
by this reasoning; the A17-era no-IPrefix BFS is superseded.

**A14 correction (action count, confirmed by the TRACE-S trace):** the first
finalisation ATTEMPT needs 13 actions (3 proposes + 9 votes + 1 Recheck), and
actual finalisation needs 15 (+ CandidateFinalise + FinaliseStep). Spec note A14
("minimum 10 actions") is WRONG by 3 (attempt) / 5 (completion). Hence
MaxSteps=10 runs can never reach a finalisation attempt — confirmed empirically
by the variant NoFinal test (see evidence report). The @10 runs are vacuous for
finalisation for TWO independent reasons: the step bound AND the CHOOSE defect.

**IPrefix diagnostic outcome (Q-M1, machine-decided 2026-11-06):** the
consecutive-chain case is DECIDED — violated under A17 (15-action trace, h2
finalises, h1 never qualifies), FIXED under A18 by the genesis base case
(TRACE-S complete, exit 0; BothFinalised-negation trace proves h1+h2
finalise consecutively). The GAP case was DECIDED the other way under A18 —
GAP-TRACE A18 (single gap transition, attestations + formed GapCert, exit
12): g finalises while parent h1 lacks a QC, because GapCertForEdge
substitutes for the parent QC. **CLOSED under A19 (Option B, founder
decision 2026-11-06 19:32 IST):** the prefix gate on finalisation
(Qualifying requires PrefixOK — every ancestor finalised or qualifying in
the same step) makes GAP-TRACE complete and clean (exit 0, 688,550
distinct), TRACE-S still clean (exit 0, 53,586 distinct), and the h1+h2
consecutive-finalisation proof re-verified. Option A was rejected as
incomplete (h1 needs the gap cert via ChildOK, so the "cert not yet formed"
ordering would still violate IPrefix). Both IPrefix holes found by the
diagnostics are now closed. FREEZE 2026-11-06 19:42 IST: spec A19 +
evidence package FROZEN; repository packaging may proceed. See the evidence
report (A19 ADDENDUM).

**Old verdict:** prior package 0/25 FAITHFUL. This matrix improves
that verdict only for rows that show a FAITHFUL result from a
completed TLC run above. Scope reduction without justification is
not a pass.
