# MARWANTA — FIRST PROTOTYPE AUTHORIZATION SHEET

**Status:** PROPOSAL ONLY. This sheet is NOT an approval, NOT
architecture approval, NOT a protocol decision, and NOT code.
It exists so the founder can approve the minimum local prototype
in one decision, after which — and only after which — the first
line of prototype code may be written.
**Parent document:** `MARWANTA_CONSOLIDATED_ARCHITECTURE_READINESS_ASSESSMENT.md`
(§3.1 start-blockers S-1–S-5, §4 minimum prototype scope, §6
prototype blockers PB-1–PB-7), in `phase2-model-fidelity-redesign/`.
**What this sheet does NOT do:** it does not close any RI issue
(RI-01–RI-42), any BL blocker (BL1–BL16), any invariant, obligation,
assumption, or founder decision. It does not authorize testnet,
mainnet, token work, model construction, or protocol approval.
**Code status at the time this sheet is written:** NO prototype code
has been written. No prototype directory has been created. No
`.py`, `.rs`, `.go`, `.ts`, or other code file has been created for
MARWANTA under this sheet. The first line of code will be written
only AFTER the founder approves this sheet (see Approval block, §6).

---

## 1. Prototype scope (from Readiness Assessment §4, summarized — assessment governs on any difference)

- **Type:** Minimum LOCAL prototype only. Single machine / local
  network only.
- **Hypothesis under test (local form only):** Proof-Carrying,
  Fault-Isolated Execution — locally, with deterministic execution,
  proof-carrying transactions, and shared local settlement, a fault
  in one domain does not corrupt another domain, and a cross-domain
  operation is all-or-none.
- **Components (test implementations, labelled test-only):**
  P-C1 deterministic execution engine (test engine); P-C2 at least
  TWO execution domains; P-C3 proof-carrying transaction format
  (test format, §3 below); P-C4 shared LOCAL settlement engine;
  P-C5 replay + DA gate (local); P-C6 per-domain metering (test
  rules, §3 below); P-C7 fault injector (labelled injected faults);
  P-C8 3–4 LOCAL validators (test aggregation, §3 below); P-C9
  local chain + candidate/discard harness.
- **Demonstrations (must all pass as traces, §4.3 of assessment):**
  D-1 deterministic replay reproduces claimed roots; D-2 DA gate +
  abstention on missing DA; D-3 proof does NOT substitute for replay
  (negative control); D-4 fault isolation, domain crash; D-5 fault
  isolation, invalid execution / resource exhaustion; D-6 atomic
  cross-domain settlement; D-7 candidate discard on non-finalisation;
  D-8 local TOCTOU version-vector rejection (local only).

## 2. Boundary (binding if approved — violation = kill, §5)

- Local only. No external validators, no public endpoint, no
  internet-facing service.
- No real assets, no token, no token contract, no distribution.
- Simulated global state only: single local chain view; any
  quorumLost flag in tests is LOCALLY SET by test harness and
  labelled "simulated quorumLost, not real network partition".
  Simulated partition traces do NOT validate partition safety.
- **Excluded (not tested, not claimed):** validator crash recovery
  (RI-05–RI-09, RI-19); S7 global/local/disagreement (RI-11–RI-13);
  D-N1 exit (RI-10); global TOCTOU (RI-15); migration/epoch
  (RI-31); deadline convention (RI-30, except a local test value
  if needed for settlement traces, labelled test value); fork-choice
  protocol selection (RI-26, except test rule in §3); stake/
  aggregation protocol construction (RI-35/RI-22 protocol versions —
  test aggregation only); slashing (RI-33); B_eff governance (RI-25).

## 3. Proposed test configuration and test values (FOR APPROVAL — test-only, NOT protocol values)

Every value below is a TEST value proposed for prototype tests only.
Approving this sheet approves these values FOR TESTS ONLY. Protocol
decisions (D11, D10, D6, §20.5, proof format) remain OPEN even after
test approval. If the founder wants different test values, he must
state them in his approval — the prototype will use the values in
the APPROVED sheet, not the values in this proposal, if they differ.

| Item | Proposed test value / configuration | Protocol status after test approval |
|---|---|---|
| Finalisation (test) | Alternative A, path-gated (edge-bound gate, per comparative design) — local only | D11 remains OPEN. A as test config does NOT select A as protocol. Results do not transfer to B1/B2/B3. |
| Fork rule (test) | FC-1, highest QC view, as local test rule (only if a fork occurs in local tests; otherwise not applicable locally) | O-FC-SEL remains OPEN. FC-1 as test rule does NOT select FC-1 as protocol. |
| Proof format (test) | Transaction carries: domain_id, pre-state root, post-state root, execution-trace hash. Verifier REPLAYS deterministically and compares post-state root; proof alone never causes a vote (D-3 negative control enforces this). | Protocol proof format remains OPEN. Test format does NOT decide it. |
| Domains (test) | 2 domains: Domain A, Domain B. Each domain reads/writes only its own state keys in tests (test capability rule). | §20.5 remains OPEN. Test capability rule does NOT decide §20.5. |
| Metering (test) | Cap 1,000,000 test units per transaction per domain (TEST VALUE ONLY). Exhaustion test = transaction exceeding cap in one domain. | §20.5 metering remains OPEN. 1,000,000 is a test number, not a protocol number. |
| Validators (test) | 4 local validators, equal test stake each, QC threshold > 2/3 of test stake (3 of 4 test validators, by equal-stake counting for tests). | D6/D10 remain OPEN. Equal test stake does NOT decide stake cap, minimum validators, or aggregation construction. |
| Aggregation (test) | Test aggregation: individual test signatures counted distinctly, no double-counting (test construction, labelled test-only). | D10 remains OPEN. Test aggregation does NOT decide protocol aggregation. |
| Settlement (test) | Cross-domain operation across Domain A + Domain B, canonical lock order (domain_id, key_id), decide + apply in ONE local block, candidate discarded if local block does not finalise. | Settlement protocol (C1–C4, deadline, migration/epoch) remains OPEN. Local settlement test does NOT validate partition/migration/epoch settlement safety. |
| First code location (after approval only) | New directory `~/workspace/marwanta/prototype-local/` (NOT created yet — created only after approval, with first file being the local harness skeleton as specified in the approved scope). | Directory creation itself is prototype work, not architecture approval. |

## 4. Evidence standard (proposed — requires approval under §6)

Prototype report must contain, for every demonstration D-1–D-8:
trace steps, inputs (injected faults labelled injected), expected
outcome, actual outcome, pass/fail, and supporting logs (replay log,
DA log, metering log, settlement trace as applicable). Plus:
configuration record (test config + test values + protocol decisions
recorded as OPEN alongside); fault-injection log (per-domain state
comparisons); settlement traces (lock order, decide+apply, discard);
kill/decision log (any kill trigger with trace, or explicit "no kill
triggered" with traces cited); and a non-claims statement listing
Readiness Assessment §4.4 non-claims as NOT claimed (global atomicity,
general safety/prefix/lock/gap/C1–C4 proofs, real replay/DA bounds,
crash recovery, S7/D-N1, fork-choice/A-vs-B/B3/deadline/migration/
epoch/stake/aggregation/slashing/§20.5 protocol decisions, any
performance number, any testnet/mainnet readiness, any token claim).
An artifact without test-configuration / test-value labels is
unlabelled evidence and must not be cited (kill criterion K-7).

## 5. Kill criteria (binding if approved — kill = stop + report, no waiver)

- K-1 Fault leak across domains (D-4/D-5 fail) → STOP, report KILL.
- K-2 Vote on missing DA or replay-mismatched transaction (D-1/D-2
  fail) → STOP, report KILL.
- K-3 Proof substitutes for replay (D-3 fail) → STOP, report KILL.
- K-4 Partial settlement in a finalised local block (D-6 fail) →
  STOP, report KILL.
- K-5 Candidate effect persisting after non-finalisation (D-7 fail)
  → STOP, report KILL.
- K-6 Scope breach (external validator, public endpoint, real asset,
  token, or global/distributed claim) → STOP immediately, report
  KILL (scope breach); results from breached scope must not be cited
  as prototype evidence.
- K-7 Evidence failure (non-reproducible or unlabelled results) →
  STOP evidence claims; report KILL unless founder re-authorizes
  with corrected evidence standard; prior unlabelled results
  discarded or re-run with labels.
No kill may be waived as a "known issue" without founder
re-authorization with a new scope. A kill does not close any RI/BL/
invariant/obligation/decision — it stops prototype testing and
requires a new authorization to retry.

## 6. Approval block (founder approval required — code starts only after this block is approved)

**Approval is given ONLY by the founder's explicit message approving
this sheet.** Examples of approving messages (copy-paste style):
- "§4 minimum local prototype approved as per authorization sheet"
- "Authorization sheet approved, test values as proposed, code shuru karo"
Any approval message must be read as approving THIS SHEET'S scope
(§1–§5) and NOTHING beyond it. If the founder wants different test
values, different test configuration, or a different scope, his
approval message must state the differences — the prototype will
follow the APPROVED differences, and this proposal's values will
not be used where they differ.
**After approval, the sequence is:**
1. Create `~/workspace/marwanta/prototype-local/` (first time only).
2. Write the first line of prototype code in the local harness
   skeleton, under §1–§5 scope only.
3. Build demonstrations D-1–D-8 as traces, with evidence per §4.
4. Stop on any kill criterion (§5) and report — no silent continuation.
**Before approval, the sequence is:** NO code. Documentation and
preparation only (this sheet is preparation, not code).

## 7. Freeze confirmation for this sheet

- Existing documents (v0.4, blueprint, V1, V2, V2.1, V2.2, V2.3,
  Challenge, Global TOCTOU Correction, Proof Closure Plan, Invariant
  Traceability Matrix, Readiness Assessment): NOT MODIFIED by this
  sheet.
- No v0.5. No code file (`.py`, `.rs`, `.go`, `.ts`, or other
  executable): NOT CREATED by this sheet.
- No TLC, simulation, or model execution: NOT PERFORMED for this
  sheet.
- BL1–BL16: OPEN. All 21 invariants, 53 obligations, 34 assumptions,
  founder decisions: OPEN. KNOWN / KNOWN-NONE: BLOCKED.
- This sheet is a PROPOSAL. It does not authorize code by itself.

PROTOTYPE AUTHORIZATION SHEET — REVIEW REQUIRED. NO CODE WRITTEN YET.
