# MARWANTA Model Evidence Report — Phase 2 Model Run (2026-11-05/06)

**Authorized configuration:** (Alternative A, FC-1, prospective, n/a,
specified-test, Convention A, boolean-quorumLost, NORMAL / NEGATIVE-CONTROL /
CRASH / PARTITION families, bounds: 4 validators, heights 0..4).
Authorized 2026-11-05 13:49 IST by the founder (Model Authorization Approval
Record; Corrected Blueprint Re-issue BL1 APPROVED and CLOSED for model baseline
text; L0 Decision Log L0-01–L0-19 COMPLETED for this run). Model construction in
`phase2-model/` strictly under Model Authorization Sheet §2–§8. No prototype
expansion, no testnet, no protocol mainnet claims authorized.

**Spec:** `Marwanta.tla` (module `Marwanta`), A17 version, 850 lines,
md5 `7c76835eb42bc7f0c9864dd9f41e50a4`. (A16 was 827 lines, md5
`a82b52067aae5733c024471553763187`; the A16→A17 change is the founder-authorized
Option A SelectedTipId fix + A14 correction, 2026-11-06 — see the A17 Addendum
below. The A16 run record in E-M2 is preserved unchanged. Version history: the
772-line version ran NORMAL and the old NEGATIVE-CONTROL (its md5 was NOT
recorded — a known evidence gap, stated here); the A15 version ran the early
CRASH legs: 798 lines, md5 `017374d2c21cbf42f0ce58a4b8d0672f`; A16 ran CRASH
resumes, PARTITION, and the NEGATIVE-CONTROL re-run.)
**Tooling:** Java Temurin JRE 17.0.21 (`~/workspace/tools/java17/jdk-17.0.21+9-jre/bin/java`),
TLC 2026.10.30.154139 (`phase2-tlc-verification/tla2tools.jar`). Note: the prior
package used Java 17.0.20.1; the patch difference is recorded, not hidden.
**Run flags:** `-deadlock -checkpoint 5 -workers 2` unless stated otherwise.
`-deadlock` DISABLES TLC's deadlock check (double-negative flag naming; TLC
checks deadlocks by default) — required because the bounded model has
intentional terminal states at MaxSteps. Workers 2 measured faster than
workers 4 on this VM (disk-bound). Checkpoints every 5 min into `states/`;
resume with `-recover states/<dir>`. VM: 4 cores, ~7.9 GB RAM; runtime restarts
killed runs repeatedly — checkpoint + resume is the working pattern.
**Heap:** `-Xmx768m` for the family runs; `-Xmx5g` for the diagnostic legs and
the NEGATIVE-CONTROL probe/resume #4 (a 15-min probe showed -Xmx5g restores
~1.0–1.4M distinct/min vs ~27k/min disk-thrash on -Xmx768m at >100M states).

## E-M1 — Configuration record

| Run | Config | MaxH | MaxV | DeadlineD | Quorum | MaxSteps | Family flags | Spec |
|---|---|---|---|---|---|---|---|---|
| NORMAL | configs-10/NORMAL.cfg | 4 | 5 | 10 | 3 | 10 | all FALSE | 772-line (md5 not recorded) |
| CRASH | configs-10/CRASH.cfg | 4 | 5 | 10 | 3 | 10 | EnableCrash=TRUE | A15 798-line, then A16 827-line (resumes; behaviourally identical for CRASH) |
| PARTITION | configs-10/PARTITION.cfg | 4 | 5 | 10 | 3 | 10 | EnablePartition=TRUE | A16 827-line |
| NEGATIVE-CONTROL (old) | configs-10/NEGATIVE-CONTROL.cfg | 4 | 5 | 10 | 3 | 10 | EnableAdversarial=TRUE | 772-line (md5 not recorded) |
| NEGATIVE-CONTROL (re-run) | configs-10/NEGATIVE-CONTROL.cfg | 4 | 5 | 10 | 3 | 10 | EnableAdversarial=TRUE | A16 827-line |
| GAP-PREFIX diagnostic (BFS) | configs-diag/GAP-PREFIX.cfg | 3 | 4 | 10 | 3 | 16 | all FALSE | A16 827-line |
| GAP-PREFIX diagnostic (dfid) | configs-diag/GAP-PREFIX.cfg | 3 | 4 | 10 | 3 | 16 | all FALSE | A16 827-line, `-dfid 16 -workers 1` |
| GAP-PREFIX-VARIANT (BFS) | configs-diag/GAP-PREFIX-VARIANT.cfg | 3 | 4 | 10 | 3 | 16 | all FALSE | MarwantaDiag.tla (diagnostic variant) |
| TRACE-S (constrained) | configs-diag/TRACE-S.cfg | 3 | 4 | 10 | 3 | 16 | all FALSE | MarwantaDiag.tla + CONSTRAINT TraceConstraint |
| NORMAL-NoFinal-VARIANT | configs-diag/NORMAL-NoFinal-VARIANT.cfg | 4 | 5 | 10 | 3 | 10 | all FALSE | MarwantaDiag.tla + NoFinal invariant |

Invariants per config are listed in the config files. NORMAL/CRASH check the
16 base invariants incl. unscoped NoExit. PARTITION/NEGATIVE-CONTROL check
NoExitExceptApproved (Option B) instead of unscoped NoExit; NEGATIVE-CONTROL
additionally checks S7Containment and StaleContainment (18 invariants total).
The diagnostic configs check 7 invariants (ISafety, IPrefix, IPathGateEdge,
IGC, IQC, IContiguousLogPrefix, StaleNeverFinalises). The NoFinal config adds
`NoFinal == st.finalSet = {GenesisId}`.

L0 log + BL1 approval: `phase2-model-fidelity-redesign/MARWANTA_MODEL_AUTHORIZATION_APPROVAL_RECORD.md`.
P-4(b) labelling: the proposed test IDs (NT-S4, NT-S5, NT-M2, NT-QC-DBL,
TOCTOU/STALE-COMMIT/WAL traces) are registered as MODEL TRACES, labelled as
such, never citable as Appendix B evidence. All runs here are model traces.

## E-M2 — Per-config results

### NORMAL @10 — PASS, COMPLETE (2026-11-05 15:43:37 IST, exit 0)
Depth 11, 35,047,573 generated / 26,131,926 distinct, 0 on queue.
Fingerprint collision probability: optimistic 1.3E-5, actual 1.9E-5.
All 16 invariants hold (incl. unscoped NoExit). Records:
`raw-output-10/NORMAL.txt` (first INCOMPLETE attempt, killed),
`NORMAL-long.txt` (false-deadlock record — run launched without `-deadlock`),
`NORMAL-resume.txt` (PASS record, resumed from checkpoint
`states/26-11-05-14-49-46.386`).
**Scope correction (2026-11-06): this PASS is VACUOUS for finalisation.**
`finalSet={genesis}` in every explored state: no non-genesis block was ever
finalised. The finalisation invariants (ISafety, IPrefix, IPathGateEdge, IGC,
IQC, IContiguousLogPrefix) held trivially. See the SelectedTipId defect
section below. Non-finalisation behaviour (votes, locks, proposals, gap
attestations) was genuinely exercised.

### CRASH @10 — PASS, COMPLETE (2026-11-05 18:50:40 IST, exit 0)
Depth 11, 106,402,662 generated / 73,920,868 distinct, 0 on queue.
Fingerprint collision probability: optimistic 1.3E-4, actual 7.9E-5.
All 16 invariants hold (incl. IRecoveryNoWrongLock, ISafeModeNoVotes, unscoped
NoExit). Path: old-spec run killed by restart (INCOMPLETE,
`CRASH-killed-old-spec.txt`); cross-spec resume failed (exit 75); fresh A15
run timed out at 5400s (49,008,881 distinct, INCOMPLETE, `CRASH.txt`);
resume #1 killed by restart at 65,869,759 distinct (`CRASH-resume.txt`);
resume #2 completed in 18min52s (`CRASH-resume3.txt`, PASS record).
**Scope correction: same finalisation vacuity as NORMAL** (no non-genesis
finalisation within @10). Crash/recovery behaviour was genuinely exercised.

### PARTITION @10 — PASS, COMPLETE (2026-11-05 20:02:43 IST, exit 0)
Single leg, 1h11m, no interruption. Depth 11, 196,491,318 generated /
35,407,506 distinct, 0 on queue. Fingerprint collision probability:
optimistic 3.1E-4, actual 2.0E-5. All 16 invariants hold (incl.
IFreezeNoTransition, INoWallClockAbort, NoExitExceptApproved). Record:
`raw-output-10/PARTITION.txt`.
**Scope correction: same finalisation vacuity as NORMAL.** Partition/freeze
behaviour was genuinely exercised.

### NEGATIVE-CONTROL @10, old spec — FAILED NoExit (2026-11-05 15:49 IST, exit 12)
Depth 8, 16,936,879 generated / 3,537,685 distinct, 3,046,429 on queue.
7-state counterexample: Init → GrantOperatorApproval → CorruptS7Record →
DetectS7Disagreement → UpdateS7Record (silently overwrote the corrupt record)
→ ExplainCause → ReconcileS7 (safeMode exited, exitedSafeMode=TRUE, violating
unscoped NoExit). The other 17 invariants held to that depth. Record:
`raw-output-10/NEGATIVE-CONTROL.txt`. This failure is REAL evidence about the
old model and is preserved in the defect log, not erased. Root cause: the
ReconcileS7 guards were under-specified (Challenge Report V2.3 §3.5 L1–L8);
fixed by A15 (s7Corrupt/s7Resolution fields, UpdateS7Record blocked while
corrupt, ReconcileS7 blocked while corrupt + fresh-recheck guard).

### NEGATIVE-CONTROL @10, fixed spec (A16, NoExitExceptApproved) — INCOMPLETE
134,608,561 distinct states explored, 123,261,924 on queue, NO violation
found (NoExitExceptApproved, S7Containment, StaleContainment + 15 base
invariants held on every explored state). Legs: fresh run killed by restart at
19,984,064 distinct; resume #1 timed out 5400s at 81,246,847 distinct /
73,250,831 queued; resume #2 killed by restart at 109,967,095 distinct /
99,954,091 queued; resume #3 timed out 5400s at 110,438,643 distinct /
100,491,858 queued (throughput collapsed to ~27k distinct/min on -Xmx768m,
disk-backed MSBDiskFPSet/DiskStateQueue thrash); 15-min -Xmx5g probe restored
~1.0–1.4M distinct/min (125,852,003 distinct / 115,110,558 queued at
2026-11-06 00:33); resume #4 (-Xmx5g) killed by restart at 134,608,561
distinct / 123,261,924 queued, rate decayed to ~29k distinct/min by end of
leg. Checkpoint dir `states/26-11-05-20-02-55.270/` is 45 GB — retained so the
run can be resumed on a machine with faster disk / more RAM. Per the binding
feasibility rule this is reported INCOMPLETE, never silently re-bounded.
Partial evidence only: the negative controls held on 134.6M states. Full
leg record in `raw-output-10/RUN_LOG.txt`.

### INCOMPLETE runs (recorded, never passes)
- NORMAL@12: killed at depth 9, 45,634,159 generated / 9,822,896 distinct
  (`raw-output/NORMAL.txt`).
- CRASH@9: killed by restart, depth 10, 38,352,539 generated / 9,254,684
  distinct (`raw-output-9/CRASH.txt`).
- Intermediate NORMAL@10 / CRASH@10 legs listed under their family records
  above.

## E-M3 — Fidelity matrix
`evidence/FIDELITY_MATRIX_REVERIFIED.md` (F1–F4). F4 run-result column filled
2026-11-06 from the runs above, with the finalisation-vacuity labelling for
rows 1, 2, 5, 7, 8, 17 and the SelectedTipId defect note. The old package's
0/25 FAITHFUL verdict is improved only by rows backed by completed runs; scope
reduction without justification is not a pass.

## Diagnostic runs (Q-M1 / IPrefix)

### GAP-PREFIX diagnostic, full spec, BFS — INCOMPLETE
MaxH=3, MaxV=4, MaxSteps=16 (not 15: one step of headroom against
action-ordering uncertainty, reason recorded in the config), NORMAL flags,
7 invariants. Legs: fresh run timed out 5400s at 45,961,854 distinct /
33,612,435 queued, depth 13, no violation (`raw-output-diag/GAP-PREFIX.txt`);
resume #1 killed by restart at 65,545,257 distinct / 49,501,885 queued, depth
13 (`GAP-PREFIX-resume.txt`); resume #2 timed out 5400s at 70,023,125 distinct
/ 53,286,386 queued, depth 13, throughput collapsed to ~29k distinct/min
(`GAP-PREFIX-resume2.txt`). Checkpoint `states/26-11-06-01-00-32.666/` (20 GB)
retained. Record: `raw-output-diag/RUN_LOG.txt`. Superseded by TRACE-S below.

### GAP-PREFIX diagnostic, full spec, dfid — INCOMPLETE (killed)
`-dfid 16 -workers 1` (dfid does not support multiple workers). Killed by
runtime restart after 46 min: 102,324,435 generated / 14,762,200 distinct, no
violation, no error. Record: `raw-output-diag/GAP-PREFIX-dfid.txt`.
Superseded by TRACE-S below.

### GAP-PREFIX-VARIANT, consensus-only variant spec, BFS — INCOMPLETE (superseded)
Variant spec `MarwantaDiag.tla` (see below), diagnostic config, MaxSteps=16.
Timed out 5400s at 28,715,573 distinct / 17,627,946 queued, depth 14, no
violation, no error. Checkpoint `states/26-11-06-05-33-15.874` retained.
Record: `raw-output-diag/GAP-PREFIX-VARIANT.txt`. Superseded by TRACE-S below.

### TRACE-S constrained run — DECISIVE (2026-11-06 07:07 IST, exit 75)
Variant spec + CONSTRAINT TraceConstraint (main-chain states only: blocks ⊆
{genesis,h1,h2,h3}, votes on those blocks only, no attestations, no gap certs,
no forks). 15 seconds, 273,835 generated / 25,215 distinct, depth 15.
**TLC RuntimeException: `Attempted to compute the value of an expression of
form CHOOSE x in S: P, but no element of S satisfied P`**
(MarwantaDiag lines 221–225 = SelectedTipId CHOOSE.) Error trace
`MarwantaDiag_TTrace_1793929019.tla` (14 states, steps 0..13) is exactly the
hand-verified Trace S prefix: propose h1 (view 1), propose h2 (view 2),
propose h3 (view 3), votes v2/v3/v4 on h1, then h2, then h3 (all replay=TRUE,
da=TRUE, stale=FALSE), Recheck (recheckPresent=TRUE, recheckOk=TRUE).
finalSet={genesis}, candidateFinal={}, finalisedCounter=0 throughout.
Expanding the steps=13 state attempts CandidateFinalise → OnSelectedBranch →
SelectedTipId → CHOOSE → error. Record: `raw-output-diag/TRACE-S.txt`.

### Diagnostic variant spec
`MarwantaDiag.tla` (847 lines): mechanically derived from the A16 spec by
ONLY (a) renaming the module and (b) reducing Next to the consensus-only
actions (ProposeBlock, ProposeFork, Vote, AttestGap, FormGapCert,
CandidateFinalise, FinaliseStep, Recheck), plus diagnostic operators NoFinal,
SelProbe, TraceConstraint/MainIds. Everything else identical (verified by
diff). SUBSET ARGUMENT (in the file header): every behavior of the variant is
a behavior of the full spec (same Init, Next_variant ⊆ Next_full, same
invariants), because the removed actions never create blocks, votes, gap
certificates, or finalisations, and can only hinder or delay finalisation.
Hence a violation found here IS a violation in the full spec, and
unreachability of finalisation here at MaxSteps=10 implies unreachability in
the full spec at MaxSteps=10. The variant exists ONLY to machine-check the
Q-M1 traces and the MaxSteps=10 finalisation-vacuity claim.

### NORMAL-NoFinal-VARIANT — PASS, COMPLETE (2026-11-06 07:22:06 IST, exit 0)
Variant spec + NORMAL config (MaxH=4, MaxV=5, MaxSteps=10) + invariant
`NoFinal == st.finalSet = {GenesisId}` (plus the 16 base invariants).
**Result: "Model checking completed. No error has been found."** Depth 11,
31,239,470 generated / 5,766,289 distinct, 0 on queue. Fingerprint collision
probability: optimistic 8.0E-6, actual 4.3E-7. Finished in 14min 13s.
NoFinal PASSED — no state in the complete @10 variant graph has a non-genesis
finalisation. By the subset argument, finalisation is unreachable at MaxSteps=10
in the FULL spec too. This is the empirical confirmation of the @10 vacuity
claim: the three family PASSes (NORMAL/CRASH/PARTITION) never tested
finalisation. (The action-count argument already implied this — 13 > 10 — and
the TRACE-S trace shows why the bound matters: the first attempt is at
steps=13.) Record: `raw-output-diag/NORMAL-NoFinal-VARIANT.txt`.

## E-M4 — Item 9 (C1–C4 settlement-safety) status

SETTLEMENT-SAFETY CLAIM WITHHELD pending the C1–C4 mandatory verification
blocker (Item 9).

Settlement traces are inside the PARTITION/NORMAL scope (settlement actions
fire in those families), but deadline-expiry Item 9 traces are NOT covered
within the model bounds (D=10 unreachable: finalisedCounter max 6 within
heights 0..4, so B_f + 10 is never reached). The disclaimer above is retained
verbatim. No combined settlement-safety claim is made. Additionally, since no
non-genesis block was ever finalised in any run (see the SelectedTipId defect),
no settlement was ever decided in a finalised block in the model either —
settlement finalisation behaviour is untested beyond the action-level guards.

## E-M5 — Non-claims (what this evidence does NOT establish)

- These bounded checks close NO obligation (all 53 remain OPEN), NO assumption
  (all 34 remain OPEN as proof/validation items, except A1 accepted as an
  explicit real-world assumption via L0-07 and A-L3-S/A-L3-H accepted
  independently via L0-17, and A-M1 decided for the model run only via L0-13),
  and NO blocker beyond BL1's text closure. BL2, BL10, BL11 are satisfied only
  as run-scope authorizations/dispositions for this model run. BL3 is moot for
  this run (Alternative A selected) but OPEN generally. BL4–BL9, BL12–BL16
  remain OPEN.
- No general proof: a TLC pass (even complete) never closes a mathematical-proof
  obligation (O-S1/O-C8, O-S2/O-C9, O-S4/O-S5, O-S6, O-M6/O-C10, P-GT-1–P-GT-4
  remain open). A bounded check SUPPORTS, never closes, a general theorem.
- No real-world, cryptographic, performance, testnet, or mainnet claim. No
  claim about throughput, latency, or production behaviour. No token-economics
  claim (token work remains not authorized).
- The @10 family PASSes are vacuous for finalisation (see E-M2 scope
  corrections). They verify non-finalisation behaviour only.
- The IPrefix question (Q-M1) is UNDECIDED pending a fixed SelectedTipId model.
  The Trace S argument is a hand-derivation, not a machine-checked result.
- The NEGATIVE-CONTROL re-run is INCOMPLETE, not a pass. The diagnostic BFS /
  dfid / variant-BFS legs are INCOMPLETE, not passes. The TRACE-S outcome is an
  ERROR (spec defect), not a pass and not an invariant violation.
- No S-M stop was triggered by a safety violation in the family runs; the stops
  recorded are timeouts, runtime restarts, and the TRACE-S spec-defect error.

## E-M6 — Stop / defect log

1. **SelectedTipId CHOOSE unsatisfiable (NEW, machine-confirmed 2026-11-06).**
   The FC-1 tip-selection predicate fails its self-comparison (see the defect
   note in the fidelity matrix). First finalisation attempt crashes TLC
   (RuntimeException). The model cannot finalise any block as written.
   Severity: BLOCKING for all finalisation verification. Fix requires a founder
   decision (e.g. add `r.id # t` self-exclusion or an `r.id = t` disjunct);
   NO spec edit is authorized in this run. Evidence: TipTest isolated
   reproduction (`~/workspace/marwanta/tiptest/`, since removed from /tmp),
   SelProbe test (initial state: Tips={} so the IF branch is taken — no
   CHOOSE), TRACE-S error trace (`MarwantaDiag_TTrace_1793929019.tla`).
2. **A14 minimum-finalisation count wrong (NEW, confirmed by the TRACE-S trace).**
   Spec note A14 says 10 actions; the true minimum is 13 to the first
   finalisation ATTEMPT and 15 to completion (3 proposes + 9 votes + 1 Recheck
   + CandidateFinalise + FinaliseStep). The A14 note is stale (predates the
   recheck guard) and must be corrected when the spec is next revised.
3. **ReconcileS7 under-guarded (found by the old-spec NEGATIVE-CONTROL NoExit
   violation, fixed by A15).** UpdateS7Record could silently overwrite a
   corrupt record; ReconcileS7 lacked the L1–L8 guards. Fixed: s7Corrupt /
   s7Resolution fields, UpdateS7Record blocked while corrupt, ReconcileS7
   blocked while corrupt + fresh-recheck guard. The old-spec failure is
   preserved above (E-M2) as evidence.
4. **Genesis not in finalSet (found by reasoning before any TLC finalisation,
   fixed by A11).** Init finalSet was {}; the first FinaliseStep would have
   violated IPrefix. Fixed: genesis final by definition.
5. **False deadlock (process defect).** First long NORMAL run launched without
   `-deadlock`; TLC's default deadlock check stopped the run on an intentional
   steps=10 terminal state. Fixed: all runs use `-deadlock`; README corrected.
6. **INCOMPLETE runs:** NORMAL@12, CRASH@9, intermediate NORMAL@10/CRASH@10
   legs, NEGATIVE-CONTROL re-run (134.6M distinct, disk-throughput collapse),
   diagnostic BFS/dfid/variant-BFS legs (see E-M2). All recorded with their
   numbers; none presented as passes.
7. **Disk-throughput collapse (infrastructure, not a spec finding).**
   Disk-backed MSBDiskFPSet/DiskStateQueue throughput collapses to ~27–29k
   distinct/min once the on-disk state exceeds ~40–45 GB (NEGATIVE-CONTROL
   45 GB checkpoint, diagnostic 20 GB). `-Xmx5g` restores ~1M/min temporarily.
   This VM cannot complete the NEGATIVE-CONTROL @10 graph in reasonable time.
8. **NoFinal test infrastructure failure (superseded).** The first NoFinal run
   (full spec, /tmp/finaltest) died with "No space left on device" because
   /tmp is a 512 MB tmpfs. Rerun as the variant test on the main disk; see
   diagnostic runs above. /tmp cleaned.
9. **No S-M safety stop triggered** in the family runs. Stops were timeouts
   (5400s legs), runtime restarts, and the TRACE-S spec-defect error.

## A17 ADDENDUM (2026-11-06) — Option A fix applied; Q-M1 DECIDED

**Founder decision (2026-11-06 15:09 IST): Option A.** The SelectedTipId
CHOOSE predicate now carries the self-exclusion disjunct `r.id = t` first.
Spec `Marwanta.tla` A16 (827 lines) → A17 (850 lines, md5
`7c76835eb42bc7f0c9864dd9f41e50a4`); diagnostic variant `MarwantaDiag.tla`
likewise updated (847 → 878 lines, md5 `f72c12db35d89e8b7dda5530c0339877`).
A14 corrected in the same revision (13 attempt / 15 completion, confirmed by
the TRACE-S trace). A17 note added to both spec headers. The fix was applied
identically to both files (SelectedTipId blocks verified identical by diff).
No other spec text changed. No frozen document touched (v0.4, closure plan,
matrix, blueprint, prototype-local all still verified unchanged — see below).

**TRACE-S on A17 (2026-11-06 15:11:11 IST, exit 12) — Q-M1 DECIDED.**
Config: `configs-diag/TRACE-S.cfg` (variant A17, MaxH=3, MaxV=4, MaxSteps=16,
NORMAL flags, 7 invariants, CONSTRAINT TraceConstraint). **"Error: Invariant
IPrefix is violated."** 28s, 351,990 generated / 31,637 distinct, depth 16,
6,405 on queue. Trace: `MarwantaDiag_TTrace_1793958042.tla` (16 states, steps
0..15). Record: `raw-output-diag/TRACE-S-A17.txt`.
The trace (machine-confirmed): propose h1 (view 1), h2 (view 2), h3 (view 3);
votes v2/v3/v4 on h1, then h2, then h3 (TLC's interleaving differs slightly
from the hand trace — Recheck fired at step 12 before the last h3 vote, v1
voted h3 at step 13 giving h3 its QC); step 14 CandidateFinalise (b=h2,
candidateFinal={genesis,h1,h2}, finalJust={[b=h2, child=h3]}); step 15
FinaliseStep finalises h2 ONLY (finalQC={[b=h2, voters={2,3,4},
edgeGated=TRUE]}, finalisedCounter=1). finalSet={genesis,h2};
Ancestors(h2)={h2,h1,genesis} is NOT a subset of finalSet → IPrefix violated.
**Q-M1 ANSWER: Alternative A does NOT guarantee I-Prefix.** The violation
needs no gap, no fork, no adversary — the simplest consecutive chain, 15
actions. Root cause (confirmed): EdgeGated(h1) is always FALSE in the
consecutive case — HasQC(genesis) is FALSE forever (Vote forbids voting for
genesis) and h1 proposed consecutively has gapSkipped=FALSE, so no gap cert
can cover its edge. The spec comment's claim "when a block qualifies, every
qualifying ancestor qualifies with it" is FALSE for the height-1 block. Any
protocol fix (e.g. special-casing the genesis edge, or a prefix condition on
finalisation) is a FOUNDER DECISION; no further spec edit is authorized here.
The other 6 invariants in the TRACE-S config (ISafety, IPathGateEdge, IGC,
IQC, IContiguousLogPrefix, StaleNeverFinalises) held on the 31,637 explored
states of this diagnostic run — a bounded diagnostic result, not a family pass.
**A17 LIMIT (open empirical question):** Option A guarantees a satisfying tip
only when the maximal tip is UNIQUE in (QC view, height, fork status). A tie
state (two QC-less tips at the same max height, same QC view -1, same fork
flag, while a QC'd candidate exists) would still leave CHOOSE unsatisfiable.
Whether such a state is reached is being tested by the no-IPrefix variant BFS
(config `configs-diag/GAP-PREFIX-VARIANT-noIPrefix.cfg`, IPrefix removed from
the invariant list so TLC continues past the known violation; result pending).
If a tie errors TLC, a full total order (e.g. tie-break by block id) needs a
further founder decision.
**Effect on the @10 family PASSes:** none — the @10 runs cannot reach a
finalisation attempt (13 > 10) under either A16 or A17, so their results
stand as recorded (vacuous for finalisation, genuine for non-finalisation
behaviour). No family re-run is needed at MaxSteps=10. A family run at
MaxSteps≥15 would now be meaningful but is infeasible on this VM (the
diagnostic BFS at MaxSteps=16 already exceeds 28M distinct states at depth 14
without completing).

## A18 ADDENDUM (2026-11-06) — Genesis base case + ID tie-breaker; IPrefix HOLDS, h1+h2 finalise consecutively

**Founder decision (2026-11-06 15:24 IST):** (1) EdgeGated genesis base case
— `EdgeGated(b) == b.parent = GenesisId \/ HasQC(b.parent) \/
HasGapCert(b.parent, b)`; (2) SelectedTipId ID tie-breaker — `r.id < t.id`
when views and heights are equal. **Translation (recorded, not hidden):**
`b.parent` is `ParentId(b)` in this spec (IDs carry no parent field; parents
are computed from height), and `HasGapCert(b.parent, b)` is the existing
`GapCertForEdge(b)`. The implemented form is `EdgeGated(b) ==
ParentId(b) = GenesisId \/ HasQC(ParentId(b)) \/ GapCertForEdge(b)`; since
`ParentId(genesis) = GenesisId` (self-parent), the base case also covers
b = genesis, subsuming the old `b.h = 0` disjunct. ParentHasQC is superseded
and retained only for reference. **The literal tie-breaker `r.id < t.id` is
UNEVALUABLE in TLC** (tested 2026-11-06 with an isolated module, exit 75:
"The first argument of < should be an integer" — IDs are `[h, fork]`
records). Implemented instead as `IdRank` comparison (`IdRank(id) == id.h * 2
+ (IF id.fork THEN 1 ELSE 0)`, injective on BlockIds, hence a strict total
order on distinct IDs), with a fork-equality guard — the guard is REQUIRED,
because without it the rank disjunct would also fire when fork flags differ
and would undo the non-fork preference. **Recorded limit:** given IDs are
`(h, fork)` pairs, the rank disjunct is provably vacuous as a deciding
comparison (two distinct IDs with equal view and height either differ in fork
— already ordered by the fork disjunct — or are equal, covered by the A17
`r.id = t` disjunct); the A17 predicate was already total on distinct IDs.
The disjunct is retained because the founder ordered an explicit ID
tie-breaker; it is evaluable, harmless, and makes the total order explicit.
Spec `Marwanta.tla` A17 (850 lines) → A18 (890 lines, md5
`f7b081fbedfa248afa052725791728a2`); variant `MarwantaDiag.tla` likewise
(878 → 925 lines, md5 `8ad20877440e4366e4cca204b6296572`; includes the new
diagnostic operator `NotBothFinalised`). EdgeGated, SelectedTipId, and IdRank
verified identical between the two files by diff.

**TRACE-S on A18 (2026-11-06 15:28:50 IST, exit 0) — IPrefix HOLDS.**
Config: `configs-diag/TRACE-S.cfg` (variant A18, MaxH=3, MaxV=4, MaxSteps=16,
NORMAL flags, 7 invariants, CONSTRAINT TraceConstraint). **"Model checking
completed. No error has been found."** 1min 02s, 569,719 generated / 53,586
distinct, 0 on queue, depth 17. Fingerprint collision: optimistic 1.5E-9,
actual 1.1E-10. All 7 invariants (ISafety, IPrefix, IPathGateEdge, IGC, IQC,
IContiguousLogPrefix, StaleNeverFinalises) hold on the COMPLETE constrained
space. The A17 IPrefix violation is gone. Record:
`raw-output-diag/TRACE-S-A18.txt`.

**TRACE-S-BothFinal on A18 (2026-11-06 15:29:47 IST, exit 12) — POSITIVE
PROOF that h1 and h2 finalise consecutively.** Config:
`configs-diag/TRACE-S-BothFinal.cfg` (TRACE-S config + `NotBothFinalised`
invariant, which asserts h1 and h2 are NEVER both finalised). **"Error:
Invariant NotBothFinalised is violated."** 37s, 366,686 generated / 34,278
distinct, 7,883 on queue. Trace: `MarwantaDiag_TTrace_1793959150.tla`
(16 states, steps 0..15), ending with `finalSet = {genesis, h1, h2}`,
`finalisedCounter = 2`. The violation of NotBothFinalised IS the proof: TLC
refuted "never both finalised" with a concrete 15-action trace in which h1
qualifies via the genesis base case, h2 qualifies via h1's QC, and both are
finalised with all ancestors present (IPrefix holds). Record:
`raw-output-diag/TRACE-S-BothFinal-A18.txt`.

**Scope of the A18 verdict:** the IPrefix result is a BOUNDED diagnostic
result on the constrained TRACE-S subspace (main-chain states only, MaxH=3,
MaxSteps=16), not a family pass and not a general proof. The @10 family
PASSes are unaffected (they cannot reach finalisation under any spec version
at MaxSteps=10). A family run at MaxSteps≥15 remains infeasible on this VM.
The no-IPrefix variant BFS launched on the A17 spec is superseded by A18;
its result, when it arrives, is an A17-era diagnostic only.

## GAP-TRACE FINDING (2026-11-06) — Gap-certified edge breaks IPrefix; freeze HELD

**GAP-TRACE on A18 (2026-11-06 19:04:59 IST, exit 12) — IPrefix VIOLATED.**
Config: `configs-diag/GAP-TRACE.cfg` (variant A18 + GapTrace operators,
MaxH=3, MaxV=4, MaxSteps=20, NORMAL flags, 7 invariants, CONSTRAINT
GapTraceConstraint — a single gap transition: h1 view 1 → g height 2 view 3,
skipping view 2, with attestations and a formed GapCert). **"Error: Invariant
IPrefix is violated."** 1min 33s. Trace:
`MarwantaDiag_TTrace_1793972006.tla` (17 states, steps 0..16). Record:
`raw-output-diag/GAP-TRACE-A18.txt`.
The trace: genesis (view 0), h1 (view 1), g (height 2, view 3, parent h1,
gapSkipped=TRUE), c (height 3, view 4, parent g). Attestations for view 2
from v2,v3,v4; gap cert (h1,g) formed with attesters {2,3,4}. Votes: v2,v3,v4
on g and c ONLY — no votes on h1, so h1 never held a QC. CandidateFinalise(g)
fired (HasQC(g), QC'd child c, EdgeGated via the gap cert, on selected
branch); candidateFinal={genesis,h1,g}; FinaliseStep finalised g ONLY (h1
does not qualify — no QC). finalSet={genesis,g}; Ancestors(g)={g,h1,genesis}
is NOT a subset → IPrefix violated.
**Root cause (distinct from the A17 hole):** for consecutive edges, EdgeGated
requires HasQC(parent), so a child cannot become a finalisation candidate
until its parent is QC'd — that is why TRACE-S A18 passed. For gap edges,
GapCertForEdge SUBSTITUTES for the parent QC, so a gap child can finalise
while its parent is QC-less. Combined with eager FinaliseStep (which finalises
only currently-qualifying members), the parent is left unfinalised and IPrefix
breaks. The A18 genesis base case does not fix this (it covers only height-1
blocks whose parent IS genesis; here the issue is h1's missing QC, not its
edge gate). Variant (b) GAP-TRACE-NoParentQC was NOT run — it is subsumed:
the (a) violation trace already contains no votes on h1, so it satisfies
(b)'s constraint; running (b) would re-find the same violation.
**Freeze status: NOT FROZEN.** The gap trace did not confirm cleanly, so per
the founder's conditional the artifact is not frozen with a clean bill. The
violation is recorded here as a finding. Any protocol fix (e.g. requiring the
parent to be QC'd/finalised even for gap edges, or a prefix condition on
finalisation) is a FOUNDER DECISION. Repository packaging is on hold pending
that decision (or an explicit order to freeze with the violation recorded as a
known open issue).

## A19 ADDENDUM (2026-11-06) — Option B prefix gate; gap hole CLOSED; FREEZE

**Founder decision (2026-11-06 19:32 IST): Option B.** Keep EdgeGated as-is;
add a prefix gate to FinaliseStep — a block finalises only when all its
ancestors are finalised or qualify in the same step. Option A (removing the
GapCertForEdge disjunct from EdgeGated) was REJECTED as incomplete on
analysis: h1 still needs the gap cert to qualify via ChildOK, so the "cert
not yet formed" ordering would still finalise g alone and violate IPrefix.
Option C (finalise the whole ancestor chain at once) was already rejected
(it breaks IQC and I-P0). The founder asked which was right; the assistant
recommended B and the founder picked B.
**The fix (A19, applied to both `Marwanta.tla` and `MarwantaDiag.tla`,
verified identical by diff):** two new operators before Qualifying, and one
added conjunct:
`AncestorQualifies(a) == a \in st.candidateFinal /\ a \notin st.finalSet
/\ HasQC(a) /\ ChildOK(a) /\ EdgeGated(a) /\ OnSelectedBranch(a)` — the
ancestor conditions inlined (TLA+ operators cannot self-refer);
`PrefixOK(b) == \A a \in Ancestors(b) : a \in st.finalSet \/
AncestorQualifies(a)`; `Qualifying(b)` gains `/\ PrefixOK(b)`.
Ancestors(b) is transitively closed (explicit unrolling), so the check is
transitive without recursion. Since FinaliseStep finalises ALL qualifying
members in one step, every ancestor the gate relies on finalises together
with b, so finalSet is prefix-closed by construction. If any ancestor does
not qualify now, b waits — finalisation is delayed, never prefix-breaking.
EdgeGated is UNCHANGED by A19 (gap certs still gate the edge and the child
link); only the finalisation gate is added. Spec note A19 added to both
headers.
**Re-runs on A19 (all on the variant; the full spec is behaviourally
identical for these diagnostics — see the subset argument in the variant
header):**
- **GAP-TRACE A19 (2026-11-06 19:41:21 IST, exit 0) — "Model checking
  completed. No error has been found."** COMPLETE. 6,836,367 generated /
  688,550 distinct / 0 on queue, depth 21, 4min 33s. Fingerprint: optimistic
  vs actual 1.8E-8. All 7 invariants (ISafety, IPrefix, IPathGateEdge, IGC,
  IQC, IContiguousLogPrefix, StaleNeverFinalises) hold on the COMPLETE
  constrained gap space. **The gap-edge IPrefix hole is CLOSED.** (First
  attempt killed by a runtime restart at 333,561 distinct, depth 18, no
  violation; its checkpoint lacked vars.chkpt and was unusable — fresh
  re-run completed. Record: `raw-output-diag/GAP-TRACE-A19.txt`.)
- **TRACE-S A19 (2026-11-06 19:41:57 IST, exit 0) — "Model checking
  completed. No error has been found."** COMPLETE. 569,719 generated /
  53,586 distinct / 0 on queue, depth 17, 30s. Fingerprint actual 2.8E-10.
  Same distinct count as A18 (53,586) — the prefix gate changes nothing on
  the consecutive main-chain space, as expected. Record:
  `raw-output-diag/TRACE-S-A19.txt`.
- **TRACE-S-BothFinal A19 (2026-11-06 19:42:17 IST, exit 12) — "Error:
  Invariant NotBothFinalised is violated."** The violation of
  NotBothFinalised IS the positive proof: trace
  `MarwantaDiag_TTrace_1793974318.tla` ends with finalSet={genesis,h1,h2},
  finalisedCounter=2, 15 actions — **h1 and h2 still finalise consecutively
  under A19, IPrefix holds.** Record:
  `raw-output-diag/TRACE-S-BothFinal-A19.txt`.
**Freeze status: FROZEN.** The gap trace confirmed cleanly under the
founder-picked fix, so per the founder's conditional (2026-11-06 19:01 IST)
the artifact is frozen with a clean bill on the gap subspace and bundled
into this evidence package. Both IPrefix holes found by the diagnostics are
now closed (consecutive: A18 genesis base case; gap: A19 prefix gate).
Repository packaging may now proceed. Scope limits still stand: bounded
diagnostic results only (TRACE-S main-chain subspace, GAP-TRACE single-gap
subspace, families @ MaxSteps 10 vacuous for finalisation); NEGATIVE-CONTROL
@10 remains INCOMPLETE; settlement safety (Item 9, C1–C4) remains WITHHELD;
no protocol approval, no testnet, no mainnet claim is authorised by this
freeze.

## Frozen-document verification (2026-11-06, at delivery)
- v0.4 `MARWANTA_GENESIS_ARCHITECTURE_SPECIFICATION_v0.4.md`: 1,858 lines,
  md5 `1b1011cbaca466eb52c897af519a0373` — UNCHANGED.
- Proof closure plan `PROOF_CLOSURE_PLAN.md`: 1,674 lines — UNCHANGED.
- Invariant traceability matrix: 107 lines — UNCHANGED.
- Corrected Blueprint Re-issue: 1,495 lines — UNCHANGED.
- Prototype-local: all files dated Nov 4; `evidence.json` md5
  `377667a419d2e589c72628df8e89e45a` — UNTOUCHED (frozen as evidence).
- Authorized spec `Marwanta.tla`: A19, 922 lines, md5
  `47fd0e5a1c2ccfabcad9502ca5ce2353` — CHANGED by the founder-authorized A19
  fix only (A18 was 890 lines, md5 `f7b081fbedfa248afa052725791728a2`).
  Diagnostic variant `MarwantaDiag.tla`: A19, 980 lines, md5
  `a0bf7883e1b8f1ed6873e324c8530090` (header records the A19 source spec
  md5 `47fd0e5a1c2ccfabcad9502ca5ce2353`).
- **FREEZE (2026-11-06 19:42 IST):** spec A19 + this evidence package are
  FROZEN as the model-run artifact. Gap subspace clean (GAP-TRACE A19,
  exit 0, complete); main-chain subspace clean (TRACE-S A19, exit 0,
  complete); h1+h2 consecutive-finalisation proof re-verified under A19.
