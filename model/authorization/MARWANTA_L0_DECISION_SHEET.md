# MARWANTA — L0 DECISION SHEET (PROPOSAL)

**Status:** PROPOSAL ONLY. REVIEW REQUIRED. NO DECISION IS MADE BY
THIS SHEET. Every decision below is OPEN until the founder selects an
option in an explicit message, authorizes labelled conditional runs for
that decision, or records an explicit deferral with a scope note.
Silence is not a selection. A general approval of this sheet does NOT
select every option in it; the founder must select per decision, or
state in his approval message which decisions he is selecting and
which he is deferring.
**Companion documents (same authorization, same turn):**
`MARWANTA_MODEL_FIDELITY_REDESIGN_BLUEPRINT_CORRECTED_REISSUE.md`
(BL1 proposal) and `MARWANTA_MODEL_AUTHORIZATION_SHEET.md`.
**What this sheet does NOT do:** it does not close any RI issue
(RI-01–RI-42), any BL blocker (BL1–BL16), any invariant, obligation,
or assumption. It does not authorize model construction, prototype
expansion, testnet, mainnet, or token work. Model construction remains
NOT AUTHORIZED until the founder separately approves the Model
Authorization Sheet after reviewing this sheet.
**Labels:** OPEN = undecided. PROPOSED = a correction/report proposal
exists, awaiting founder selection. UNRESOLVED = no proposal closes it
yet, or the proposal itself leaves a gap open. SUPPORTED BY EVIDENCE =
follows directly from a previously delivered verified document rule
(documentary evidence only, never model-run evidence).

## How to decide (read first)

For each decision L0-01–L0-19, the founder has exactly three kinds
of response, and each must be recorded verbatim in the decision log
that follows approval:
1. **Select an option** (e.g. "L0-01: Alternative A"). The model is
   then built for that option; results for other options are not
   claimed from that model.
2. **Authorize labelled conditional runs** (e.g. "L0-01: run A and B3
   separately, labelled, no merging"). Every result must carry its
   configuration tuple; a result without a tuple is unlabelled
   evidence and must not be cited. Conditional runs do NOT select a
   protocol alternative.
3. **Defer with a scope note** (e.g. "L0-04 deferred; gap-dependent
   features excluded from model scope, scope recorded"). Deferral
   without a scope note is not a decision — the dependent model
   features simply cannot be built or claimed until the decision is
   made or the exclusion is recorded.
A decision deferred for the model is NOT deferred for the protocol:
protocol decisions remain OPEN in every case until the founder
selects them as protocol decisions, which is a separate act from
selecting a model test configuration.

## Decision summary (all OPEN)

| ID | Question | Source | Options |
|---|---|---|---|
| L0-01 | Finalisation alternative (D11 / O-C1) | Comparative design, closure plan | A / B1 / B2 / B3 / labelled conditional runs |
| L0-02 | Fork-choice function (O-FC-SEL) | Comparative design | FC-1 / FC-2 / FC-3 / FC-4 / UNCHECKED labelling |
| L0-03 | B3 LOG-FINAL semantics (O-F5) | Comparative design, V1 | (a) derived-prefix / (b) eligiblePrefix / conditional |
| L0-04 | Gap attestation wording + category (D1) | Option 3C, V2.3 | Adopt verbatim text + category / amend / defer with scope note |
| L0-05 | Gap format + threshold (D7) | Option 3C, closure plan | Specify format + threshold / defer with scope note |
| L0-06 | QC invalidation variant + timing (D2, O-I1, O-I2) | Option 3C, V2.3, Challenge | Prospective / retroactive / per-stage scope |
| L0-07 | B_eff acceptance (D3) | v0.4, closure plan | Accept as explicit assumption / reject (then safety unprovable) |
| L0-08 | Lock conjunction + rank (D5) | Option 3C, closure plan | Adopt corrected conjunction / approved alternative |
| L0-09 | Stake cap + minimum validators (D6) | v0.4, closure plan | Specify values + enforcement / defer with scope note |
| L0-10 | Aggregation construction (D10, A3) | Closure plan | Specify construction / cryptographic proof as separate deliverable / per-variant runs |
| L0-11 | Migration + audit window (D8, D-N3) | v0.4, closure plan | Specify option + audit publication + freeze window |
| L0-12 | Epoch trigger (Item 6 vs C1–C4) | Closure plan, blueprint C5 | Finalised-block trigger spec / defer with scope note |
| L0-13 | Deadline convention + value (A-M1, O-M4, O-M5) | Closure audit, closure plan | Convention A (111→110) / Convention B (112→111) + D value |
| L0-14 | SafeMode exit (D-N1) | V2.3 Point 2, Challenge §1 | Authorization source (a)/(b)/(c) + per-reason resolutions + check-log format |
| L0-15 | S7 reconciliation authority | Challenge §3 | Self / quorum / operator / defer (leaving BLOCKED) |
| L0-16 | Crash inventory + DISAGREE + commit marker | V1, V2, V2.1, Challenge §1 | CP7–CP10 adopt / exclude with scope note; DISAGREE R1/R2/R3; marker format |
| L0-17 | Storage/history retrievability (A-L3-S, A-L3-H) | Blueprint C3, V2.1 | Accept each path independently / defer (KNOWN stays BLOCKED) |
| L0-18 | Gap-conflict halt scope (D-N2) + replay commitment (D4) | Option 3C, closure plan | Specify halt scope; specify pre-vote replay commitment |
| L0-19 | View duration / pacemaker (D9) + Appendix B registration (BL11) | Closure plan, readiness §1 RI-39 | Specify weakest-validator class + duration rule; register NT IDs + traces (separate approval) |

---

## Group A — Finality, prefix, log (L0-01–L0-03)

### L0-01 — Finalisation alternative (D11 / O-C1). OPEN.
**Question:** Which finalisation alternative does the redesigned model
implement: A (path-gated), B1 (deferred recording), B2 (transitive),
or B3 (two-status FINAL vs LOG-FINAL)? B unsubvarianted is NOT an
option: the comparative design proved it incoherent (genesis—A(v1)—
G(v3, skips v2, no gap cert)—H(v4): Final(G) holds, Final(A) fails).
**Options and consequences:**
- **A:** Gate is edge-bound (I_PathGateEdge). Liveness cost: one
  missing gap certificate stalls all descendants (needs O-F1 gap
  formation liveness, itself OPEN). Model implements candidate/final
  split + PrefixCheck as invariant (M1 corrected).
- **B1:** Deferred recording. Operationally equal to A if the record
  has no protocol effect; discipline O-C3 (predicateHolds never used
  by consumers) must then be modelled/audited. If the record DOES
  have an effect, B1 is a different alternative and must be specified
  as such — it cannot be both.
- **B2:** Transitive justification. Weakness is structural: it
  fabricates justification (I-TransitiveJustificationWeakness). Model
  must mark transitive justification distinctly and audit it under
  O-F4; consumers must not treat transitive justification as direct
  justification without that audit.
- **B3:** Two-status. Requires L0-03 (semantics) AND consumer audit
  over the real consumer list (O-C2). Model must implement FINAL and
  LOG-FINAL as separate sets with separate consumers.
- **Labelled conditional runs:** Run any subset above separately,
  each with its configuration tuple, no merging, no cross-alternative
  safety claim. This authorizes model runs, NOT a protocol selection.
**If deferred without scope note:** No finalisation model can be
built faithfully; I-Prefix, I-SingleCanonicalLog, I-PathGateEdge,
I-ContiguousLogPrefix cannot be checked for any alternative.
**Closure requirement:** Founder selection recorded, or conditional-run
authorization recorded with the exact alternative set, plus O-C8/O-C9
general proofs for the selected alternative (proofs are a later step,
not closed by this selection).

### L0-02 — Fork-choice function (O-FC-SEL). OPEN.
**Question:** Which fork-choice function, if any, does the model use
to define branch uniqueness (I_SingleCanonicalLog + I_ForkSelection)?
**Options:**
- **FC-1 highest QC view.** Deterministic from QC data; needs proof
  that it yields a unique branch under the selected alternative.
- **FC-2 highest justified height.** Needs the same uniqueness proof;
  height and QC view can disagree, so FC-1 and FC-2 results are not
  interchangeable.
- **FC-3 first-seen tie-break.** Highest determinism risk: it is
  observer-dependent (arrival order differs per validator). If
  selected, cross-validator determinism must be proven or explicitly
  bounded; otherwise branch uniqueness is UNCHECKED for FC-3 runs.
- **FC-4 reserved placeholder.** Contributes nothing until specified;
  selecting FC-4 without a specification is not a selection.
- **UNCHECKED labelling:** Model runs with branch uniqueness
  explicitly labelled UNCHECKED for the defined scope. Results must
  carry that label; no branch-uniqueness claim may be cited from
  such runs.
**If deferred without scope note:** I_SingleCanonicalLog and
I_ForkSelection cannot be closed for any model run.
**Closure requirement:** Selection (or UNCHECKED authorization)
recorded, plus per-function bounded checks and a general uniqueness
proof for the selected function (later step).

### L0-03 — B3 LOG-FINAL semantics (O-F5). OPEN, conditional on B3.
**Question (only if B3 is selected or run conditionally):** Is
LOG-FINAL (a) the immutable derived prefix
`logFinalSet_derived = {x in finalSet: Ancestors(x) subset of finalSet}`
(monotonic, default in corrected blueprint), or (b) the mutable
`eligiblePrefix` (NOT a log, never for consumers)?
**Consequences:** Under (a), monotonicity is a checkable property
and consumers use logFinalSet_derived. Under (b), there is NO log
object for consumers from this mechanism at all — consumer separation
(O-C2) must then be satisfied by a different, specified mechanism,
or B3(b) runs cannot support any §9 consumer claim. The two semantics
must never be mixed in one run or one result.
**If B3 is not selected:** L0-03 is moot for the model but remains
OPEN as a protocol decision for any future B3 consideration.
**Closure requirement:** Semantics choice recorded (if B3), plus
O-F5 monotonicity proof for (a) or consumer-mechanism specification
for (b), plus consumer audit (O-C2) over the real consumer list.

## Group B — Gap, QC, stake, lock (L0-04–L0-10)

### L0-04 — Gap attestation wording + category (D1). OPEN.
**Question:** Is the verbatim attestation text adopted, and is the
false-attestation category adopted? Research text (Option 3C):
*"By signing this attestation for view v, I attest that I have cast
no vote in view v and I will cast no vote in view v after this
attestation; a vote in view v after this attestation constitutes
false-attestation evidence equivalent in category to equivocation,
subject to Phase 2 adoption of that category."*
**Options:** (a) Adopt text + category as stated. (b) Adopt text
with amended category (amendment must be written out in full).
(c) Defer with scope note: gap-dependent model features (gap
formation, gap-gated finalisation, withheld-QC traces) excluded from
model scope until D1 is decided.
**Consequences of adoption:** Enforcement is detection/invalidation
+ accountability only; cryptographic prevention is IMPOSSIBLE and
must be stated as a limit in every gap claim. A vote after attestation
is then a slashable/accountable event under the adopted category, not
merely a protocol anomaly.
**Closure requirement:** Wording + category recorded in full, plus
enforcement specification (detection, invalidation scope per L0-06,
accountability procedure) — enforcement procedure itself is a later
specification step, not closed by wording adoption alone.

### L0-05 — Gap format + threshold (D7). OPEN.
**Question:** What is a gap certificate's format, and what threshold
forms one? Formation threshold and finalisation threshold must be
distinguished if they differ; if they are the same, that must be
stated explicitly, not assumed.
**Options:** Specify format (fields: pair (B,C), views covered,
attester set, attestation references) + threshold (count / stake
weight / distinct-validator rule) in full; or defer with scope note
(gap-certificate formation excluded from model scope; gap-gated
finalisation traces cannot then be built).
**Closure requirement:** Format + threshold recorded, plus O-F1 gap
formation liveness disposition (formation liveness cost accepted, or
alternative selected under D11).

### L0-06 — QC invalidation variant + timing (D2, O-I1, O-I2). OPEN.
**Question:** When a QC is invalidated (e.g. gap attestation proves a
contributing vote should not count), does invalidation apply
prospectively only, retroactively, or per reliance stage?
**Options:** (a) Prospective only: already-occurred reliance persists;
invalidation blocks future reliance only. (b) Retroactive: past
reliance recomputed (third-party verifier recomputation, O-I2) —
but retroactive invalidation must never be presented as un-finalising
a finalised block (finality never reverts). (c) Per-stage scope:
different scope at formation, at finalisation, and after finalisation,
specified stage by stage.
**Timing (O-I1) must also be specified:** Invalidation after reliance
but before finalisation must block finalisation; invalidation after
finalisation cannot block it. Delayed propagation (a validator learns
of invalidation late) must be modelled as a timing window, not assumed
away. Slashing linkage is kept distinct from invalidation scope
(RI-33): invalidation is about counting, slashing is about punishment.
**If deferred:** QC eligibility at use (qcActive) cannot be modelled
faithfully; finalisation traces that rely on invalidated QCs are
uninterpretable.
**Closure requirement:** Variant + per-stage scope + timing rule
recorded, plus traces for invalidation before formation, between
formation and finalisation, and after finalisation, per chosen variant.

### L0-07 — B_eff acceptance (D3). OPEN. UNRESOLVED as measurement.
**Question:** Does the founder explicitly accept B_eff < W/3 as an
assumption, knowing B_eff = Byzantine ∪ P0-violating power counted
once, and the B_p0 component is UNMEASURABLE from on-chain data?
**Options:** (a) Accept, with the acceptance recorded as an explicit
assumption in every dependent safety claim (R1 reporting control only;
no model, proof, or implementation closes this). Governance/monitoring
may track proxies, but monitoring must never be labelled measurement
of B_p0. (b) Do not accept: then no safety claim depending on
B_eff < W/3 can be made at all, and the model runs only under the
labelled assumption "IF B_eff < W/3" without any claim that it holds
in reality.
**Closure requirement:** Acceptance record (or non-acceptance record)
per dependent claim. There is no model/proof closure for this decision
by construction — it is a REAL-WORLD ASSUMPTION decision.

### L0-08 — Lock conjunction + rank (D5). OPEN.
**Question:** Is the corrected voting conjunction adopted? Corrected
conjunction (PROPOSED, from Option 3C + Trace L4 correction): vote
only if view monotonicity AND (extends lock chain OR parent-QC view
strictly greater than lock view) AND P0/DA AND gap completeness;
rank only after the lock gate, never overriding a valid safety lock.
**Options:** (a) Adopt conjunction as stated. (b) Adopt an approved
alternative conjunction, written out in full with its own Trace L4
counterexample analysis. Rank (QC view, height, hash) ordering for
tie-breaking within the gate must be specified if rank is used at all;
arbitrary ranks must be shown never to override a valid lock (O-S5).
**Closure requirement:** Conjunction recorded, plus general
lock-safety proof (O-S4) and rank-never-overrides proof (O-S5) as
later steps, plus traces for rank-vs-lock pairs (including NT-S5/NT-S4
once registered under L0-19).

### L0-09 — Stake cap + minimum validators (D6). OPEN.
**Question:** What is the stake cap, what is the minimum number of
distinct validators for a QC, and how is each enforced?
**Options:** Specify values + enforcement (cap enforcement at QC
formation and at finalisation; QC failure below minimum distinct
validators) in full; or defer with scope note (QC counting in the
model then uses validator-counting only, labelled as such, and no
stake-weighted claim may be cited from those runs).
**Closure requirement:** Values + enforcement recorded, plus traces
(cap enforcement, QC failure below minimum) and B_eff interaction
analysis (analysis, not B_p0 measurement — see L0-07).

### L0-10 — Aggregation construction (D10, A3). OPEN.
**Question:** What threshold-signature aggregation construction is
used, and is its cryptographic security proven as a separate
deliverable (A3)?
**Options:** (a) Specify construction in full + commission the A3
cryptographic proof as a separate deliverable (model assumes
aggregationValid as an INPUT flag until A3 exists; counting alone
never satisfies threshold). (b) Authorize per-variant model runs with
aggregationValid as an explicit input (valid / invalid at same vote
count, distinctness failure, double-counting) — labelled as input
variation, not as aggregation security evidence.
**Closure requirement:** Construction specification + A3 proof (for
protocol aggregation claims), or explicit input-flag labelling (for
model runs only). Aggregation security is never closed by a model run.

## Group C — Recovery, S7, crash, halt (L0-11–L0-18)

### L0-11 — Migration + audit window (D8, D-N3). OPEN.
**Question:** Which migration option, which cross-transition rule,
and what audit publication + freeze window apply?
**Options:** Specify migration option + rule (how FL_old transitions
to FL_new, hybrid transition log contents S1–S5), audit publication
completeness (what is published, where, before migration takes
effect), and freeze-window enforcement (how long migration is frozen
for audit, what blocks it). Snapshot during a partition must be
specified as REJECTED or DEFERRED — "either" is not a specification.
**If deferred with scope note:** Migration/epoch features excluded
from model scope; settlement traces during migration cannot be built.
**Closure requirement:** Option + rule + audit + freeze window
recorded, plus traces (migration during partition, post-snapshot gap
finalisation ⇒ abort + re-audit, epoch during freeze, deadline expiry
during freeze forbidden).

### L0-12 — Epoch trigger (Item 6 vs C1–C4). OPEN.
**Question:** What triggers an epoch transition, in finalised-block
terms? The blueprint's Item 6 epoch trigger is NOT C1–C4 compliance
and must not be cited as such.
**Options:** Specify the trigger as a finalised-block event (never
wall-clock), with its interaction with settlement deadlines and
migration frozen state. Or defer with scope note (epoch transitions
excluded from model scope).
**Closure requirement:** Trigger specification recorded, plus traces
(epoch advance during freeze rejected, duplicate advance rejected as
stale, epoch consequences for non-COMMITTED settlements per v0.4).

### L0-13 — Deadline convention + value (A-M1, O-M4, O-M5). OPEN.
**Question:** Convention A (creation + D: old 111 → new 110) or
Convention B (creation + D + 1: old 112 → new 111)? And what is D?
**Options:** Select A or B, and specify D (value). Selecting a
convention without D, or D without a convention, is incomplete.
**Consequences:** Every deadline-dependent trace, invariant, and rule
must be re-stated under the selected convention; Item 9 traces must
be re-checked under it. A trace computed under the other convention
is not evidence for the selected convention.
**Closure requirement:** Convention + D recorded, plus re-statement
of all deadline-dependent rules/traces under the selected convention.

### L0-14 — SafeMode exit (D-N1). OPEN. Exit BLOCKED until decided.
**Question:** What authorizes SafeMode exit, what resolves each exit
reason, and what format does the exit check log take?
**Options for authorization source (none selected, candidates only):**
(a) Validator self-authorization after P1–P4 checks (check log as
evidence). (b) Quorum/peer attestation (QC-backed, not mere peer
majority). (c) Operator/founder manual approval (durable approval
record). Self-authorization must NOT be treated as default.
**Per-reason resolutions (each OPEN, must be specified per reason):**
DISAGREEMENT, FAILURE, INCOMPLETE, INCOMPATIBLE, S7-UNVERIFIED,
S7-CONTRADICTORY — a single generic "resolve and exit" procedure is
not a specification.
**Check-log format (OPEN):** Each check result + version/sequence at
check time + S7 result, durably logged before the EXIT record (V2.3
Point 2 ordering X1–X6). An EXIT record without a matching check log
and authorization log is an EXIT-CLAIM PENDING VERIFICATION, not an
exit.
**Preconditions P1–P5 (all must hold, none satisfiable on current
documents until L0-17 and S7 sources are specified):** P1 recovery
decision complete (E1–E8 incl. A-KNOWN-6G/6L); P2 original reason
resolved per reason; P3 S7 current at exit time (fresh recheck);
P4 no conflicting in-progress decide/apply/migration/epoch/
finalisation (or each handled by a specified procedure); P5
authorization obtained + durably logged BEFORE the EXIT record.
**Closure requirement:** Authorization source + per-reason
resolutions + check-log format recorded, plus crash traces at every
exit step (X1–X6) and (i) check log + (ii) authorization log +
(iii) EXIT record verification traces.

### L0-15 — S7 reconciliation authority. OPEN. Separate from D-N1.
**Question:** Who authorizes leaving S7-CONTRADICTORY (validator-wide
SAFE_MODE on global source disagreement)?
**Options (none selected):** (a) Validator self-reconciliation
(auditable resolution record). (b) Quorum attestation (QC-backed).
(c) Operator/founder manual approval (durable approval record).
Reconciliation authority is its OWN decision: choosing D-N1
authorization does not choose reconciliation authority, and vice versa.
**Leaving conditions L1–L8 (all required, none waivable by time or
operator assertion or single-source availability):** L1 fresh verified
agreement on ALL components; L2 cause with evidence (unknown cause
fails; corruption reclassifies to S7-UNVERIFIED handling); L3
authorization (currently unsatisfiable ⇒ leaving BLOCKED); L4 durable
resolution record; L5 verification (1)–(6) as a distinct step; L6
fresh S7 recheck AFTER resolution; L7 no other SAFE_MODE reason
pending; L8 per-action rechecks thereafter.
**Permanent disagreement:** Remain S7-CONTRADICTORY indefinitely —
no timeout, no automatic exit, no single-source fallback — unless a
timeout/fallback rule is separately specified, justified, and approved
as a new protocol rule (NOT proposed in any current document).
**Closure requirement:** Authority + procedure satisfying Challenge
§3.5 (i)–(v) recorded, plus crash traces C1–C8 and permanent /
unavailable-source handling decision.

### L0-16 — Crash inventory, DISAGREE, commit marker. OPEN.
**Question (three sub-questions, each needs its own answer):**
(a) Crash points: Are PROPOSED CP7–CP10 adopted (settlement decide/
apply, migration snapshot, epoch transition, invalidation
application) or explicitly excluded with a scope note? CP1–CP6 are
specified (V2 §3); CP7–CP10 are PROPOSED only.
(b) DISAGREE resolution: R1 (amend registry to S-INTERNAL
DISAGREEMENT), R2 (amend to S-VERSUS-H INCOMPATIBILITY), or R3
(retire the row)? None selected. Until one is chosen, DISAGREE must
not be cited as a lock-versus-lock exhibit; traces cite a PROPOSED
successor diagnostic or report INCOMPLETE for registry purposes.
Registry text itself is NOT changed by this sheet (registry amendment
requires its own approved amendment after selection).
(c) Commit-marker format: What durable marker distinguishes
WAL-fsynced (COMMITTED) entries from present-but-unfsynced entries
(Challenge §1.1)? Format (commit marker naming highest committed WAL
sequence, or approved watermark alternative) is OPEN. Until specified
+ approved, "replay discards uncommitted entries" is PROPOSED but not
implementable as specified.
**Closure requirement:** CP inventory decision + DISAGREE resolution
selection + marker format recorded, plus every CE row mapped with
write/recovery sequences and WAL replay traces T-WAL-1/2/3.

### L0-17 — Storage/history retrievability (A-L3-S, A-L3-H). OPEN.
**Question:** Are Path S (storage) and Path H (history) retrievability
accepted, independently? A-L3 split into A-L3-S and A-L3-H, both OPEN.
**Vocabulary (corrected, V2.1):** Path S reports lock state only
(S-LOCK(L), affirmative S-NONE, or S-FAIL(state)); Path H reports
history state only (H-COMPLETE(log) or H-FAIL(state)). H-lock phrases
are FORBIDDEN in future tables/traces/results. No lock-derivation
rule from ownVoteLog is invented by this sheet.
**Compatibility evidence E1–E8 (all required for KNOWN/KNOWN-NONE,
all currently BLOCKED):** E1 S lock evidence complete; E2 H history
complete; E3 lock-adoption marker ordered vs votes (MISSING,
blocking); E4 logging-before-sending specified + enforced (MISSING,
blocking); E5 attestation coverage/validity, location MISSING
(blocking); E6 invalidation knowledge source (MISSING, blocking);
E7 S7 condition = A-KNOWN-6G + A-KNOWN-6L (see Group C, S7 sources);
E8 fresh P0/DA per new vote. Compatibility (not "agreement") is
UNEVALUABLE if E3/E4/E5 is missing — never a pass.
**KNOWN / KNOWN-NONE remain BLOCKED** on current documents regardless
of this sheet: this sheet records what would satisfy them, it does
not satisfy them. Single-path success → SAFE_MODE INCOMPLETE
RECOVERY (V2 conservative rule, PROPOSED as protocol decision, not
approved by this sheet).
**Closure requirement:** A-L3-S and A-L3-H acceptances recorded
independently (or explicitly not accepted, with KNOWN staying
BLOCKED), plus joint-recovery traces showing compatibility or
SAFE_MODE on any missing item.

### L0-18 — Gap-conflict halt scope (D-N2) + replay commitment (D4). OPEN.
**Question:** (a) When gap evidence conflicts (e.g. attestation vs
vote history), what halts, and how is the halt resolved (D-N2)?
(b) What pre-vote replay commitment does a validator make (D4) —
what does it commit to having replayed, and what evidence of that
commitment exists for later challenge?
**Options:** Specify halt scope (per-validator halt, per-gap halt,
validator-wide halt — each with different liveness cost) + resolution
procedure; specify replay commitment (commitment content, evidence
form, challenge procedure). Or defer each with a scope note (gap-
conflict traces / replay-commitment traces excluded from model scope).
**Closure requirement:** Halt scope + resolution + replay commitment
recorded, plus traces (gap conflict with halt, replay commitment
challenged and verified/failed).

## Group D — Duration, registry (L0-19)

### L0-19 — View duration (D9) + Appendix B registration (BL11). OPEN.
**Question (two sub-questions, second needs its own approval):**
(a) View duration / pacemaker: What is the view duration rule, and
for which weakest-validator class is it feasible (replay + DA time
measured for that class)? Duration values are NOT invented by this
sheet; the decision specifies the class + measurement method + rule,
and feasibility is established by MEASUREMENTS (real-world evidence,
not model evidence) in a later step. Until measured, DURATION_FAILURE
remains a feasibility counterexample, not a closed issue.
(b) Appendix B registration: Register, with full setups, the
PROPOSED test IDs NT-S4, NT-S5, NT-M2, NT-QC-DBL (defined in closure
plan §(g) only, no results claimed), PrefixCheck / candidate variables
and traces, TOCTOU / STALE-COMMIT traces, WAL traces, reconciliation
traces, and all traces beyond T1–T14 that the model will cite, plus
the DISAGREE resolution once selected (L0-16). Until registered, no
NT ID or new trace ID may be cited as an existing test or as having
results.
**Closure requirement (a):** Weakest-validator class + duration rule
recorded, plus measurements in a later step. **Closure requirement
(b):** Separate founder approval registering each ID/trace with its
full setup in Appendix B. This sheet proposes the registration list;
it does not register anything by itself.

## Decision log (to be completed by the founder's approval message)

| ID | Founder response (select / conditional runs / defer + scope note) | Date | Model impact recorded |
|---|---|---|---|
| L0-01 | | | |
| L0-02 | | | |
| L0-03 | | | |
| L0-04 | | | |
| L0-05 | | | |
| L0-06 | | | |
| L0-07 | | | |
| L0-08 | | | |
| L0-09 | | | |
| L0-10 | | | |
| L0-11 | | | |
| L0-12 | | | |
| L0-13 | | | |
| L0-14 | | | |
| L0-15 | | | |
| L0-16 | | | |
| L0-17 | | | |
| L0-18 | | | |
| L0-19 | | | |

**Rules for completing this log:** One row per decision, no row left
blank after approval (a blank row means the decision was not
addressed, not that it was approved). A row marked "defer" must carry
its scope note in the same row. A row marked "conditional runs" must
list the exact configuration set. The completed log, not this sheet's
proposals, is the record the Model Authorization Sheet will cite.

## Freeze confirmation for this sheet

- Existing documents (v0.4, blueprint, V1, V2, V2.1, V2.2, V2.3,
  Challenge, Global TOCTOU Correction, Proof Closure Plan, Invariant
  Traceability Matrix, Readiness Assessment, Prototype Authorization
  Sheet, prototype-local evidence): NOT MODIFIED by this sheet.
- No v0.5. No ".tla", ".cfg", ".py" or executable files: NOT CREATED
  by this sheet. No TLC, simulation, or model execution: NOT
  PERFORMED for this sheet.
- BL1–BL16: OPEN. All 21 invariants, 53 obligations, 34 assumptions,
  founder decisions: OPEN. KNOWN / KNOWN-NONE: BLOCKED.
- This sheet is a PROPOSAL. It selects nothing by itself.

L0 DECISION SHEET — REVIEW REQUIRED. MODEL CONSTRUCTION NOT AUTHORIZED.
