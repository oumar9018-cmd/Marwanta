# MARWANTA

**MARWANTA is an independent Layer-1 blockchain under research.**
Thesis: **Proof-Carrying, Fault-Isolated Execution** — isolated, deterministic,
capability-bounded execution domains; proof-carrying transactions; shared
settlement with atomic cross-domain operations and no partial execution.

This repository is the frozen public record of the protocol design and its
machine-checked model. It is research, not a product. There is no testnet,
no mainnet, and no token.

## What is MARWANTA, and what problem does it solve?

**The problem, in one line:** on today's blockchains, execution and
settlement are coupled — one faulty application can halt or corrupt shared
state, and an operation that touches several applications cannot be
guaranteed all-or-nothing without heavy coordination.

**MARWANTA's answer (a research hypothesis, not a proven result):** split
execution into isolated, deterministic, capability-bounded domains, make
every transaction carry its own proof, and settle on a shared layer that
applies cross-domain operations atomically or not at all — so a fault in
one domain stays in that domain, and a validator never finalises a block
it has not fully replayed.

**What this repo proves so far:** the consensus core of that design is
machine-checked in TLA+ (see Status below). What it does **not** prove:
that the full design works in production, performs, or is safe at scale.
That is what the funding is for.

## Status — read this first

| Item | State |
|---|---|
| Architecture spec (v0.4) | Draft, **not approved** |
| Formal model (TLA+, spec A19) | **Frozen 2026-11-06** |
| Prototype (§4 minimum, local) | Built, passed, **frozen as evidence** |
| Private / public testnet | Not authorised |
| Mainnet / token | Not authorised |

**What the model verified (bounded, machine-checked):** the NORMAL, CRASH and
PARTITION families complete at MaxSteps 10; the two IPrefix holes found by
diagnostics are both closed under spec A19 — the consecutive-chain hole
(genesis base case, A18) and the gap-edge hole (prefix gate on finalisation,
A19). The h1+h2 consecutive-finalisation proof is re-verified under A19.

**What is NOT claimed:** the @10 family passes are vacuous for finalisation
(no non-genesis block can finalise within 10 steps); the NEGATIVE-CONTROL
re-run is INCOMPLETE (134.6M states explored, no violation found, state
graph not exhausted); settlement safety (C1–C4) is WITHHELD pending its
mandatory verification blocker; no general proof, no performance claim, no
testnet or mainnet claim follows from this repository. The full evidence,
including every limitation, is in `model/evidence/MODEL_EVIDENCE_REPORT.md`.

## Repository layout

```
spec/       Architecture specification v0.4 (frozen draft, 1,858 lines)
model/      TLA+ model, spec A19 (frozen) + diagnostic variant
  authorization/  L0 decision log, authorization sheet + approval record
  configs/  Family + diagnostic run configs
  evidence/ Evidence report, evidence.json, fidelity matrix
  traces/   Counterexample / proof traces produced by TLC
prototype-local/  §4 minimum local prototype (frozen as evidence)
docs/       Funding needs plan ($5,000–$10,000, milestone tranches)
ROADMAP.md  What happens next, in funding-tranche order (gates named)
.github/workflows/  TLA+ syntax check (SANY) on every spec change
```

Frozen evidence files may reference the author's local workspace paths
(e.g. `~/workspace/...`); those are part of the frozen record, not links.
Nothing frozen has been edited for this repository.

## How to verify

Requires Java 17 and TLC. Download `tla2tools.jar` from the TLA+
releases (github.com/tlaplus/tlaplus/releases). Example — the
gap-edge check that closed the second IPrefix hole, run from this
repository's root:

```sh
java -Xmx5g -cp tla2tools.jar tlc2.TLC -deadlock -workers 2 \
  -config model/configs/GAP-TRACE.cfg model/MarwantaDiag
# Expected: "Model checking completed. No error has been found."
# (6,836,367 generated / 688,550 distinct, depth 21)
```

Expected results for every run are recorded in
`model/evidence/MODEL_EVIDENCE_REPORT.md` and `model/evidence/evidence.json`.
State checkpoints (`states/`, tens of GB) are not included in this repository.

## Funding

MARWANTA needs funding for the next step: servers for testing that this
workstation cannot run, plus operating costs. The ask is **$5,000–$10,000**,
released in three milestone tranches. Full breakdown:
`docs/MARWANTA_FUNDING_NEEDS_PLAN.md`.

## Team

- **Founder — [@oumar9018-cmd](https://github.com/oumar9018-cmd):**
  protocol design, architecture, and every decision in this repository.
  The spec, the TLA+ model (A19), the verification runs, the evidence
  package and the prototype were all built under his direction and review.

The team is small by design at this stage: the funding buys compute and
an independent review, not headcount. Co-builders are welcome once the
verification milestone is done — see `ROADMAP.md`.

## Contact

Founder: [@oumar9018-cmd](https://github.com/oumar9018-cmd).
Issues and pull requests are welcome; protocol changes need founder approval.
