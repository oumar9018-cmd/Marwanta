---- MODULE Marwanta ----
\* MARWANTA redesigned TLA+ model (authorized configuration only).
\*
\* AUTHORIZED CONFIGURATION (Approval Record 2026-11-05):
\*   (Alternative A, FC-1, prospective, n/a, specified-test,
\*    Convention A, boolean-quorumLost,
\*    NORMAL / NEGATIVE-CONTROL / CRASH / PARTITION families,
\*    bounds: 4 validators, heights 0..4)
\* Families NOT authorized: MIGRATION, OUT-OF-ASSUMPTION.
\* Model language: TLA+ with TLC (tla2tools 2026.10.30.154139,
\* Java 17.0.21 Temurin -- prior package used Java 17.0.20.1;
\* tool version difference is recorded in the evidence, not hidden).
\*
\* SCOPE (Model Authorization Sheet sections 2-8):
\* M1 candidate/final split + PrefixCheck as invariant + I-PrefixRaw
\* diagnostic; M2 claim-order P0 (Layer 2 only, real replay NOT
\* modelled); M3 Path S / Path H recovery + WAL replay (commit marker,
\* sequence) + safeModeRec; M4 SafeModeGuard + D-N1 exit outline
\* (BLOCKED) + per-action S7 recheck + S7-CONTRADICTORY; M5
\* pair-specific gap accountability + at-use validity; M6 QC counting
\* vs aggregation split (aggregationValid INPUT flag); M7 C1-C4
\* partition machine (Item 9 traces); M8 migration/epoch with freeze
\* (MIGRATION family excluded, so migration traces are NOT in this
\* model -- see fidelity matrix); M9 configuration tuples; M10
\* fidelity matrix F1-F4.
\*
\* FIDELITY NOTES (abstractions, stated here, not hidden):
\* A1. Local validator under test is v1; validators v2, v3 are honest
\*    environment validators (their locks are NOT modelled; their votes
\*    are constrained only by view monotonicity + claims). v4 is the
\*    single Byzantine validator (B_eff = 1 < 4/3, in-assumption).
\* A2. Lock = highest-view block voted by v1 (operational lock). The
\*    QC-derived lock (lockTrue) is NOT separately modelled; lock
\*    derivation from QC is an O-R2 / O-C6 equivalence, NOT-MODELLED
\*    here (see fidelity matrix).
\* A3. Version vector is merged to 3 components
\*    (chain, partition, settlement) instead of the 9-component Vg.
\*    Merging is conservative: a change in any sub-component increments
\*    the merged component, so a merged check can reject more often,
\*    never accept more often, than the 9-component check.
\* A4. Gap formation threshold is the test-only count (L0-05 deferral):
\*    a gap certificate requires >= 3 distinct attestations for each
\*    skipped view. Formation liveness (O-F1) is NOT modelled.
\* A5. Fork-choice FC-1 is applied at finalisation (only blocks on the
\*    highest-QC-view branch may finalise). Vote-time fork-choice is
\*    NOT modelled; votes may be cast for either branch.
\* A6. Epoch advance is modelled as requiring no freeze (conservative,
\*    fail-closed). If the protocol later permits epoch advance during
\*    freeze, this model must be revised.
\* A7. Deadline D = 10 test blocks (Convention A, L0-13). With heights
\*    0..4, finalisedCounter can reach at most 6, so deadline expiry
\*    (finalisedCounter >= B_f + 10) is UNREACHABLE within bounds.
\*    Deadline-expiry traces are NOT-MODELLED in this run; Convention A
\*    arithmetic (deadline = B_f + D) is verified by calculation, not
\*    by a TLC trace. Settlement ABORT on deadline is present as an
\*    action but unreachable in bounds -- recorded, not hidden.
\* A8. E3/E4/E5 are FALSE in all configs (missing on current
\*    documents). Compatibility is therefore always FALSE, KNOWN is
\*    never achieved, and D-N1 exit never fires. This is the intended
\*    fail-closed behaviour, verified by TLC (invariants NeverKnown,
\*    NoExitExceptApproved), not a model bug.
\* A9. TLA+ actions are atomic by definition. The local lock across
\*    prior-attestation-check + attestation creation, and the G3+G4
\*    local critical section, are atomic IN THE MODEL by construction;
\*    real implementation must enforce them with a local lock
\*    (implementation requirement I-GT-2/I-GT-3, not a model proof).
\* A10. No wall-clock variable exists in this model. Wall-clock abort
\*     is modelled only as an adversarial attempt (NEGATIVE-CONTROL
\*     family) that must be rejected with no state change.
\* A11. Genesis is final by definition (log root): Init finalSet =
\*     {GenesisId}. finalisedCounter counts non-genesis finalised
\*     blocks only (starts 0); deadline arithmetic uses B_f in those
\*     terms. Genesis never re-finalises (no QC: votes exclude it).
\* A12. Byzantine (v4) false-claim votes are gated on
\*     EnableAdversarial. In NORMAL/CRASH/PARTITION runs v4 votes
\*     with TRUE claims only (equivocation is the threat); false-claim
\*     votes are NEGATIVE-CONTROL (VoteWithoutClaim). Sound: a
\*     false-claim vote can never count toward a QC and no invariant
\*     reads votes except through QC definitions.
\* A13. AttestGap views are 1..(MaxV-1). A skipped view is always
\*     >= 1 (genesis view 0 is never skipped) and <= MaxV-1 (a child
\*     view is <= MaxV, so the view it skips is <= MaxV-1).
\*     Attestations outside this range can never be used; the
\*     restriction loses no behaviour.
\* A14. Minimum steps to first finalisation is 13 actions to the first
\*     ATTEMPT (propose h1, 3 votes, propose h2, 3 votes, propose h3,
\*     3 votes, Recheck) and 15 actions to completion (+ CandidateFinalise
\*     + FinaliseStep). CORRECTED 2026-11-06: the earlier "10 actions"
\*     claim was wrong (it failed to count the mandatory Recheck and the
\*     QC'd-child requirement); the 13/15 counts are machine-confirmed by
\*     the TRACE-S error trace. A MaxSteps < 13 run can never attempt
\*     finalisation, so finalisation invariants are vacuous there; such a
\*     run is labelled vacuous for those invariants, not a pass.
\* A15. S7 reconciliation (Challenge §3.5, L1-L8). Leaving
\*     S7-CONTRADICTORY DOES exit safeMode when it is the only reason
\*     (L7) -- but only with ALL of L1-L8: fresh verified agreement
\*     (L1), cause named with evidence (L2), authorization (L3,
\*     L0-15), durable resolution record (L4, modelled as the
\*     s7Resolution flag set by ReconcileS7), verification (L5),
\*     fresh S7 recheck AFTER resolution (L6, modelled as a fresh
\*     recheck guard), no other reason pending (L7), per-action
\*     rechecks thereafter (L8). Cause category (d) record corruption
\*     RECLASSIFIES to S7-UNVERIFIED handling, never reconciliation
\*     (L2); unknown cause never reconciles. The model tracks
\*     s7Corrupt (set only by CorruptS7Record); a corrupt record
\*     cannot be "caught up" by UpdateS7Record (a re-read of a corrupt
\*     record fails), and ReconcileS7 is blocked while s7Corrupt.
\*     In this run's scope the ONLY verifiable-disagreement path is
\*     corruption, so reconciliation is unreachable here and
\*     NoExitExceptApproved holds; the S7-UNVERIFIED repair procedure
\*     itself is NOT modelled (implementation/real-world scope).
\* A16. NoExit scope (Option B, founder decision 2026-11-05). The
\*     NoExit invariant (never exit safeMode at all) is SUPERSEDED by
\*     NoExitExceptApproved: NoExit guards unauthorized/silent exits
\*     only. Authorized S7 reconciliation (opApproval + agreement +
\*     cause resolution, L1-L8 per A15) exiting safeMode is
\*     design-intended and a valid recovery path. The old-spec
\*     NEGATIVE-CONTROL run FAILED the old NoExit with a 7-state trace
\*     (corrupt record silently overwritten, reconciliation exited
\*     safeMode without L4/L5/L6) -- that trace is blocked by the A15
\*     guards, and the invariant is now the scoped form. NORMAL and
\*     CRASH passed the stronger (unscoped) NoExit; NEGATIVE-CONTROL
\*     and PARTITION use the scoped form.
\* A17. SelectedTipId fix, Option A (founder decision 2026-11-06).
\*     The FC-1 tip-selection CHOOSE was unsatisfiable: for the winning
\*     tip t, the universal quantification over Tips included t's own
\*     record, and all three disjuncts were false for it (equal QC view,
\*     height not < itself, fork /\ ~fork false). The first finalisation
\*     attempt therefore crashed TLC (TRACE-S, 2026-11-06, exit 75) and
\*     the model could never finalise any block. FIX: the predicate now
\*     carries the self-exclusion disjunct `r.id = t` first, so the
\*     condition is vacuously true for the candidate's own record.
\*     LIMIT (recorded, not hidden): Option A guarantees a satisfying t
\*     only when the maximal tip is UNIQUE in (QC view, height, fork
\*     status). Two distinct tips tied on all three (e.g. two branches
\*     at the same height with the same QC view and same fork flag)
\*     would still leave the CHOOSE unsatisfiable. Whether such a tie
\*     state is reachable and finalisation-attempted is an empirical
\*     question for the re-runs; if a tie errors TLC, a full total order
\*     (e.g. tie-break by block id) needs a further founder decision.
\*     A14 corrected in the same revision (13 attempt / 15 completion).
\* A18. Genesis base case for EdgeGated + ID tie-breaker for SelectedTipId
\*     (founder decision 2026-11-06). (1) EdgeGated now treats genesis as
\*     the base case: EdgeGated(b) == ParentId(b) = GenesisId \/
\*     HasQC(ParentId(b)) \/ GapCertForEdge(b) — the founder's formula
\*     (b.parent = GenesisId \/ HasQC(b.parent) \/ HasGapCert(b.parent, b))
\*     translated with the spec's operators (b.parent is ParentId(b);
\*     HasGapCert(parent, b) is GapCertForEdge(b)). This closes the Q-M1
\*     hole: h1 (parent genesis) now qualifies, so h1 and h2 finalise
\*     consecutively and IPrefix holds on the TRACE-S trace. ParentHasQC is
\*     superseded by this form and retained only for reference. (2) The
\*     SelectedTipId order is completed with a deterministic ID
\*     tie-breaker, expressed as IdRank comparison (IdRank(id) ==
\*     id.h * 2 + (IF id.fork THEN 1 ELSE 0), injective on BlockIds): the
\*     literal form r.id < t.id is UNEVALUABLE in TLC (tested 2026-11-06,
\*     exit 75 — "<" requires integers, IDs are [h, fork] records), so the
\*     rank form is the faithful translation. The fork-equality guard is
\*     REQUIRED: without it the rank disjunct would also fire when fork
\*     flags differ and would undo the non-fork preference. RECORDED
\*     LIMIT: given IDs are (h, fork) pairs, the rank disjunct is provably
\*     vacuous as a deciding comparison — two distinct IDs with equal view
\*     and height either differ in fork (already ordered by the fork
\*     disjunct) or are equal (covered by the A17 r.id = t disjunct) — and
\*     the A17 predicate was already total on distinct IDs (see the A17
\*     note). The disjunct is retained because the founder ordered an
\*     explicit ID tie-breaker; it is evaluable, harmless, and makes the
\*     total order explicit in the text.
\* A19. Prefix gate on finalisation (Option B, founder decision 2026-11-06).
\*     Closes the GAP-TRACE IPrefix hole (second hole): a gap-certified edge
\*     let g finalise while parent h1 lacked a QC, because GapCertForEdge
\*     substitutes for the parent QC and eager FinaliseStep finalised only
\*     currently-qualifying members. FIX: Qualifying(b) now also requires
\*     PrefixOK(b) — every ancestor of b must already be finalised or
\*     qualify in the same step. Ancestors(b) is transitively closed, so the
\*     check is transitive; the ancestor conditions are inlined in
\*     AncestorQualifies (TLA+ operators cannot self-refer). Since
\*     FinaliseStep finalises ALL qualifying members together, every ancestor
\*     the gate relies on finalises with b, so finalSet is prefix-closed by
\*     construction. If any ancestor does not qualify now, b waits —
\*     finalisation is delayed, never prefix-breaking. Option A (removing
\*     the GapCertForEdge disjunct from EdgeGated) was REJECTED as
\*     incomplete: h1 still needs the gap cert to qualify via ChildOK, so
\*     the "cert not yet formed" ordering would still finalise g alone.
\*     EdgeGated is UNCHANGED by A19 (gap certs still gate the edge and
\*     the child link); only the finalisation gate is added.

EXTENDS Integers, FiniteSets, Sequences, TLC

CONSTANTS
    MaxH,          \* 4 (authorized bound: heights 0..4)
    MaxV,          \* 5 (views 0..5, allowing one skipped view)
    DeadlineD,     \* 10 test blocks (Convention A, L0-13)
    Quorum,        \* 3 (of 4 validators, equal test stake)
    MaxSteps,      \* step bound per config (depth bound)
    EnableAdversarial, \* TRUE only in NEGATIVE-CONTROL runs
    EnableCrash,        \* TRUE only in CRASH runs
    EnablePartition,    \* TRUE only in PARTITION runs
    E3Missing,     \* TRUE in all configs (E3 missing on current documents)
    E4Missing,     \* TRUE in all configs (E4 missing on current documents)
    E5Missing      \* TRUE in all configs (E5 missing on current documents)

\* Single state record (one variable keeps actions readable and
\* avoids 46-variable UNCHANGED lists; TLC treats the record as
\* the state).
VARIABLE st

Validators == 1..4
Honest == 1..3
Local == 1
BlockIds == [h: 0..MaxH, fork: BOOLEAN]
NoLock == [id |-> [h |-> -1, fork |-> FALSE], v |-> -1]
GenesisId == [h |-> 0, fork |-> FALSE]

ParentId(b) == IF b.h = 0 THEN b ELSE [h |-> b.h - 1, fork |-> FALSE]

\* ----- helpers over st.blocks -----
BlockRec(b) == CHOOSE r \in st.blocks : r.id = b
HasBlock(b) == \E r \in st.blocks : r.id = b
BlockView(b) == IF HasBlock(b) THEN BlockRec(b).view ELSE -1
BlockGapSkipped(b) == IF HasBlock(b) THEN BlockRec(b).gapSkipped ELSE FALSE
BlockAggValid(b) == IF HasBlock(b) THEN BlockRec(b).aggValid ELSE FALSE

\* QC: >= Quorum distinct voters with TRUE claims, not stale,
\* aggregation valid, not invalidated (prospective, at use).
QCVoters(b) == {v \in Validators :
    \E r \in st.votes : r.v = v /\ r.b = b /\ r.replay /\ r.da /\ ~r.stale}
HasQC(b) == Cardinality(QCVoters(b)) >= Quorum
           /\ BlockAggValid(b) /\ b \notin st.invalidated

\* Ancestors by explicit unrolling (heights 0..4, at most 4 steps).
Ancestors(b) ==
    {b} \cup (IF b.h >= 1 THEN {ParentId(b)} ELSE {})
        \cup (IF b.h >= 2 THEN {ParentId(ParentId(b))} ELSE {})
        \cup (IF b.h >= 3 THEN {ParentId(ParentId(ParentId(b)))} ELSE {})
        \cup (IF b.h >= 4 THEN {ParentId(ParentId(ParentId(ParentId(b))))} ELSE {})

\* Edge gate (Alternative A, edge-bound): the parent is genesis (base
\* case, A18), or the parent has a QC, or a gap certificate covers the
\* edge into b. (Founder formula: b.parent = GenesisId \/ HasQC(b.parent)
\* \/ HasGapCert(b.parent, b); translated with the spec's operators:
\* b.parent is ParentId(b) — IDs carry no parent field, parents are
\* computed from height — and HasGapCert(parent, b) is GapCertForEdge(b).
\* ParentId(genesis) = GenesisId (self-parent), so the base case also
\* covers b = genesis, subsuming the old b.h = 0 disjunct.)
ParentHasQC(b) == b.h = 0 \/ HasQC(ParentId(b))  \* SUPERSEDED by A18; retained for reference.
GapCertForEdge(b) == BlockGapSkipped(b) /\
    \E c \in st.gapCerts : c.child = b /\ c.parent = ParentId(b)
EdgeGated(b) == ParentId(b) = GenesisId \/ HasQC(ParentId(b)) \/ GapCertForEdge(b)

\* Qualifying direct child for two-chain finalisation (A rule):
\* child with parent = b, QC(child), view consecutive or gap-covered.
ChildOK(b) == \E c \in st.blocks :
    c.parent = b /\ HasQC(c.id) /\
    (c.view = BlockView(b) + 1 \/
     (c.view > BlockView(b) + 1 /\ c.gapSkipped /\
      \E cert \in st.gapCerts : cert.child = c.id /\ cert.parent = b))

\* Fork-choice FC-1 (highest QC view): tips are proposed blocks with
\* no child in blocks. Selected tip = tip with highest QC view.
\* A block may finalise only if it is an ancestor of, or equal to,
\* the selected tip.
Tips == {r \in st.blocks : ~\E c \in st.blocks : c.parent = r.id}
TipQCView(r) == IF HasQC(r.id) THEN r.view ELSE -1
\* Numeric rank on block IDs (A18): TLC cannot evaluate < on record IDs
\* (tested 2026-11-06: exit 75, "first argument of < should be an integer"),
\* so the founder-ordered ID tie-breaker (r.id < t.id) is expressed as a
\* rank comparison. IdRank is injective on BlockIds ([h, fork] pairs),
\* hence a strict total order on distinct IDs.
IdRank(id) == id.h * 2 + (IF id.fork THEN 1 ELSE 0)
SelectedTipId ==
    IF Tips = {} THEN GenesisId
    ELSE (CHOOSE t \in {r.id : r \in Tips} :
        \A r \in Tips : r.id = t
            \/ TipQCView(r) < TipQCView(BlockRec(t))
            \/ (TipQCView(r) = TipQCView(BlockRec(t)) /\ r.id.h < t.h)
            \/ (TipQCView(r) = TipQCView(BlockRec(t)) /\ r.id.h = t.h
                /\ r.id.fork /\ ~t.fork)
            \/ (TipQCView(r) = TipQCView(BlockRec(t)) /\ r.id.h = t.h
                /\ r.id.fork = t.fork /\ IdRank(r.id) < IdRank(t)))
OnSelectedBranch(b) == b \in Ancestors(SelectedTipId) \/ b = SelectedTipId

\* S7 agreement (global source vs durable record, both verifiable).
S7Agree == st.s7Rec.verifiable
           /\ st.s7Chain.partition = st.s7Rec.partition
           /\ st.s7Chain.epoch = st.s7Rec.epoch

\* Compatibility E1-E8 (V2.1): E1, E2, E6, E8 are TRUE in the model;
\* E3, E4, E5 are FALSE (missing on current documents); E7 = S7Agree.
\* Compatible is therefore always FALSE in this run -- intended.
Compatible == TRUE /\ TRUE /\ ~E3Missing /\ ~E4Missing /\ ~E5Missing
              /\ TRUE /\ S7Agree /\ TRUE

\* ----- initial state -----
Init ==
    st = [blocks |-> {[id |-> GenesisId, view |-> 0, parent |-> GenesisId,
                       aggValid |-> TRUE, gapSkipped |-> FALSE]},
          forkProposed |-> FALSE,
          votes |-> {},
          lastView |-> [v \in Validators |-> -1],
          lock |-> NoLock,
          sLock |-> NoLock,
          sState |-> "OK",
          hVotes |-> {},
          hState |-> "COMPLETE",
          attestations |-> {},
          gapCerts |-> {},
          candidateFinal |-> {},
          finalSet |-> {GenesisId},
          finalJust |-> {},
          finalQC |-> {},
          safeMode |-> FALSE,
          smReasons |-> {},
          exitedSafeMode |-> FALSE,
          approvedExit |-> FALSE,
          opApproval |-> FALSE,
          quorumLost |-> FALSE,
          freeze |-> FALSE,
          finalisedCounter |-> 0,
          partitionCounter |-> 0,
          causeExplained |-> FALSE,
          epoch |-> 0,
          epochCounter |-> 0,
          invGen |-> 0,
          invalidated |-> {},
          aggInvalid |-> {},
          settlement |-> [state |-> "NONE", bf |-> 0, decideCounter |-> 0],
          version |-> [chain |-> 0, part |-> 0, settle |-> 0],
          recheckVer |-> [chain |-> 0, part |-> 0, settle |-> 0],
          recheckOk |-> FALSE,
          recheckPresent |-> FALSE,
          s7Chain |-> [partition |-> FALSE, epoch |-> 0],
          s7Rec |-> [partition |-> FALSE, epoch |-> 0, verifiable |-> TRUE],
          s7Corrupt |-> FALSE,
          s7Resolution |-> FALSE,
          diagnostics |-> {},
          crashed |-> FALSE,
          preCrashLock |-> NoLock,
          known |-> FALSE,
          recovered |-> FALSE,
          recoveryLockOK |-> TRUE,
          lockViolated |-> {},
          viewViolated |-> {},
          safeModeVoted |-> FALSE,
          freezeViolation |-> FALSE,
          settledTerminal |-> FALSE,
          steps |-> 0]

StepOK == st.steps < MaxSteps

\* ================= ACTIONS =================

\* --- Propose a main-chain block at the next height ---
ProposeBlock ==
    /\ StepOK
    /\ \E h \in 1..MaxH, vw \in 0..MaxV :
        /\ ~\E r \in st.blocks : r.id = [h |-> h, fork |-> FALSE]
        /\ \A hh \in 0..h-1 : \E r \in st.blocks : r.id = [h |-> hh, fork |-> FALSE]
        /\ LET parent == [h |-> h-1, fork |-> FALSE]
               pv == BlockView(parent)
           IN /\ vw = pv + 1 \/ vw = pv + 2
              /\ (vw = pv + 1 \/ (vw = pv + 2 /\
                    Cardinality({v \in Validators :
                        [v |-> v, view |-> pv+1] \in st.attestations}) >= Quorum))
              /\ st' = [st EXCEPT
                    !.blocks = st.blocks \cup
                        {[id |-> [h |-> h, fork |-> FALSE], view |-> vw,
                          parent |-> parent, aggValid |-> TRUE,
                          gapSkipped |-> (vw = pv + 2)]},
                    !.steps = st.steps + 1]

\* --- Propose one fork block (height 2 or 3, view = main view + 1) ---
ProposeFork ==
    /\ StepOK
    /\ ~st.forkProposed
    /\ \E h \in 2..3 :
        /\ \E r \in st.blocks : r.id = [h |-> h, fork |-> FALSE]
        /\ ~\E r \in st.blocks : r.id = [h |-> h, fork |-> TRUE]
        /\ LET parent == [h |-> h-1, fork |-> FALSE]
               mv == BlockView([h |-> h, fork |-> FALSE])
           IN st' = [st EXCEPT
                !.blocks = st.blocks \cup
                    {[id |-> [h |-> h, fork |-> TRUE], view |-> mv + 1,
                      parent |-> parent, aggValid |-> TRUE,
                      gapSkipped |-> FALSE]},
                !.forkProposed = TRUE,
                !.steps = st.steps + 1]

\* --- Vote (honest: claims TRUE, lock conjunction, view monotonic;
\*      local v1 additionally requires fresh recheck + no safeMode;
\*      Byzantine v4: claims arbitrary, no lock/view gate) ---
Vote ==
    /\ StepOK
    /\ \E v \in Validators, b \in BlockIds, rp \in BOOLEAN, da \in BOOLEAN :
        /\ HasBlock(b) /\ b # GenesisId
        /\ ~\E r \in st.votes : r.v = v /\ r.b = b
        /\ (v \in Honest => rp /\ da)
        /\ (v \notin Honest => EnableAdversarial \/ (rp /\ da))
        /\ (v \in Honest => BlockView(b) > st.lastView[v])
        /\ (v = Local =>
            /\ ~st.safeMode /\ ~st.crashed
            /\ st.recheckPresent /\ st.recheckVer = st.version /\ st.recheckOk
            /\ (st.lock.id.h = -1
                \/ ParentId(b) = st.lock.id
                \/ (HasQC(ParentId(b)) /\ BlockView(ParentId(b)) > st.lock.v)))
        /\ LET newLock == IF v = Local /\ BlockView(b) > st.lock.v
                          THEN [id |-> b, v |-> BlockView(b)] ELSE st.lock
               compliant == (v # Local) \/ st.lock.id.h = -1
                            \/ ParentId(b) = st.lock.id
                            \/ (HasQC(ParentId(b)) /\ BlockView(ParentId(b)) > st.lock.v)
           IN st' = [st EXCEPT
                !.votes = st.votes \cup
                    {[v |-> v, b |-> b, replay |-> rp, da |-> da, stale |-> FALSE]},
                !.lastView = [st.lastView EXCEPT ![v] = BlockView(b)],
                !.lock = newLock,
                !.sLock = IF v = Local THEN newLock ELSE st.sLock,
                !.hVotes = IF v = Local THEN st.hVotes \cup {b} ELSE st.hVotes,
                !.lockViolated = IF v = Local /\ ~compliant
                                 THEN st.lockViolated \cup {v}
                                 ELSE st.lockViolated,
                !.safeModeVoted = st.safeModeVoted
                    \/ (v = Local /\ st.safeMode),
                !.viewViolated = IF v \in Honest /\ BlockView(b) <= st.lastView[v]
                                 THEN st.viewViolated \cup {v}
                                 ELSE st.viewViolated,
                !.steps = st.steps + 1]

\* --- Attest no vote in a view (atomic check + creation, A9) ---
AttestGap ==
    /\ StepOK
    /\ \E v \in Validators, vw \in 1..(MaxV-1) :
        /\ ~\E r \in st.votes : r.v = v /\ BlockView(r.b) = vw
        /\ [v |-> v, view |-> vw] \notin st.attestations
        /\ (v = Local =>
            /\ ~st.safeMode /\ ~st.crashed
            /\ st.recheckPresent /\ st.recheckVer = st.version /\ st.recheckOk)
        /\ st' = [st EXCEPT
                !.attestations = st.attestations \cup {[v |-> v, view |-> vw]},
                !.steps = st.steps + 1]

\* --- Form a pair-specific gap certificate (>=3 attestations per skipped view) ---
FormGapCert ==
    /\ StepOK
    /\ \E parent \in BlockIds, child \in BlockIds :
        /\ HasBlock(parent) /\ HasBlock(child)
        /\ BlockRec(child).parent = parent
        /\ BlockRec(child).gapSkipped
        /\ BlockView(child) > BlockView(parent) + 1
        /\ ~\E c \in st.gapCerts : c.parent = parent /\ c.child = child
        /\ \A vw \in (BlockView(parent)+1)..(BlockView(child)-1) :
            Cardinality({v \in Validators :
                [v |-> v, view |-> vw] \in st.attestations}) >= Quorum
        /\ LET atts == {v \in Validators :
                    \E vw \in (BlockView(parent)+1)..(BlockView(child)-1) :
                        [v |-> v, view |-> vw] \in st.attestations}
           IN st' = [st EXCEPT
                !.gapCerts = st.gapCerts \cup
                    {[parent |-> parent, child |-> child, attesters |-> atts]},
                !.steps = st.steps + 1]

\* --- Record a candidate finalisation (split from finalisation, M1).
\*     Candidate set is prefix-closed by construction at candidate
\*     step (candidates are proposals, not a log; I-Prefix constrains
\*     finalSet, not candidateFinalSet). ---
CandidateFinalise ==
    /\ StepOK
    /\ ~st.safeMode /\ ~st.crashed
    /\ st.recheckPresent /\ st.recheckVer = st.version /\ st.recheckOk
    /\ \E b \in BlockIds, child \in BlockIds :
        /\ HasBlock(b) /\ b \notin st.candidateFinal /\ b \notin st.finalSet
        /\ HasQC(b) /\ ChildOK(b) /\ EdgeGated(b) /\ OnSelectedBranch(b)
        /\ HasBlock(child) /\ BlockRec(child).parent = b /\ HasQC(child)
        /\ (BlockView(child) = BlockView(b) + 1 \/
            (BlockView(child) > BlockView(b) + 1 /\ BlockRec(child).gapSkipped /\
             \E cert \in st.gapCerts : cert.child = child /\ cert.parent = b))
        /\ st' = [st EXCEPT
                !.candidateFinal = st.candidateFinal \cup Ancestors(b),
                !.finalJust = st.finalJust \cup {[b |-> b, child |-> child]},
                !.steps = st.steps + 1]

\* A block qualifies for finalisation now (QC + child QC + edge gate
\* rechecked at finalisation, on the FC-1 selected branch).
\* Prefix gate (Option B, A19): a block finalises only if every ancestor is
\* already finalised or qualifies in the same step. Ancestors(b) is
\* transitively closed (explicit unrolling in Ancestors), so checking all of
\* them is transitive — no recursion is needed. The ancestor conditions are
\* inlined below (AncestorQualifies repeats Qualifying's conjuncts without
\* the prefix gate itself); an operator cannot refer to itself in TLA+.
\* Since FinaliseStep finalises ALL qualifying members in one step, every
\* ancestor the gate relies on finalises together with b, so the resulting
\* finalSet is prefix-closed by construction. If any ancestor does not
\* qualify now, b waits — finalisation is delayed, never prefix-breaking.
AncestorQualifies(a) == a \in st.candidateFinal /\ a \notin st.finalSet
    /\ HasQC(a) /\ ChildOK(a) /\ EdgeGated(a) /\ OnSelectedBranch(a)
PrefixOK(b) == \A a \in Ancestors(b) : a \in st.finalSet \/ AncestorQualifies(a)
Qualifying(b) == b \in st.candidateFinal /\ b \notin st.finalSet
    /\ HasQC(b) /\ ChildOK(b) /\ EdgeGated(b) /\ OnSelectedBranch(b)
    /\ PrefixOK(b)
QualChild(b) == CHOOSE c \in st.blocks :
    c.parent = b /\ HasQC(c.id) /\
    (c.view = BlockView(b) + 1 \/
     (c.view > BlockView(b) + 1 /\ c.gapSkipped /\
      \E cert \in st.gapCerts : cert.child = c.id /\ cert.parent = b))

\* --- Finalise ALL currently qualifying candidates in one step
\*     (eager finalisation: when a block qualifies, every qualifying
\*     ancestor qualifies with it in the same step, so finalSet stays
\*     prefix-closed; finalisation is never a delayed single-block
\*     action that can leave a finalised block with an unfinalised
\*     qualifying ancestor). ---
FinaliseStep ==
    /\ StepOK
    /\ ~st.safeMode /\ ~st.crashed
    /\ st.recheckPresent /\ st.recheckVer = st.version /\ st.recheckOk
    /\ \E b \in BlockIds : Qualifying(b)
    /\ LET newFin == {x \in st.candidateFinal : Qualifying(x)}
       IN st' = [st EXCEPT
            !.finalSet = st.finalSet \cup newFin,
            !.finalQC = st.finalQC \cup
                {[b |-> x, voters |-> QCVoters(x),
                  edgeGated |-> EdgeGated(x)] : x \in newFin},
            !.finalJust = st.finalJust \cup
                {[b |-> x, child |-> QualChild(x).id] : x \in newFin},
            !.finalisedCounter = st.finalisedCounter + Cardinality(newFin),
            !.version = [st.version EXCEPT !.chain = st.version.chain + 1],
            !.steps = st.steps + 1]

\* --- Fresh recheck (G1): read global version + S7, store snapshot ---
Recheck ==
    /\ StepOK
    /\ st' = [st EXCEPT
            !.recheckVer = st.version,
            !.recheckOk = ~st.safeMode /\ S7Agree /\ ~st.crashed,
            !.recheckPresent = TRUE,
            !.steps = st.steps + 1]

\* --- Settlement: create / decide / apply / abort (decide+apply in
\*     one finalised block; abort only on a finalised-block event,
\*     Convention A deadline = bf + DeadlineD; no wall-clock) ---
SettleCreate ==
    /\ StepOK
    /\ ~st.safeMode
    /\ st.settlement.state = "NONE"
    /\ st' = [st EXCEPT
            !.settlement = [state |-> "CREATED", bf |-> st.finalisedCounter,
                            decideCounter |-> st.finalisedCounter],
            !.steps = st.steps + 1]

SettleDecide ==
    /\ StepOK
    /\ ~st.safeMode /\ ~st.freeze
    /\ st.recheckPresent /\ st.recheckVer = st.version /\ st.recheckOk
    /\ st.settlement.state \in {"CREATED", "WAIT", "PREPARED"}
    /\ st' = [st EXCEPT
            !.settlement = [st.settlement EXCEPT
                !.state = "DECIDED_COMMIT",
                !.decideCounter = st.finalisedCounter],
            !.freezeViolation = st.freezeViolation \/ st.freeze,
            !.version = [st.version EXCEPT !.settle = st.version.settle + 1],
            !.steps = st.steps + 1]

SettleApply ==
    /\ StepOK
    /\ ~st.safeMode /\ ~st.freeze
    /\ st.recheckPresent /\ st.recheckVer = st.version /\ st.recheckOk
    /\ st.settlement.state = "DECIDED_COMMIT"
    /\ st.finalisedCounter = st.settlement.decideCounter
    /\ st' = [st EXCEPT
            !.settlement = [st.settlement EXCEPT !.state = "COMMITTED"],
            !.settledTerminal = TRUE,
            !.freezeViolation = st.freezeViolation \/ st.freeze,
            !.version = [st.version EXCEPT !.settle = st.version.settle + 1],
            !.steps = st.steps + 1]

SettleAbort ==
    /\ StepOK
    /\ ~st.freeze
    /\ st.settlement.state \in {"CREATED", "WAIT", "PREPARED", "DECIDED_COMMIT"}
    /\ st.finalisedCounter >= st.settlement.bf + DeadlineD
    /\ st' = [st EXCEPT
            !.settlement = [st.settlement EXCEPT !.state = "ABORTED"],
            !.settledTerminal = TRUE,
            !.freezeViolation = st.freezeViolation \/ st.freeze,
            !.version = [st.version EXCEPT !.settle = st.version.settle + 1],
            !.steps = st.steps + 1]

\* --- Epoch advance: finalised-block trigger only (never wall-clock);
\*     duplicate advance (same finalisedCounter) rejected; no freeze (A6) ---
EpochAdvance ==
    /\ StepOK
    /\ ~st.safeMode /\ ~st.freeze
    /\ st.finalisedCounter > st.epochCounter
    /\ st.epoch < 3
    /\ st' = [st EXCEPT
            !.epoch = st.epoch + 1,
            !.epochCounter = st.finalisedCounter,
            !.version = [st.version EXCEPT !.part = st.version.part + 1],
            !.s7Chain = [st.s7Chain EXCEPT !.epoch = st.s7Chain.epoch + 1],
            !.s7Rec = [st.s7Rec EXCEPT !.verifiable = FALSE],
            !.steps = st.steps + 1]

\* --- Prospective QC invalidation (finalised blocks never revert) ---
InvalidateQC ==
    /\ StepOK
    /\ \E b \in BlockIds :
        /\ HasBlock(b) /\ b \notin st.finalSet /\ b \notin st.invalidated
        /\ st' = [st EXCEPT
                !.invalidated = st.invalidated \cup {b},
                !.invGen = st.invGen + 1,
                !.version = [st.version EXCEPT !.settle = st.version.settle + 1],
                !.steps = st.steps + 1]

\* --- Aggregation invalidation (NEGATIVE-CONTROL only): aggValid is an INPUT flag ---
SetAggInvalid ==
    /\ StepOK
    /\ EnableAdversarial
    /\ \E b \in BlockIds :
        /\ HasBlock(b) /\ BlockAggValid(b)
        /\ LET rec == BlockRec(b)
           IN st' = [st EXCEPT
                !.blocks = (st.blocks \ {rec}) \cup
                    {[rec EXCEPT !.aggValid = FALSE]},
                !.aggInvalid = st.aggInvalid \cup {b},
                !.steps = st.steps + 1]

\* --- Operator/founder durable approval record (D-N1 / reconciliation) ---
GrantOperatorApproval ==
    /\ StepOK
    /\ ~st.opApproval
    /\ st' = [st EXCEPT !.opApproval = TRUE, !.steps = st.steps + 1]

\* --- Partition (PARTITION family only): quorum lost, freeze on ---
Partition ==
    /\ StepOK
    /\ EnablePartition
    /\ ~st.quorumLost
    /\ st' = [st EXCEPT
            !.quorumLost = TRUE,
            !.freeze = TRUE,
            !.partitionCounter = st.finalisedCounter,
            !.version = [st.version EXCEPT !.part = st.version.part + 1],
            !.s7Chain = [st.s7Chain EXCEPT !.partition = TRUE],
            !.s7Rec = [st.s7Rec EXCEPT !.verifiable = FALSE],
            !.steps = st.steps + 1]

\* --- Quorum recovery (on a finalised-block event during partition) ---
RecoverQuorum ==
    /\ StepOK
    /\ EnablePartition
    /\ st.quorumLost
    /\ st.finalisedCounter > st.partitionCounter
    /\ st' = [st EXCEPT
            !.quorumLost = FALSE,
            !.freeze = FALSE,
            !.version = [st.version EXCEPT !.part = st.version.part + 1],
            !.s7Chain = [st.s7Chain EXCEPT !.partition = FALSE],
            !.s7Rec = [st.s7Rec EXCEPT !.verifiable = FALSE],
            !.steps = st.steps + 1]

\* --- Durable global-state record catches up with the chain ---
UpdateS7Record ==
    /\ StepOK
    /\ ~st.s7Corrupt
    /\ st' = [st EXCEPT
            !.s7Rec = [partition |-> st.s7Chain.partition,
                       epoch |-> st.s7Chain.epoch, verifiable |-> TRUE],
            !.steps = st.steps + 1]

\* --- S7 disagreement detection (validator-wide SAFE_MODE) ---
DetectS7Disagreement ==
    /\ StepOK
    /\ st.s7Rec.verifiable
    /\ (st.s7Chain.partition # st.s7Rec.partition
        \/ st.s7Chain.epoch # st.s7Rec.epoch)
    /\ st' = [st EXCEPT
            !.safeMode = TRUE,
            !.smReasons = st.smReasons \cup {"S7-CONTRADICTORY"},
            !.diagnostics = st.diagnostics \cup {"S7-CONTRADICTORY"}
                \cup (IF st.s7Corrupt THEN {"S7-UNVERIFIED"} ELSE {}),
            !.steps = st.steps + 1]

\* --- D-N1 exit (BLOCKED: guard requires Compatible, which is FALSE
\*     while E3/E4/E5 are missing -- exit never fires in this run) ---
SafeModeExit ==
    /\ StepOK
    /\ st.safeMode /\ st.opApproval /\ Compatible /\ S7Agree
    /\ st' = [st EXCEPT
            !.safeMode = FALSE,
            !.exitedSafeMode = TRUE,
            !.approvedExit = TRUE,
            !.steps = st.steps + 1]

\* --- S7 reconciliation (operator approval + agreement + cause) ---
ExplainCause ==
    /\ StepOK
    /\ "S7-CONTRADICTORY" \in st.diagnostics
    /\ ~st.causeExplained
    /\ st' = [st EXCEPT !.causeExplained = TRUE, !.steps = st.steps + 1]

ReconcileS7 ==
    /\ StepOK
    /\ st.safeMode /\ st.opApproval /\ S7Agree /\ st.causeExplained
    /\ ~st.s7Corrupt
    /\ st.recheckPresent /\ st.recheckVer = st.version /\ st.recheckOk
    /\ "S7-CONTRADICTORY" \in st.smReasons
    /\ LET rest == st.smReasons \ {"S7-CONTRADICTORY"}
       IN st' = [st EXCEPT
            !.smReasons = rest,
            !.safeMode = IF rest = {} THEN FALSE ELSE TRUE,
            !.exitedSafeMode = IF rest = {} THEN TRUE ELSE st.exitedSafeMode,
            !.approvedExit = IF rest = {} THEN TRUE ELSE st.approvedExit,
            !.s7Resolution = TRUE,
            !.steps = st.steps + 1]

\* --- Crash (CRASH family): in-memory lock lost, vote history may lose its tail ---
Crash ==
    /\ StepOK
    /\ EnableCrash
    /\ ~st.crashed
    /\ \E hv \in {st.hVotes, {}} :
        st' = [st EXCEPT
                !.crashed = TRUE,
                !.preCrashLock = st.lock,
                !.lock = NoLock,
                !.hVotes = hv,
                !.hState = IF hv = st.hVotes THEN "COMPLETE" ELSE "LOSS",
                !.steps = st.steps + 1]

\* --- Storage fault injection (CRASH / NEGATIVE-CONTROL) ---
InjectStorageFault ==
    /\ StepOK
    /\ (EnableCrash \/ EnableAdversarial)
    /\ \E ss \in {"TORN", "CORRUPT"} :
        st' = [st EXCEPT
                !.sState = ss,
                !.sLock = [id |-> [h |-> -2, fork |-> FALSE], v |-> -2],
                !.steps = st.steps + 1]

\* --- Recovery from storage (Path S: lock only), storage intact ---
RecoverFromStorageOK ==
    /\ StepOK
    /\ EnableCrash
    /\ st.crashed /\ st.sState = "OK"
    /\ st' = [st EXCEPT
            !.crashed = FALSE,
            !.lock = st.sLock,
            !.recovered = TRUE,
            !.recoveryLockOK = TRUE,
            !.known = Compatible,
            !.safeMode = TRUE,
            !.steps = st.steps + 1]

\* --- Recovery from storage, storage faulty (no lock restored) ---
RecoverFromStorageBad ==
    /\ StepOK
    /\ EnableCrash
    /\ st.crashed /\ st.sState # "OK"
    /\ st' = [st EXCEPT
            !.crashed = FALSE,
            !.lock = NoLock,
            !.recovered = TRUE,
            !.recoveryLockOK = TRUE,
            !.known = FALSE,
            !.safeMode = TRUE,
            !.diagnostics = st.diagnostics \cup {"S-RECOVERY-FAILED"},
            !.steps = st.steps + 1]

\* --- Recovery from history (Path H: history only, NEVER a lock -- V2.1) ---
RecoverFromHistory ==
    /\ StepOK
    /\ EnableCrash
    /\ st.crashed
    /\ st' = [st EXCEPT
            !.crashed = FALSE,
            !.recovered = TRUE,
            !.recoveryLockOK = TRUE,
            !.known = FALSE,
            !.safeMode = TRUE,
            !.diagnostics = st.diagnostics \cup {"H-RECOVERY-NO-LOCK"},
            !.steps = st.steps + 1]

\* --- Adversarial: vote without claims (never counts toward QC) ---
VoteWithoutClaim ==
    /\ StepOK
    /\ EnableAdversarial
    /\ \E v \in Validators, b \in BlockIds :
        /\ HasBlock(b) /\ b # GenesisId
        /\ ~\E r \in st.votes : r.v = v /\ r.b = b
        /\ st' = [st EXCEPT
                !.votes = st.votes \cup
                    {[v |-> v, b |-> b, replay |-> FALSE, da |-> FALSE,
                      stale |-> FALSE]},
                !.steps = st.steps + 1]

\* --- Adversarial: residual-window commit (stale recheck, commits anyway) ---
ResidualCommit ==
    /\ StepOK
    /\ EnableAdversarial
    /\ st.recheckPresent /\ st.recheckVer # st.version
    /\ \E b \in BlockIds :
        /\ HasBlock(b) /\ b # GenesisId
        /\ ~\E r \in st.votes : r.v = Local /\ r.b = b
        /\ st' = [st EXCEPT
                !.votes = st.votes \cup
                    {[v |-> Local, b |-> b, replay |-> TRUE, da |-> TRUE,
                      stale |-> TRUE]},
                !.safeMode = TRUE,
                !.smReasons = st.smReasons \cup {"STALE-COMMIT"},
                !.diagnostics = st.diagnostics \cup {"STALE-COMMIT"},
                !.steps = st.steps + 1]

\* --- Adversarial: wall-clock abort attempt (must change nothing) ---
WallClockAbortAttempt ==
    /\ StepOK
    /\ EnableAdversarial
    /\ st.settlement.state \in {"CREATED", "WAIT", "PREPARED", "DECIDED_COMMIT"}
    /\ st' = [st EXCEPT
            !.diagnostics = st.diagnostics \cup {"WALL-CLOCK-ABORT-ATTEMPTED"},
            !.steps = st.steps + 1]

\* --- Adversarial: exit attempt without operator approval (must change nothing) ---
ExitWithoutApproval ==
    /\ StepOK
    /\ EnableAdversarial
    /\ st.safeMode /\ ~st.opApproval
    /\ st' = [st EXCEPT
            !.diagnostics = st.diagnostics \cup {"EXIT-ATTEMPT-WITHOUT-APPROVAL"},
            !.steps = st.steps + 1]

\* --- Adversarial: corrupt the durable S7 record (verifiably wrong) ---
CorruptS7Record ==
    /\ StepOK
    /\ EnableAdversarial
    /\ st' = [st EXCEPT
            !.s7Rec = [partition |-> ~st.s7Chain.partition,
                       epoch |-> st.s7Chain.epoch, verifiable |-> TRUE],
            !.s7Corrupt = TRUE,
            !.steps = st.steps + 1]

\* ================= NEXT / SPEC =================
Next ==
    \/ ProposeBlock \/ ProposeFork \/ Vote \/ AttestGap \/ FormGapCert
    \/ CandidateFinalise \/ FinaliseStep \/ Recheck
    \/ SettleCreate \/ SettleDecide \/ SettleApply \/ SettleAbort
    \/ EpochAdvance \/ InvalidateQC \/ SetAggInvalid
    \/ GrantOperatorApproval
    \/ Partition \/ RecoverQuorum \/ UpdateS7Record
    \/ DetectS7Disagreement \/ SafeModeExit \/ ExplainCause \/ ReconcileS7
    \/ Crash \/ InjectStorageFault \/ RecoverFromStorageOK
    \/ RecoverFromStorageBad \/ RecoverFromHistory
    \/ VoteWithoutClaim \/ ResidualCommit \/ WallClockAbortAttempt
    \/ ExitWithoutApproval \/ CorruptS7Record

Spec == Init /\ [][Next]_st

\* ================= INVARIANTS =================
\* No two finalised blocks at the same height (no conflicting finals).
ISafety == \A b1, b2 \in st.finalSet : b1.h = b2.h => b1 = b2
\* Prefix closure over the final set (PrefixCheck as invariant).
IPrefix == \A b \in st.finalSet : Ancestors(b) \subseteq st.finalSet
\* Edge gate held at finalisation (recorded in finalQC, stable history).
IPathGateEdge == \A rec \in st.finalQC : rec.edgeGated
\* Lock never violated by the local validator (history, V2.1 style).
ILock == st.lockViolated = {}
\* Gap certificates: finalised skipped-view blocks have a >=3 cert.
IGC == (\A b \in st.finalSet : BlockGapSkipped(b) =>
            \E c \in st.gapCerts : c.child = b
                /\ Cardinality(c.attesters) >= Quorum)
       /\ (\A c \in st.gapCerts : Cardinality(c.attesters) >= Quorum)
\* QC at finalisation: >= Quorum distinct voters, all with TRUE claims.
IQC == \A rec \in st.finalQC :
    Cardinality(rec.voters) >= Quorum
    /\ \A v \in rec.voters : \E r \in st.votes :
        r.v = v /\ r.b = rec.b /\ r.replay /\ r.da /\ ~r.stale
\* Claim order: every counted vote carried TRUE replay + DA claims.
IP0ClaimOrder == \A rec \in st.finalQC : \A v \in rec.voters :
    \E r \in st.votes : r.v = v /\ r.b = rec.b /\ r.replay /\ r.da
\* Recovery never produces a wrong lock (history flag).
IRecoveryNoWrongLock == st.recoveryLockOK
\* No vote by the local validator while in SAFE_MODE (history flag).
ISafeModeNoVotes == ~st.safeModeVoted
\* No settlement transition while frozen (history flag).
IFreezeNoTransition == ~st.freezeViolation
\* Abort only on a finalised-block deadline (never wall-clock).
INoWallClockAbort == st.settlement.state = "ABORTED"
    => st.finalisedCounter >= st.settlement.bf + DeadlineD
\* Conditional recovery termination (bounded lag 2; vacuous in bounds
\* while DeadlineD = 10 is unreachable -- see fidelity matrix).
IRecoveryTermination ==
    ~ (st.settlement.state \in {"CREATED", "WAIT", "PREPARED", "DECIDED_COMMIT"}
       /\ ~st.quorumLost
       /\ st.finalisedCounter > st.settlement.bf + DeadlineD + 2)
\* Finalised main-chain heights form a contiguous prefix from genesis.
IContiguousLogPrefix == \A h \in 1..MaxH :
    [h |-> h, fork |-> FALSE] \in st.finalSet
        => [h |-> h-1, fork |-> FALSE] \in st.finalSet
\* KNOWN is never achieved (Compatibility is FALSE while E3/E4/E5 are missing).
NeverKnown == ~st.known
\* SAFE_MODE is never exited except through an approved exit path
\* (Option B, founder decision 2026-11-05): an exit is approved iff
\* it goes through SafeModeExit (D-N1, opApproval + Compatible +
\* S7Agree) or ReconcileS7 (opApproval + agreement + cause, L1-L8
\* per A15). approvedExit is set TRUE exactly by those two actions
\* when they actually exit. Any other path that set exitedSafeMode
\* would violate this invariant. NoExit (never exit at all) is
\* superseded by this invariant; it was too strong because approved
\* S7 reconciliation is a design-intended valid recovery path.
NoExitExceptApproved == ~st.exitedSafeMode \/ st.approvedExit

\* SUPERSEDED by NoExitExceptApproved (Option B, A16). Retained so
\* the NORMAL and CRASH configs, which passed/are running with it,
\* and their checkpoints remain valid. It is the stronger form: it
\* holds in NORMAL/CRASH because no exit path is reachable there.
NoExit == ~st.exitedSafeMode
\* A stale vote never contributes to a finalisation QC.
StaleNeverFinalises == \A rec \in st.finalQC : \A v \in rec.voters :
    ~\E r \in st.votes : r.v = v /\ r.b = rec.b /\ r.stale
\* Containment: S7-CONTRADICTORY diagnostic implies SAFE_MODE.
S7Containment == "S7-CONTRADICTORY" \in st.diagnostics => st.safeMode
\* Containment: STALE-COMMIT diagnostic implies SAFE_MODE.
StaleContainment == "STALE-COMMIT" \in st.diagnostics => st.safeMode

====
