# MARWANTA — MODEL AUTHORIZATION APPROVAL RECORD

**Record date:** 2026-11-05 (founder approval message received in the
MARWANTA side chat, 2026-11-05 13:49 IST).
**Purpose:** This file records the founder's approvals verbatim. It
does NOT modify any proposal document. The three proposal files
(L0 Decision Sheet, Corrected Blueprint Re-issue, Model Authorization
Sheet) remain as written, with their closing statuses intact. This
record is the authorization the Model Authorization Sheet §8 requires.

## 1. Corrected Blueprint Re-issue (BL1) — APPROVED, BL1 CLOSED for model baseline text

The founder reviewed and APPROVED the Corrected Blueprint Re-issue
(`MARWANTA_MODEL_FIDELITY_REDESIGN_BLUEPRINT_CORRECTED_REISSUE.md`,
1,495 lines) as the baseline model design. BL1 is formally closed
for model baseline text. BL1 closure covers the corrected TEXT only:
it does not approve the protocol, does not select any alternative,
fork-choice, or founder decision, and does not close any other BL
blocker (BL2–BL16 remain OPEN, except as satisfied by the L0 log and
this record's prerequisites, see §3).

## 2. L0 Decision Log — COMPLETED (verbatim from founder message)

- L0-01: Alternative A (path-gated, edge-bound)
- L0-02: FC-1 (highest QC view)
- L0-03: N/A (Alternative A selected; B3 moot for this run)
- L0-04: Adopt Option 3C verbatim wording + false-attestation category
- L0-05: Defer with scope note (gap formation threshold excluded;
  test-only count used)
- L0-06: Prospective only (finalized blocks never revert)
- L0-07: Accept B_eff < W/3 as explicit real-world assumption
  (R1 control)
- L0-08: Adopt corrected voting conjunction (Option 3C / Trace L4)
- L0-09: Equal test stake across 4 validators; stake-weighting
  deferred with scope note
- L0-10: AggregationValid as explicit input flag (per-variant runs,
  security proven separately under A3)
- L0-11: Defer migration scope note (snapshot rejected during
  partition; freeze window enforced)
- L0-12: Finalised-block event trigger only (never wall-clock)
- L0-13: Convention A (creation + D, 111->110) with D=10 test blocks
- L0-14: Option (c) Operator/founder manual durable approval required
  for D-N1 exit; fail-closed
- L0-15: Option (c) Operator/founder manual approval for
  S7-CONTRADICTORY reconciliation; zero timeout exit
- L0-16: CP1-CP6 active, CP7-CP10 excluded with scope note; R1
  S-INTERNAL DISAGREEMENT; sequence commit-marker
- L0-17: Accept A-L3-S and A-L3-H independently; single-path success =
  SAFE_MODE INCOMPLETE RECOVERY
- L0-18: Defer gap halt with scope note; Layer 1 pre-vote replay
  commitment required
- L0-19: (a) Weakest-validator duration deferred to hardware
  benchmark; (b) Register proposed test IDs (NT-S4, NT-S5, NT-M2,
  NT-QC-DBL, TOCTOU/STALE-COMMIT, WAL traces) as model traces per
  P-4(b).

**Interpretation notes recorded with the log (from the Model
Authorization Sheet P-4 and the L0 sheet):** L0-19(b) registers the
listed IDs as MODEL TRACES per P-4(b) — labelled model traces, NOT
Appendix B traces. They must never be cited as Appendix B evidence.
L0-05, L0-09, L0-11, L0-18 deferrals are deferrals WITH the scope
notes stated in each row; the deferred features are excluded from
model scope as stated, not silently dropped. L0-13 D=10 is a TEST
value (test blocks); deadline expiry at B_f + 10 is outside the
authorized height bound 0..4 and is therefore NOT observable in the
model runs — this is a recorded bound limitation, not a protocol claim.

## 3. Model Authorization Sheet — APPROVED under Prerequisites P-1 through P-5

Prerequisite status at approval:
- P-1 L0 Decision Log completed: SATISFIED by §2 above (all 19 rows
  completed, no row blank).
- P-2 Corrected blueprint approved (BL1): SATISFIED by §1 above.
- P-3 Configuration set authorized (BL2): SATISFIED by the authorized
  configuration in §4 below.
- P-4 Trace registration disposition (BL11): SATISFIED as P-4(b)
  model-trace labelling for the L0-19(b) IDs (see §2 note). No ID in
  this run is cited as an Appendix B trace.
- P-5 Bounds + feasibility rule authorized (BL10): SATISFIED by the
  bounds in §4 below and the feasibility rule in the Model
  Authorization Sheet §3 (INCOMPLETE, never silently re-bounded).

## 4. Authorized configuration (verbatim from founder message)

(Alternative A, FC-1, prospective, n/a, specified-test, Convention A,
boolean-quorumLost, NORMAL/NEGATIVE-CONTROL/CRASH/PARTITION families,
bounds: 4 validators, heights 0..4).

**Families NOT authorized:** MIGRATION and OUT-OF-ASSUMPTION. No
migration trace, no out-of-assumption (B_eff >= W/3) trace may be run
or cited under this authorization. Model construction proceeds in a
separate model directory (`~/workspace/marwanta/phase2-model/`)
strictly under Model Authorization Sheet §2–§8 scope. No prototype
expansion, no testnet, and no protocol mainnet claims authorized.

## 5. What this record does NOT do

- It does not modify v0.4, the original blueprint, V1, V2, V2.1, V2.2,
  V2.3, the Challenge, the Global TOCTOU Correction, the Proof Closure
  Plan, the Invariant Traceability Matrix, the Readiness Assessment,
  the Prototype Authorization Sheet, or prototype-local evidence.
- It does not close BL2–BL16 (except BL2/BL10/BL11 dispositions
  recorded in §3, which are authorizations for THIS RUN's scope, not
  general closures), any invariant, obligation, or assumption.
- It does not authorize any model result to be cited as a general
  proof, real-world evidence, or protocol decision.

MODEL AUTHORIZATION APPROVAL — RECORDED 2026-11-05. MODEL CONSTRUCTION AUTHORIZED FOR THE §4 CONFIGURATION ONLY.
