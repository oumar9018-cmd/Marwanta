# MARWANTA — Minimum Local Prototype

**Status:** Built under the approved authorization sheet
(`../phase2-model-fidelity-redesign/MARWANTA_FIRST_PROTOTYPE_AUTHORIZATION_SHEET.md`).
This prototype is a TEST implementation under that sheet's scope ONLY.
It is NOT architecture approval, NOT a protocol decision, NOT model
authorization, and NOT testnet/mainnet authorization.

## Scope (binding)

- **Local only.** Single process, single machine, Python stdlib only.
  No network, no external validators, no public endpoint, no real
  assets, no token.
- **Hypothesis tested (local form only):** Proof-Carrying,
  Fault-Isolated Execution — locally, a fault in one domain does not
  corrupt another domain, and a cross-domain operation is all-or-none.
- **Test configuration (test-only, protocol decisions remain OPEN):**
  finalisation Alternative A, path-gated (test); fork rule FC-1
  (test, not exercised — no fork in demo traces); proof format:
  transaction carries domain_id, pre-state root, post-state root,
  execution-trace hash, verifier replays and compares; metering cap
  1,000,000 test units per transaction per domain (TEST VALUE ONLY);
  4 local validators, equal test stake, QC threshold 3;
  test signatures are deterministic strings, NOT cryptographic
  signatures and NOT the protocol aggregation construction (D10 OPEN).
- **Excluded (not tested, not claimed):** validator crash recovery
  (WAL, safeModeRec, S/H compatibility); S7 global/local/disagreement;
  D-N1 exit; global TOCTOU (UNRESOLVED at protocol level);
  migration/epoch; deadline convention; fork-choice protocol selection;
  stake/aggregation/slashing/§20.5 protocol decisions.

## Files

- `proof.py` — deterministic hashing helpers (test only).
- `engine.py` — deterministic execution, capability rule (test),
  metering rule (test), fault (crashed domain) mechanism.
- `validator.py` — replay + DA gate + QC counting (test). Vote
  always replays; there is no proof-only voting path.
- `chain.py` — local chain, Alternative A (test) finalisation rule,
  candidate state (state applies ONLY on finalisation; non-finalised
  candidate discarded), local version counter + local conditional
  commit helper. Local lock (`threading.RLock`) serializes LOCAL
  actions only.
- `settlement.py` — cross-domain settlement, canonical lock order
  (domain_id, key_id), decide + apply as ONE candidate.
- `fault.py` — injected faults (labelled injected in traces).
- `run_demo.py` — demonstrations D-1..D-8, writes `evidence/evidence.json`.

## How to run

```
python3 run_demo.py
```

Expected output: `PASS` for D-1..D-8 and `ALL PASS: True`.
Exit code 0 iff every demonstration passes, else 1.
Evidence is written to `evidence/evidence.json` on every run.

## Demonstrations (D-1..D-8, each on a fresh local setup)

- D-1 deterministic replay reproduces claimed roots, all validators vote, block finalises.
- D-2 DA gate: missing-DA transaction -> all validators abstain DA_MISSING, state unchanged.
- D-3 proof does NOT substitute for replay (negative control): present-but-wrong proof -> replay mismatch abstains.
- D-4 fault isolation, domain crash: crashed domain A abstains, domain B still finalises, A unchanged.
- D-5 fault isolation, invalid execution / resource exhaustion: tampered proof rejected, over-cap transaction rejected (METERING), B unaffected.
- D-6 atomic cross-domain settlement: A -10 / B +10, canonical lock order, both legs applied on finalisation.
- D-7 candidate discard: voted-but-unfinalised blocks (normal + settlement) discarded, no effect, chain continues.
- D-8 local TOCTOU: local version change between recheck and commit -> rejection; no interleaving -> commit succeeds. Local only; global TOCTOU NOT demonstrated.

## What this prototype must NOT claim

See `evidence/evidence.json` fields `not_claimed` and `limitations`,
and the authorization sheet §4.4. In short: no general proofs, no
global atomicity, no real replay/DA bounds, no crash recovery, no
S7/D-N1, no fork-choice/A-vs-B/B3/deadline/migration/epoch/stake/
aggregation/slashing/§20.5 protocol decisions, no performance numbers,
no testnet/mainnet readiness, no token claim.

## Known limitations (honest, in evidence too)

- Gap-certificate branch in `chain.py` is implemented but NOT
  exercised by D-1..D-8 (consecutive views only). Gap accountability
  is therefore NOT claimed demonstrated.
- FC-1 test fork rule is documented but NOT exercised (no fork in
  demo traces).
- Test signatures are deterministic strings, not cryptographic.
- Local lock serializes local actions only, not global updates.
- Single-process local run; results do not transfer to distributed,
  testnet, or mainnet claims without separate distributed validation.

## Kill criteria

Authorization sheet §5 (K-1..K-7) applies to prototype testing:
any demonstration failure, fault leak, vote on missing DA /
replay-mismatched transaction, proof substituting for replay,
partial settlement, candidate persistence, scope breach, or evidence
failure stops prototype testing and must be reported as KILL, not
waived. The final evidence run for this build must show no kill
triggered; if a run fails, that run's evidence records the failure
and the prototype must not be reported as passing.
