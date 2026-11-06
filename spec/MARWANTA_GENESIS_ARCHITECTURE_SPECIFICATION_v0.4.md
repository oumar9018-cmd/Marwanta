# MARWANTA — Genesis Architecture Specification v0.4

**Project:** MARWANTA — Independent Layer-1 Blockchain
**Document status:** DRAFT FOR FOUNDER REVIEW — NOT APPROVED FOR IMPLEMENTATION. Approval remains withheld. No coding, prototype, testnet, or token decisions are authorised by this document.
**Version:** 0.4 (revises v0.3; four founder corrections merged 2026-11-01; v0.1, v0.2 and v0.3 preserved untouched)
**Strict rule in force:** NO CODING, NO PROTOTYPE, NO TESTNET, NO TOKEN DECISIONS until the founder reviews and approves this revised architecture AND the Phase 2/3 gates in §19 are passed. This v0.4 revision does not itself constitute approval. No production code, prototype code, repository, testnet, mainnet, token, users, TVL, partnerships, or audit results are authorised or claimed by this document.

> **One-sentence thesis, to be validated — not assumed proven:** [Untested Hypothesis] Applications can execute in fault-isolated domains, while their state transitions and cross-domain interactions remain cryptographically verifiable and atomically settled under one shared security set, without one application's failure, congestion, or exploit halting or corrupting unrelated applications.

> **Honest headline, unchanged from v0.1:** This document does **not** claim MARWANTA beats Ethereum or Solana. It claims a *testable direction* — fault isolation plus tiered proof-carrying — that is worth formalising, simulating, and, only if simulation and review pass, prototyping. Every number that is a goal is labelled **TARGET (untested)** with the test that would validate it. No users, TVL, partnerships, audits, or performance results are claimed, because none exist yet.

> **What changed in v0.2, in one paragraph:** v0.1 contained a real contradiction about proof vs. replay, an incomplete settlement design, an overstated isolation claim, an unmodelled shared-bottleneck problem, and overclaimed novelty. v0.2 fixes the contradiction by a single hard rule (Tier-2 validity proofs are supplementary only and can never substitute for validator replay for finality), replaces the settlement sketch with a complete log-derived state machine, replaces the isolation slogan with a layer-by-layer containment table and adversarial scenarios, adds a capacity/allocation model that admits which bottlenecks stay global, demotes every v0.1 "innovation" that was in fact a combination of prior art, and adds measurable kill criteria. Where a fix is a design decision, it is stated as a decision. Where the fix still requires a proof, a measurement, or a primary-source check, it is marked PARTIALLY RESOLVED or UNRESOLVED in the register below and is not hidden behind future-phase language.

> **What changed in v0.3, in one paragraph:** v0.3 merges the 2026-11-01 clarification register into the actual sections of v0.2; it adds no new mechanism and claims no approval. (1) Deadlines and epochs are now defined ONLY in finalised-block terms, termination is bounded ONLY in finalised-block terms AFTER quorum recovery, and K1 is split into K1-T / K1-P / K1-C. (2) The MAES private-logic verification claim is WITHDRAWN: Mode A (validator replay only) is the only mode in v0.3, and Mode B (a specified Tier-2 proof) is a future, unavailable mode. Private execution from full validators is NOT supported under Rule P0. (3) Every K1–K6 numeric threshold now carries its classification, rationale, baseline, sensitivity, and the evidence that would justify changing it; all numeric thresholds are ARBITRARY PROVISIONAL except the logical / BFT-derived standards marked as such. (4) A Phase 2 dependency map (items A–L) is added in §15.1 and summarised in §19.3. Where v0.3 and v0.2 conflict on these three issues, v0.3 governs; where they conflict on anything else, the more restrictive reading governs until v0.4.

> **What changed in v0.4, in one paragraph:** v0.4 corrects four founder issues in the body, and claims no approval. (1) Finality is now formally defined as TWO-CHAIN, not three-chain, in §2.2/§2.2A, with voting and lock rules, a consecutive-view requirement, and finality lag in finalised views/blocks — plus an explicit statement that the HotStuff-2 safety proof does not automatically transfer to MARWANTA's adaptation. (2) Slashing is now one consistent rule: vote-without-replay is a protocol violation regardless of outcome, while slashing additionally requires qualifying evidence (§9.5), because a correct-looking vote alone does not prove an internal omission. (3) The settlement partition rule is now identical in §2.5, §3.5, §6.6, §6.6A, §6.7, §14.4 and §21: no transition is finalised during a quorum-loss partition, wall-clock epoch end or timeout never aborts, abort occurs only on a finalised-block event, and the termination bound applies only after quorum recovery. (4) Domain isolation is restated as execution-only, with a §20.5 parameter table in which every value is UNDECIDED / RESEARCH REQUIRED and no unmeasured isolation guarantee is claimed. Where v0.4 and v0.3 conflict on these four issues, v0.4 governs.

---

## Issue Resolution Register — founder's 6 critical issues (read this first)

| # | Founder issue | Status in v0.2 | Addressed in | What would fully resolve any remainder |
|---|---|---|---|---|
| 1 | Proof-architecture contradiction (§§1.3, 5.1, 5.7, 9.1): does every validator execute, or can Tier-2 proofs substitute? | **RESOLVED as a specification decision** | §1.3, §2.2, §5.1–§5.8, §7.6, §9.1, §10.4 | Machine-checked proof of the validator rule and replay equivalence in Phase 2 — a design decision is not a proof. If Phase 2 finds the rule unimplementable at the required cost, the rule must be revised, not quietly relaxed. |
| 2 | Fault-isolation boundaries: WASM sandboxing + ceilings do not isolate shared consensus, mempool, networking, state-root, storage, settlement | **PARTIALLY RESOLVED** | §4.9 (containment table), §4.10 (6 adversarial scenarios), §8, §20 | Phase 3 measurement of actual leakage under W5/W6 workloads against the §21 isolation kill threshold. Qualitative boundaries are fixed here; quantitative leakage bounds are not yet measured and are therefore not claimed. |
| 3 | Atomic settlement state machine, safety, bounded liveness, lock-griefing economics | **PARTIALLY RESOLVED** | §6.2–§6.8 (complete state machine, invariants, hand analysis, cost model) | Machine-checked model (TLA+ or equivalent) proving safety invariants and termination bounds in Phase 2, plus Phase 3 contention/adversarial simulation. The hand analysis in §6 is explicitly NOT a machine-checked proof. |
| 4 | Shared bottlenecks despite per-domain ceilings | **PARTIALLY RESOLVED** | §20 (capacity/allocation model, per-resource table), §4.5, §8 | Phase 3 hardware/workload measurements that fill in the symbolic capacities in §20 with real numbers, and a global-scheduler design validated against those numbers. §20 states plainly which bottlenecks remain global even after mitigation. |
| 5 | Novelty test: feature-by-feature prior-art matrix vs. Ethereum, Solana, Aptos, Sui, Polkadot, Cosmos | **RESOLVED as a matrix and demotion exercise** | §17 (matrix), §18 (rewritten dossiers), Appendix C (demotion log) | Phase 1 primary-paper verification of every matrix cell. The matrix is built from v0.1 secondary sources plus the founder's correction; any cell that primary review overturns must be corrected in v0.4, not defended. |
| 6 | Kill criteria: measurable abandon / narrow conditions | **RESOLVED as criteria** | §21, §14.4, §15 | Founder confirmation of the threshold values in §21 (they are labelled founder-set thresholds to be confirmed, NOT measured results) and Phase 3 measurement against them. |
| 7 | 2026-11-01 clarification 1: deadline vs quorum loss | **CORRECTED in v0.3 text** | §6.2, §6.6, §6.6A, §6.7, §14.4, §21 (K1-T/K1-P/K1-C) | Phase 2 must formalise D, epoch length, and finality lag in finalised blocks and model-check the revised termination-after-recovery bound; wall-clock termination during a partition remains unbounded by construction. |
| 8 | 2026-11-01 clarification 2: MAES private-logic verifiability | **CLAIM WITHDRAWN in v0.3 text** | §5.6, §5.6A, §18.6, §18 C2 | Phase 2 must specify a Tier-2 proof construction before any Mode B claim can be made; until then MAES tests atomicity, execution isolation, Mode A auditability, and refund correctness only. |
| 9 | 2026-11-01 clarification 3: threshold justification + Phase 2 dependency map | **CORRECTED in v0.3 text** | §21, §21.1, §15.1, §19.3 | Founder must confirm or revise every threshold in §21.1; Phase 3 cannot pass/fail a gate against unconfirmed thresholds. |

| 10 | Founder issue 10 (2026-11-01 review): finality definition — §2.2 two-chain vs three-chain ambiguity | **CORRECTED in v0.4 text as TWO-CHAIN** | §2.2, §2.2A, §19.1(10) | Phase 2 must reconcile MARWANTA's consecutive-view formulation with HotStuff-2's double-certificate commit step and prove the adapted rule; the HotStuff-2 proof does not transfer automatically. |
| 11 | Founder issue 11: slashing consistency — vote-without-replay (§1.3, §2.2, §9, §11) | **CORRECTED in v0.4 text to ONE rule** | §1.3, §2.2, §9.2, §9.4, §9.5 (NEW), §10.4 inv. 8, §11.1, §11.3 | Phase 2 must fix challenge parameters (bound, bond, repeat count, intermediate format), penalty rates, jailing durations, and appeal window; perfect detection without a challenge is NOT claimed. |
| 12 | Founder issue 12: settlement partition consistency (§2.5, §3.5, §6.6, §6.6A) | **CORRECTED in v0.4 text — identical rule in every listed section** | §2.5, §3.5, §6.6, §6.6A (canonical), §6.7, §14.4, §21 K1-T/P/C | Phase 2 must formalise D, epoch length, and finality lag in finalised blocks and model-check K1-T/K1-P under a partition-and-heal model. |
| 13 | Founder issue 13: domain isolation limits and measurable parameters (§4.1, §4.9, §20) | **CORRECTED in v0.4 text — execution-only scope + §20.5 parameter table, all values UNDECIDED** | §4.1, §4.9, §20.4, §20.5 (NEW) | Phase 3 must measure every §20.5 parameter on W1–W6; until then no numeric isolation or degradation bound is claimed. |

**UNRESOLVED sub-items that still prevent knowing the complete system (stated here, not buried):**

- (a) Machine-checked proof of consensus + settlement safety and of the §5 validator rule, including the revised termination-after-recovery bound — **UNRESOLVED, Phase 2 required.** §6.7 is a hand analysis only.
- (b) Quantitative isolation leakage, proof cost, and validator hardware numbers — **UNRESOLVED, Phase 3 measurement required.** §20 uses symbolic capacities, not measured numbers.
- (c) Exact proof system, arithmetisation path, and whether a provable VM can share the execution VM — **UNRESOLVED, Phase 2 research required.** Tier-2 is therefore supplementary only (§5) and can be deferred without breaking finality.
- (d) Exact token parameters, fee levels, lock fees, and bond sizes — **UNDECIDED, not invented.** §6.8 uses abstract units only.
- (e) Primary-source verification of the §17 matrix — **UNRESOLVED, Phase 1 required.**
- (f) Block time, prepare deadline D, epoch length, and finality lag in finalised blocks — **UNDECIDED, Phase 2 must fix them in finalised-block terms, not seconds.** Until then, no wall-clock settlement latency claim can be made from this document.

- (g) Equivalence between MARWANTA's consecutive-view two-chain formulation (§2.2A) and HotStuff-2's double-certificate commit step, and a safety proof for the adapted protocol (P0 replay + DA gate + stake-weighting + settlement interaction) — **UNRESOLVED, Phase 2 required.** The HotStuff-2 proof does not transfer automatically.
- (h) Slashing challenge parameters, penalty rates, jailing durations, appeal window, and the quorum threshold for replay evidence — **UNDECIDED / RESEARCH REQUIRED, Phase 2.** Perfect detection of a correct-looking vote cast without replay, without a challenge, is NOT claimed.
- (i) Every §20.5 parameter value (scheduler, storage, root, network) — **UNDECIDED / RESEARCH REQUIRED, Phase 3 measurement required.** No numeric isolation or degradation bound is claimed until measured.
- (j) Finality lag in finalised views/blocks — **UNDECIDED, Phase 2 must fix it once view/block timing in finalised-block terms is fixed.** No wall-clock finality latency is claimed.

If any of (a)–(c) fails in Phase 2/3, §21 — not further complexity — decides whether the thesis is abandoned or narrowed.

---

## How to read this document — labelling rule

Every substantive technical claim carries one of five labels:

- **[Established]** — widely accepted distributed-systems / cryptography result, e.g. BFT safety bounds under partial synchrony.
- **[Prior Art]** — a mechanism already used, published, or deployed by another system; MARWANTA did not invent it.
- **[Proposed MARWANTA]** — a specific design choice proposed for MARWANTA in this document. It is a proposal, not a proven result.
- **[Untested Hypothesis]** — a claim that would need experiment, simulation, or formal analysis before it can be relied on.
- **[Research Required]** — an open question that Phase 1–3 must answer before the choice is locked.

Where a paragraph mixes labels, the label at the start of each bullet or sentence governs that bullet or sentence. Unlabelled headings, tables of contents, and purely definitional text are definitions, not factual claims.

**Research method and evidence limits (read before trusting §17):** v0.2 retains v0.1's secondary-source base (public web text search, 2026-10-31: HotStuff/HotStuff-2, Narwhal/Bullshark and Mysticeti, Avalanche Snowman, Solana Sealevel and local fee markets, Aptos Block-STM, Sui object model, Cosmos IBC, Polkadot shared security and XCM, STARK/SNARK validity proofs, Starknet/SHARP, deterministic WASM runtimes, Merkle/Verkle state commitments, data-availability sampling). Sources were largely secondary summaries, documentation pages, and explainers — **not** a full primary-paper review, and **not** independent benchmark reproduction. [Research Required] Phase 1 must replace every secondary-source claim in §17 with primary-paper and primary-documentation citations, and must record where a claim could not be verified. Any statement in this draft that turns out to be wrong on primary review must be corrected in v0.5, not defended (v0.4 did not complete primary verification; see Appendix E item (k)).

**What v0.2 deliberately does NOT decide:** exact token supply, exact validator minimum stake, exact block time, exact TPS, exact proof system, exact cryptography for the state tree beyond the §7 baseline, and the final consensus variant beyond the justified adaptation in §2. Those are listed as undecided in §19 precisely so the founder is not asked to approve invented numbers.

---

## 0. Executive summary — what MARWANTA is, and what it is not

- **What it is:** [Proposed MARWANTA] A permissionless Layer-1 whose unit of isolation is the *application domain*: a bounded execution environment with its own state namespace, resource budget, capability manifest, and failure boundary, settled by one shared validator set and one global state commitment.
- **What it is not:** [Proposed MARWANTA] Not an Ethereum clone, not a Solana clone, not an EVM fork, not a generic "high-TPS chain", and not a rollup. It does not achieve isolation by giving each application its own chain and its own validator set (that is the Cosmos sovereign-zone model [Prior Art]); it keeps shared security and pays for isolation inside one chain.
- **The central trade-off, stated up front, now sharpened by v0.2:** [Untested Hypothesis] Isolation buys fault containment and congestion containment *inside the execution layer*, but it cannot buy isolation of the shared layers — consensus, block propagation, global root computation, the write-ahead log, and the settlement log are global by construction (§4.9, §20). Cross-domain atomicity is bought with latency (at least two consensus steps) and with lock contention. If §21 kill criteria show that the global layers leak more than the threshold, or that settlement abort rates make atomic cross-domain work unusable, the thesis is weakened and must be narrowed (single-domain + async messaging) rather than defended with more complexity.
- **Security posture:** [Proposed MARWANTA] No unaudited mainnet. No token launch to attract airdrop farmers. No fabricated ecosystem metrics. Mainnet is conditional on Phase 7 (independent review, formal verification of critical properties, penetration testing, bug-bounty preparation) plus the readiness gates in §15, Phase 9. **And, new in v0.2: no Tier-2 proof, however strong, can ever make an unexecuted block final (§5.1).**

### Terminology used throughout

| Term | Definition in this document |
|---|---|
| **Domain** | [Proposed MARWANTA] A named application execution environment: one application, or one tightly coupled application family, with its own state namespace, code, resource budget, and manifest. Domains are the fault boundary *in the execution layer only* (§4.9). |
| **Capability manifest** | [Proposed MARWANTA] A machine-checkable declaration, published at domain deployment, of what state a domain may read/write, what other domains it may call, and what resource ceilings it accepts. Execution that exceeds the manifest is rejected, not merely charged more. |
| **Execution receipt** | [Proposed MARWANTA] A signed, hash-chained record of one execution: inputs, declared read/write sets, resource use, resulting state-diff commitment, and outcome (success / domain-local failure / settlement abort). A receipt is *evidence of what was claimed*, not by itself a validity proof. |
| **Validity proof (Tier-2)** | [Established] A cryptographic proof (STARK, SNARK, or other) that a computation was performed correctly, verifiable without re-executing the computation. Validity ≠ receipt. In v0.2, Tier-2 is **supplementary only** (§5.1) — it never substitutes for validator replay for finality. |
| **Settlement** | [Proposed MARWANTA] The global step that either commits *all* effects of a cross-domain operation or commits *none* of them (plus, where specified, a defined compensation/refund effect). Partial commitment is a protocol violation, not a user error. |
| **Finality** | [Established] In BFT terms, the point after which a committed decision cannot be reverted without violating the fault assumption (here, < 1/3 Byzantine stake by the rule in §2). Finality in MARWANTA is deterministic BFT finality, not probabilistic confirmation counting. |
| **Data availability (DA)** | [Established] The guarantee that the data needed to verify and reconstruct state is actually published and retrievable, not merely committed to by hash. In v0.2, DA is a *precondition* for a validator voting to finalise, not a post-hoc property (§5.1, §7.6). |

---

## 1. Complete architecture diagram

### 1.1 System view (Mermaid) — corrected in v0.2: proof is a sidecar, not the critical path

```mermaid
flowchart TB
    subgraph Clients["Clients & Wallets"]
        U[User / Agent]
        W[Wallet / SDK]
        D[Developer Tooling]
    end

    subgraph Edge["Edge / RPC Layer (untrusted, replaceable)"]
        RPC[Public RPC Nodes]
        IDX[Indexer & Explorer]
        FAU[Testnet Faucet]
    end

    subgraph Net["MARWANTA P2P Network"]
        MEM[Mempool & Gossip\n(per-domain queues + global caps - §20)]
        CON[Consensus: HotStuff-2 lineage\n(adapted, NOT claimed new - §2)]
        EXEC[Execution Layer\nDomain-isolated deterministic WASM\nEVERY validator replays EVERY tx - §5.1]
        SETT[Settlement Log + State Machine\nLog-derived, deterministic - §6\nDECIDE+APPLY atomic in one block]
        STATE[State & Storage\nPer-domain SMT roots -> Global root §7]
        DA[Data Availability Gate\nFull block data BEFORE finality vote - §5.1]
    end

    subgraph ProofSide["Proof Sidecar - SUPPLEMENTARY ONLY"]
        PROOF[Proof Layer\nReceipts always; Tier-2 validity proofs\nNEVER substitute for replay - §5]
        PV[Prover (non-validator role)]
    end

    U --> W --> RPC
    D --> RPC
    RPC --> MEM
    MEM --> CON
    CON --> EXEC
    EXEC --> SETT
    SETT --> STATE
    EXEC --> DA
    DA --> CON
    CON <--> V1[Validator]
    CON <--> V2[Validator]
    CON <--> VN[Validator ... n >= 3f+1]
    SETT -.-> PROOF
    PV -.-> PROOF
    PROOF -.-> IDX
    STATE --> IDX
    RPC --> IDX
    RPC --> FAU
```

Reading the diagram: the solid path is MEM → CON (order) → EXEC (replay by every validator) → SETT (log-derived decide+apply) → STATE, gated by DA before any finality vote. The dashed path to PROOF is deliberately off the critical path: a missing, late, or invalid Tier-2 proof degrades light-client fast verification only; it never blocks, accelerates, or overrides finality.

### 1.2 Transaction flow (ASCII, one cross-domain transaction) — corrected

```
User signs tx
   │  (domain intents + capability manifest refs + resource budget)
   ▼
RPC / Mempool ── gossip, signature + manifest pre-check, per-domain queue (§20)
   │
   ▼
Ordered by Consensus (§2) — order only, NOT execution, NOT finality
   │
   ▼
Execution (§4) + Replay (§5.1): EVERY full validator deterministically
   replays EVERY intent in its domain sandbox, checks manifest + budget,
   compares its state root to the proposed root. NO direct cross-domain writes.
   │
   ├── Single-domain tx ──► domain-local commit + receipt
   │
   └── Cross-domain tx ──► Settlement (§6, log-derived state machine):
         PREPARE-ATTEMPT: all-or-none lock acquisition in canonical order;
                          if any lock unavailable -> WAIT (no locks held) or ABORT
         PREPARED: all locks held, receipts + diff commitments in ordered log
         DECIDE+APPLY (same block): all prepared -> COMMIT all diffs;
                                     any abort/timeout/epoch-end -> ABORT all,
                                     locks released, defined refund path
   │
   ▼
Data Availability Gate (§5.1, §7.6): validator must hold FULL block data
   (txs, diffs, receipts, settlement decisions, domain roots) before voting
   to finalise. Data withheld -> no vote, leader timeout, no finality.
   │
   ▼
State commitment (§7): per-domain roots recomputed by replay,
                       global root = Merkle root over domain roots,
                       block header commits: tx root, state root,
                       receipts root, settlement-decision root,
                       (optional, supplementary) proof root
   │
   ▼
Finality (§2): quorum certificate chain -> deterministic finality.
   Finality requires replay + DA + QC. Tier-2 proof is NOT required
   and NOT sufficient for finality.
   │
   ▼
Light clients / Indexer / Explorer verify: header + inclusion proof.
   Tier-2 proof, if present and valid, is an ADDITIONAL check for
   light clients / external verifiers only (§5.6).
```

### 1.3 Layering rule — REWRITTEN in v0.2 (resolves the v0.1 contradiction)

- [Proposed MARWANTA] **Consensus orders; execution executes; settlement commits; proofs supplement.** No layer may silently do another layer's job. In particular, execution may not reorder transactions to "fix" a conflict, consensus may not execute application code to decide ordering, and the proof layer may not certify a block that validators have not replayed.
- [Proposed MARWANTA] **THE CANONICAL RULE (v0.2, §5.1): every full validator replays every transaction in every block it votes to finalise, without exception.** The sentence in v0.1 §1.3 that a validator "does not need to re-execute every domain's private computation in the Tier-2 validity-proof case" is **withdrawn and replaced** by this rule. There is no Tier-2 exception to replay for finality. A validator that has not replayed must not vote to finalise; a validator that votes on the basis of a Tier-2 proof alone is in protocol violation, regardless of whether the block turns out to be correct. Slashing for that violation additionally requires qualifying evidence under the one consistent rule in §9.5 (§9, §11) — violation status does not depend on outcome, but a correct-looking vote alone does not prove an internal omission (see §9.5, enforcement gap).
- [Prior Art] This separation follows the Narwhal/Bullshark lesson of separating dissemination from ordering, and the Aptos/Sui lesson of separating ordering from execution — but MARWANTA v0.2 does **not** adopt a DAG mempool as its consensus (see §2 for why, and for the simulation that could change that decision).
- [Proposed MARWANTA] Domains are **not** shards with separate validator sets and **not** separate chains. Every validator validates every domain's settlement commitment **by replay**, not by trusting a proof, a receipt, or another validator's word.

---

## 2. Consensus design

### 2.1 Decision, stated plainly (no new-consensus claim)

- **[Proposed MARWANTA] v0.2 consensus = an adaptation of the HotStuff-2 lineage (pipelined, quorum-certificate-based BFT), with Jolteon-style pipelining as a reference implementation pattern, NOT a new consensus protocol.** No new consensus mechanism is claimed, because no demonstrable advantage for a new mechanism has been shown.
- **[Prior Art] HotStuff** introduced linear view-change communication and responsiveness under partial synchrony; **HotStuff-2** restructured safety into block structure (implicit locks, two-chain finality) and reduced finality latency versus classic three-phase HotStuff. **AptosBFT** is a HotStuff-derived production example.
- **[Research Required]** Whether a DAG-based mempool/consensus (Narwhal/Bullshark, Mysticeti) would beat HotStuff-2 for MARWANTA's workload *under MARWANTA's domain/settlement traffic mix* is **unresolved**. §14 defines the head-to-head simulation that must run in Phase 3 before any DAG adoption. A DAG is **not** bolted onto HotStuff-2 in v0.2 and called new.

### 2.2 Properties (updated in v0.2: validator replay + DA are now explicit preconditions)

| Property | v0.2 specification |
|---|---|
| Fault model | [Established] Byzantine faults, n ≥ 3f + 1 validators (by stake-weighted voting power, §2.5), at most f Byzantine voting power. Safety holds under partial synchrony; liveness holds after GST with an honest leader. |
| Safety | [Established] Two honest validators never finalise conflicting blocks at the same height, under the §2.2A two-chain rule and the < 1/3 Byzantine assumption. [Research Required] Full formal proof for MARWANTA's exact adaptation (including P0 replay, DA gate, stake-weighting, and settlement-phase interaction) must be written in Phase 2 and model-checked in Phase 3 — the HotStuff-2 proof does **not** automatically transfer to a modified protocol, and the correspondence between MARWANTA's consecutive-view formulation and HotStuff-2's double-certificate commit step is itself RESEARCH REQUIRED (§2.2A). |
| Validator precondition for a finality vote (NEW, canonical) | [Proposed MARWANTA] Before signing any vote that can contribute to finalising block B, a validator MUST have: (1) downloaded and hash-verified the full data of B (§5.1 DA gate); (2) deterministically replayed every transaction in B and reproduced the claimed global root and every domain root in B; (3) verified every settlement decision in B against the §6 state machine from the ordered log; (4) verified receipts roots and manifest/budget enforcement for B. A Tier-2 proof may be checked in addition, but it satisfies none of (1)–(4) on its own. A validator that cannot complete (1)–(4) — data missing, replay mismatch, or execution timeout — must abstain from that vote, not vote on trust. |
| Liveness | [Established] After GST, a sequence of honest leaders drives progress. Liveness is **not** guaranteed during asynchrony or partition (finality-over-availability choice). MARWANTA chooses finality over availability during partition. |
| Adversarial model | [Proposed MARWANTA] Adversary controls < 1/3 of voting power, can delay (not indefinitely after GST), reorder, and equivocate messages, can run malicious domains, can spam, can bribe/coordinate Byzantine validators, but cannot break the stated cryptographic assumptions (hash collision resistance, signature unforgeability, and, for Tier-2 *supplementary* checks only, the proof system's soundness). Network adversary cannot forge honest validators' signatures. Long-range and stake-history attacks are addressed in §10. |
| Message complexity | [Prior Art] HotStuff lineage: O(n) authenticators per view in the happy path via threshold-signature quorum certificates; O(n²) in cascading leader-failure view changes. [Proposed MARWANTA] v0.2 targets the same bounds and must **measure**, not assert, them in simulation for n = 4, 16, 64, 128 validators (TARGET test set, §14). |
| Communication complexity | [Proposed MARWANTA] Leader-to-all proposal + all-to-leader votes per view (star topology per view), plus gossip for mempool dissemination. Block payloads are referenced by hash where possible; full payloads are disseminated once, not re-broadcast per vote. Exact bandwidth per validator is a Phase 3 measurement, not a v0.2 claim. |
| Finality definition | [Proposed MARWANTA] **TWO-CHAIN, canonical — see §2.2A for the formal rule.** A block B in view v is **final if and only if** QC(B) exists AND there exists a direct child block B' with parent = B, view(B') = v+1 (consecutive views), and QC(B') exists. **No grandchild is required.** A block in a non-consecutive view chain does not finalise B under this rule, even if a later certified descendant exists. Clients must **not** treat one confirmation, optimistic execution output, a receipt, or a Tier-2 proof as finality. MARWANTA adds P0 replay and the DA gate as preconditions for a finality vote (§2.2, validator precondition row); those additions are MARWANTA's, not part of original HotStuff-2, and the HotStuff-2 safety proof does **not** automatically transfer to the adapted protocol — Phase 2 formal proof is still required (§2.2A). |
| Leader selection & rotation | [Proposed MARWANTA] Deterministic, stake-weighted, VRF-seeded rotation per view/epoch, with the seed derived from prior finalised headers so it cannot be freely chosen by the outgoing leader. [Research Required] Exact VRF construction, rotation period, and leader-slowdown penalties are Phase 2 decisions; rotation alone does not solve leader censorship (§2.6). |
| Leader failure recovery | [Prior Art] View change on timeout: validators stop voting for the stalled view, carry forward the highest certified block they know, and the next leader proposes extending it. [Proposed MARWANTA] Timeout values must be adaptive (measured round-trip + execution slack), not a single hard-coded constant, and timeout inflation under attack is itself a slashing/monitoring signal (§9). |
| Equivocation detection | [Proposed MARWANTA] Two different signed proposals/votes for the same view/height from the same validator are cryptographic evidence of equivocation, gossiped as evidence, and trigger slashing (§11) after on-chain verification. |
| Sybil resistance | [Established] BFT voting power must be tied to a scarce resource, not to node count. [Proposed MARWANTA] That resource is bonded stake (§11). A validator identity without bonded stake has zero voting power. This does not solve stake concentration (§10, §16). |
| Partition recovery | [Proposed MARWANTA] On partition heal, validators re-sync from the highest finalised header, replay certified (not merely gossiped) blocks, and rejoin only after verifying the finalised chain and current validator set. No "longest chain wins by length" rule: finalised blocks are never reverted. Unfinalised blocks on a minority partition are discarded, and their transactions return to the mempool (with nonce/sequence handling in §3 so they are not double-applied). |

### 2.2A Formal finality rule — TWO-CHAIN, canonical (NEW in v0.4)

**Status of this subsection:** this is the canonical finality definition for v0.4. Where any other passage in v0.4 appears to describe a three-chain rule, a grandchild requirement, or a different finality trigger, this subsection governs and that passage must be corrected in v0.5. This subsection is a specification decision, not a proof: it states the rule to be proven in Phase 2, it does not prove it.

**Reference.** HotStuff-2 (Malkhi & Nayak, "HotStuff-2: Optimal Two-Phase Responsive BFT", Cryptology ePrint Archive 2023/397) replaces HotStuff's three-phase / three-chain structure with a two-phase regime and a 2-chain commit rule instead of a 3-chain rule. In that paper, a party votes for a block only if it extends the highest certificate it knows, and it updates its lock to the parent block on voting. MARWANTA adopts the two-chain direction of that work. MARWANTA's exact formulation below — in consecutive-view terms, with stake-weighting and with P0/DA preconditions — is an adaptation, not a verbatim copy of the paper's single-shot exposition. The correspondence between MARWANTA's consecutive-view formulation and the paper's double-certificate commit step (in which a party, on voting for a block, commits an ancestor covered by a double certificate) is [Research Required] in Phase 2: Phase 2 must either prove the two formulations equivalent under MARWANTA's pipelining, or revise §2.2A to the formulation that is proven. Until then, §2.2A is the rule to be proven, not a proven theorem about HotStuff-2.

**Definitions.**
- `n` = number of validators by voting power; the fault bound is `n >= 3f + 1` in voting-power terms, i.e. at most `f` Byzantine voting power, strictly less than one-third of total voting power. [Established, BFT]
- `QC(B)` = a quorum certificate for block B: an aggregated set of signed votes for B totalling at least `2f + 1` voting power (in MARWANTA's adaptation, at least two-thirds of bonded-stake voting power; the exact aggregation and threshold-signature construction are Phase 2 decisions, but the threshold is not: it must be > 2/3 of voting power). A single vote, a receipt, a Tier-2 proof, or optimistic execution output is not a QC.
- `view(B)` = the view in which B was proposed. Views are monotonic per validator: a validator never votes in a view lower than a view it has already voted in, and never votes twice in the same view for conflicting blocks (equivocation, §9.5).
- `parent(B') = B` means B' directly extends B in the block chain (B is B''s immediate parent, by hash linkage). "Descendant" without "direct child" does not satisfy the rule.
- `lock` = the highest certified block a validator has voted for, represented by its QC and view. Locking is per validator, not per chain: different validators may hold different locks at the same time, which is why the voting rule below, not a global lock, is the safety mechanism.

**Voting rule (a validator may vote for a proposal in view v only if ALL of the following hold; otherwise it must abstain, not vote on trust).**
1. The proposal is the first valid proposal the validator has seen in view v, from the designated leader for v, with a valid parent QC chain and no equivocation in that view by that leader.
2. The proposal extends the highest certified block known to the validator, or is justified by a QC whose view is higher than the validator's lock view. Formally: let `P` be the parent block of the proposed block. The validator votes only if `rank(QC(P)) >= rank(lock)`, where rank is by QC view (higher view = higher rank; ties are broken only by the deterministic rule Phase 2 must specify — tie-breaking is [Research Required] and must not be left to implementation choice).
3. `view(proposal) > last_voted_view` for that validator (view monotonicity).
4. MARWANTA preconditions, which are additions to HotStuff-2 and do not appear in the original paper: the validator has completed P0 for the proposed block — (1) full-data download and hash verification, (2) deterministic replay reproducing the claimed global and domain roots, (3) settlement-decision verification against §6, (4) receipts/manifest/budget verification (§2.2, validator precondition row; §5.1). A Tier-2 proof satisfies none of (1)–(4) on its own.
5. The proposal does not conflict with a block the validator has already locked at a view >= the proposal's parent QC view, unless a newer QC justification as in (2) is present. A validator that votes in breach of (1)–(5) commits a protocol violation (§9.5), regardless of whether the block turns out to be correct.

**Lock rule.** When a validator votes for a block B' whose parent is B, it updates its lock to QC(B) (the parent's certificate) and records lock view = view(B). Thereafter it will not vote for a conflicting block at or below that lock view without a newer QC justification as in voting rule (2). The lock is what prevents an honest validator that helped certify B from later helping to certify a conflicting branch that would finalise a competitor to B. Locking does not, by itself, finalise anything: finality requires the commit rule below.

**Commit rule (FINALITY) — TWO-CHAIN.**
- Block B in view v is FINAL if and only if: (a) QC(B) exists, AND (b) there exists a direct child block B' with parent(B') = B and view(B') = v + 1, AND (c) QC(B') exists.
- No grandchild is required. No third QC is required. A chain B -> B' -> B'' does not add a further finality condition for B beyond (a)–(c); B'' may be relevant to finalising B', not to finalising B.
- Finality is observed when QC(B') is observed in the finalised log (or in a quorum-certified form a client can verify). A client or validator that has seen QC(B) alone, or B' proposed but not yet certified, must not treat B as final.
- **Non-consecutive views do NOT fire the rule.** If B is in view v, the next certified block is in view v + 2 or later (because view v + 1 had a faulty leader, a timeout, or no QC), and B' in view v + 2 has parent = B, then B is NOT final under this rule at that point, even though B' is certified and extends B. Finality for B waits for a consecutive pair: a certified direct child in the immediately following view. This is the strict reading of the task rule adopted in v0.4. Phase 2 must confirm that this strict consecutive-view reading is the intended HotStuff-2 pipelined reading for MARWANTA, or revise §2.2A with a proven alternative — it must not silently relax the rule in implementation to "any certified descendant" without a new founder approval, because that relaxation changes the safety argument.
- **Worked cases (illustrative, in views, not seconds).** (i) B in view 5, QC(B) formed; B' in view 6, parent = B, QC(B') formed: B is FINAL. (ii) B in view 5, QC(B) formed; view 6 produces no QC; B' in view 7, parent = B, QC(B') formed: B is NOT yet final under §2.2A; it becomes final only if a later consecutive pair covers it under the same rule applied to its own chain position (for example, if B' in view 7 is itself followed by a certified direct child in view 8, then B' is final, and B's finality must be re-evaluated under the proven rule Phase 2 writes down — v0.4 does not claim B becomes final merely because a descendant is final, and Phase 2 must state the ancestor-finality consequence explicitly). (iii) Two conflicting blocks B and B* at the same height, each with a QC: at most one can satisfy the commit rule with an honest quorum under the < 1/3 Byzantine assumption and the voting/lock rules above; if both appear finalised, the BFT assumption or the voting rule has been violated, and §10.7 incident response applies — finality is not "repaired" by a proof or by a later QC.

**Finality lag (in finalised views/blocks, not seconds).** Under the commit rule, the minimum lag from B's QC to B's finality is one consecutive view: B in view v becomes final only when QC(B') in view v + 1 is observed. In finalised-block terms, that is at least one additional finalised block (B') beyond B, plus the local P0 replay/DA verification a validator must complete before voting for B' (which is work, not a view count, and is not stated in seconds because block/view duration is UNDECIDED). No wall-clock finality latency (for example, "final in X seconds") is claimed in v0.4, because block time, view duration, and finality lag in seconds are all UNDECIDED (§19.2). A future version that states a seconds figure without fixing those parameters would be inventing a number.

**What is NOT finality.** One confirmation (a block proposed or included once), optimistic execution output, a Tier-1 receipt, a Tier-2 validity proof, a light-client header, or a quorum of votes that has not yet formed a QC for a consecutive direct child, is not finality. In particular, a Tier-2 proof for B does not finalise B, even if the proof is valid, because finality under §2.2A requires QC(B') in the next view, and Tier-2 is supplementary under §5.1.

**MARWANTA additions vs original HotStuff-2 (stated so the proof gap is visible).** Original HotStuff-2 does not include: MARWANTA's P0 replay precondition, MARWANTA's DA gate as a voting precondition, MARWANTA's stake-weighted voting-power adaptation (the paper is stated in replica counts, 2t + 1 of n = 3t + 1), MARWANTA's settlement-decision verification as part of a vote, or MARWANTA's domain/receipt verification. Each addition changes what a vote means and therefore changes the safety argument. **The HotStuff-2 safety proof does NOT automatically transfer to MARWANTA's adapted protocol.** Phase 2 must write a formal specification of the adapted protocol (voting rule, lock rule, commit rule, P0, DA, stake-weighting, settlement interaction) and model-check it; until that proof exists, §2.2A is a rule to be proven, and v0.4 must not be cited as "proven safe by HotStuff-2".

**UNRESOLVED in §2.2A (not hidden).**
- Equivalence between MARWANTA's consecutive-view formulation and HotStuff-2's double-certificate commit step in the paper's single-shot exposition, and the ancestor-finality consequence in worked case (ii) above — RESEARCH REQUIRED, Phase 2.
- Tie-breaking for equal-rank QCs, exact threshold-signature aggregation, pacemaker/view-synchronisation details, and view timeout values in finalised-block terms — UNDECIDED, Phase 2.
- Finality lag in seconds — UNDECIDED, because block/view duration is undecided; only the one-view minimum in view terms is claimed.

### 2.3 Why not Avalanche-family or DAG as the v0.2 base?

- **[Prior Art] Avalanche Snowman/Snowman++:** repeated random subsampling gives fast probabilistic finality and scales to large validator sets without a leader bottleneck. **Why not v0.2 base:** [Proposed MARWANTA] MARWANTA's settlement model (§6) needs a single, globally agreed, deterministic commit/abort decision for a cross-domain batch. A probabilistic-finality protocol makes "was this batch committed or aborted?" a confidence statement, not a deterministic fact, at the moment settlement must act. This is a *fit* argument, not a claim that Avalanche is worse in general. [Research Required] A Snowman-based variant remains a Phase 3 comparison candidate if its finality can be made deterministic enough for settlement (e.g. via a finality gadget).
- **[Prior Art] Narwhal/Bullshark, Mysticeti:** separating dissemination from ordering removes the leader as a data bottleneck. **Why not v0.2 base:** [Proposed MARWANTA] DAG mempools add substantial implementation and memory-management complexity and their benefit is largest when dissemination, not execution or settlement, is the bottleneck. For MARWANTA, execution isolation and settlement are hypothesised to be the bottleneck first. [Research Required] Phase 3 must test that hypothesis; if dissemination *is* the bottleneck at the target validator count, a later version may adopt a DAG dissemination layer *under* the HotStuff-2 ordering rule, with a fresh safety argument.
- **[Prior Art] Tendermint/CometBFT:** also a sound BFT choice. **Why not chosen:** [Proposed MARWANTA] Its classic all-to-all voting form is a worse fit for larger validator sets than the linear HotStuff lineage, for no compensating advantage identified in research. Recorded so Phase 2 can revisit it with measurements.

### 2.4 Consensus + execution interaction

- [Proposed MARWANTA] Consensus orders *transaction intents and settlement decisions*; it does **not** wait for full application execution before ordering. Execution happens after ordering, deterministically, from the ordered log. This is the standard order-then-execute pattern [Prior Art] and it is what makes deterministic replay (§5) possible.
- [Untested Hypothesis] Pipelining execution of block N+1 while block N is being certified could cut latency, but it risks speculative state that must be rolled back if N is not finalised. **v0.2 rule: no speculative commit.** Optimistic *execution* for latency is allowed only if its output is never presented to users as final and is discarded on reorg of unfinalised blocks. Phase 3 must quantify the latency gain before this is allowed beyond an experiment.

### 2.5 Validator set, epochs, and voting power

- [Proposed MARWANTA] Validators are organised in epochs (length **UNDECIDED**, candidate range to be tested: 1 day to 1 week of blocks — do not fix in v0.2). At epoch boundaries the active set, voting powers, and rotation seed are committed in a finalised epoch-transition block.
- [Proposed MARWANTA] Voting power is proportional to bonded stake, capped per validator at a **TARGET (untested)** maximum share to be set in Phase 2 tokenomics work (exact value and effect [Research Required]).
- [Proposed MARWANTA] Joining requires a bond transaction, a liveness/identity key registration, and a warm-up period of at least one epoch so the set cannot change mid-epoch in a way that breaks quorum accounting. Leaving requires an unbonding period (duration **UNDECIDED**, §11) during which the validator remains slashable for faults committed while bonded.
- [Proposed MARWANTA] **Epoch boundary and settlement (new, §6.6; corrected in v0.3; canonical rule §6.6A):** no non-COMMITTED settlement survives a finalised epoch-transition block. A wall-clock epoch end alone never aborts a settlement; abort occurs only on a finalised epoch-transition block (§6.6A, bullets C1–C4). That block deterministically aborts every settlement that is not already COMMITTED, releases its locks, and records the abort. This is what makes §6 bounded in finalised-block terms after quorum recovery: a finalised epoch-transition block is a hard termination horizon for every settlement. An epoch boundary that passes in wall-clock time during a quorum-loss partition does NOT abort anything, because no epoch-transition block has been finalised (§6.6A).

### 2.6 Censorship, MEV, and leader power — limits of this design

- [Prior Art] Any leader-based BFT gives the leader short-term power to delay or omit transactions. Rotation bounds the duration, it does not eliminate the power.
- [Proposed MARWANTA] v0.2 mitigations, all partial: (a) mempool gossip so a transaction omitted by one leader is visible to the next; (b) a "censorship evidence" path where a user can submit proof of repeated omission to trigger a forced-inclusion window in a later epoch (mechanism [Research Required]); (c) no in-protocol MEV auction in v0.2 — MEV is treated as a research and monitoring problem, not solved by this spec. **No claim is made that MARWANTA is MEV-free or censorship-proof.**
- [Research Required] Encrypted mempools, fair-ordering protocols, and proposer-builder separation are Phase 2 research items with their own latency and complexity costs. They are not adopted on the basis of this draft.

---

## 3. Transaction lifecycle

### 3.1 Transaction anatomy (all fields are specification, not code)

A MARWANTA transaction is, [Proposed MARWANTA]:

1. **Sender + nonce/sequence** — replay protection (§10). One account, one strictly increasing sequence per domain interaction is the baseline; cross-domain sequence handling is defined in §3.4.
2. **Domain intents** — an ordered list of intents, each naming exactly one domain, one entry point, and its arguments. An intent may not name a domain outside its sender's capability or the domain's manifest (§4).
3. **Declared resource budget** — per-intent compute, storage, and bandwidth ceilings, plus a total fee ceiling. Execution that exceeds its declared budget aborts that intent (domain-local failure, §4.5), it does not borrow from another intent's budget.
4. **Declared read/write hints** — [Prior Art] Solana-style upfront declaration, adapted to domains: each intent declares the state keys it expects to read/write. Hints are used for scheduling (§4.4); they are **not** trusted for security — the runtime enforces actual access against the manifest, and a hint that understates actual access causes abort, not silent expansion.
5. **Settlement mode** — `single` (one domain, commit-or-abort locally) or `atomic` (multiple domains, §6). Atomic mode is opt-in and costs more (two-phase coordination); it is not the default for simple transfers.
6. **Signature(s)** — sender signature over the whole transaction; multi-signature / agent authorisation is a domain-level concern, not a consensus-level one, in v0.2.

### 3.2 Lifecycle stages (single-domain, happy path)

```
1. SIGN      User/agent signs; wallet checks manifest + budget locally (client-side, untrusted).
2. SUBMIT    Tx gossiped to mempool; RPC/validators pre-check: signature, nonce, fee ceiling ≥ minimum, manifest references exist. Per-domain mempool queue (§20).
3. ORDER     Leader proposes tx in a block; consensus certifies order (§2). Tx is now ordered, NOT yet executed or final.
4. EXECUTE+REPLAY  Deterministic WASM execution in the target domain (§4), replayed by EVERY full validator (§5.1). Produces receipt + state-diff commitment.
5. DA GATE   Validator must hold full block data before voting to finalise (§5.1). No data -> no vote.
6. COMMIT    Domain-local commit; per-domain root updated; global root updated (§7).
7. FINALISE  Quorum-certificate chain finalises the block (§2.2). Only now is the tx final for clients.
8. VERIFY    Light clients / indexers verify inclusion + state proof from the finalised header (§7.5). Tier-2 proof, if any, is an additional check only.
```

### 3.3 Lifecycle stages (cross-domain atomic, happy path — detail in §6)

```
1–3. As above, with settlement mode = atomic and a settlement ID binding all intents.
4. PREPARE-ATTEMPT  In one deterministic execution step, attempt all-or-none lock
                    acquisition in canonical order (§6.3). Success -> PREPARED,
                    locks held, receipts + diff commitments in ordered log.
                    Failure -> WAIT (no locks held) until deadline, then ABORT.
5. DECIDE+APPLY (same block)  All prepared -> COMMIT all diffs. Any abort/timeout/
                    epoch-end -> ABORT all, locks released, refund path (§6.4).
                    There is NO decided-but-unapplied state across blocks.
6. DA GATE + FINALISE + VERIFY as above. A cross-domain tx is final only when
   its settlement decision is final.
```

### 3.4 Replay, ordering, and nonce rules

- [Proposed MARWANTA] A transaction's sequence number is consumed **only** on successful ordering for execution, not on mempool gossip. A transaction that is ordered but aborts (domain-local failure or settlement abort) still consumes its sequence and still pays the fee for resources actually used up to the abort point (exact fee-on-abort rule is a Phase 2 tokenomics decision, §11 — the principle is: abort must not be free, or abort becomes a free DoS/griefing vector).
- [Proposed MARWANTA] Cross-domain transactions use a single global sequence for the sender plus per-domain sub-sequences derived deterministically from the settlement ID, so a replayed cross-domain tx cannot be split into its intents and replayed separately. [Research Required] The exact derivation and its interaction with domain-local sequences must be formalised in Phase 2; a flaw here is a double-spend vector (§10).
- [Established] Transaction ordering within a block is the consensus order. Execution must be deterministic with respect to that order: the same ordered log, replayed by any honest validator, yields the same state root. Non-determinism (wall-clock, random numbers without a committed seed, floating point, unordered map iteration) is a protocol bug, not a developer choice (§4.6).

### 3.5 Failure taxonomy (what "failed" means at each stage)

| Stage | Failure | Effect |
|---|---|---|
| Pre-check | Bad signature, bad nonce, fee ceiling too low, unknown domain | Never ordered; no fee, no sequence consumed |
| Execution (single) | Out-of-budget, manifest violation, runtime trap, domain logic revert | Tx included, domain-local abort, fee for work done, sequence consumed, no state change from that tx |
| Prepare (atomic) | Any domain fails to prepare, lock unavailable past the finalised deadline block (B_f + D finalised blocks), conflict, or finalised abort event | Whole settlement aborts (§6); no partial effects; locks released (or never acquired, in the WAIT case). A wall-clock timeout never aborts a settlement by itself — abort requires a finalised-block event (§6.6A, bullets C1–C4). |
| Settlement | Leader failure, partition, finalised epoch-transition block | Deterministic abort path (§6.6, §6.6A); settlement must terminate within the §6.7 bound after quorum recovery, in finalised-block terms — during a quorum-loss partition it freezes (no transition, no partial state) and does not terminate until the chain resumes finalising. A wall-clock epoch end never aborts; only a finalised epoch-transition block does (§6.6A, bullets C1–C4). |
| Consensus | Leader failure, partition | Tx delayed, not lost; returns to mempool after view timeout / reorg of unfinalised blocks. A view timeout is a consensus liveness event, not a settlement abort: it never aborts a settlement by itself (§6.6A). |
| Proof (Tier-2 only) | Proof invalid, missing, or prover unavailable | **No effect on finality.** Proof status recorded as INVALID / MISSING / UNAVAILABLE; light-client fast verification degrades; prover flagged (§5.5) |
| Replay disagreement | Validator's replay root ≠ proposed root | Validator rejects block, does not vote, gossips evidence. Replay wins over any proof, receipt, or proposer claim (§5.1) |
| Data unavailable | Full block data not retrievable by validator | Validator does not vote to finalise; block cannot finalise without a quorum of validators who hold the data (§5.1) |

---

## 4. Execution isolation model

### 4.1 The domain as a fault boundary — what isolation does and does not mean (corrected in v0.2)

- **[Proposed MARWANTA] Isolation means, in the execution layer ONLY (NEW in v0.4 — scope restated, no shared-layer claim):** a domain's code runs in its own deterministic WASM sandbox; it can read/write only its own state namespace plus explicitly capability-granted shared state; it has its own resource budget that cannot be borrowed or exceeded by another domain; its failure (trap, out-of-budget, logic revert, resource exhaustion) aborts only its own intent(s) in the single-domain case, and triggers a defined settlement abort in the atomic case — it does not crash the validator, corrupt another domain's state, or halt execution of other domains *in the same execution step, at the execution layer*. This bullet makes NO claim about consensus, block propagation, global root computation, shared storage, the settlement log, or epoch transitions: those are shared layers (§4.9, §20, §20.5) and are bounded, not isolated, and every numeric bound for them is currently UNDECIDED / RESEARCH REQUIRED until Phase 3 measurement.
- **[Proposed MARWANTA] Isolation does NOT mean, and v0.1 overstated this by implication:** domains are invisible to each other, or that a domain can hide a state transition from validators, or that a malicious domain cannot waste *its own* budget, spam *its own* namespace, or attempt cross-domain calls, or that shared layers are isolated. Shared consensus, mempool, networking, global state-root computation, storage, and settlement are **not** isolated by WASM sandboxing or by per-domain ceilings alone, and NO row in §4.9 claims CONTAINED for a shared layer's finality, latency, or throughput: where §4.9 says CONTAINED, the scope is stated in that row (execution only, or unrelated-input lock non-interference, or access only via independent RPC operators) and does not extend to shared layers. §4.9 states, layer by layer, what is contained, what degrades, and what is still chain-wide; §20.5 states every shared-layer parameter, its unit, its current UNDECIDED value, and how it will be measured. Any v0.1 sentence that could be read as "isolation prevents one domain degrading the whole network" is superseded by §4.9 and §20, and any v0.4 sentence that could be read as a proven or numeric isolation guarantee is withdrawn by this bullet: isolation beyond the execution layer is an unmeasured, unproven claim in v0.4, not a guarantee.
- **[Prior Art] Closest analogues, and how MARWANTA differs:** Solana's account model + Sealevel gives parallelism via declared accounts but all programs share one global state space and one fee market — a hot program can congest the whole network. Sui's object model gives structural independence for owned objects and a fast path for single-owner txs, but shared objects still go through consensus and contention. Polkadot parachains give strong isolation but with separate chains and a relay-chain coordination cost. Cosmos zones give full sovereignty but no shared security. [Proposed MARWANTA] MARWANTA's bet is the middle point none of those occupies: **one chain, one validator set, many hard-bounded domains, with cross-domain work only through settlement.** Whether that middle point is better than either pole for real workloads is [Untested Hypothesis] — it is the thesis, not a conclusion.

### 4.2 Domain structure

- [Proposed MARWANTA] Each domain has: (a) a unique domain ID, (b) immutable-or-versioned code (upgrade path governed by the domain's own governance, §10.9 — protocol upgrades are separate), (c) a state namespace (a subtree of the global state, §7), (d) a capability manifest, (e) a resource budget policy (per-tx ceilings + per-block domain ceiling, §4.5), (f) a status: `active`, `quarantined`, `paused` (by domain governance or by protocol safety halt, §4.7).
- [Proposed MARWANTA] Domain deployment is permissionless in design intent (anyone can deploy a domain by paying deployment + storage costs), but deployment does **not** grant the domain any other domain's capabilities. Capability grants are explicit, revocable, and recorded on-chain so auditors can see who can call whom. Domain-creation cost and identity rules must address ceiling evasion by domain splitting (§4.10, scenario 6, and §20); if splitting is free, per-domain ceilings are meaningless.

### 4.3 Capability manifest (the enforcement mechanism)

A manifest declares, in machine-checkable form [Proposed MARWANTA]:

1. **State capabilities:** which state keys / key ranges the domain may read, write, or create. Wildcard write access to the global namespace is forbidden; a domain that needs shared state must name it.
2. **Call capabilities:** which other domains it may invoke, through which entry points, and with what argument-size limits. No capability = no call, even if the target domain is willing. Note: "invoke" in v0.2 means *declare an intent for settlement* (§6), never a synchronous direct write to another domain.
3. **Resource ceilings:** maximum compute, storage writes, and cross-domain messages per transaction and per block (see §4.5).
4. **Proof tier:** whether the domain's settlements require Tier-2 proof generation in addition to Tier-1 receipts (Tier-2 is supplementary, §5 — a domain cannot opt out of replay, and cannot opt into "proof instead of replay").
5. **Upgrade authority:** who may upgrade the domain's code or manifest, and under what delay / timelock (so users are not rug-pulled by a silent upgrade — timelock length is [Research Required]).

- [Proposed MARWANTA] The runtime enforces the manifest at execution time, not at deployment time alone: a domain whose code *attempts* an unmanifested access traps and aborts. Static analysis at deployment is a developer aid, not the security boundary, because WASM code can construct accesses dynamically.
- [Research Required] Manifest expressiveness vs. auditability: a manifest language that is too expressive becomes unauditable; one that is too narrow blocks legitimate composability. Phase 2 must prototype the manifest language on paper (not code) against at least five realistic application patterns and show the failure modes.

### 4.4 Scheduling: deterministic parallelism inside and across domains

- **[Prior Art] Solana Sealevel:** transactions declare read/write accounts; non-conflicting txs run in parallel, conflicting txs run sequentially. **[Prior Art] Aptos Block-STM:** optimistic parallel execution with post-hoc validation and re-execution of conflicting txs, giving serial-equivalence without declarations.
- **[Proposed MARWANTA] v0.2 scheduling rule:** (a) Transactions in *different* domains with no declared cross-domain dependency run in parallel. (b) Within a domain, transactions are scheduled by declared read/write sets where available (Sealevel-style), falling back to sequential execution within the domain when declarations are incomplete or conflicts are detected. (c) Cross-domain transactions are **not** parallelised across their domains in the prepare phase's *commit* step — they are coordinated by settlement (§6). This is deliberately conservative: parallelism is claimed only where conflict-freedom is structurally guaranteed, not optimistically assumed for cross-domain work.
- **[Research Required]** Whether Block-STM-style optimistic execution *within* a domain beats declared-set scheduling for MARWANTA's expected contention profile is a Phase 3 simulation question. It is not adopted in v0.2, because optimistic re-execution inside a domain interacts with the domain's resource budget in ways that need measurement (re-executed work must be charged fairly or it becomes a free-attack vector).

### 4.5 Resource metering and congestion isolation (execution layer only — see §20 for global limits)

- [Proposed MARWANTA] Three independent resource dimensions, metered separately — compute, storage, bandwidth — following the founder's requirement that they not be conflated into a single "gas" number that hides which resource is scarce:
  - **Compute:** deterministic instruction/step metering in the WASM runtime (fuel-style metering [Prior Art: Wasmtime fuel, NEAR gas metering]).
  - **Storage:** per-byte write + per-byte state-growth charge, plus a state-rent / storage-deposit concept for long-lived state (exact rent model is a Phase 2 tokenomics decision, §11 — the principle is that state growth must have an ongoing or deposit cost, or the chain subsidises infinite bloat).
  - **Bandwidth:** per-byte transaction and cross-domain message charge, counted against the sending domain's budget.
- [Proposed MARWANTA] **Per-domain per-block ceiling:** each domain has a maximum share of a block's compute/storage/bandwidth. When a domain hits its ceiling, its remaining transactions wait for a later block — they do not borrow another domain's share, and they do not raise fees for other domains *at the execution layer*. This is the congestion-isolation mechanism *for execution*: a viral domain congests itself, not other domains' execution.
- [Untested Hypothesis] Per-domain ceilings will prevent the "one hot app DoSes the chain" failure mode that shared fee markets suffer *at the execution layer*. The hypothesis is testable in Phase 3 by flooding one domain and measuring latency/fee impact on unrelated domains (see §14, workload W5). If the test shows leakage (e.g. via shared mempool, shared consensus, or shared state-tree updates), the ceiling design must be revised — the claim must not survive a failed test. §20 explains why ceilings alone cannot prevent leakage at the shared layers.
- [Proposed MARWANTA] **Predictable costs:** a transaction's fee ceiling is computed from its declared budget before execution; the user never pays more than the ceiling, and pays only for resources actually consumed (plus the abort fee rule in §3.4). Dynamic per-domain congestion pricing (a multiplier when a domain is near its ceiling) is [Proposed MARWANTA] as an *optional* Phase 2 mechanism, not a v0.2 requirement — predictable base pricing is the v0.2 promise.

### 4.6 Deterministic execution

- [Established] All honest validators must produce the identical state root from the identical ordered log, or consensus on state is impossible.
- [Proposed MARWANTA] Determinism rules for the WASM runtime: fixed instruction set (a pinned WASM version + pinned host-function set), no wall-clock, no unseeded randomness (randomness only from a committed, finalised-header-derived seed, and only where the protocol explicitly allows it), no floating point in consensus-critical paths (the safer v0.2 rule is **no float in consensus paths**), no host I/O, no unordered iteration over host-provided maps, and pinned versions of every host function. Runtime upgrades that change determinism require a coordinated protocol upgrade with a replay test (§10.9).
- [Prior Art] WASM runtimes used in blockchains (Wasmtime, Wasmer, Wasmi) differ in metering and compilation trade-offs; NEAR's migration from a custom VM to Wasmtime showed metering cost is a first-order design issue, not an afterthought. [Research Required] Phase 2 must evaluate Wasmtime vs. Wasmi (interpreter, easier deterministic metering) vs. a custom metering layer, on the criteria: determinism, metering accuracy, compilation latency, adversarial-input robustness, and auditability — and must not pick by popularity.

### 4.7 Fault containment and quarantine (execution layer)

| Failure | Containment in v0.2 | What it does NOT do |
|---|---|---|
| Domain code traps / panics | Intent aborts; domain state unchanged for that tx; validator continues | Does not fix the bug; repeated traps are a domain-quality signal, not a protocol fault |
| Domain out-of-budget (compute/storage/bandwidth) | Intent aborts at budget exhaustion; fee charged for work done | Does not raise the domain's budget automatically; a domain that is always out-of-budget is misconfigured, not attacked |
| Domain logic revert (e.g. insufficient balance, failed invariant) | Domain-local revert; no state change from that tx | Does not revert other domains' already-finalised txs |
| Malicious domain attempts unmanifested access | Runtime trap + abort; attempt recorded in receipt for audit | Does not automatically ban the domain — banning is a governance/safety decision (§10) |
| Domain floods network with valid-but-useless txs | Per-domain block ceiling + fees contain it to its own share *at execution* | Does not stop the domain from wasting its own users' fees, nor from consuming shared mempool/gossip/state-root capacity (§4.9, §20) |
| Domain repeatedly fails cross-domain prepares | Settlement aborts; domain may be flagged; repeated failure triggers a protocol-level review signal | Does not automatically quarantine without a defined, appealable process — auto-quarantine without due process is itself a censorship vector |
| Validator disagrees on a domain's execution result | Deterministic replay + state-root comparison exposes the disagreement; consensus on the *ordered log* is unaffected; the disagreeing validator's state root is provably wrong against the quorum | Does not halt the chain; the minority root is ignored, the validator is investigated/slashed only if the disagreement is attributable to a protocol violation, not a benign version skew (version skew is handled by coordinated upgrades, §10.9) |

- [Proposed MARWANTA] **Quarantine protocol (v0.2, to be formalised in Phase 2):** a domain enters `quarantined` status only via (a) its own governance pause, or (b) a protocol safety halt triggered by a defined condition (e.g. proof of state-corruption attempt, or a supermajority validator signal that the domain's code violates a protocol invariant), with a public reason, a time bound, and a defined un-quarantine path. Quarantined domains cannot initiate new cross-domain settlements, but existing user funds/state in the domain must remain withdrawable through a defined exit path — quarantine must never become confiscation. [Research Required] The exact trigger, quorum, and exit mechanics are the highest-risk governance design in this spec (§16).

### 4.8 Developer experience rule

- [Proposed MARWANTA] A developer must be able to build a domain without understanding consensus internals: they write WASM-compilable code (Rust-first in v0.2 intent, other languages via WASM as the runtime matures), declare a manifest, test locally against a deterministic simulator, and deploy. If building a MARWANTA domain requires reading the consensus spec, the developer experience has failed — that failure is measurable in Phase 6 (time-to-first-deployment for an external developer with no founder contact, §12).

### 4.9 Fault-isolation containment table — NEW in v0.2 (founder issue 2)

**How to read this table (NEW in v0.4 — scope clarified):** CONTAINED = the failure does not affect other domains' execution, fees, or finality beyond the stated bound, WITHIN THE SCOPE STATED IN THAT ROW. DEGRADED = other domains still progress, but with measurably worse latency, fees, or throughput. CHAIN-WIDE = the failure can halt, delay, or corrupt the whole chain's progress, or raise costs for all domains. "Mechanism" is the mitigation; "Residual" is what remains after it. No row claims CONTAINED for a shared layer's finality, latency, or throughput: the Domain execution row is CONTAINED at execution only; the Settlement coordinator row's CONTAINED is for unrelated inputs' lock non-interference only, not for the settlement log; the Proof generation row's CONTAINED is for finality only (light-client fast verification still degrades); the RPC/indexer row's CONTAINED is for access via independent operators only, not for chain progress. No numeric degradation bound is claimed in this table: every numeric bound is UNDECIDED until §20.5 parameters are measured in Phase 3.

| Layer | Failure example | Classification | Mechanism in v0.2 | Residual risk |
|---|---|---|---|---|
| Domain execution (WASM sandbox) | Domain code traps, loops to budget, reverts, writes outside manifest | **CONTAINED** | Sandbox + manifest enforcement + per-intent budget (§4.3, §4.5); abort is domain-local | A runtime/sandbox escape bug is CHAIN-WIDE by definition (§10.2); sandbox is therefore a primary audit target, not a guarantee |
| Resource ceilings (execution) | One domain floods with valid txs within its own budget | **CONTAINED at execution; DEGRADED at shared layers** | Per-domain per-block ceilings (§4.5); excess waits, does not borrow | Ceilings bound execution share, not mempool, gossip, root, or disk share (§20) |
| Consensus (ordering + finality) | Byzantine leader delays/omits; 1/3 slow validators; partition | **CHAIN-WIDE** (by design) | Rotation, view-change, finality-over-availability (§2) | No domain-level isolation is possible here: one consensus serves all domains. A halted consensus halts every domain. This is the structural price of shared security. |
| Mempool / gossip | One domain floods mempool with valid, fee-paying txs | **DEGRADED, can become CHAIN-WIDE under saturation** | Per-domain mempool queues + per-domain caps + global mempool cap + fee-ordered eviction (§8, §20) | Queues are in shared validator memory and shared gossip bandwidth. Saturation still raises propagation latency for all domains; a flood that fills the global cap evicts or delays unrelated txs. See §4.10 scenario 1. |
| Networking (P2P, block propagation) | Gossip amplification: large txs/blocks from one domain; eclipse of a validator | **DEGRADED to CHAIN-WIDE** | Per-peer rate limits, size limits, diverse peers (§8); block-size cap (§20) | Block propagation is global: a large block from one domain delays every validator's next vote. Eclipse of enough validators can degrade quorum liveness chain-wide. See §4.10 scenario 5. |
| Global state-root computation | One domain writes many keys / deep trie paths in one block | **DEGRADED, with a CHAIN-WIDE tail** | Per-domain root caching + incremental root updates + per-domain write ceiling (§7, §20) | The global root must still be recomputed/verified by every validator for every block. Root cost is O(domain roots + changed subtrees), not O(one domain) — but a pathological write pattern can still inflate every validator's per-block CPU. See §4.10 scenario 2. |
| Storage / disk (WAL, state DB, IOPS) | One domain bloats state or writes at high IOPS | **DEGRADED** | Per-domain storage ceiling + rent/deposit + write batching + global write scheduler (§7, §20) | The WAL and state DB are shared. Disk IOPS queueing is shared: one domain's write burst raises fsync/write latency for all domains' commits in the same block window. |
| Settlement coordinator (log-derived state machine) | One domain never prepares, holds locks, or spams settlement intents | **DEGRADED for contended inputs; CONTAINED for unrelated inputs** | All-or-none lock acquisition, no hold-and-wait, prepare deadline, epoch abort, per-domain lock budget (§6) | Contended inputs are still blocked for the lock duration (§6.7 bound). Unrelated domains progress, but settlement throughput for the contended key is zero for the lock window. See §4.10 scenario 4. |
| Proof generation (Tier-2, supplementary) | Prover fails, is slow, or censors a batch | **CONTAINED** (by the §5.1 rule) | Tier-2 is never on the finality path; missing/invalid proof degrades light-client fast verification only | If any future design made Tier-2 load-bearing, this row would become CHAIN-WIDE. v0.2 forbids that change without a new founder approval. Prover centralisation still matters for light clients (§5, §21). |
| RPC / indexer | One domain's queries flood an RPC/indexer | **CONTAINED if operators are independent; DEGRADED if a single RPC serves all** | Multiple independent RPC/indexer operators, rate limits, verifiable responses (§12) | RPC/indexer are not consensus. A single popular RPC going down degrades user access, not chain finality. Users who trust one RPC without verifying headers inherit that RPC's failure. |

**Summary sentence the founder asked for, stated plainly (NEW in v0.4):** [Proposed MARWANTA] WASM sandboxing + resource ceilings isolate *execution faults and execution share*. They do **not** isolate consensus, block propagation, global root computation, shared disk, or the settlement log. Those layers are shared by construction in a single-chain design, and their failure modes are chain-wide or degraded, mitigated by caps and scheduling (§20) but never eliminated. A design that promised full isolation of shared layers on one chain would be false; the honest claim is *bounded degradation, UNMEASURED in v0.4*, to be measured in Phase 3 against §21 using the §20.5 parameters. No numeric degradation bound, and no isolation guarantee beyond the execution layer, is claimed in v0.4.

### 4.10 Adversarial congestion scenarios — NEW in v0.2 (founder issue 2; at least 5 required, 6 given)

Each scenario states: attacker capability, mechanism of harm, v0.2 mitigation, and residual risk. All scenarios assume the attacker pays fees and follows the transaction format (valid-but-hostile traffic is the hard case; invalid traffic is already rejected at pre-check).

**Scenario A1 — Mempool flood from one domain.** Attacker domain submits fee-paying, valid txs at maximum rate, filling per-domain and global mempool queues. *Harm:* unrelated txs are delayed or evicted; gossip bandwidth is consumed by one domain. *Mitigation:* per-domain mempool queue + cap, global cap, fee-ordered eviction within a domain's queue first, per-peer gossip rate limits (§8, §20). *Residual:* under sustained flood at the global cap, unrelated low-fee txs still wait; latency for unrelated domains rises (DEGRADED). The mitigation bounds the damage, it does not make flood traffic free to ignore — validators still pay memory/bandwidth to receive and evict it.

**Scenario A2 — State bloat.** Attacker domain writes many new keys (or deep trie paths) per block, inflating state size, root-computation cost, and future read cost. *Harm:* every validator's per-block CPU and disk grow; future sync cost grows for everyone. *Mitigation:* per-domain storage ceiling per block, storage deposit/rent (§4.5, §7), write-cost calibrated to trie depth (§20), pruning (§7.4). *Residual:* bloat already written is permanent until rent/pruning removes it; root cost for a block containing a bloat burst is still paid by all validators in that block. Rent that is too low does not deter bloat; rent that is too high kills legitimate long-lived apps (§11).

**Scenario A3 — Receipt / proof spam.** Attacker domain generates many tiny executions, each producing a receipt, and/or requests Tier-2 proofs for many small batches. *Harm:* receipts root grows, block headers/bodies bloat, prover queue saturates, light-client verification cost rises. *Mitigation:* receipts are hash-chained and root-committed, not individually gossiped as separate messages; Tier-2 proofs are batched, not per-tx (§5.6), with a minimum batch size and prover queue caps; receipt spam is charged per execution like any other work. *Residual:* receipt data still occupies block space and validator disk; prover spam degrades Tier-2 availability for legitimate batches (contained, because Tier-2 is supplementary — §5.1 — but light clients lose fast verification during the spam window).

**Scenario A4 — Cross-domain lock contention.** Attacker domain repeatedly initiates settlements locking a popular input (e.g. a shared liquidity key), then lets them abort at the deadline, or many legitimate settlements contend for the same key. *Harm:* legitimate settlements for that key abort or wait; lock window blocks the key's other users. *Mitigation:* all-or-none lock acquisition (no partial holds), canonical lock order, prepare deadline, per-domain lock budget and escalating abort fees, epoch abort (§6, §6.8). *Residual:* the contended key itself is still unavailable during each lock window; the mitigation bounds the window and prices it, it does not make contention disappear. Unrelated keys and domains are unaffected (CONTAINED for them).

**Scenario A5 — Gossip amplification.** Attacker uses large transactions, many peers, or repeated re-gossip to amplify bandwidth: one byte submitted becomes many bytes propagated. *Harm:* validator bandwidth and CPU for deduplication rise; block propagation slows for all domains. *Mitigation:* tx size limits, gossip deduplication, per-peer rate limits and disconnect on flood, block-size cap, hash-referenced payload dissemination where possible (§8, §20). *Residual:* amplification cannot be reduced to 1:1 in a gossip network; the bound is a multiplier cap (measured in Phase 3), not elimination. A validator with limited bandwidth still degrades first.

**Scenario A6 — Domain-splitting evasion.** Attacker splits one application into many domains to evade per-domain ceilings, lock budgets, and mempool quotas. *Harm:* per-domain caps become meaningless; the attacker regains a global share. *Mitigation:* domain-creation cost (deployment + storage deposit), per-creator / per-account domain-creation rate limit, and a global scheduler (§20) that caps *aggregate* share across domains controlled by the same creator where attribution is possible — plus the global block cap, which no number of domains can exceed. *Residual:* attribution of "same creator" across Sybil accounts is imperfect; the ultimate backstop is the global cap and the global scheduler, not per-domain caps. If domain creation is cheap, the per-domain isolation claim must be narrowed further in v0.5 (v0.4 already narrows it to execution-only, §4.1).

---

## 5. Proof-carrying transaction design — REWRITTEN in v0.2 (founder issue 1)

### 5.1 THE ONE SECURITY MODEL (canonical — every other section must be read under this rule)

[Proposed MARWANTA] **Rule P0 — Replay is the security base; receipts are audit evidence; Tier-2 proofs are supplementary only.**

1. **What a full validator MUST do before voting to finalise:** replay every transaction in the block deterministically (§2.2 precondition), verify the global and domain roots, verify settlement decisions against §6, verify receipts roots and manifest/budget enforcement, and hold the full block data (DA gate, §5.7). This is mandatory for every block, every domain, every transaction type, with no exception for Tier-2 batches, high-value settlements, or light-client batches.
2. **What a Tier-2 proof can do:** provide an *additional* check for light clients and external verifiers, and a fast pre-check for validators that does **not** replace (1). A validator may verify a Tier-2 proof early to detect a bad block sooner, but it must still replay before voting.
3. **What a Tier-2 proof can NEVER do:** substitute for validator execution for finality; override a replay disagreement; finalise a block whose data is unavailable; or make a block final on its own. Any v0.1 language suggesting otherwise — in §§1.3, 5.1, 5.7, and 9.1, and in the §1 diagram — is withdrawn by this section and by the rewritten diagram in §1.1. If any other passage in v0.4 appears to contradict P0, P0 governs and the passage must be corrected in v0.5.
4. **Soundness assumptions, stated in order of reliance:** finality relies on (a) BFT quorum honesty (< 1/3 Byzantine) and (b) deterministic replay correctness — it does **not** rely on proof-system soundness. Light-client fast verification that uses a Tier-2 proof additionally relies on (c) proof-system soundness under its stated assumptions (hash-based for STARK-first direction, §5.3). A break in (c) therefore degrades light-client verification only; it cannot rewrite finalised state. A break in (a) or in replay determinism is a critical protocol failure (§10).
5. **Why this rule, and what it costs:** [Proposed MARWANTA] The rule is chosen because it is the only rule under which a proof-system bug, a prover failure, or prover centralisation cannot become a finality bug. Its cost is explicit and accepted: every validator pays full replay cost for every transaction, so MARWANTA's validator hardware bar is set by replay cost, not by proof-verification cost (§20). A design that saved replay cost by trusting proofs would be cheaper and more centralised — v0.2 rejects that trade for the base layer, and says so plainly, rather than claiming both cheap validation and full security.

### 5.2 The three mechanisms, distinguished (corrected table)

| Mechanism | What it proves | Who verifies, at what cost | v0.2 role |
|---|---|---|---|
| **Deterministic replay** | [Established] That re-running the ordered log yields the claimed state root | Every full validator, at full execution cost | **Primary and mandatory security mechanism.** Not optional, not replaced by proofs, not waived for Tier-2 batches. |
| **Execution receipt** | [Proposed MARWANTA] That a specific execution *was claimed* with specific inputs, read/write sets, resource use, and a state-diff commitment, signed by the executing validator(s) | Any auditor, light client, or indexer, at hash/signature-verification cost | **Always produced.** Receipts make failures auditable and cross-domain prepares checkable without re-executing everything *for a query* — but a receipt alone does **not** prove correctness, and a receipt never authorises finality. A Byzantine validator can sign a false receipt; it is trustworthy only when combined with quorum certification + replay availability. |
| **Validity proof (STARK/SNARK, Tier-2)** | [Established] That a computation was performed correctly, without re-executing it | Verifier, at proof-verification cost (small relative to execution, but prover cost is large) | **Tiered, selective, supplementary.** Only where the benefit exceeds prover cost (see §5.4). Never assumed free, never required for every transaction, never sufficient for finality. |

Conflating these three — e.g. calling a receipt a "proof", or calling a validity proof a substitute for replay — would be a security misrepresentation. This document does not do that, and §5.1 is the arbiter if any passage is ambiguous.

### 5.3 Execution receipts (Tier 1 — always)

- [Proposed MARWANTA] Every executed transaction produces a receipt containing: transaction hash, settlement ID (if any), domain ID, entry point, declared vs. actual read/write sets, resource consumption per dimension (§4.5), outcome code, state-diff commitment (hash of the domain's state changes), and the pre/post domain-root for that transaction's effect. Receipts are hash-chained per domain and per block, and the block header commits to a receipts root (§7).
- [Proposed MARWANTA] Receipts enable: (a) auditors to detect a domain whose actual access diverges from its manifest, (b) settlement prepares to be checked, for audit purposes, from receipts and finalised log entries without the auditor itself re-executing — which is NOT an independent correctness proof: the auditor still trusts the validator quorum's replay (see §5.6A, Mode A), (c) users to prove "my transaction executed with this outcome" to a third party, and (d) incident response to reconstruct what happened (§10.10). They do not enable a light client to trust a state transition without either replay or a validity proof *plus* quorum trust — that limitation must be stated in all developer documentation.

### 5.4 Validity proofs (Tier 2 — selective) and the STARK vs. SNARK evaluation

**Evaluation summary (from prior-art research, to be replaced by primary review in Phase 1):**

| Dimension | SNARK family | STARK family |
|---|---|---|
| Proof size | [Prior Art] Very small (hundreds of bytes in typical constructions) — cheap to post/verify on-chain | [Prior Art] Larger (tens to ~hundreds of KB in typical constructions) — expensive per proof if posted naively |
| Verification cost | [Prior Art] Lowest on-chain | [Prior Art] Higher per proof, but amortisable over large batches |
| Trusted setup | [Prior Art] Often required (per-circuit or universal); a compromised setup can enable false proofs | [Prior Art] Transparent — no trusted setup; public randomness |
| Post-quantum posture | [Prior Art] Generally not post-quantum for common curve-based constructions | [Prior Art] Hash-based, generally considered post-quantum-leaning |
| Prover cost / scalability | [Prior Art] Moderate; circuit design constrains general computation | [Prior Art] Scales well to very large traces; prover cost still substantial |
| Aggregation | [Prior Art] Recursive SNARKs exist | [Prior Art] Recursive STARKs natural; Starknet's SHARP shows shared-prover aggregation spreading verification cost across many programs |

- **[Proposed MARWANTA] v0.2 direction (not a locked choice):** STARK-first research direction for Tier-2 proofs, because transparency (no trusted-setup ceremony to secure and audit) and hash-based assumptions fit a new Layer-1 that cannot afford a setup-trust controversy at genesis, and because MARWANTA's Tier-2 use is batched settlement (where STARK's per-proof size is amortised). SNARK wrapping of a STARK (as in SHARP-style recursion [Prior Art]) is a *candidate* optimisation if on-chain verification size becomes the binding cost — but the wrapped proof then inherits the wrapping layer's assumptions, which must be stated, not hidden.
- **[Research Required]** The STARK-first direction is **not** a commitment until Phase 2 answers: (a) Can MARWANTA's WASM execution trace be arithmetised efficiently, or does proving require a separate provable VM (e.g. a Cairo-style VM) that diverges from the execution VM? A proving VM that differs from the execution VM creates a two-implementation correctness problem. (b) What are measured prover time, memory, and proof size for MARWANTA's actual workloads (not for a toy circuit)? (c) Who runs provers, and what happens if provers centralise? If any answer is bad, Tier 2 must be narrowed or deferred — Tier 1 + replay remains the security base either way, and finality is unaffected by that deferral (that is precisely the point of §5.1).

### 5.5 Where expensive ZK proofs are NOT worth it (explicit non-use cases) + Tier-2 case table

- [Proposed MARWANTA] **Simple single-domain transfers and single-domain state updates: NO validity proof.** Deterministic replay by validators is cheaper, simpler, and already sufficient. Adding a ZK proof here would add prover latency, prover centralisation risk, and circuit risk for zero security gain over replay.
- [Proposed MARWANTA] **High-frequency, low-value, intra-domain operations (e.g. gaming moves, micro-interactions): NO per-transaction validity proof.** The prover cost would exceed the transaction value and destroy latency. Receipts + replay are the mechanism; validity proofs, if used at all, are batched over many operations.
- [Proposed MARWANTA] **Any case where data availability is not also solved: NO validity proof as a substitute for data availability.** A proof that a state transition was correct is useless if the data needed to reconstruct or challenge that state is withheld. Proof + availability are a pair (§7.6).
- [Proposed MARWANTA] **Privacy as a side effect: NO claim.** MARWANTA's Tier-2 proofs in v0.2 are *validity* proofs (correctness), not *privacy* proofs (hiding inputs). If a future version adds privacy, it needs a separate design and threat model. Marketing Tier-2 as "private by ZK" would be false.

**Tier-2 case table — what happens, who decides, and what finality does (canonical, §5.1):**

| Tier-2 case | Validator action | Light-client / external-verifier action | Effect on finality |
|---|---|---|---|
| Proof valid | Verify proof as an additional check, then still replay before voting (§5.1) | May use proof + header QC as a fast check, subject to proof-soundness trust (§5.6) | None beyond replay+QC: finality comes from replay+QC, not from the proof |
| Proof invalid | Ignore proof for finality; replay decides. Record INVALID proof status in the block's proof-status field; flag prover for investigation (§10) | Must NOT trust the batch on the basis of the proof; fall back to header + inclusion proof (quorum trust only) or wait for a valid proof / full-node verification | **None.** An invalid proof never invalidates a correctly replayed block, and never finalises a wrong one. |
| Proof missing (batch has no Tier-2 proof) | Replay as normal; record MISSING status. No delay, no penalty to the block. | Fast verification unavailable for that batch; fall back to header + inclusion proof | **None.** Tier-2 is optional per batch. |
| Prover unavailable / slow | Replay as normal; Tier-2 queue status recorded as UNAVAILABLE. Prover liveness is not consensus liveness. | Fast verification degraded for the affected batches | **None.** |
| Proof valid BUT replay disagrees with claimed root | **Replay wins.** Validator rejects the block, does not vote, gossips replay evidence. Proof is treated as faulty (soundness bug, arithmetisation mismatch, or prover error) and triggers investigation. | Must not use the proof to override replay evidence; a light client that trusted the proof alone would be wrong — this is why §5.6 states light-client proof reliance is weaker than full validation | **Block is not finalised on proof.** If a quorum nevertheless finalises it, that is a Byzantine-quorum failure (§10), not a proof-based finality. |
| Replay agrees, proof valid, but underlying data withheld | Validator does **not** vote (DA gate, §5.7). Proof does not cure withholding. | Cannot reconstruct state; must not treat the batch as verified | **No finality** until data is available to a quorum of validators. |

### 5.6 Where validity proofs DO earn their cost (Tier-2 use cases, supplementary only)

1. **Cross-domain settlement batches:** [Proposed MARWANTA] A single validity proof over a batch of cross-domain settlements lets a light client or an external verifier perform a supplementary fast check of the *settlement decision* (all-or-nothing, correct diff application) subject to proof soundness and quorum trust — it does NOT independently prove private logic correctness, and it does not replace replay for finality. See §5.6A for the exact Mode A / Mode B statements. This is the supplementary proof use, because cross-domain correctness is exactly where replay-by-everyone is most expensive *for a light client* — not for a validator, which replays anyway (§5.1). This is the flagship proof use, because cross-domain correctness is exactly where replay-by-everyone is most expensive *for a light client* — not for a validator, which replays anyway (§5.1).
2. **Light-client fast sync:** [Proposed MARWANTA] A chain of validity proofs (or a recursive proof over many blocks) could let a new light client verify a long history without replaying it. This is [Research Required] — it depends on recursive proving performance and on availability of the underlying data, and it is not a v0.2 promise.
3. **External settlement / bridge verification:** [Proposed MARWANTA] A validity proof presented to another chain or to an off-chain verifier is stronger than a multisig attestation. But bridges remain high-risk (§10.8) and a proof does not fix a bridge's custody or finality-mismatch bugs — it only fixes the "was this computation correct?" subproblem.

### 5.6A Verification modes — what is actually proved, and what is not (NEW in v0.3, from the 2026-11-01 clarification register)

[Proposed MARWANTA] The claim that a third party can verify private agent logic without replaying
it is WITHDRAWN. Finalisation, correctness, and privacy are three different things, and this
subsection keeps them apart.

**Mode A — v0.3 as specified (validator replay only). This is the ONLY mode available in v0.3.**

- Statement actually proved to an auditor: "A quorum of validators, under the §2 finality rule and
  assuming fewer than one-third Byzantine stake, finalised a block containing this settlement
  decide entry, these receipts, and these domain roots, and the block data needed to replay it
  was available to full validators at finalisation time (DA gate)."
- What the auditor verifies directly: header quorum certificate, transaction inclusion, receipts
  root against the receipts presented, domain roots against the block body, settlement decide
  entry in the finalised log, and manifest references as recorded in the log.
- What remains trusted, not verified by the auditor: quorum honesty; deterministic replay
  correctness; that the honest validators in the quorum actually replayed (the auditor does not
  re-execute); data availability to full validators at the time (the auditor may not hold the
  full data itself); and, crucially, the truth of any off-chain input, including a verifier
  agent's attestation that delivery or quality occurred. A validity-style proof of on-chain
  execution does not prove an off-chain fact.
- What is NOT proved: that an agent's private strategy was correct, optimal, honest, or the
  strategy the agent claimed to follow; that private inputs were correct; or that the computation
  is correct independently of the validator quorum. An auditor who does not replay does not
  independently check correctness; the auditor trusts that the quorum replayed correctly. That
  trust cannot be transferred to a non-replaying auditor by calling a receipt a "proof." A
  receipt is evidence of what was claimed (§5.2), not a validity proof.

**Mode B — future Tier-2 mode (NOT available in v0.3, NOT claimed).**

- Statement that COULD be proved, if and only if a proof construction is specified and
  implemented: "There exist private inputs w such that circuit C, on public inputs x and w,
  produces output y, and y matches the settlement diff committed in the block."
- What would remain trusted even in Mode B: proof-system soundness under its stated assumptions;
  correctness of circuit C as an encoding of the intended computation (a correct proof of the
  wrong circuit proves nothing useful); binding of public inputs x to the actual settlement;
  data availability for the data needed to use the proof; and, again, the truth of off-chain
  inputs and attestations. A zero-knowledge proof hides inputs from the verifier; it does not
  make those inputs true.
- What Mode B would still NOT prove: off-chain delivery, off-chain quality, agent intent, or
  any fact outside the circuit's inputs.

**Private execution — plainly stated.**

- Private from a non-validator auditor: partially, by accident of receipts, not by design.
  Receipts contain read/write sets, resource use, and diff commitments, which may leak
  information. Receipts are not a privacy mechanism in v0.3 (§5.5: Tier-2 in v0.3 is validity,
  not privacy).
- Private from full validators: NO. Rule P0 requires every full validator to replay every
  transaction before voting. A validator cannot replay what it cannot see. Therefore agent logic
  and data executed on-chain in a domain are visible to full validators in v0.3. Calling that
  "private execution" would be false.
- Private on-chain execution with validator replay conflicts unless the proof system is
  redesigned so validators verify a proof INSTEAD of replaying. That redesign would change P0,
  change finality trust (finality would then rely on proof soundness), and require a separate
  founder approval. It is NOT in v0.3 and must not be smuggled into MAES as an assumed capability.
- Off-chain strategy versus on-chain execution: if an agent's strategy decision is made off-chain
  and only its settlement intent is executed on-chain, then on-chain verification covers the
  intent's execution, not the off-chain decision. MAES (§18.6) must state, per workload, which
  part is on-chain and which part is off-chain, and must not claim on-chain verification of the
  off-chain part.

### 5.7 Proof aggregation

- [Prior Art] Starknet's SHARP aggregates many programs' proofs recursively into one verification, socialising cost. [Proposed MARWANTA] MARWANTA adopts the *pattern* (batch + recurse) as a research direction, not a copied implementation: Tier-2 proofs are generated per settlement batch, then recursively aggregated per block and per epoch where the aggregation proof's verification cost is measurably lower than verifying each batch proof separately. Aggregation depth, recursion limits, and prover decentralisation are Phase 2/3 measurements. **Aggregation must never hide a failed batch proof inside a successful aggregate** — the aggregate must commit to each constituent proof's identity and status (VALID / INVALID / MISSING) so a failure is attributable, and an aggregate containing an INVALID constituent must itself verify as INVALID for that constituent's batch.

### 5.8 Deterministic replay as the fallback that must always work — and as the base (corrected)

- [Proposed MARWANTA] Replay is not merely a fallback in v0.2; it is the base (§5.1). If the proof system is ever found flawed, paused, or too expensive, the chain must still be verifiable by replay — and, under §5.1, it already is, because validators never stopped replaying. That means: full transaction data and full state-diff data must be available to validators (subject to pruning rules in §7.4 that preserve replayability for a defined window), and the execution VM must remain deterministic and independently re-implementable. A design where only provers can verify the chain is a centralisation design, and v0.2 rejects it.
- [Proposed MARWANTA] **Data-availability requirements before commit (canonical):** before a validator votes to finalise block B, it must hold, locally and hash-verified: (i) every transaction in B; (ii) every domain state-diff commitment and the data needed to recompute every domain root in B; (iii) every settlement decision and prepare record for settlements decided in B; (iv) the receipts data needed to recompute the receipts root. *To whom:* to every full validator that votes, and to any full node that wishes to verify B independently. *If it is not available:* the validator abstains, requests the data via gossip/sync, and if the proposer repeatedly withholds data, the view times out and the leader changes (§2.2). A block whose data is withheld from a quorum cannot finalise, by construction — withholding is a liveness attack on that block, not a safety break, provided validators obey the DA gate. A validator that votes without the data is in violation and its vote is not a valid finality vote under this spec, even if a quorum forms around it by other means — that formation would itself be evidence of quorum misbehaviour (§10).
- [Proposed MARWANTA] **Replay disagreement, canonical resolution:** the validator whose replay root differs from the proposed root rejects the block and does not vote. It gossips the conflicting root + the transaction(s) whose replay diverges, as evidence. Other validators replay independently; they do not defer to the first reporter, to a proof, or to the proposer. If a quorum of honest validators agrees with the proposed root, the disagreeing validator is wrong (version skew, hardware fault, or local corruption) and must fix its software; it is not slashed for a benign skew, but it is slashed if its disagreement is shown to be a deliberate incorrect vote (§11). If a quorum finalises a root that honest replay contradicts, the BFT safety assumption has failed (§10.1) — the correct response is halt/investigation (§10.7), not a proof-based override.

---

## 6. Shared settlement model — COMPLETE STATE MACHINE in v0.2 (founder issue 3)

### 6.1 Why settlement is a separate protocol step

- [Proposed MARWANTA] Domains do not write to each other's state. If they did, isolation would be fiction. Cross-domain work therefore needs a coordination step that is *not* just "domain A calls domain B and hopes": it must guarantee that either all domains' effects commit or none do, that a failure in one domain cannot leave another domain half-updated, and that the decision itself is finalised by consensus, not by one domain's say-so.
- [Proposed MARWANTA] **The coordinator is not a server, committee, or trusted party.** It is a deterministic state machine whose transitions are computed by every validator from the ordered log. Two validators given the same ordered log must compute the same settlement state, or replay (§5.1) fails and the block is rejected. Any design in which coordinator output depends on one validator's local state, wall-clock, or private input is invalid under this spec.

### 6.2 Settlement state machine — states, transitions, triggers (complete)

**Identifiers and parameters (symbolic — values are Phase 2 decisions, not v0.2 numbers):**

- `SID` — settlement ID, derived deterministically from (sender sequence, transaction hash, intent list hash). A SID is single-use: it can never be reused for a different settlement, and a re-proposal with the same SID is idempotent (see §6.5).
- `D` — prepare deadline, in FINALISED blocks from the settlement's finalised ORDERED block B_f. The deadline finalised block is B_f + D. D is NOT seconds, NOT wall-clock time, and NOT a count of proposed or gossiped blocks. Symbolic parameter; Phase 2 must set D by simulation (too short = spurious aborts under load; too long = lock-griefing window, §6.8) and must state it in finalised blocks.
- `E_f` — the next finalised epoch-transition block. No settlement survives a finalised epoch-transition block undecided (§6.6, §6.6A). An epoch does not end in wall-clock time; it ends when an epoch-transition block is finalised.
- `Locks(SID)` — the set of (domain, key) pairs declared as inputs by the settlement's intents, in canonical order (§6.3).
- `R` — maximum prepare attempts within D (symbolic; Phase 2 sets R, e.g. bounded retries, not unbounded polling).

**States (a settlement is always in exactly one state, derived from the finalised log):**

| State | Meaning | Locks held? | Diffs applied? |
|---|---|---|---|
| `CREATED` | Settlement ordered in a block, intents validated, dependency graph acyclic (§6.4). Not yet attempted. | No | No |
| `WAIT` | Prepare attempted, at least one lock unavailable, no locks acquired (all-or-none, §6.3). Settlement is queued for retry within D. | **No** | No |
| `PREPARED` | All locks acquired in one deterministic step; every participating domain produced a receipt + diff commitment in the ordered log. | **Yes, all** | No (diffs are commitments, not yet applied) |
| `DECIDED_COMMIT` | Transient, intra-block state only: decision entry computed, diffs applied in the same block (see §6.5). Never persists across blocks as a separate state. | Released as part of apply | **Yes, all, in the same block** |
| `DECIDED_ABORT` | Transient, intra-block state only: decision entry computed, no diffs applied, locks released in the same block. Never persists across blocks as a separate state. | Released | **No** |
| `COMMITTED` | Terminal. Decision finalised; all diffs applied; locks released; receipts final. | No | Yes |
| `ABORTED` | Terminal. Decision finalised; no diffs applied; locks released; refund/fee path executed (§6.4). | No | No |
| `EXPIRED` | Terminal sub-case of ABORTED: abort was caused by a finalised deadline block (B_f + D finalised blocks), a finalised epoch-transition block, or leader/validator failure exceeding the bound (§6.6). All abort triggers in this table are finalised-block events; wall-clock passage alone never triggers them (§6.6A). Recorded distinctly for griefing accounting (§6.8). | No | No |

There is deliberately **no** `PARTIALLY_PREPARED`, `DECIDED_BUT_UNAPPLIED`, or `RECOVERING` state that persists across blocks. Partial preparation is prevented by all-or-none acquisition (§6.3); decided-but-unapplied is prevented by decide+apply atomicity in one block (§6.5); recovery is replay of the log (§6.5), not a separate state.

**Transition table (every transition is triggered by a finalised log entry, not by wall-clock or by a coordinator message):**

| # | From → To | Trigger (log entry / event) | Guard (must hold, else transition does not occur) | Effect |
|---|---|---|---|---|
| T1 | (none) → `CREATED` | Transaction with settlement mode = atomic is ordered in finalised block B_f | Signature, nonce, manifest refs, fee ceiling, dependency graph acyclic (§6.4), SID unused | Settlement record created in finalised block B_f; deadline finalised block = B_f + D; attempt counter = 0 |
| T2 | `CREATED` → `PREPARED` | Prepare-attempt entry in a later ordered block, executing §6.3 | All locks in Locks(SID) free AND all domains' prepare checks pass (balances, invariants, manifest, budget) AND attempt ≤ R AND finalised block ≤ deadline finalised block | All locks acquired atomically in canonical order; receipts + diff commitments appended to log; state = PREPARED |
| T3 | `CREATED` → `WAIT` | Prepare-attempt entry where §6.3 fails on lock availability only (not on a domain logic failure) | At least one lock held by another settlement AND no domain logic failure AND finalised block ≤ deadline finalised block AND attempt ≤ R | **No locks acquired** (all-or-none); attempt counter += 1; settlement queued for retry in a later block |
| T4 | `WAIT` → `PREPARED` | Retry prepare-attempt entry | Same guard as T2 | Same effect as T2 |
| T5 | `WAIT` → `ABORTED` / `EXPIRED` | Finalised deadline entry (finalised block > B_f + D) OR attempt counter > R OR finalised epoch-transition block (§6.6) | Settlement still in WAIT at that finalised block | No locks to release (none held); refund/fee path (§6.4); terminal, recorded as EXPIRED if deadline/epoch caused it |
| T6 | `CREATED` → `ABORTED` | Prepare-attempt entry where a domain logic check fails (insufficient funds, invariant failure, manifest violation, budget exceeded) | Failure is deterministic from the ordered log (replayable, §5.1) | No locks acquired (attempt is atomic); refund/fee path; terminal |
| T7 | `PREPARED` → `COMMITTED` (via intra-block `DECIDED_COMMIT`) | Decide entry in an ordered block, computed deterministically from the log: all domains prepared AND no abort trigger AND finalised block ≤ deadline finalised block AND same epoch | All PREPARED conditions still hold at decide time (locks still held by this SID, no intervening abort) | All diffs applied, domain roots updated, locks released, all in the same block; terminal COMMITTED |
| T8 | `PREPARED` → `ABORTED` / `EXPIRED` (via intra-block `DECIDED_ABORT`) | Decide entry where any abort trigger holds: finalised deadline block passed, finalised epoch-transition block, leader/validator failure exceeding the §6.7 bound, or an explicit abort entry from a domain whose prepare is withdrawn only via the defined abort path (a domain cannot unilaterally withdraw a PREPARED settlement except through the log's abort entry) | Abort trigger is in the finalised log | No diffs applied; locks released in the same block; refund/fee path; terminal |
| T9 | Any non-terminal → `ABORTED` / `EXPIRED` (epoch) | Finalised epoch-transition block | Settlement not already COMMITTED at epoch boundary | Locks released (if any), refund/fee path, terminal. **No settlement is carried over an epoch.** |
| T10 | Any state → (crash/restart recovery) | Validator restarts and replays the finalised log from the last finalised header + snapshot (§7.3) | Replay reproduces the same log-derived state | Validator reconstructs exactly the settlement state above from the log. No settlement is "recovered" by asking a coordinator, a peer, or a prover — only by replay. A settlement that was PREPARED in the log before the crash is still PREPARED after replay; a settlement that was only gossiped, not ordered, is not a settlement at all and must be re-submitted by the sender with a new SID. |

**What is forbidden by this table (and why each prohibition matters):**

- No transition on wall-clock time. Deadlines are in blocks, not seconds, so every validator computes the same deadline from the same log. Wall-clock deadlines would make replay non-deterministic (§4.6).
- No transition on a single validator's message. Only finalised log entries move a settlement. A leader's private "I decided" message is not a decision.
- No partial lock holding. A settlement either holds all its locks or none. This is the deadlock-prevention mechanism (§6.3), not an optimisation.
- No re-proposal of a terminal settlement with the same SID. A new attempt must use a new SID, a new sequence, and new fees — otherwise an abort could be replayed as a commit (§6.5, idempotency).

### 6.3 Lock acquisition — ordering, deadlock prevention, granularity

- [Proposed MARWANTA] **Canonical order:** locks are acquired in strict lexicographic order of (domain_id, key_id), where key_id is the declared input key. Every validator executes acquisition in this order, in one deterministic step, for a given settlement. A settlement that declares its inputs out of order has them re-sorted by the protocol before acquisition; declaration order is not acquisition order.
- [Proposed MARWANTA] **All-or-none acquisition (no hold-and-wait):** the prepare-attempt step checks availability of *all* locks, and only if all are free does it acquire any. If any lock is unavailable, it acquires none and moves to WAIT (T3). Classical deadlock requires hold-and-wait (a settlement holding one lock while waiting for another). By eliminating hold-and-wait at acquisition, and by holding only disjoint lock sets after PREPARED (two PREPARED settlements cannot hold overlapping locks, because acquisition checks the global lock table in the same deterministic step), v0.2 eliminates the classic deadlock cycle *by construction* for the acquisition phase. This is a design argument, not a machine-checked proof (§6.7 states what remains to be proven).
- [Proposed MARWANTA] **Lock granularity:** lock at the declared input-key level, not whole-account or whole-domain level, unless the domain's manifest declares a coarser granularity for that key range. Finer granularity = more concurrency, more lock-table entries; coarser = fewer entries, more false contention. [Research Required] Phase 3 simulation with realistic cross-domain workloads must measure abort rates under key-level vs. account-level locking before the granularity is locked. A granularity that is too coarse will show up as spurious aborts in W4 (§14); a granularity that is too fine will show up as lock-table memory/CPU cost in §20.
- [Proposed MARWANTA] **Lock table:** a deterministic, in-memory, per-block structure derived from the ordered log (not a separate database that can diverge). Lock table size is bounded by the per-domain lock budget (§6.8) and the global lock cap (§20). A lock table that grows unboundedly is a memory-exhaustion vector (§4.10, scenario A2/A4).

### 6.4 Dependency management, conflict detection, refund/fee path

- [Proposed MARWANTA] Every cross-domain transaction declares a dependency graph: which intents depend on which other intents' outputs. The coordinator (log-derived state machine) validates the graph for cycles before prepare begins; a cyclic dependency is rejected at pre-check (T1 guard fails, settlement never CREATED), not discovered mid-settlement.
- [Proposed MARWANTA] Conflict detection is by declared input locks (§6.3): if two pending settlements lock overlapping inputs, the second waits (WAIT, no locks held) or aborts on a finalised deadline block, depending on priority. Priority rule in v0.2: **first-PREPARED-wins** — the settlement that first reaches PREPARED holds the locks; a later settlement that needs the same locks waits. There is no priority inversion by fee in v0.2 (a higher-fee settlement does not pre-empt a PREPARED settlement's locks), because pre-emption would break the atomicity bound and create a griefing vector (pay more to steal a lock). [Research Required] Whether fee-priority pre-emption with compensation could be safe is a Phase 2 question; it is not adopted here.
- [Proposed MARWANTA] **Refund/fee path on ABORT (all abort cases, T5/T6/T8/T9):** (a) no domain state changes from the aborted settlement are applied; (b) locked inputs are released in the same block as the abort decision (for PREPARED → ABORTED) or were never acquired (for WAIT/CREATED → ABORTED); (c) fees are charged only for resources actually consumed during prepare attempts (not for the full committed effect), plus the abort fee in §6.8 where applicable; (d) any escrowed value that was locked for the settlement is returned to its origin domain/account in the same block, not held by the coordinator; (e) the abort is recorded in the log with a reason code (logic failure / deadline / epoch / contention) so griefing accounting (§6.8) can attribute it. Refund execution is idempotent: replaying the abort entry twice (e.g. after a crash/restart replay) must not refund twice — idempotency is by SID + abort-entry hash, checked deterministically during replay.
- [Proposed MARWANTA] **On COMMIT:** all diffs apply, or the block is invalid. There is no "commit most domains and compensate the rest" path in v0.2 — compensation is an application-level pattern that domains may build *on top* of settlement, but it is not the protocol's atomicity mechanism. Conflating compensation with atomicity would hide partial failures.

### 6.5 Crash/restart recovery, re-proposal, idempotency

- [Proposed MARWANTA] **Recovery = replay, nothing else.** A validator that crashes and restarts reconstructs settlement state solely by replaying the finalised log from its last snapshot (§7.3) through the §6.2 transition table. It does not query a coordinator, a prover, or a peer for "the current settlement state" as a trusted source; a peer's settlement state is at most a hint to be verified by replay.
- [Proposed MARWANTA] **Unfinalised prepares are not settlements.** A prepare that was gossiped but not ordered in a finalised block has no state, holds no locks, and is invisible to recovery. The sender must re-submit (new SID, new sequence, new fees) if it still wants the settlement. This rule prevents a crash from resurrecting a settlement that never existed in the log.
- [Proposed MARWANTA] **Re-proposal:** a settlement that aborted (any reason) may be re-proposed by the sender as a *new* settlement with a new SID and a new sender sequence. The old SID is terminal and can never transition again. A re-proposal that reuses the old SID is rejected at pre-check as a replay (§3.4).
- [Proposed MARWANTA] **Idempotency of apply/abort:** the DECIDE+APPLY step and the ABORT refund step are each keyed by (SID, decide-entry hash). During replay, if the same decide entry is encountered twice (e.g. due to a restart mid-block), the second encounter is a no-op for state (roots, balances, locks already reflect the first application) but must still be recorded as a replay duplicate in validator logs for audit. Idempotency is checked by the state machine, not by trusting the proposer not to duplicate entries — a proposer that duplicates a decide entry in two different blocks is equivocating (§2.2) and the second block is invalid.

### 6.6 Validator/leader failure mid-settlement, epoch changes, conflicting settlements

| Event | Exact v0.2 behaviour |
|---|---|
| Leader fails during PREPARE (prepare not yet finalised) | Prepare entry is not in the finalised log; settlement remains CREATED/WAIT; next leader may include a new prepare-attempt entry. No locks held, no state changed. Delay only. |
| Leader fails after PREPARE finalised, before DECIDE | Settlement is PREPARED in the finalised log; locks held. Next leader must include a decide entry (COMMIT or ABORT) no later than the finalised deadline block (B_f + D finalised blocks); it cannot silently drop a PREPARED settlement. If no decide entry is finalised by that finalised block, T8 fires on that finalised deadline block and the settlement aborts. A wall-clock deadline passing without a finalised block does not fire T8 (§6.6A). |
| Validator (non-leader) fails / goes offline mid-settlement | No effect on settlement state, which is log-derived. The validator re-syncs by replay (§6.5) and rejoins. If enough validators fail that quorum is lost, liveness pauses (finality-over-availability, §2) and resumes on partition heal; PREPARED settlements remain PREPARED in the finalised log and are decided or aborted by deadline/epoch rules AFTER heal, in finalised-block terms — they are not lost, but they may abort on deadline after heal. D does not advance during the partition, so a long wall-clock heal does not by itself expire a settlement. That is a bounded-abort-after-recovery outcome, not a hang and not a termination guarantee during the partition (§6.6A, §6.7). |
| Epoch change while settlement is CREATED/WAIT/PREPARED | **All non-COMMITTED settlements abort in the finalised epoch-transition block (T9) — and only there.** A wall-clock epoch end without a finalised epoch-transition block aborts nothing (§6.6A). Locks released, refund path executed, reason code = epoch. No lock, prepare, or diff is carried into the next epoch. A sender that still wants the settlement must re-propose in the new epoch with a new SID. This rule is what bounds every settlement's lifetime by the epoch length, even if D is misconfigured. |
| Epoch change while settlement is COMMITTED | No effect: COMMITTED is terminal and its diffs are already in a finalised block. Epoch transition does not revert finalised commits (§2.2). |
| Two settlements compete for the same locked input | First-PREPARED-wins (§6.4). The loser waits (no locks held) until the winner commits/aborts or its own finalised deadline block / finalised epoch-transition block fires, then aborts if still blocked. Wall-clock deadline or epoch passage alone does not abort it (§6.6A). The loser cannot pre-empt, cannot split the winner's locks, and cannot force the winner to abort by fee bidding in v0.2. |
| Settlement A locks X, settlement B locks Y, then A wants Y and B wants X (classic cycle) | **Cannot occur under §6.3:** A cannot be PREPARED holding X while waiting for Y, because acquisition is all-or-none. A either holds X+Y (if both were free at its prepare step, in canonical order) or holds nothing and waits. There is therefore no hold-and-wait cycle to deadlock. What *can* occur is contention (both want X, one waits) — that is bounded by finalised deadline/epoch abort after recovery, not by deadlock (§6.7, §6.6A). |
| Settlement decision entry is duplicated or conflicting | Duplicate decide entries for the same SID in the same block are invalid (block rejected). Conflicting decide entries (one COMMIT, one ABORT for the same SID) in different blocks: the first finalised decide entry wins; the second is invalid on replay because the settlement is already terminal. A proposer that creates conflicting decide entries is equivocating (§2.2). |

### 6.6A Quorum-loss partition — the finalised-block rule (NEW in v0.3; canonical bullets C1–C4 NEW in v0.4)

**Canonical partition rule (NEW in v0.4 — identical wording is enforced in §2.5, §3.5, §6.6, §6.7, §14.4 and §21).** Where any of those sections appears to state a different rule, this list governs:
- **C1 — No transition during quorum loss.** During a quorum-loss partition, NO settlement transition is finalised (no creation, prepare, commit, abort, deadline abort, or epoch abort).
- **C2 — Wall-clock never aborts.** A wall-clock epoch end or a wall-clock timeout NEVER automatically aborts a settlement, and never expires a lock, by itself.
- **C3 — Abort only on a finalised-block event.** Abort occurs ONLY on a finalised-block event: a finalised deadline block (B_f + D finalised blocks) or a finalised epoch-transition block.
- **C4 — Termination bound only after recovery.** The termination bound applies ONLY after quorum recovery, in finalised-block terms plus finality lag (see §6.7). During a partition, termination is not bounded in wall-clock time.

[Proposed MARWANTA] This subsection corrects any reading of §6.2–§6.7 that implied a settlement
terminates, aborts, or expires during a partition. It does not.

- **Finalised block defined.** A finalised block H_f is a block that has obtained a quorum
  certificate under the §2 finality rule and whose state root has been replay-verified under
  Rule P0 (§5.1). A proposed block, a gossiped block, and a block seen by only some validators
  are NOT finalised blocks for any deadline, epoch, or termination purpose.
- **During a quorum-loss partition, no settlement transition can be finalised.** No T1 creation,
  no T2 prepare, no T7 commit, no T8 abort, no T5 deadline abort, and no T9 epoch abort can be
  finalised, because every transition is triggered ONLY by a finalised log entry (§6.2). Safety
  is preserved by freezing, not by aborting: CREATED, WAIT, and PREPARED settlements remain in
  their last finalised state, locks held by PREPARED settlements remain held in log terms, no
  diffs are applied, no refunds are executed, and no partial state is created.
- **Wall-clock time does not expire a settlement.** A PREPARED settlement can remain locked for
  longer, in wall-clock time, than any wall-clock equivalent of D, and an epoch boundary can pass
  in wall-clock time without an epoch abort occurring. Neither is a violation of D, because D has
  not elapsed in finalised-block terms. Any previous wording implying a wall-clock deadline
  guarantee is withdrawn by this subsection.
- **Single leader failure is not quorum loss.** If the next leader is honest and quorum remains,
  the chain keeps finalising, D keeps advancing in finalised blocks, and deadline/epoch aborts
  can still fire. Quorum loss is the case that stops D from advancing.
- **After quorum recovery.** Once the chain resumes finalising, the first finalised block at or
  after B_f + D triggers the deadline abort path, and the first finalised epoch-transition block
  triggers T9 for every still non-COMMITTED settlement. Termination is then bounded as in §6.7:
  no later than min(B_f + D, next E_f) in finalised blocks, plus finality lag for the deciding
  block. Recovery converts a frozen settlement into a terminated settlement; it does not convert
  an abort into a commit.
- **Finality lag is not yet an exact number.** It depends on the exact HotStuff-2 adaptation in
  §2 (two-chain finality in v0.3, exact view/round timing to be fixed in Phase 2) and must be
  stated in finalised blocks, not seconds, in v0.5 (v0.4 states only the minimum lag of one consecutive view, §2.2A). Until then, the bound in §6.7 is a bound in
  finalised blocks plus an unspecified finality lag, not a wall-clock latency promise.
- **If a partition never recovers,** K1-T and K1-C (§21) are BLOCKED / INCONCLUSIVE, not passed
  and not failed. Reporting them as passed during an ongoing partition would be false.

### 6.7 Safety invariants, hand analysis, and bounded liveness — with the proof gap stated (CORRECTED in v0.3: termination-after-recovery only, see §6.6A)

**Safety invariants (must hold in every finalised block; violation = critical protocol bug, §10.4):**

- **S1 Atomicity:** for any finalised settlement, either all domain diffs are applied (COMMITTED) or none are (ABORTED). No finalised state contains a partial settlement. *Hand argument:* diffs are applied only in the intra-block DECIDE+APPLY step (T7), which applies all diffs or none in the same block execution; abort steps (T5/T6/T8/T9) apply none. There is no transition that applies a subset. *Gap:* this is a hand argument over the transition table, not a machine-checked proof. A bug in the transition implementation could still violate S1 — that is why §10.5 requires model checking before prototype.
- **S2 Lock exclusivity:** at any point in the finalised log, a (domain, key) lock is held by at most one non-terminal settlement. *Hand argument:* acquisition checks the global lock table in one deterministic step and acquires all-or-none (§6.3); release happens only in the same block as decide/abort. *Gap:* hand argument only; the lock-table implementation and its replay equivalence must be model-checked.
- **S3 No hold-and-wait deadlock (acquisition phase):** no settlement holds a lock while waiting for another lock. *Hand argument:* §6.3 all-or-none acquisition. *Gap:* the argument covers acquisition; it does not by itself prove that the *decide* phase cannot block indefinitely — that is covered by the termination bound below, not by deadlock-freedom alone.
- **S4 Terminality:** every settlement reaches a terminal state (COMMITTED or ABORTED/EXPIRED) and never transitions out of it. *Hand argument:* the transition table has no outgoing transitions from terminal states, and SID reuse is rejected at pre-check. *Gap:* hand argument only.
- **S5 Replay determinism:** two honest validators replaying the same finalised log compute the same settlement state and the same roots. *Hand argument:* all transitions are functions of finalised log entries only (no wall-clock, no private input, no coordinator message). *Gap:* determinism of the WASM runtime and host functions (§4.6) must also hold; a runtime non-determinism bug breaks S5 independently of the settlement logic.

**Bounded liveness / termination analysis (what is bounded, and under what assumptions):**

- [Proposed MARWANTA] **Termination-after-recovery (CORRECTED in v0.3 — this replaces any unqualified 'bounded termination' claim):** every settlement created in finalised block B_f terminates (COMMITTED or ABORTED/EXPIRED) no later than `min(B_f + D, next E_f)` in finalised blocks, plus finality lag for the deciding block, PROVIDED the chain resumes finalising blocks. This bound holds even if leaders fail, domains never prepare, or contention persists after recovery, because deadline and epoch abort are finalised log entries that any honest leader can include after recovery, and a settlement cannot survive a finalised epoch-transition block. The bound is in finalised blocks, not seconds and not wall-clock time, so it is deterministic from the finalised log. During a quorum-loss partition the bound does NOT apply: no transition can be finalised, settlements freeze (§6.6A), and wall-clock termination time is unbounded without a GST / quorum-recovery assumption, which v0.3 does not make unconditionally. Wall-clock termination time, when it exists, equals partition duration (unbounded in the worst case) + finalised-block bound after recovery + finality lag.
- [Proposed MARWANTA] **Commit liveness (a legitimate settlement eventually commits) is NOT unconditionally bounded.** It holds only under the conjunction of: (a) partial synchrony after GST (§2.2); (b) a sequence of honest leaders that include prepare and decide entries; (c) the settlement's locks becoming available within D (i.e. contention does not persist for the whole deadline); (d) every participating domain passing its prepare checks; (e) no epoch abort intervening. If any of (a)–(e) fails, the settlement aborts within the termination-after-recovery bound (in finalised-block terms, after quorum recovery) — it does not hang in the finalised log, but it also does not commit. That distinction is the honest liveness claim: **v0.4 guarantees bounded termination-after-recovery, in finalised-block terms, not bounded commit, and not termination during a quorum-loss partition.** A spec that promised bounded commit under adversarial contention would be false.
- [Proposed MARWANTA] **Worst-case steps to commit-or-abort (happy-path vs. worst-case):** happy path = ORDER (1 block) + PREPARE-ATTEMPT (1 block) + DECIDE+APPLY (1 block, same block as decide entry) = 3 ordered blocks plus consensus finality lag (§2.2, two-chain finality). Worst case to *terminate after recovery* = ORDER (finalised) + up to R prepare attempts (each in a separate finalised block, if locks are contended) + deadline/epoch abort = at most `D` finalised blocks after creation (or finalised epoch length, whichever is smaller), plus finality lag. This worst case is counted from the finalised creation block and excludes any wall-clock time spent in a quorum-loss partition, during which no finalised blocks exist to count. Worst case to *commit* under contention is unbounded in the sense that a settlement may abort repeatedly on re-proposal if the same key remains contended — re-proposal is a new settlement with a new bound, not a continuation of the old one. The §21 kill criterion on settlement liveness measures exactly this abort rate, not a single settlement's latency.
- [Proposed MARWANTA] **Conditions under which liveness can fail (stated, not hidden):** (i) chain halt (quorum loss / partition) — no settlement terminates until the chain resumes finalising, after which deadline/epoch aborts fire; (ii) persistent contention on a key — settlements for that key abort repeatedly, while unrelated keys progress; (iii) a domain that always fails prepare — settlements involving it always abort, by design (that domain is faulty, not the settlement protocol); (iv) misconfigured D (too short for normal load) — spurious aborts, detectable by abort-rate monitoring and corrected by governance parameter change, not by code patching around the state machine.
- **[Research Required / UNRESOLVED]** Machine-checked proof: the hand arguments above must be replaced by a TLA+ (or equivalent) model in Phase 2 that explores all reachable states of §6.2, proves S1–S5, and proves the termination bound under the stated assumptions. Until that model exists and passes, §6 is **PARTIALLY RESOLVED** (see register). The founder must not approve v0.2 as "proven safe" — only as "state machine completely specified, ready for formal modelling".

### 6.8 Lock-griefing / DoS economics — worked cost model in abstract units (illustrative, NOT a priced token model)

**Units and warning:** all quantities below are in abstract fee/bond units (`u`), not in any token, price, or currency. No token supply, price, or fee level is set by this section (§11 remains preliminary and undecided). The model shows *structure* — when griefing is unprofitable in principle — not a price list. If a future tokenomics model sets real numbers, it must re-run this model with those numbers and publish the result; the abstract model alone does not prove real-world unprofitability.

**Definitions (per settlement, per attempt):**

- `f_prepare` = fee charged for one prepare attempt (resources actually consumed, §6.4).
- `f_abort` = abort fee charged on ABORTED/EXPIRED, escalating with repeat aborts by the same sender/domain (see escalation below).
- `f_lock` = lock-time fee per block per locked input unit, charged for each block a settlement holds locks in PREPARED (not charged in WAIT, where no locks are held).
- `B_lock` = bond posted by the settlement initiator, forfeited in whole or part on EXPIRED abort caused by the initiator's own failure to complete (not on abort caused by another domain's failure — attribution matters, see below).
- `V` = value to the victim of using the locked input during the lock window (e.g. the profit from a trade that could not execute, or the delay cost). `V` is external to the protocol and cannot be measured by the protocol; the model treats it as an attacker-estimated benefit.
- `E` = external benefit to the attacker from griefing (e.g. harming a competitor, winning an auction by blocking others, or pure sabotage value). If `E` is non-monetary (sabotage for its own sake), no fee model can make griefing "unprofitable" in the attacker's own terms — see break conditions below.

**Attacker cost to grief one key for one lock window:**

```
Cost_grief = f_prepare (per attempt, × attempts)
           + f_lock × (blocks held in PREPARED) × (locked inputs)
           + f_abort (on abort, escalating)
           + forfeited B_lock (if the abort is attributed to the initiator)
```

**Worked example (abstract units, illustrative only):**

- Suppose, for illustration, `f_prepare = 1u`, `f_lock = 2u` per block per input, `f_abort = 3u` (first abort), `B_lock = 10u`.
- Attacker prepares a settlement locking 1 popular input, holds it for 5 blocks in PREPARED, then lets it abort at deadline.
- `Cost_grief = 1 + (2 × 5 × 1) + 3 + 10 = 24u` for 5 blocks of blocking one key.
- If the victim's delay cost `V` for those 5 blocks is, say, `5u`, griefing is unprofitable in money terms (`24u > 5u`). If `V` is `50u` (e.g. blocking a large auction), griefing is profitable at these illustrative numbers, and the parameters must change (higher `f_lock`, higher `B_lock`, shorter D, or a per-domain lock budget that prevents this attacker from holding that key repeatedly) — the model tells the designer *which* knob to turn, it does not by itself set the knob.
- Repeat-griefing escalation: `f_abort` for the same sender/domain escalates per abort within a window (symbolic: `f_abort(n) = f_abort(1) × g(n)`, where `g` is an increasing function set in Phase 2, e.g. linear or exponential in the abort count within an epoch). After `n` aborts, cumulative cost grows super-linearly, so sustained griefing becomes rapidly expensive even if a single grief is cheap. The escalation window and function are Phase 2 parameters; the principle (escalation, not flat abort fee) is v0.2.
- Per-domain lock budget: each domain has a maximum number of concurrent locks and a maximum locked-input value fraction per block (symbolic caps, Phase 2 values). A domain that exhausts its budget cannot initiate new settlements until locks release. This bounds griefing by a single domain to its budget, regardless of its fee-paying ability — fees alone do not bound a wealthy attacker, budgets do.

**When the griefing-unprofitability argument breaks (stated, not hidden):**

1. **Non-monetary attacker (`E` is sabotage value, not money):** if the attacker values harm above any fee, fees do not deter. Mitigation is then budgets + deadlines + epoch abort (bound the harm window), not higher fees alone. A fee-only anti-griefing claim would be false for this attacker.
2. **Wealthy attacker / subsidised fees:** if the attacker can pay any fee (or is the domain itself, subsidising its own users' fees), `Cost_grief` is not a constraint. Mitigation is per-domain lock budgets and per-creator domain-creation limits (§4.10, scenario A6), which bind regardless of wealth.
3. **High `V` / low `f_lock` mismatch:** if the locked input's value to victims vastly exceeds the lock fee, griefing is profitable. Mitigation is to scale `f_lock` with locked value (lock fee proportional to locked-input value, not flat per input) — a Phase 2 design decision, flagged here because a flat lock fee is the most likely miscalibration.
4. **Attribution failure:** if abort cause cannot be attributed (was it the initiator, a participating domain, or contention?), forfeiting `B_lock` punishes the wrong party and the model collapses. Mitigation is reason-coded aborts (§6.4) with attribution by log evidence: initiator-caused EXPIRED (never prepared, or prepared then abandoned) forfeits; victim-domain-caused abort (another domain failed prepare) does not forfeit the initiator's bond. If attribution cannot be made deterministic from the log, `B_lock` forfeiture must not be used — only fees and budgets remain.
5. **Sybil griefing:** attacker splits griefing across many domains/accounts to evade per-domain budgets and abort escalation. Mitigation is domain-creation cost + per-creator rate limits + the global lock cap (§20). If Sybil attribution fails, the global cap is the backstop, and per-domain budgets alone must not be claimed sufficient.

---

## 7. State and storage architecture

### 7.1 State model

- [Proposed MARWANTA] Global state is partitioned by domain: each domain owns a namespace subtree. The global state root is computed as: `GlobalRoot = MerkleRoot( DomainRoot_1, DomainRoot_2, … )` over domain IDs in deterministic order. A domain's root commits to that domain's entire state subtree.
- [Proposed MARWANTA] This structure gives two properties: (a) a domain's state can be proven (inclusion / non-inclusion) with a domain proof + a global proof, without revealing other domains' state; (b) a domain's state corruption is attributable — if a domain root is wrong, the fault is in that domain's execution, not in an undifferentiated global trie.
- [Research Required] Whether per-domain roots should be Sparse Merkle Trees, Merkle Patricia Tries, or another authenticated structure is a Phase 2 decision. The v0.2 baseline is **Sparse Merkle Tree per domain** (simple, key-independent proof sizes, well-understood) with the global root as a Merkle tree over domain roots. Verkle trees are **not** adopted in v0.2: they offer smaller proofs [Prior Art] but require new cryptographic assumptions, a complex migration, and integration work with the proof system that a v0.2 draft cannot justify. Verkle adoption is a future upgrade candidate, evaluated only after the baseline is measured.

### 7.2 State commitments in the block header

A block header commits to, [Proposed MARWANTA]: previous block hash, height, timestamp (consensus time, not wall-clock truth), proposer, quorum certificate for the parent, transaction root, receipts root, global state root, per-domain root list (or its Merkle root, with the full list available in the block body for validators), settlement-decision root, proof-status root (VALID / INVALID / MISSING / UNAVAILABLE per Tier-2 batch — status only, never a substitute for replay, §5.1), and (when Tier-2 proofs are present) proof root. A header that omits any required root is invalid. A header whose proof root is present but whose replay root mismatches is still invalid — proof presence does not cure a replay mismatch (§5.5).

### 7.3 Synchronisation

- [Proposed MARWANTA] New validators sync by: (a) downloading and verifying finalised headers from genesis (or from a trusted checkpoint **only** if the checkpoint mechanism is itself verifiable — a checkpoint that requires trusting a third party is not a sync mechanism, it is a trust assumption, and must be labelled as such), (b) downloading state snapshots at epoch boundaries, verified against the epoch's global root, and (c) replaying blocks after the snapshot to reach the tip.
- [Proposed MARWANTA] Fast sync via snapshots must not become "trust the snapshot provider": snapshots are verified against finalised roots, and a validator that syncs from a snapshot must still be able to verify subsequent blocks by replay. Snapshot providers are untrusted conveniences, not authorities.
- [Research Required] Snapshot format, snapshot frequency, and the trade-off between snapshot size and replay time are Phase 2/3 measurements. No sync-time number is claimed in v0.2.

### 7.4 History, pruning, and archival

- [Proposed MARWANTA] Full validators retain: all finalised headers, all blocks for a defined recent window (length **UNDECIDED**, to be set by storage economics in Phase 2), and state snapshots at epoch boundaries. Older block bodies may be pruned by a full validator after the window, **provided** that (a) the pruned data remains available from archival nodes, and (b) pruning never removes data needed to verify the current state root from the last snapshot.
- [Proposed MARWANTA] Archival nodes are a distinct, voluntary role: they retain full history and serve it via the RPC/indexer layer. Archival service is incentivised (see §11 — mechanism [Research Required]) or it will not exist at scale, and a chain whose history exists only on the founding team's servers is not decentralised. No claim is made in v0.2 that archival incentives are solved.
- [Proposed MARWANTA] Historical state access (querying state at an old height) is served by archival nodes, not by every validator. Light clients and applications must be told this explicitly: "query old state" is not a consensus guarantee, it is an archival service.

### 7.5 Light-client verification (corrected to §5.1)

- [Established] A light client that trusts only finalised headers and Merkle inclusion proofs can verify that a piece of state *was included* in a finalised state root, without downloading the full state.
- [Proposed MARWANTA] MARWANTA light-client verification steps: (1) obtain a chain of finalised headers verified by quorum certificates (or a verified checkpoint + header chain), (2) request a state proof: domain proof (state key → domain root) + global proof (domain root → global root), (3) verify both proofs against the finalised header's global root, (4) for a transaction, verify inclusion via the transaction root + receipts root. For Tier-2 batches, step (4) may *additionally* verify a validity proof — but only as an additional check, and only with the understanding in §5.6: a light client that relies on a Tier-2 proof additionally trusts proof-system soundness, and a light client that does not replay is trusting quorum honesty. **A light client is not as secure as a full validator, and documentation must not imply otherwise. A light client must never be told that a Tier-2 proof alone is equivalent to full validation.**
- [Proposed MARWANTA] If a light client receives a valid Tier-2 proof for a batch but the corresponding header is not finalised, the batch is not final — proof does not accelerate finality (§5.1).

### 7.6 Data availability (corrected to §5.1 DA gate)

- [Established] Data availability is the guarantee that the data needed to verify and reconstruct state is actually published and retrievable, not merely committed to by hash. A header that commits to data nobody can download is a withholding attack.
- [Proposed MARWANTA] v0.2 baseline: **full replication + DA gate** — every validator downloads full block data before voting to finalise (§5.8 lists exactly what data). This is simple, secure, and expensive at scale, and it is the honest baseline for a new chain. Data-availability sampling (DAS) with erasure coding [Prior Art: Ethereum danksharding research, Celestia] is **not** adopted in v0.2: it is a powerful technique, but it adds sampling, reconstruction, and fraud-proof complexity that must be proven for MARWANTA's block structure before it is relied on. DAS is a Phase 3+ research candidate, with the explicit condition that it must not weaken the full-replication security guarantee for validators that choose to replicate fully. **Crucially, DAS, if ever adopted, must not replace the DA gate for validators: a validator that has not itself obtained or sampled-verified the data to the required threshold must still not vote to finalise.** The exact DAS threshold and its interaction with the DA gate are Phase 2/3 research, not v0.2 decisions.
- [Research Required] At what block size / throughput does full replication become the bottleneck, and what validator hardware does that imply? That is a §14 measurement, not a v0.2 assertion.

### 7.7 Realistic validator hardware and storage growth (no invented numbers — method, not claims)

- [Proposed MARWANTA] v0.2 does **not** publish a "minimum validator spec" as a fact, because no workload has been measured. Instead, Phase 3 must publish, for each benchmark workload in §14: CPU cores utilised, RAM (including mempool, state cache, WASM compilation cache), disk IOPS and total storage after 30/90/365 days at the measured throughput, and network bandwidth (ingress/egress). Only from those measurements can a honest minimum spec be derived.
- [Proposed MARWANTA] Design intent (TARGET, untested): an ordinary, non-datacentre validator — a well-provisioned server or high-end workstation, not a supercomputer cluster — should be able to validate the chain at the Phase 5 private-testnet workload. If Phase 3 shows that intent requires datacentre hardware, the intent must be revised or the workload narrowed; the spec must not be silently edited to pretend datacentre hardware is "ordinary".
- [Proposed MARWANTA] Storage growth control levers (all to be parameterised in Phase 2): state rent/deposits (§4.5), pruning window (§7.4), per-domain storage ceilings, and transaction size limits. No single lever is claimed sufficient alone. §20 models how these levers interact with the global disk budget.

---

## 8. Networking design (updated: shared-layer limits stated)

- [Proposed MARWANTA] Transport: libp2p-style authenticated peer-to-peer networking is the v0.2 *candidate* (not a locked dependency) — [Prior Art] used by Ethereum, Polkadot, and others — with peer identities tied to validator keys for validators and to ephemeral keys for non-validator peers. [Research Required] Phase 2 must evaluate libp2p vs. a custom QUIC-based stack on: NAT traversal, connection management under churn, gossip efficiency, and auditability. Popularity alone is not a selection criterion.
- [Proposed MARWANTA] Gossip: transactions and blocks propagate by gossip with deduplication, size limits, and per-peer rate limits. A peer that floods is rate-limited and then disconnected; rate-limiting parameters are [Research Required] and must be tuned so legitimate bursts (e.g. a popular domain launch) are not mistaken for attacks. **Gossip is a shared layer (§4.9): per-domain gossip quotas bound a domain's gossip share, but block propagation itself is global — a large block from one domain delays all validators (§4.10, scenario A5).**
- [Proposed MARWANTA] Mempool: a validator's mempool is local and untrusted — it is not consensus. Mempool policy (fee ordering, eviction, size caps) is a local choice that affects liveness (censorship, §2.6) but not safety, provided consensus ordering is independent of any single mempool. **Mempool is a shared layer (§4.9, §20): per-domain queues bound a domain's mempool share, but total mempool memory and gossip bandwidth are shared validator resources.**
- [Proposed MARWANTA] Peer discovery and bootstrap: a hard-coded bootstrap list at genesis is a centralisation risk if it is never diversified. v0.2 requires a documented path from bootstrap-list discovery to DHT/peer-exchange discovery, and a requirement that the bootstrap list itself be replaceable by governance without a chain halt. Bootstrap nodes run by the founding team at testnet are labelled as such and must not be presented as decentralisation.
- [Proposed MARWANTA] Network partitions (§2.2) are handled by finality-over-availability: the chain halts on the minority side rather than forking finalised history. Peer reconnection after partition follows the re-sync rule in §7.3.
- [Proposed MARWANTA] Observability: validators expose metrics (peer count, gossip latency, mempool size, execution time, state size) via a standard metrics endpoint for the status dashboard (§12), but metrics must not leak private transaction data or validator IP topology beyond what is necessary for network health.

---

## 9. Validator architecture (corrected in v0.2: §9.1 execution column)

### 9.1 Node roles (one validator set, multiple node types) — CORRECTED

| Role | Validates? | Executes / replays? | Stores full state? | Notes |
|---|---|---|---|---|
| **Validator (consensus + execution)** | Yes, votes with bonded stake | **Yes — MUST replay every tx in every block it votes to finalise (§5.1). No Tier-2 exception.** | Yes (pruning per §7.4) | The security set. Must meet the Phase 3-derived hardware spec. A validator that votes without replay is in protocol violation. |
| **Full node (non-voting)** | Verifies headers + replay, does not vote | Yes, for verification (same replay rule, voluntarily, to be able to audit) | Yes (pruning per §7.4) | Anyone can run; strengthens auditability without stake. |
| **Light client** | Verifies headers + proofs (§7.5) | **No** — and therefore trusts quorum honesty, plus proof soundness if it uses Tier-2 (§5.6) | No | Wallets, browsers, agents. **Not** as secure as a full validator. Must never be told a Tier-2 proof makes it equivalent to a validator. |
| **Archival node** | As full node, plus full history retention | Yes | Yes, full history | Voluntary, incentivised or grant-funded (§7.4, §11). |
| **Prover (Tier-2 only)** | No (prover is not a validator role) | Generates validity proofs for Tier-2 batches; does **not** vote, does **not** finalise | No | [Research Required] Prover decentralisation is an open problem (§5.4, §16). A single prover is a centralisation and censorship risk **for Tier-2 fast verification only**, not for finality, because Tier-1 replay remains the base (§5.1). Any v0.1 sentence implying prover failure affects finality is withdrawn. |

### 9.2 Validator lifecycle

1. **Bond:** stake bonded via a bond transaction; validator keys registered (consensus key, network key, and a separate withdrawal key — key separation so a compromised consensus key does not directly steal stake).
2. **Warm-up:** at least one epoch before voting power activates (§2.5).
3. **Active:** proposes (when leader), votes, executes/replays, gossips. Must maintain uptime and correct execution; downtime and incorrect votes are penalised (§11). **Correct execution includes the §5.1 replay precondition: a vote cast without replay is a protocol violation regardless of outcome (see §9.5). Slashing for that violation additionally requires qualifying evidence under §9.5; a correct-looking vote alone does not prove the omission.**
4. **Exit:** unbonding period during which the validator remains slashable for past faults; voting power is removed at the next epoch boundary after unbonding completes.
5. **Slashing / jailing:** equivocation, double-signing, vote-without-replay with qualifying evidence under §9.5, or provable protocol violations trigger slashing (§11) and temporary jailing (removal from the active set for a defined period). Violation status for vote-without-replay does not depend on outcome; slashing does depend on qualifying evidence (§9.5). Jailing for downtime alone must be proportionate — a validator that is merely slow should not be treated like one that equivocated.

### 9.3 Key management and operational security

- [Proposed MARWANTA] Validators must be able to run consensus keys in a hardware security module (HSM) or threshold-signing setup, and must be able to rotate consensus keys without unbonding (via a key-rotation transaction that proves control of both old and new keys). Key rotation that requires unbonding discourages rotation and therefore weakens security.
- [Proposed MARWANTA] No validator operation should require the founding team's intervention. If a validator cannot join, rotate, or exit without contacting founders, the validator architecture has failed the permissionless test (§12's "without contacting founders" rule applies to validators as well as developers).

### 9.4 Incentives and penalties (summary — full design in §11)

- Validators are paid from transaction fees + protocol rewards (inflation, if any — amount **UNDECIDED**). Rewards must be sufficient to cover honest validator operating costs at the Phase 3-derived hardware spec, or the validator set will centralise to whoever can subsidise operation. "Sufficient" is a measurement, not a slogan: Phase 5 must survey real validator costs before mainnet parameters are set.
- Penalties are proportionate and attributable, under the one consistent rule in §9.5 (NEW in v0.4): downtime < incorrect vote < vote-without-replay with qualifying evidence < equivocation < provable state-corruption attempt, in proportion only. Exact rates are UNDECIDED, Phase 2 tokenomics work, not v0.4 numbers. A penalty that is too harsh for downtime discourages small validators; a penalty that is too lenient for equivocation invites attacks.

---

### 9.5 Slashing for vote-without-replay — ONE consistent rule (NEW in v0.4, canonical)

**Status.** This subsection is the canonical slashing rule for vote-without-replay. It replaces the conditional, outcome-dependent wording in v0.3 §1.3, §9.2, §9.4, §10.2, §11.1 and §11.3, under which slashing appeared to depend on whether a vote contributed to a wrong finalisation. Where any other passage in v0.4 still appears to make violation or slashing conditional on outcome, this subsection governs and that passage must be corrected in v0.5. This subsection is a specification decision, not a proof and not a measurement: penalty rates, challenge parameters, and several evidence thresholds are UNDECIDED (Phase 2) and are marked as such below.

**Rule P-S (canonical, two separate questions).**
1. **Violation — outcome-independent.** A validator commits a protocol violation if it signs a vote that can contribute to finalising block B without first completing ALL of P0 for B: (1) full-data download and hash verification (DA gate, §5.1/§5.8); (2) deterministic replay of every transaction in B reproducing the claimed global root and every domain root in B; (3) settlement-decision verification against §6 from the ordered log; (4) receipts-root, manifest, and budget verification for B. If any of (1)–(4) is skipped, the vote is a violation, even if B turns out to be correct, even if the vote is not decisive for the QC, and even if no harm results. A vote on the basis of a Tier-2 proof alone, without (1)–(4), is a violation on the same terms.
2. **Slashing — violation PLUS qualifying evidence.** Slashing additionally requires qualifying evidence as defined below, because an internal omission is not directly observable from a correct-looking vote alone. A vote that looks correct, is for the correct root, and is indistinguishable on-chain from a replayed vote does not, by itself, prove the voter skipped replay. Claiming otherwise would be false. Slashing without qualifying evidence is therefore forbidden in v0.4, even where a violation is suspected.

**Enforcement gap (stated plainly, not hidden).** Perfect detection of a validator that votes correctly without replaying, without a challenge mechanism, is NOT possible from the vote alone, and v0.4 does NOT claim it. Detection in v0.4 rests on three evidence classes below. A validator that always votes correctly, never equivocates, and never fails a challenge will not be slashed for vote-without-replay under this rule, even if it in fact skipped replay in private — that is a known limitation of the rule, not a bug to be papered over. The rule deters the detectable cases (wrong votes, equivocation, challenge failure, outcome-attributable wrong finalisation) and makes abstention the safe alternative to voting without replay; it does not make undetectable private omission impossible.

**Violation taxonomy.**
- **V-P0:** vote without completing P0 steps (1)–(4) for the voted block. Subtypes: V-P0-DA (step 1 not completed), V-P0-REPLAY (step 2 not completed), V-P0-SETTLE (step 3 not completed), V-P0-RECEIPT (step 4 not completed). Subtyping matters for challenges: a challenge must state which step is alleged to have been skipped, where that is knowable.
- **V-WRONG:** vote for a block root that honest replay contradicts. V-WRONG may overlap V-P0 (a validator that skipped replay may vote wrong), but it is a distinct violation class because its evidence is outcome-based (see E1/E3).
- **V-EQ:** equivocation — two different signed proposals or votes for the same view/height from the same validator. V-EQ is a violation on its own, independent of P0.
- **V-DOWN (not a P0 violation):** downtime, missed votes, or slow votes. Missing a vote is not vote-without-replay. Downtime is handled under the downtime penalty category only, proportionately, and is not treated as a Byzantine fault on its own.

**Evidence classes (qualifying evidence for slashing).**
- **E1 — Self-evident evidence (no challenge needed).** (a) Equivocation: two conflicting signed votes/proposals for the same view/height from the same validator, each cryptographically verifiable on-chain. (b) Vote without DA, proven by data-availability challenge failure: the validator voted for a block whose full data it cannot produce on a DA challenge within the Phase 2 bound (see E2 for the bound; the DA-specific challenge is E1(b) because failure to produce data the voter must have held is itself the evidence). (c) Vote for a root that honest replay contradicts, where contradiction is proven by a conflicting finalised block at the same height/order or by a quorum-certified replay record — the exact quorum threshold for a replay record is [Research Required] in Phase 2 and is not invented here. E1 evidence alone qualifies for slashing under the penalty categories below, subject to the appeal safeguards.
- **E2 — Challenge-based evidence (replay-audit challenge).** Any validator or full node may submit a replay-audit challenge against a specific vote, stating the block, the validator, and the P0 step alleged. The challenged validator must, within a defined bound in finalised blocks (value UNDECIDED, Phase 2 — the bound must be stated in finalised blocks, not seconds, consistent with §6.6A), publish replay intermediates in a verifiable form specified by Phase 2 (at minimum: input-data hash, per-domain roots recomputed, settlement decisions recomputed, receipts root recomputed, in a format a challenger can re-derive by replay). Outcomes: (i) intermediates match honest replay — challenge fails, challenger bond (if any; amount UNDECIDED, Phase 2) may be forfeited in whole or part to deter spam challenges, and no slashing follows from that challenge; (ii) intermediates mismatch honest replay — qualifying evidence for slashing, subject to appeal; (iii) no response within the bound — qualifying evidence only after the safeguards below, not on a single silent timeout alone. Safeguards: a challenge must be bonded (amount UNDECIDED) to deter spam; a single challenge failure that is shown to be caused by a benign version skew during a declared coordinated-upgrade window, or by a documented hardware fault with no wrong outcome, is treated as a warning and a re-challenge, not as immediate slashing; repeated challenge failures (repeat count UNDECIDED, Phase 2) escalate warning -> jailing -> slashing. A challenge that targets a validator that abstained (correctly, for missing data or replay mismatch) is invalid and must not be used to punish abstention.
- **E3 — Attributable-outcome evidence (ex-post).** A validator's signed vote is part of a QC that finalises a wrong root, where wrongness is later proven by conflicting finalised evidence or by a Phase 7 audit finding that is itself replay-verifiable. E3 qualifies for slashing, but with two explicit limits: (a) slashing after finalisation cannot undo finality — the wrongly finalised block remains final under §2.2A unless the BFT assumption itself has failed and §10.7 incident response applies; slashing is accountability, not rollback; (b) E3 requires proof that this validator's vote was in that QC (signature in the QC) AND proof that the root was wrong (replay evidence as in E1(c)), not merely that the validator voted in the same epoch or view.

**Attribution.**
- Slashing is per-validator, by signature, stake-weighted in proportion only (rates UNDECIDED). No collective punishment: validators that abstained, voted correctly after replay, or were not in the QC are not slashed for another validator's violation.
- Abstention is the CORRECT behaviour when data is missing, replay mismatches, or P0 cannot be completed in time: a validator that abstains in those cases commits no P0 violation and must not be slashed as Byzantine for abstaining. Repeated abstention may affect rewards or downtime treatment only, under proportions set in Phase 2, and must be distinguished in the record from a P0 violation.
- Delegators, if delegation is adopted, share penalties only as Phase 2 tokenomics specifies; v0.4 does not decide delegator penalty pass-through (UNDECIDED, §11.3).

**Penalty categories (proportions only, rates UNDECIDED, Phase 2).** In increasing severity: (1) downtime — lowest, temporary jailing first; (2) incorrect vote — a vote for a wrong root where P0 compliance is not separately proven (for example, an honest replay error or version skew that produces a wrong vote without evidence of skipped replay); (3) vote-without-replay with qualifying evidence (E1/E2/E3) — above incorrect vote, because it is a deliberate precondition breach, not merely a wrong result, and below equivocation; (4) equivocation / double-signing — severe; (5) provable state-corruption attempt — severe + jailing. Jailing (temporary removal from the active set) applies immediately on E1 equivocation pending investigation, and on other categories only under the escalation rule in E2 or on a final slashing decision; jailing durations are UNDECIDED, Phase 2. Slashed funds destination (treasury vs burn) remains [Research Required] as in §11.3, because slashing-to-treasury creates a perverse incentive that must be decided explicitly, not by default.

**Appeal and false-positive safeguards.**
- Benign version skew: a validator running a previous deterministic software version during a declared coordinated-upgrade window, whose vote differs only because of that version and who updates within the window, is not slashed as Byzantine. Version skew outside a declared window, or a skew that produces a wrong finalisation, is not automatically benign and is judged under E1/E3.
- Hardware fault / single timeout: a single challenge non-response or a single missed vote, with no wrong outcome and a documented fault, is a warning, not slashing. Escalation requires repetition as in E2.
- Appeal window: a slashed validator may submit exculpatory replay evidence within a window stated in finalised blocks (duration UNDECIDED, Phase 2). A successful appeal reverses the slashing record and, where technically possible, returns slashed funds under the Phase 2 rule for appeal reversals; an appeal does not reverse finality.
- No slashing on suspicion alone: a validator must not be slashed for vote-without-replay on the basis of timing, latency, or statistical inference alone, without E1, E2, or E3 evidence.

**UNRESOLVED in §9.5 (not hidden).**
- Challenge bound in finalised blocks, challenger bond amount, repeat-failure count for escalation, replay-intermediate format, quorum threshold for replay evidence in E1(c)/E3, penalty rates, jailing durations, appeal window, and delegator pass-through — all UNDECIDED / RESEARCH REQUIRED, Phase 2.
- Whether a challenge mechanism can be made spam-resistant and timely enough to be practical at the target validator count — untested; Phase 3 must simulate challenge load under W6.
- Perfect detection without a challenge — NOT claimed, as stated in the enforcement gap above.


## 10. Threat model (updated: proof-system threat corrected to §5.1)

### 10.1 Security assumptions (what the design trusts, stated so it can be challenged)

1. [Established] Cryptographic assumptions: hash functions are collision-resistant, signatures are unforgeable, and (for Tier-2 *supplementary* checks only) the proof system is sound under its stated assumptions. If any assumption breaks, the affected mechanism breaks — there is no design that survives broken cryptography. **A break in proof-system soundness breaks light-client fast verification, not finality (§5.1).**
2. [Established] BFT assumption: < 1/3 of voting power is Byzantine at any time. If ≥ 1/3 is Byzantine, safety is not guaranteed — this is a property of BFT, not a MARWANTA flaw to hide.
3. [Proposed MARWANTA] Partial synchrony after GST (§2.2). During unbounded asynchrony, liveness is not guaranteed.
4. [Proposed MARWANTA] Honest validators run unmodified, deterministic software and obey the §5.1 replay precondition. A validator running modified software that produces a different state root is detectable (§4.7) but not automatically "fixed" — detection is the mechanism, correction is via the validator fixing its software.
5. [Proposed MARWANTA] Domain code is untrusted. The protocol must be safe even if every domain is malicious, subject to the resource and manifest limits in §4. A design that is safe only if developers are honest is not a blockchain design.

### 10.2 Attack inventory (each attack: vector, impact, v0.2 mitigation, residual risk)

**Byzantine validator attacks** — [Established] Equivocation, double-signing, withholding votes, proposing invalid blocks, voting without replay. Mitigation: quorum certificates, equivocation evidence + slashing (§2.2, §9.2), invalid blocks rejected by honest validators that replay (§5.1). Residual: < 1/3 Byzantine validators can still delay (not halt permanently after GST) and can censor for short windows (§2.6). A validator that votes without replay commits a protocol violation regardless of outcome; slashing for that violation requires qualifying evidence under §9.5 (§9.4). A correct-looking vote alone does not prove the omission (see §9.5, enforcement gap).

**Sybil attacks** — [Established] Creating many identities to gain influence. Mitigation: voting power tied to bonded stake, not identity count (§2.5). Residual: stake concentration (§16) — Sybil resistance does not solve wealth concentration. Domain-level Sybil (splitting to evade ceilings) is §4.10 scenario A6, mitigated by domain-creation cost + global cap (§20), not by stake alone.

**Long-range attacks** — [Established] An attacker with old keys (that no longer hold stake) builds an alternative history from genesis and presents it as canonical. Mitigation: finality (old history cannot rewrite finalised blocks), weak subjectivity checkpoints that are themselves verifiable (not trusted third-party checkpoints), and unbonding periods that keep keys slashable for a window. [Research Required] Exact weak-subjectivity period and checkpoint verification for MARWANTA are Phase 2 work; a new chain with a short history is *more* vulnerable to long-range confusion in its early life, and that early-life risk must be disclosed, not hidden.

**Replay attacks** — [Established] Re-submitting a valid transaction to execute it twice. Mitigation: sequence numbers (§3.4), cross-domain sequence derivation, and domain-local nonce handling. Residual: a flaw in cross-domain sequence derivation is a double-spend vector — this is why §3.4 is flagged [Research Required] for formalisation.

**Double spending** — [Established] Spending the same funds twice via conflicting transactions. Mitigation: single consensus order + locked inputs during settlement (§6) + sequence consumption. A double-spend that succeeds would mean consensus ordering or lock enforcement failed — both are protocol-critical bugs, not application bugs.

**Reentrancy** — [Prior Art] Classic shared-state attack (DAO hack lineage): a malicious contract re-enters a victim mid-execution before state is updated. Mitigation in MARWANTA: **structural** — domains cannot synchronously call each other mid-execution (§6.5); cross-domain effects go through intents + settlement, and within a domain, the runtime enforces checks-effects-interactions as a *recommended pattern* plus manifest-scoped state access. Residual: reentrancy *within* a domain is still possible if the domain's own code is vulnerable — the protocol cannot audit every domain's logic. Developer guidance and auditing (§12) are the mitigation there, not a protocol guarantee.

**State corruption** — Malicious or buggy domain code writes outside its namespace, or a validator's state diverges. Mitigation: manifest enforcement (§4.3), deterministic replay + root comparison (§4.7), per-domain roots for attribution (§7.1). Residual: a runtime bug that allows namespace escape is a critical vulnerability — the WASM sandbox is a primary audit target (§10.5).

**Malicious application behaviour** — A domain that is itself a scam, a griefing tool, or a spam engine. Mitigation: containment (§4.7, §4.9), per-domain budgets/ceilings (§4.5), fees, lock budgets (§6.8), global scheduler (§20). **Non-mitigation, stated honestly:** the protocol does not judge whether a domain is "good" — permissionless deployment means scams can deploy. User protection comes from wallets, explorers, and reputation signals (§12), not from protocol censorship of domains by default. Quarantine (§4.7) is for protocol-safety threats, not for content moderation, and conflating the two would create a censorship tool.

**Proof-system vulnerabilities — CORRECTED in v0.2** — A flaw in the STARK/SNARK implementation, arithmetisation, or trusted setup (if SNARKs are used) allows false validity proofs. **Impact under §5.1: a false Tier-2 proof does NOT by itself rewrite state, finalise a wrong block, or override replay.** Mitigation: Tier-1 replay remains the base (§5.1) — replay disagreement triggers investigation and block rejection, not proof-based override. The v0.1 §10.2 sentence asking "does a Tier-2 proof ever *override* replay disagreement?" is answered in v0.2: **no, never.** [Research Required] The remaining proof-system risks are: (a) light clients / external verifiers that trust a false proof alone (mitigated by documentation that proof reliance is weaker than full validation, §5.6); (b) prover implementation bugs that produce invalid proofs at scale (mitigated by proof-status recording and prover flagging, §5.5); (c) a proving-VM / execution-VM divergence that makes a proof correspond to a different computation than the replayed one (mitigated by requiring proof and replay to be checked against the same state-diff commitment, and by Phase 2 arithmetisation research, §5.4).

**Denial of service (network, mempool, execution)** — Flooding gossip, mempool, or execution with valid-but-useless work. Mitigation: per-peer rate limits (§8), per-domain block ceilings (§4.5), per-domain mempool queues (§20), resource metering + fees (§4.5), and proof-of-work-free spam economics via fees (fees must be high enough to make spam expensive, low enough to keep legitimate use affordable — that balance is a Phase 2/5 measurement, not a v0.2 number). Residual: shared layers still degrade (§4.9, §4.10, §20) — DoS is bounded, not eliminated.

**Resource exhaustion** — Infinite loops, memory bombs, storage bloat, state-tree depth attacks. Mitigation: deterministic metering with hard ceilings (§4.5, §4.6), storage deposits/rent (§4.5), WASM memory limits, state-access cost that reflects trie depth, and the global scheduler (§20). Residual: metering itself can be gamed if the cost model does not match real validator cost (e.g. an operation that is cheap in fee but expensive in disk I/O) — the cost model must be calibrated against measured validator costs in Phase 3, not set by intuition.

**Bridge and cross-chain risks** — [Prior Art] Bridges are historically the highest-loss attack surface in crypto (custody compromise, signature-verification bypass, finality mismatch — e.g. Wormhole $325M signature bypass and Ronin $625M validator-compromise cases cited in prior-art research). Mitigation in MARWANTA: **no custom bridge at genesis.** Cross-chain access in v0.2 is via established, audited interoperability patterns only (e.g. IBC-style light-client verification where the counterparty chain supports it, or audited third-party bridges with explicit trust assumptions), and any bridge integration must carry a public trust model stating exactly what is trusted. A MARWANTA-native bridge is a post-mainnet-readiness project, not a launch feature. Any bridge that requires trusting a small multisig must be labelled as such to users.

**Upgrade and governance attacks** — Malicious protocol upgrade, governance capture by large stakers, or a rushed emergency upgrade that introduces a bug. Mitigation: protocol upgrades via finalised governance with timelocks, replay testing of every upgrade against historical blocks (§10.9), separation of domain governance from protocol governance, and an emergency halt mechanism that is time-bounded and publicly justified (§10.10). Residual: governance by stake inherently gives large stakers more influence — that trade-off is disclosed in §11 and §16, not solved by pretending governance is one-person-one-vote.

**Network-level attacks** — Eclipse attacks (isolating a validator from honest peers), BGP/DNS hijacking of bootstrap, peer flooding. Mitigation: diverse peer connections, peer scoring, bootstrap diversification (§8), and validator peer sets that are not solely dependent on the founding team's bootstrap nodes. [Research Required] Eclipse resistance for MARWANTA's specific peer-selection algorithm is a Phase 3 simulation item.

**Settlement-specific attacks (new in v0.2, cross-referenced to §6)** — Lock-griefing, lock-table exhaustion, settlement-ID replay/splitting, decide-entry duplication, epoch-boundary manipulation. Mitigation: §6.2–§6.8 in full (all-or-none acquisition, canonical order, deadline, epoch abort, idempotency by SID, reason-coded aborts, lock budgets, escalating abort fees). Residual: contention on a single key still blocks that key for the lock window (§6.7); non-monetary griefing is bounded, not deterred, by fees (§6.8 break conditions).

### 10.3 Attack trees (summarised — full trees are Phase 2 deliverables)

- **Goal: steal funds from a domain.** Paths: (a) exploit domain logic → requires domain bug, mitigated by audit + manifest, not protocol; (b) reenter cross-domain → blocked structurally (§6.5); (c) corrupt state root → requires runtime escape or ≥ 1/3 Byzantine, mitigated by sandbox + BFT + replay (§5.1); (d) bridge custody compromise → mitigated by no-native-bridge-at-genesis (§10.2); (e) replay/double-spend → blocked by sequence + locks (§3.4, §6); (f) false Tier-2 proof → **cannot steal funds under §5.1**, because finality requires replay, not proof — a false proof alone moves no funds.
- **Goal: halt the chain.** Paths: (a) ≥ 1/3 Byzantine withholding → liveness loss is inherent to BFT, recovery on partition heal (§2.2); (b) domain resource exhaustion → contained at execution, degraded at shared layers (§4.9, §20); (c) consensus bug → mitigated by formal spec + model checking (Phase 2/3), residual is the reason for phased testnets; (d) data withholding → DA gate prevents finality of withheld blocks, but the proposer can delay that block's finality until leader change (§5.8).
- **Goal: censor a user/domain.** Paths: (a) leader omission → bounded by rotation + forced-inclusion research (§2.6); (b) validator collusion to quarantine a domain → bounded by quarantine due process (§4.7); (c) RPC/indexer censorship → mitigated by multiple independent RPC/indexer operators (§12), not by protocol alone; (d) prover censorship of Tier-2 batches → contained, because Tier-2 is supplementary (§5.1) — prover censorship degrades light-client fast verification, not finality or execution.
- **Goal: inflate / devalue the token (if launched).** Paths: (a) unbounded minting bug → mitigated by supply invariants checked in every block (total supply conservation as a protocol invariant, §10.4); (b) governance capture to change issuance → mitigated by timelocks + supermajority thresholds (§11).

### 10.4 Formal protocol invariants (to be proven in Phase 2, listed here as requirements — updated with P0 and settlement invariants)

1. **Conservation:** total native-token supply after any block = supply before + protocol-defined issuance − protocol-defined burns. No transaction or domain can mint outside this rule.
2. **Atomicity:** for any finalised cross-domain settlement, either all domain diffs are applied or none are (plus the defined refund path). No finalised state contains a partial settlement. (§6.7, S1)
3. **Isolation (execution layer only, corrected):** a domain's *execution* state after a block depends only on its own prior state, its own transactions, and settlement diffs it participated in — never on another domain's private state except through a settlement it joined. This invariant does **not** claim isolation of shared-layer latency, fees, or throughput (§4.9, §20).
4. **Determinism:** the same ordered log yields the same global root on every honest validator. (§6.7, S5)
5. **Finality monotonicity:** once a block is final, no honest validator finalises a conflicting block at the same height.
6. **Budget enforcement:** no execution exceeds its declared resource budget, and no domain exceeds its per-block ceiling in a finalised block *at the execution layer*. (Global-layer caps are §20, not this invariant.)
7. **Manifest enforcement:** no execution reads/writes state or calls a domain outside its manifest in a finalised block.
8. **Replay-before-finality (NEW, §5.1; slashing rule §9.5):** no validator vote contributes to finality for a block the validator has not replayed and for which it does not hold full data. A vote cast in violation of this invariant is a protocol violation, regardless of whether the block turns out to be correct. Violation and slashing are separate questions: slashing additionally requires qualifying evidence under §9.5 (E1/E2/E3). A correct-looking vote alone is not qualifying evidence of an internal omission.
9. **Lock exclusivity:** at any point in the finalised log, a (domain, key) lock is held by at most one non-terminal settlement. (§6.7, S2)
10. **Settlement terminality:** every settlement reaches a terminal state in the finalised log and never transitions out of it; a SID is never reused. During a quorum-loss partition settlements freeze in their last finalised state (§6.6A); this invariant is evaluated over finalised blocks, after the chain resumes finalising. (§6.7, S4)

Violation of any invariant in a finalised block is, by definition, a critical protocol bug — not a "known issue" to be documented away.

### 10.5 Independent audit plan (no audit results are claimed — this is a plan)

- **Phase 2:** internal specification review + model checking of consensus, settlement (§6), and the §5.1 validator rule (TLA+ or equivalent — tool choice [Research Required]).
- **Phase 3:** simulation adversarial testing (Byzantine leaders, partitions, spam domains, lock-griefing, §4.10 scenarios) with published scenarios and results.
- **Phase 4–5:** code audit of the prototype/testnet implementation by at least one independent firm, with scope covering: WASM sandbox escape, consensus implementation vs. spec, settlement state machine, manifest enforcement, metering, global scheduler (§20), and key management. Audit reports are published in full (not summaries) before public testnet is called "secure".
- **Phase 7:** second independent audit + formal verification of critical properties (invariants in §10.4) + penetration testing of RPC, P2P, and wallet integration surfaces. Mainnet readiness (§15, Phase 9) requires all critical findings fixed and re-tested, not merely acknowledged.

### 10.6 Bug bounty strategy

- [Proposed MARWANTA] A public bug bounty opens at public testnet (not at mainnet), with severity tiers tied to the invariants in §10.4 (critical = invariant violation, high = fund-loss or halt vector, medium = griefing/DoS, low = information disclosure). Bounty amounts are **UNDECIDED** until a treasury/budget exists (§11) — publishing a bounty amount without a funded treasury would be a false promise. Safe-harbour terms, disclosure timelines, and a public hall-of-fame are part of the bounty design, not afterthoughts.

### 10.7 Incident response and recovery plan

- [Proposed MARWANTA] Incident tiers: Tier 1 (chain halt / invariant violation) → coordinated validator halt via a pre-agreed emergency procedure, public incident notice within a defined window, and a fix + replay test before restart. Tier 2 (domain-level exploit) → domain quarantine path (§4.7) + user exit path, without halting unrelated domains if possible *at the execution layer* (shared-layer halt, if the incident is in consensus/root/storage, is chain-wide by necessity, §4.9). Tier 3 (RPC/indexer outage) → failover to independent operators, no chain halt.
- [Proposed MARWANTA] Emergency halt authority, if any exists, is time-bounded, requires a supermajority of validators (not founders alone), and automatically expires unless renewed by governance with a public justification. An indefinite founder-controlled halt is a centralisation backdoor and is rejected in v0.2.
- [Proposed MARWANTA] Post-incident: a public post-mortem (what happened, what invariant failed, what fix was applied, what test prevents recurrence) is required before the affected component is returned to production use. Post-mortems are not optional PR.

### 10.8 What this threat model does NOT cover

- [Proposed MARWANTA] Application-logic bugs inside a domain (e.g. a DeFi pricing error) are the domain developer's responsibility, mitigated by audit and testing (§12), not by the protocol. The protocol guarantees the *execution* was as coded and as manifested; it does not guarantee the code was *wise*.
- [Proposed MARWANTA] Off-chain risks (exchange custody, wallet malware, phishing, social engineering) are outside the protocol threat model but inside the ecosystem's user-protection responsibility (§12, §13). A chain that is secure on-chain but whose users are routinely phished through its official tooling has still failed its users.

---

## 11. Token economics proposal — PRELIMINARY ONLY

**Status banner for this entire section:** [Proposed MARWANTA] **PRELIMINARY PROPOSAL, AFTER PROTOCOL DESIGN, NOT A LAUNCH PLAN.** No token is launched by this document. No supply, price, or distribution is promised. All parameters below are either (a) structural proposals (how fees/staking/slashing *work*) or (b) explicitly **UNDECIDED** values that Phase 2 tokenomics work and founder approval must set before any testnet token has economic meaning. Testnet tokens, if any, are valueless by design. **§6.8's abstract-unit cost model is not a token model and must not be read as one.**

### 11.1 Design principles (in priority order)

1. **Security budget first:** token issuance + fees must, in steady state, pay for honest validator operation at the Phase 3-derived hardware spec, or the validator set will not be sustainable. If the math does not close, the design must change (fewer validators, lower hardware bar, or different workload) — not be papered over with speculative price assumptions.
2. **Sustainability over speculation:** no mechanism whose primary purpose is price appreciation, no airdrop-farmer farming loop, no "yield" that is paid from new entrants rather than from fees or defined issuance. If a mechanism cannot be explained without assuming new buyers, it is rejected.
3. **Fees reflect real resources:** compute, storage, and bandwidth are priced separately (§4.5) so users pay for what they consume and domains cannot externalise storage bloat onto validators for free. Lock fees and abort fees (§6.8) are part of this principle: locking a shared input is a scarce resource and must be priced, with the price structure (not just the level) decided in Phase 2.
4. **Penalties are attributable and proportionate:** slashing punishes provable protocol violations, not bad luck or slow hardware (§9.4). Vote-without-replay is a protocol violation regardless of outcome (§10.4, invariant 8); with qualifying evidence under §9.5 it belongs in the severe category. Mere abstention for missing data or replay mismatch is not a violation — it is the correct behaviour (§9.5).

### 11.2 Fees

- [Proposed MARWANTA] **Base fee per resource unit:** each resource dimension (compute step, storage byte-write, bandwidth byte) has a protocol base price, adjustable by governance within bounded ranges (bounds [Research Required] — unbounded governance fee changes are a governance-attack vector).
- [Proposed MARWANTA] **Per-domain congestion multiplier:** when a domain approaches its per-block ceiling (§4.5), its fee multiplier rises (mechanism and curve [Research Required]), so congestion is priced *inside* the congested domain, not across the network *at the execution layer*. Base fees for unrelated domains do not rise because one domain is hot — but shared-layer costs (§20) can still rise for all domains under global saturation, and that distinction must be documented, not hidden.
- [Proposed MARWANTA] **Lock and abort fees:** lock-time fees, abort fees with escalation, and lock bonds are structural proposals in §6.8. Their *levels* are UNDECIDED and must be set by re-running the §6.8 model with real tokenomics numbers in Phase 2.
- [Proposed MARWANTA] **Fee distribution:** fees are split between (a) the validators that produced/finalised the block, (b) a protocol treasury (for audits, grants, infrastructure — §11.6), and (c) burning (if adopted — burn fraction **UNDECIDED**). The split is a Phase 2 decision with a sustainability model, not a v0.2 number.
- [Proposed MARWANTA] **Sponsored first transactions (testnet + distribution, §13):** a domain or the protocol may sponsor a user's first transaction(s) up to a capped value, with abuse protection (per-device/account/rate caps, proof-of-humanity *or* domain-funded sponsorship — not a free-for-all faucet that bots drain). Sponsorship is a distribution tool, not a tokenomics pillar, and its cost is borne by the sponsor, not by inflation by default.

### 11.3 Staking, rewards, slashing

- [Proposed MARWANTA] **Staking:** validators bond native tokens; delegators (if delegation is adopted — [Research Required] whether delegation exists at genesis or validators are self-bonded only) bond to a validator and share rewards/penalties proportionally. Delegation, if adopted, must not create a liquid-staking layer at genesis that obscures who controls voting power.
- [Proposed MARWANTA] **Minimum stake:** **UNDECIDED.** It must be low enough to allow independent validators and high enough to make Sybil validator creation uneconomic. The value can only be set after Phase 3 hardware-cost measurements and a decentralisation target (e.g. "at least N independent validators at genesis" — N itself is a founder decision in the Approval Gate).
- [Proposed MARWANTA] **Rewards:** block rewards + fee share, paid per epoch in proportion to voting power and uptime/participation. Reward rate is **UNDECIDED** and must be modelled against validator costs (§9.4), not copied from another chain's APY.
- [Proposed MARWANTA] **Slashing categories (rates UNDECIDED, proportions only, canonical rule §9.5):** downtime (lowest, temporary jailing first) < incorrect vote < vote-without-replay with qualifying evidence under §9.5 (above incorrect vote, below equivocation) < equivocation/double-signing (severe) < provable state-corruption attempt (severe + jailing). Violation status for vote-without-replay does not depend on whether the block turns out correct; slashing requires qualifying evidence (§9.5). Slashed funds go to the treasury or are burned (destination [Research Required] — slashing-to-treasury creates a perverse incentive for the treasury to want slashing; slashing-to-burn avoids it but removes a funding source; this trade-off must be decided explicitly).
- [Proposed MARWANTA] **Unbonding:** a defined period (duration **UNDECIDED**, candidate range to be modelled: days to weeks) during which exiting stake remains slashable for past faults. Too short = long-range risk (§10.2); too long = capital inefficiency that discourages staking.

### 11.4 Supply, inflation, treasury (all UNDECIDED values, structural proposals only)

| Parameter | v0.2 status |
|---|---|
| Total / initial supply | **UNDECIDED** — founder + Phase 2 model must set it. No number is given here deliberately, to avoid anchoring on an invented figure. |
| Inflation / issuance schedule | **UNDECIDED** — structure proposed: issuance, if any, is a defined function of epoch (not discretionary per-block minting), capped, and auditable via the conservation invariant (§10.4). A fixed-supply model (fees only) is a legitimate alternative to be modelled in Phase 2; v0.2 does not pre-commit to inflation. |
| Treasury | [Proposed MARWANTA] A protocol treasury funded by a defined fee share and (if adopted) a defined issuance share, governed by transparent on-chain proposals with timelocks. Treasury spending categories: independent audits, prover/RPC infrastructure grants, developer grants (§13), and incident-response reserves. Treasury must publish all spending; an opaque treasury is a governance failure. |
| Governance | [Proposed MARWANTA] Stake-weighted voting for protocol parameters and treasury spending, with timelocks and supermajority thresholds for critical changes (issuance, slashing rates, consensus upgrades, §20 global-scheduler parameters, §6 settlement parameters). Governance is **not** one-person-one-vote, and that limitation is disclosed. Emergency powers are time-bounded (§10.7). |
| Storage / compute pricing | [Proposed MARWANTA] Separate per-resource pricing (§4.5, §11.2) + state-deposit/rent for long-lived state (model [Research Required] — rent that is too high kills legitimate long-lived apps; rent that is too low subsidises bloat). |

### 11.5 What tokenomics must NOT do

- No pre-mine, insider allocation, or team allocation is proposed in v0.2. If the founder later proposes any allocation, it must be disclosed in full, with vesting and lockups, in a separate tokenomics document — it cannot be smuggled into this spec by omission.
- No token launch, exchange listing, or price target is proposed or promised by this document.
- No mechanism is designed to attract airdrop farmers: testnet activity does not entitle anyone to a future token, and any future distribution, if ever proposed, must be decided on its own merits with anti-Sybil design, not as a growth hack.

---

## 12. Developer ecosystem architecture

**Design rule:** [Proposed MARWANTA] A developer with no founder contact must be able to: read the docs, install the local environment, write a domain, test it deterministically, deploy it to testnet, fund it from the faucet, query it via RPC/indexer, and see it in the explorer — all from public documentation. If any step requires asking the team, that step is a bug in the ecosystem design, to be fixed before public testnet is called ready. **Developer docs must state §5.1 and §4.9 plainly: replay is mandatory for validators, Tier-2 is supplementary, and shared layers are not domain-isolated — a developer who is told otherwise will design against a false model.**

| Component | v0.2 specification |
|---|---|
| Public documentation portal | [Proposed MARWANTA] Versioned docs: protocol spec (this document's successors), domain developer guide, manifest language reference, RPC reference, settlement state-machine reference (§6), global-scheduler reference (§20), and a "how MARWANTA differs and what it does not do" page that repeats the honesty constraints of this spec. Docs are versioned with protocol versions; outdated docs are archived, not silently overwritten. |
| SDKs | [Proposed MARWANTA] Rust-first SDK (matching the WASM-first developer path), with TypeScript/JavaScript SDK for wallets and front-ends as a Phase 6 requirement. SDKs must be open-source, with examples that are tested in CI against the current testnet — untested examples are worse than no examples. |
| RPC infrastructure | [Proposed MARWANTA] Public RPC endpoints run by multiple independent operators (not only the founding team), with a documented RPC API, rate limits, and health status (§13 dashboard). RPC operators are untrusted: clients verify responses against finalised headers where security matters (§7.5). |
| Public testnet | [Proposed MARWANTA] Phase 6 deliverable (§15): public RPC, explorer, faucet, and wallet onboarding, with a published testnet reset policy (testnets may reset; mainnet must not — the distinction must be explicit to users). |
| Testnet faucet | [Proposed MARWANTA] Rate-limited, abuse-protected faucet (§11.2 sponsorship rules apply): per-account/device/IP caps, captchas or equivalent where needed, and a public faucet balance so drain attacks are visible. Faucet tokens are valueless and labelled as such. |
| Block explorer | [Proposed MARWANTA] Explorer shows: blocks, transactions, receipts, domain roots, settlement decisions *and settlement states* (§6.2), lock-table status for contended keys, proof status per batch (VALID / INVALID / MISSING / UNAVAILABLE, §5.5), validator set, and domain manifests. A domain's manifest and its cross-domain capabilities must be visible in the explorer so users can audit what a domain can do before interacting with it. |
| Contract/application templates | [Proposed MARWANTA] Templates for the flagship pattern (§18's flagship is a template candidate) plus basic patterns: single-domain token, single-domain escrow, cross-domain atomic swap (via settlement, not via direct calls). Templates carry security notes and audit status — a template that has not been audited must say so. |
| Local development environment | [Proposed MARWANTA] A local, deterministic, single-node simulator that reproduces consensus ordering, domain execution, settlement (§6 state machine), and receipts without a network. Developers test against the simulator first; testnet is for integration, not for discovering determinism bugs. The simulator must implement §5.1 (replay) and §6 (log-derived settlement) exactly, or it will teach developers a false model. |
| Wallet integration | [Proposed MARWANTA] Wallet support via a standard signing/RPC interface (§10's wallet plan): account model, transaction format, and chain configuration published as a public spec so any wallet can integrate without founder permission. Existing-wallet integration (via standard interfaces) is preferred over a bespoke MARWANTA-only wallet at genesis. |
| Indexer and analytics | [Proposed MARWANTA] An open indexer (events, receipts, domain state, settlement states) with a public API, so explorers, dashboards, and third-party analytics do not depend on a single closed indexer. Indexer data is verifiable against headers/receipts where possible; where it is not, that limitation is documented. |
| Network status dashboard | [Proposed MARWANTA] Public dashboard: validator count and voting-power distribution, finality latency, block height, per-domain load/ceilings, *global scheduler utilisation per resource (§20)*, settlement abort rates by reason code (§6.4), RPC health, and incident status. Dashboard metrics are drawn from multiple sources where feasible, so a single dashboard operator cannot hide a network problem. |
| Developer tutorials | [Proposed MARWANTA] Tutorials that build a real domain end-to-end (including a failure case: what happens when a domain traps, when a settlement aborts, when a budget is exceeded, when a Tier-2 proof is missing) — not only happy-path tutorials. A developer who has only seen happy paths will be surprised by the protocol's actual behaviour. |

---

## 13. Distribution infrastructure plan — integration-first, no grinding dependency

**Founder constraint honoured:** [Proposed MARWANTA] Distribution must **not** depend on daily social-media posting, constant Telegram promotion, SEO grinding, or endless manual community management. The plan below is therefore infrastructure and integration, not content marketing. If this plan cannot attract developers and users without grinding, that is a finding to report honestly, not a reason to secretly add grinding later.

### 13.1 Primary channels (in priority order)

1. **Existing wallet integrations** — [Proposed MARWANTA] Publish the chain configuration and signing spec (§12) so existing wallets can add MARWANTA without bespoke work. Wallet integration is the highest-leverage distribution because it puts MARWANTA where users already are.
2. **Third-party application integrations** — [Proposed MARWANTA] Domains and applications built by independent teams (§12 templates, §18 flagship as a reference) attract their own users; MARWANTA benefits from their users without operating their marketing.
3. **Cross-chain access** — [Proposed MARWANTA] Via established interoperability patterns only (§10.2 bridge rule): IBC-style light-client verification where supported, audited third-party bridges with explicit trust models. No native bridge at genesis.
4. **Infrastructure provider partnerships** — [Proposed MARWANTA] RPC providers, indexers, explorers, and custody providers who run MARWANTA infrastructure independently. Partnerships are infrastructure agreements, not endorsement claims — a provider running a node is not a "partnership" to be announced as adoption.
5. **Developer tooling ecosystems** — [Proposed MARWANTA] SDKs, IDE plugins, and testing tools that make MARWANTA a low-friction choice for a developer who is already building in Rust/WASM.
6. **Technical grants and hackathons** — [Proposed MARWANTA] Grants from the treasury (§11.6) for independent domains and tooling, with public criteria, public recipients, and public deliverables. Grants are not paid for fake activity: a grant that produces no usable domain or tooling is a failed grant, reported as such.
7. **Independent applications that attract users** — [Proposed MARWANTA] The flagship (§18) and any independent domains are the user-attraction layer. The protocol itself does not run user-acquisition campaigns.

### 13.2 Onboarding and attribution infrastructure (to be built, not promised as live)

- [Proposed MARWANTA] **One-click testnet onboarding:** a public web flow (docs + faucet + wallet configuration in one place) that takes a new developer from zero to a deployed testnet domain in a single session, measured by time-to-first-deployment (§12).
- [Proposed MARWANTA] **Embedded wallet support where appropriate:** for applications whose users should not need to install a wallet first, embedded-wallet patterns (with explicit custody/trust disclosure) are a Phase 6/8 option, not a genesis requirement.
- [Proposed MARWANTA] **Sponsored first transactions with abuse protection:** §11.2 rules apply — capped, attributable, sponsor-funded, bot-resistant.
- [Proposed MARWANTA] **Referral attribution:** on-chain or indexer-based attribution for integrations (which wallet, which application, which grant brought a developer/user) so distribution spend can be measured. Attribution must be privacy-respecting (aggregate, not per-user surveillance) and must not be used to pay for fake referrals.
- [Proposed MARWANTA] **Automated technical release announcements:** release notes, protocol upgrade notices, and testnet status updates published automatically from the repository/dashboard (§12), not as manual social-media campaigns. This is the only "announcement" mechanism in v0.2, and it is deliberately boring and factual.
- [Proposed MARWANTA] **Ecosystem activity analytics:** a public dashboard of *real, verifiable* activity — domains deployed, transactions by domain, validators, RPC health, settlement abort rates (§6) — drawn from on-chain data. **No fabricated metrics:** no fake users, no wash transactions, no inflated TVL, no announced partnerships that are merely node operators. If activity is low, the dashboard shows low activity. That honesty is a feature, not a failure to be hidden.
- [Proposed MARWANTA] **Integration partner tracking:** a public registry of integrations (wallet, RPC, indexer, application) with their status (live / in progress / deprecated) and their trust model, so users can see what is real and what is aspirational.

### 13.3 What distribution will NOT do

- No bought followers, fake accounts, vote brigading, wash trading, or incentivised fake transactions. These would destroy the chain's credibility and, for a chain whose thesis is verifiability, would be a direct contradiction of its own value proposition.
- No guarantee of user growth is made in this document or in any derivative marketing. Growth, if it happens, will be measured and reported after the fact.

---

## 14. Benchmark methodology

**Cardinal rule:** [Proposed MARWANTA] Never compare MARWANTA's theoretical maximum throughput with another network's real-world throughput. Every comparison in Phase 3/5 must use the same workload, the same measurement method, and the same disclosure (hardware, network conditions, contention, adversarial conditions) for every system compared. A benchmark that violates this rule is invalid, even if it favours MARWANTA.

### 14.1 Workloads (all workloads are defined before measurement, not chosen after seeing results)

| Workload | Description | Why it matters |
|---|---|---|
| W1 Simple transfer | Single-domain native-token transfers, low contention | Baseline throughput/latency; the workload most chains report, so it is the comparability anchor |
| W2 Single-domain DeFi | Swaps / liquidity operations within one domain, moderate contention on a few hot keys | Tests intra-domain parallelism and hot-state handling |
| W3 Cross-domain settlement | Atomic settlements across 2, 3, and 5 domains (§6) | **The thesis workload.** If MARWANTA is not competitive here, the thesis fails on its own terms |
| W4 Contended hot-state | Many transactions competing for the same key/domain (e.g. a popular auction or mint) | Tests abort rates, lock contention, and fee behaviour under contention — where optimistic systems degrade |
| W5 Spam domain | One domain flooded while other domains run W1/W2 | **The isolation workload.** Measures latency/fee impact on unrelated domains — the fault-isolation claim, tested directly, now against the §4.9 containment table and §21 isolation threshold |
| W6 Adversarial | Byzantine leader (slow/equivocating), 1/3 slow validators, partition-and-heal, lock-griefing domain, mempool flood, gossip amplification (§4.10) | Tests liveness, recovery, and settlement abort behaviour under attack, not just happy-path speed |

### 14.2 Metrics (every metric reported with median, p95, p99, and max — not only the mean or the best run)

- Throughput under each workload (transactions per second, *and* settlements per second for W3, reported separately — conflating them hides settlement cost).
- Median and tail (p95/p99) transaction latency: submit → ordered, ordered → executed, executed → finalised, reported as separate intervals.
- Finality time (per §2.2 definition, not "first confirmation").
- Cost per transaction per resource dimension (§4.5), in native fee units and in validator-resource terms (CPU-ms, storage bytes, bandwidth bytes).
- Validator hardware utilisation: CPU, RAM, disk IOPS, storage growth per day at the measured throughput.
- Network bandwidth per validator (ingress/egress).
- State synchronisation time for a new validator (from snapshot + replay, §7.3).
- Proof generation and verification cost (Tier-2 only): prover time, prover memory, proof size, verifier time, per batch size — reported as a table by batch size, not as a single number. **Proof cost is reported as a light-client/external-verifier cost, not as a validator-finality cost, because validators replay regardless (§5.1).**
- Cross-application settlement latency: prepare → decide → apply, plus abort rate by reason code (logic / deadline / epoch / contention, §6.4), plus lock-hold duration distribution.
- Performance under adversarial conditions (W6): time to recovery, abort rate, and whether any invariant (§10.4) was violated (any violation = benchmark failure, not a performance footnote).
- **New in v0.2:** global-scheduler utilisation per resource (§20), lock-table size, mempool queue depth per domain, and global root computation time per block — the shared-bottleneck metrics without which §20 cannot be validated.

### 14.3 Comparison method (vs. Ethereum, Solana, Aptos, Sui — and others where relevant)

- [Proposed MARWANTA] Comparisons are made on **reproducible test conditions**: the same hardware class, the same workload definitions (adapted only where a chain's model requires it, with adaptations disclosed), the same measurement harness, and the same adversarial conditions. Where a direct comparison is impossible (e.g. a chain's model has no cross-domain settlement equivalent), the comparison is reported as "not comparable on this workload" with an explanation — not forced into a number.
- [Proposed MARWANTA] Published third-party benchmarks (e.g. Sui's or Aptos's lab TPS figures cited in prior-art research) are **not** used as MARWANTA's comparison baseline, because lab conditions do not match live conditions and the harness is not shared. If a third-party figure is cited, it must be labelled with its source, its conditions, and the caveat that it is not directly comparable.
- [Proposed MARWANTA] All benchmark code, workloads, raw results, and hardware/network disclosures are published. A benchmark whose harness is not published is not a benchmark, it is a claim.

### 14.4 Decision criteria that come out of benchmarking (the kill / proceed gates — now cross-referenced to §21)

- **Consensus gate:** HotStuff-2 adaptation proceeds to prototype only if, at n = 64 validators under W1–W3, finality latency and throughput are within the TARGET range set in Phase 2 (TARGET to be set *before* measurement, not after seeing results) and no invariant is violated under W6. If a DAG variant beats it by a *measured, material* margin (margin threshold to be set in Phase 2, e.g. > 2× on W3 finality latency at the same hardware, with no invariant cost) **and** its implementation complexity is judged manageable, a later version may adopt DAG dissemination — otherwise HotStuff-2 stays.
- **Isolation gate:** W5 must show that flooding one domain increases unrelated domains' p99 latency by no more than the Phase 2 threshold (to be set before measurement, and now formalised as a §21 kill criterion) and does not raise their execution-layer fees via the congestion multiplier. If isolation leaks beyond the threshold, the per-domain ceiling design (§4.5) and the global scheduler (§20) must be revised before prototype. **If the leak is in a shared layer that cannot be bounded by scheduling (§20, residual globals), §21's NARROW action applies.**
- **Proof gate:** Tier-2 proofs proceed only if prover cost per settlement batch is below the Phase 2 threshold *and* verifier cost is below the threshold *and* prover decentralisation has a credible path (§5.4). Otherwise Tier 2 is deferred and Tier 1 + replay remains the security base — and, under §5.1, finality is unaffected by that deferral.
- **Hardware gate:** If the Phase 3-derived validator spec requires datacentre-only hardware for the target workload, the target workload or the validator-count ambition must be revised (§7.7) — the spec must not pretend otherwise.
- **Settlement gate (REVISED in v0.3):** W3/W4/W6 settlement results must meet the revised §21 criteria K1-T, K1-P, and K1-C. Termination is judged ONLY in finalised-block terms after quorum recovery (§6.6A, §6.7); a settlement design that terminates boundedly after recovery but aborts most legitimate settlements under normal contention fails this gate, even though it satisfies termination-after-recovery — termination without usability is not success. During a quorum-loss partition, K1-T and K1-C are BLOCKED / INCONCLUSIVE, not passed: frozen settlements are reported separately and excluded from the abort-rate denominator, and a partition test must show 0 spurious commits, 0 spurious aborts, 0 partial diffs, and 100% replay reconstruction after heal (K1-P). Canonical partition rule for this gate: §6.6A bullets C1–C4, identical in §2.5, §3.5, §6.6, §6.7 and §21 — no transition during quorum loss, wall-clock never aborts, abort only on a finalised-block event, termination bound only after recovery.

---

## 15. Development roadmap (Phases 1–9) — updated with v0.2 gates

**Rule for every phase:** a phase is complete only when its exit criteria are met and published, not when its calendar time expires. Rushing a phase to meet a date by skipping its exit criteria is a governance failure, not a speedup. No phase's calendar dates are promised in v0.2 — dates without a team, a budget, and measured Phase 1–3 results would be invented numbers.

| Phase | Work | Exit criteria (must be published) |
|---|---|---|
| **Phase 1 — Architecture Research** | Replace secondary-source prior art (§17) with primary-paper/documentation review; formalise the thesis; verify the §17 matrix cell by cell; identify unresolved risks (§16) | Primary-source prior-art report; thesis statement with falsifiable tests; risk register; v0.5 spec draft if any matrix cell is overturned |
| **Phase 2 — Formal Protocol Design** | Consensus spec (HotStuff-2 adaptation, exact finality rule), execution model, state model, proof system (Tier-1/Tier-2 boundary under §5.1), atomic settlement state machine (§6) + **machine-checked model**, network protocol, threat model (§10), manifest language, global scheduler (§20), tokenomics model (§11, §6.8 with real parameters) | Formal spec document + model-checking setup **and passing model results for §10.4 invariants S1–S5 and §6.7 termination-after-recovery**; invariants stated as checkable properties; all UNDECIDED parameters listed with decision owners; §21 thresholds confirmed by founder |
| **Phase 3 — Simulation** | Consensus simulation, execution simulation, failure injection, adversarial scenarios (§4.10), performance modelling (§14 workloads W1–W6), shared-bottleneck measurements (§20) | Published simulation results + raw data; consensus / isolation / proof / hardware / settlement gates (§14.4) passed or explicitly failed with a revised plan or a §21 ABANDON/NARROW decision |
| **Phase 4 — Prototype** | Minimal validator, transaction processing, domain execution environment, state commitment, basic verification — **only after founder approval of the Phase 2/3 package** | Prototype that passes deterministic-replay tests, settlement atomicity tests, and §5.1 validator-rule tests on a local network; prototype limitations published (what it does NOT do) |
| **Phase 5 — Private Testnet** | Multiple independent nodes (not only founder-run), network failure testing, validator recovery, performance benchmarks (§14) | Private-testnet report: validator count, hardware used, benchmark results, failure-test results, recovery times, settlement abort rates under real contention |
| **Phase 6 — Public Testnet** | Public RPC, explorer, faucet, wallet onboarding, developer portal (§12) | Public testnet live with published reset policy; time-to-first-deployment measured for external developers; bug bounty open (§10.6) |
| **Phase 7 — Security and External Review** | Independent review, formal verification of critical properties, penetration testing, bug-bounty preparation (§10.5) | Published audit reports (full, not summaries); all critical findings fixed + re-tested; formal verification results for §10.4 invariants |
| **Phase 8 — Ecosystem Development** | Flagship application (§18), wallet integrations, developer partnerships, infrastructure integrations (§13) | Flagship live on testnet with measured isolation/proof benefit (not just "deployed"); at least two independent wallet/RPC integrations live |
| **Phase 9 — Mainnet Readiness** | Token economics finalised (§11), governance live, validator decentralisation plan, upgrade process, security audits complete, operational readiness (incident response drilled, §10.7) | **Mainnet readiness checklist, all items green, signed off by founder + independent reviewers.** Mainnet launch is conditional on this checklist — it is not automatic after Phase 8, and it is not a date. |


### 15.1 Phase 2 dependency map (NEW in v0.3, from the 2026-11-01 clarification register)

**Rule, restated from §19.3:** Phase 4 (prototype) must NOT start until Phase 2 formal spec + passing
model-checking results AND Phase 3 published simulation results against founder-confirmed thresholds
are published and founder-approved. This document alone authorises none of that. Simulation cannot
substitute for a formal proof, and a prototype cannot substitute for simulation.

| Item | Unresolved issue | Phase 2 deliverable required | Depends on | Blocks prototype? | Blocks what else? |
|---|---|---|---|---|---|
| A | Machine-checked proof of §6 invariants S1–S5 and §6.7 termination-after-recovery bound (revised K1-T/K1-P) | TLA+ (or equivalent) model, all reachable states explored, termination-after-recovery bound proved under stated assumptions, failures published | Final §6 state machine; §5.1 P0; manifest language (§4.3) for prepare checks; §2 finality rule for finalised-block definitions (§6.6A) | YES — blocks all of Phase 4 per §19.3 | K1 judgement; settlement safety claim; any claim that §6 is "proven safe" |
| B | Deadline, epoch, and finality-lag definitions in finalised-block terms | Exact D, epoch length, view/round timing, finality lag in finalised blocks; §6.6A definitions formalised | §2 consensus spec (HotStuff-2 adaptation, exact finality rule) | YES — blocks settlement prototype (a prototype coded against wall-clock deadlines would implement a different, non-deterministic protocol) | K1-T/K1-P measurement; §6.7 bound |
| C | Tier-2 proof system specification | STARK construction (or chosen alternative), arithmetisation path, provable-VM equivalence argument or decision to use a separate proving VM, aggregation specification, prover decentralisation design | WASM trace study; §5.4 evaluation replaced by primary review (Phase 1) | NO for Tier-1/replay prototype; YES for any Tier-2 feature in a prototype | MAES Mode B private-logic verification; light-client fast sync; any Tier-2 deployment claim |
| D | Manifest language syntax and semantics | Paper prototype of manifest language against at least five realistic app patterns (§4.3), with failure modes documented | Domain model (§4.2); settlement prepare checks (§6.2) | YES — blocks domain prototype (domains cannot be coded without a manifest to enforce) | C1 test; developer experience claim (§4.8) |
| E | Global scheduler parameters | α_r per resource, fair-share weights, redistribution cap k, admission and shedding policy, all with per-resource reasons (§20.2) | §20 capacity model; §4.5 ceilings; Phase 3 measurement plan (initial values may be provisional, but must be stated) | YES for scheduler measurement; a prototype without scheduler parameters cannot be judged against K4 | K4 judgement; W5 interpretation |
| F | Lock and griefing parameters | f_lock scaling (flat vs. value-proportional), bond size and forfeiture attribution rule, abort-fee escalation function, per-domain lock budget (§6.8) | Tokenomics model (§11) with real parameters, not abstract units; attribution by log evidence (§6.4) | YES for settlement-economics testing; NO for pure logic prototype with fees disabled, provided that prototype is labelled as not testing griefing | K1-C abort economics; §6.8 unprofitability claim (abstract model alone does not prove real-world unprofitability) |
| G | Primary-source verification of §17 matrix and C3 narrow-candidate search | Primary-paper/documentation report, cell-by-cell correction log, cited search for C3 joint semantics | Phase 1 research (papers for HotStuff-2, Narwhal/Bullshark, Block-STM, Avalanche, STARK/SNARK, Solana/Sui/Aptos mechanisms) | NO for formal modelling, but YES for any novelty claim in a prototype announcement or paper | v0.4; §18 dossiers; any "genuinely new" upgrade (currently none claimed) |
| H | Founder confirmation of thresholds (revised K1, K2–K6, with §21.1 justifications) | Founder-confirmed (or revised) threshold set, with classification per §21.1, published before Phase 3 judgement | 2026-11-01 register §3 as merged in §21.1; founder risk-tolerance statement | NO for running measurements, YES for passing/failing any Phase 3 gate | All §21 / §14.4 gate judgements; Phase 3 cannot "pass" against unconfirmed thresholds, it can only report numbers |
| I | Validator hardware and cost model | Phase 3-derived hardware spec, operating-cost model, storage-growth and sync-time measurements (§14.2, §20) | Simulation workloads W1–W6; scheduler parameters (E); pruning/archival policy (§7.4) | NO for local prototype, YES for any claim about ordinary-validator feasibility | K4/K5 judgement; mainnet readiness (Phase 9) |
| J | State-tree, snapshot, pruning, networking, VRF decisions | Final choices with reasons: Sparse Merkle baseline vs. alternative, snapshot format/frequency, pruning window, libp2p vs. custom networking, VRF rotation construction (§19.2) | §7 state model; §8 networking design; §2 consensus spec | YES — a prototype coded against undecided stack choices would need to be rewritten, not refined | State sync claim; light-client claim; validator spec |
| K | Quarantine due process and governance triggers | Trigger, quorum, time bound, appeal, and exit path for quarantined domains (§4.7), with confiscation prohibition preserved | Governance design (§10.9); domain model (§4.2) | NO for core settlement prototype; YES for any quarantine feature in a prototype | Domain safety claim; censorship-resistance claim |
| L | MAES Mode B construction (if MAES is to claim private-logic verification) | Proof construction from item C, plus a statement of what is proved and what remains trusted (§5.6A), plus off-chain/on-chain split per workload | Item C; MAES workload definition (§18.6, restated in §5.6A) | NO for MAES atomicity/isolation testing; YES for MAES private-verification claim | Flagship proof claim; any marketing or paper claim about private agent verification |

**Dependency order, in plain terms:** Formal proof (A) depends on consensus finality (B) and manifest (D).
Simulation (Phase 3) depends on formal proof (A), on scheduler parameters (E), on lock parameters (F)
for economics tests, and on founder-confirmed thresholds (H) for judgement — measurements can run
without H, judgements cannot. Prototype (Phase 4) depends on formal proof passing (A), simulation
gates passing or explicitly narrowing (Phase 3), and founder approval of the Phase 2/3 package (§19.3).
Tier-2 deployment depends on proof-system specification (C) in addition to all of the above, and is not
required for Tier-1 prototype authorisation — but Tier-2 must not be presented as available until C is
done. Mainnet readiness (Phase 9) depends on all of the above plus Phase 7 audits, validator
decentralisation evidence (I, K5), and §21 decisions for every criterion.

**Mainnet is conditional, restated:** if any Phase 7 audit finds an unfixed critical issue, if Phase 3/5 benchmarks fail their gates, if §21 kill criteria fire, or if validator decentralisation cannot be demonstrated, mainnet does not launch. A delayed mainnet with a sound protocol is better than an on-time mainnet with a known critical flaw — that preference is a founder-level decision recorded here so schedule pressure cannot quietly override it later.

---

## 16. Technical risks and unresolved questions (updated)

Risks are ranked by (impact × likelihood of blocking the thesis), not by how interesting they are. "Unresolved" means v0.2 does not have an answer — it does not mean the answer is "we will figure it out later" without a Phase assigned. Risks that v0.2 *partially* resolves are marked as such, with the remaining gap named.

### 16.1 Top risks

1. **Cross-domain settlement liveness / deadlock (HIGH, PARTIALLY RESOLVED in v0.2).** [Untested Hypothesis] Two-phase settlement with locks can deadlock or grief under realistic contention. *v0.2 progress:* complete state machine (§6), all-or-none acquisition eliminating hold-and-wait, termination-after-recovery bounded in finalised blocks (§6.7, as corrected in v0.3). *Remaining gap:* machine-checked proof + Phase 3 contention simulation. *If unresolved:* narrow to asynchronous cross-domain messaging only, abandon atomic settlement as a v0 claim (§21, K1).
2. **Proof-system cost and complexity (HIGH).** [Research Required] Proving WASM execution efficiently may require a separate provable VM, doubling implementation and audit surface, or may be too slow/expensive for settlement batches. *v0.2 progress:* §5.1 demotes Tier-2 to supplementary, so proof failure no longer threatens finality — but proof *cost* still determines whether Tier-2 is worth building at all. *Phase to resolve:* Phase 2 (arithmetisation study) + Phase 3 (prover measurements). *If unresolved:* Tier 2 deferred; Tier 1 + replay remains (thesis weakened to "proof-carrying receipts", not validity proofs, §21 K2).
3. **Prover centralisation (HIGH).** [Research Required] If only a few parties can afford to run Tier-2 provers, Tier-2 becomes a centralised dependency *for light-client fast verification* even though Tier-1 replay remains. *Phase to resolve:* Phase 2/3 (prover economics + decentralisation design). *If unresolved:* Tier 2 is not a security dependency, only an optional verifier aid (§21 K2).
4. **Validator decentralisation and security budget (HIGH).** [Research Required] If honest validator costs exceed rewards at a realistic token/fee level, the set centralises to subsidised operators. *Phase to resolve:* Phase 3 (hardware costs, §20) + Phase 2 (tokenomics model) + Phase 5 (real validator cost survey). *If unresolved:* mainnet parameters must change (lower hardware bar, different workload, or no mainnet yet, §21 K5).
5. **Shared-bottleneck leakage (HIGH, NEWLY QUANTIFIED AS A RISK in v0.2).** [Untested Hypothesis] Even with per-domain ceilings, shared consensus, root computation, disk, and propagation leak congestion chain-wide (§4.9, §20). *Phase to resolve:* Phase 3 (W5/W6 + §20 measurements). *If unresolved beyond the §21 threshold:* narrow the thesis (fewer domains per chain, lower per-block caps, or async-only cross-domain work, §21 K3/K4).
6. **WASM determinism drift (MEDIUM-HIGH).** [Research Required] Runtime upgrades, host-function changes, or compiler differences can break determinism across validators. *Phase to resolve:* Phase 2 (pinned runtime spec) + Phase 4 (differential testing across implementations). *Mitigation:* replay tests on every upgrade (§10.9).
7. **Manifest expressiveness vs. auditability (MEDIUM).** [Research Required] A manifest language too narrow blocks real apps; too expressive becomes unauditable. *Phase to resolve:* Phase 2 (paper prototyping against five real app patterns, §4.3).
8. **Governance capture / quarantine abuse (MEDIUM).** [Research Required] Stake-weighted governance and quarantine powers can be abused to censor a domain. *Phase to resolve:* Phase 2 (quarantine due process, §4.7; governance thresholds, §11). *If unresolved:* quarantine power must be narrowed (e.g. domain self-pause only + time-bounded emergency halt) before mainnet.
9. **Bridge / cross-chain trust (MEDIUM).** [Prior Art] Bridges are the highest-loss surface historically. *Mitigation in v0.2:* no native bridge at genesis (§10.2). *Residual:* any third-party bridge integration still carries its own trust model, which must be disclosed per integration.
10. **State growth and storage economics (MEDIUM).** [Research Required] Without effective rent/deposit/pruning, state bloat raises validator costs and centralises validation over time. *Phase to resolve:* Phase 2 (rent model) + Phase 3/5 (growth measurements, §20).
11. **Team and execution risk (HIGH, non-technical but decisive).** [Research Required] A Layer-1 of this scope requires distributed-systems, cryptography, and security expertise over multiple years, plus independent audit funding. A specification, however good, does not create that team or budget. The founder must assess this risk separately from the technical thesis — a sound thesis with no resourced team is still not a mainnet plan. This risk is listed here so it is not hidden behind technical discussion. (§21 K6 covers the complexity/audit-burden form of this risk.)

### 16.2 Unresolved questions (must be answered in Phase 1–3, with owners)

- Exact HotStuff-2 adaptation: finality rule, view-change details, timeout adaptation, VRF rotation construction.
- Manifest language: syntax, expressiveness, static-analysis tooling.
- Settlement parameters: prepare deadline D, lock granularity, lock quota/budget, abort fee escalation, bond forfeiture attribution, dependency-graph validation (now with §6 state machine as the starting point, not a sketch).
- State tree: Sparse Merkle baseline confirmation vs. alternative; snapshot format and frequency.
- Proof system: STARK-first confirmation, arithmetisation path, prover decentralisation, aggregation depth — under the §5.1 supplementary-only rule.
- Tokenomics: supply, issuance, minimum stake, slashing rates, fee split, treasury governance, rent model, lock/abort fee levels from §6.8 with real numbers.
- Networking: libp2p vs. custom stack, gossip/rate-limit parameters, bootstrap diversification.
- Global scheduler (§20): fair-share weights, redistribution caps, admission-control thresholds, load-shedding policy.
- Validator decentralisation target: minimum independent validator count at each phase, and how it is measured (not just claimed).
- Flagship scope: which real-world settlement pattern (§18) is built first, and what measured benefit would prove it.
- Machine-checked proofs: TLA+ (or equivalent) models for consensus, settlement (§6), and the §5.1 validator rule — existence, not just intention, is the Phase 2 exit criterion.

---

## 17. Prior-art comparison and novelty matrix — REBUILT in v0.2 (founder issue 5)

**Reading note and evidence limit (do not skip):** This matrix is built from v0.1 secondary-source research (§0, evidence limits) plus the founder's v0.1 review correction. It is a *starting matrix for Phase 1 to verify against primary sources*, not a final verdict. Where a cell says "verify in Phase 1", the claim is provisional. No TPS figure in this matrix is presented as a comparable benchmark — see §14 for why lab figures are not used as baselines.

**Classification rule (founder's rule, applied strictly):** a combination of existing mechanisms is **Engineering Combination**, not an invention, however useful the combination may be. **Genuinely New Candidate** requires a specific mechanism with no prior-art equivalent and an explanation of why no equivalent exists. If nothing qualifies, the matrix must say so. v0.2 says so: **no row in this matrix is classified Genuinely New on current evidence.** The strongest defensible claim is a novel *composition* (one shared-security chain + domain isolation + settlement-only cross-domain work + tiered supplementary proofs) whose value is untested — and a composition claim is not an invention claim. Any future claim of genuine novelty must name the specific mechanism, cite the Phase 1 primary-source search that found no equivalent, and survive the §18 dossier test.

### 17.1 Feature-by-feature matrix: what each chain does, what MARWANTA proposes, classification

| Feature | Ethereum (L1) | Solana | Aptos | Sui | Polkadot | Cosmos | MARWANTA v0.2 (proposed) | Classification for MARWANTA |
|---|---|---|---|---|---|---|---|---|
| Isolated execution | [Prior Art] Shared EVM state; contracts share one state space, gas market, and reentrancy surface | [Prior Art] Shared state; Sealevel parallelism via declared accounts, not a fault boundary | [Prior Art] Shared state; Block-STM re-executes conflicts, does not isolate faults | [Prior Art] Owned objects structurally independent; shared objects contend via consensus | [Prior Art] Parachains: separate chains, separate execution, shared security via relay chain | [Prior Art] Zones: separate chains, separate execution, no shared security | Domain-isolated deterministic WASM (§4), per-domain namespace, sandbox, manifest — but shared consensus/root/storage remain global (§4.9) | **Engineering Combination** — WASM sandboxing + namespaces + parachain-style isolation idea, combined inside one chain. No new isolation primitive is named. |
| Capability manifests | [Prior Art] No protocol-level capability manifest; access control is contract code (allow-lists, roles) | [Prior Art] Declared read/write accounts are scheduling hints, not capability enforcement; program-derived addresses constrain, but not a general manifest | [Prior Art] Move resource types + module access control; not a cross-domain capability manifest | [Prior Art] Object ownership + capabilities as objects; capability-like, but object-scoped, not domain-manifest-scoped | [Prior Art] Parachain validation + XCM permissions; not a per-application manifest enforced by the runtime | [Prior Art] Module-level permissions in Cosmos SDK; not a general manifest | Machine-checkable manifest (state + call + resource + proof-tier + upgrade authority, §4.3) enforced by the runtime at execution time, with trap on violation | **Engineering Combination** — OS capability systems + Solana declarations + Move capabilities, combined and made protocol-enforced. The *combination* (manifest + settlement-only calls + namespace) is the proposal; no single manifest primitive is shown to be without prior art. |
| Resource ceilings (per-domain) | [Prior Art] Single gas market; block gas limit is global, not per-application | [Prior Art] Compute units + local fee markets (per-account congestion pricing, verify in Phase 1) — closest prior art to per-domain ceilings | [Prior Art] Gas per transaction; no per-application block ceiling | [Prior Art] Gas + storage fund/rebate concepts (verify in Phase 1); no per-application block ceiling | [Prior Art] Parachain block / PoV size limits are per-chain, not per-application inside a chain | [Prior Art] Per-zone gas limits; no shared-chain per-application ceiling | Per-domain per-block ceilings in three independent dimensions (compute/storage/bandwidth, §4.5) + global scheduler (§20) | **Engineering Combination** — OS quotas/cgroups + Solana local fee markets + per-chain limits, combined inside one chain with a global scheduler. Demoted from v0.1 I4 "innovation" (see Appendix C). |
| Execution receipts | [Prior Art] Transaction receipts (status, gas used, logs) + state roots; receipts are not hash-chained per application | [Prior Art] Transaction status/logs; no per-application receipt chain | [Prior Art] Transaction outputs + events; no per-application receipt chain as a protocol object | [Prior Art] Transaction effects (created/mutated/deleted objects); no per-application receipt chain | [Prior Art] Parachain block validation proofs; not per-application receipts | [Prior Art] Per-zone tx results; no cross-zone receipt chain | Hash-chained receipts per domain and per block, root-committed in header (§5.3), with declared vs. actual read/write sets and resource use | **Engineering Combination** — Ethereum-style receipts + hash-chaining + domain scoping. Receipts themselves are prior art; domain-scoped hash-chaining is a combination, not a new primitive. |
| Tiered validity proofs | [Prior Art] L1: full replay. L2s: STARK (Starknet) / SNARK (zkSync, Polygon) validity proofs for rollup batches — proving is the L2's security, not supplementary | [Prior Art] No native per-tx validity-proof layer at L1; replay is the base | [Prior Art] No native per-tx validity-proof layer at L1; replay is the base | [Prior Art] No native per-tx validity-proof layer at L1; replay is the base | [Prior Art] Relay-chain validation of parachain blocks (validity via validators, not ZK proofs as the base) | [Prior Art] No native validity-proof layer; IBC light-client proofs are for messages, not execution validity | Tiered rule (§5): receipts always, replay mandatory for finality, Tier-2 validity proofs supplementary only for settlement batches / light-client sync, with an explicit non-use list (§5.5) | **Engineering Combination** — validity proofs (prior art) + replay (prior art) + a *policy* (tiering rule) for when to use each. The tiering rule is a design policy, not a new cryptographic mechanism. Demoted from v0.1 I2 "innovation" (see Appendix C). **Note the v0.2 correction:** v0.1's tiering could be misread as proof-substitutes-for-replay; v0.2's tiering explicitly forbids that, which makes it *less* novel than a proof-based validation design, not more — and that is the honest trade. |
| Atomic cross-domain settlement | [Prior Art] Atomic within a block via shared state (single execution context); cross-chain atomicity only via bridges (not atomic by default) | [Prior Art] Atomic within a transaction via declared accounts; cross-chain via bridges | [Prior Art] Atomic within a block via serial-equivalence (Block-STM) | [Prior Art] Atomic within a transaction for shared objects via consensus; cross-chain via bridges/IBC-style messaging | [Prior Art] XCM messaging under shared security (async patterns; verify XCMP completeness in Phase 1) — messaging, not two-phase atomic commit across parachains as a general primitive | [Prior Art] IBC messaging (async, not atomic across chains by default) | Two-phase, log-derived, all-or-none settlement (§6): all-or-none lock acquisition, prepare, decide+apply in one block, deadline + epoch abort, reason-coded refunds | **Engineering Combination** — classic two-phase commit (distributed databases, [Prior Art]) + BFT ordered log + domain locks. The *application* of 2PC to domain settlement on one BFT chain is a combination; 2PC itself, BFT ordering, and locks are all prior art. Demoted from v0.1 I3 "innovation" (see Appendix C). The specific joint semantics (no hold-and-wait + epoch abort + decide+apply atomicity) are a candidate for Phase 1 novelty search, but are **not** claimed as genuinely new in v0.2 until that search is done. |
| Shared settlement (one security set, one global commitment) | [Prior Art] Single chain, single state root, shared security by definition | [Prior Art] Single chain, single state root | [Prior Art] Single chain, single state root | [Prior Art] Single chain, single state root (object store) | [Prior Art] Relay chain provides shared security + shared finality for parachains — the closest prior art to MARWANTA's shared settlement | [Prior Art] No shared settlement across zones (each zone finalises its own chain; IBC does not share finality) | One validator set, one global root over domain roots, one finality rule for all domains (§7, §2) | **Established Prior Art** — shared security and a single global commitment are the default for single chains and for Polkadot's relay model. MARWANTA adapts them to domains; it does not invent them. |
| State commitments | [Prior Art] Merkle Patricia Trie; Verkle migration researched, not yet adopted at L1 (verify in Phase 1) | [Prior Art] Merkle-based accounts state | [Prior Art] Merkle-based (Jellyfish Merkle Tree lineage, verify in Phase 1) | [Prior Art] Object store with authenticated commitments (verify details in Phase 1) | [Prior Art] Relay + parachain state roots | [Prior Art] IAVL Merkle tree per zone | Per-domain Sparse Merkle roots → global Merkle root (§7.1); Verkle as future candidate only | **Established Prior Art, adapted** — two-level Merkle roots over sub-roots are prior art (Polkadot relay/parachain roots, sharded state designs). Demoted from v0.1 I5 "innovation" (see Appendix C). |
| Consensus approach | [Prior Art] Gasper (LMD-GHOST + Casper FFG), probabilistic-then-economic finality | [Prior Art] Proof-of-History + Tower BFT | [Prior Art] AptosBFT (HotStuff lineage) + Raptr (verify in Phase 1) | [Prior Art] Narwhal/Bullshark → Mysticeti (DAG, verify current version in Phase 1) | [Prior Art] Relay-chain BFT (BABE/GRANDPA lineage, verify current in Phase 1) | [Prior Art] CometBFT/Tendermint per zone | HotStuff-2 lineage adaptation, deterministic BFT finality (§2) — explicitly NOT new | **Established Prior Art (adaptation)** — no novelty claimed, in v0.1 or v0.2. |
| Parallel / conflict-aware execution | [Prior Art] Sequential EVM at protocol level | [Prior Art] Sealevel declared-set parallelism | [Prior Art] Block-STM optimistic parallelism | [Prior Art] Owned-object fast path; shared objects via consensus | [Prior Art] Parallel parachain execution under relay validation | [Prior Art] Parallel zones (no shared execution) | Parallel across domains, declared-set within domain, sequential fallback on conflict (§4.4); no optimistic cross-domain parallelism | **Engineering Combination** — Sealevel-style declarations + domain parallelism (parachain-style) inside one chain. No new scheduling primitive is claimed. |
| Light-client verification | [Prior Art] Header + Merkle inclusion proofs; L2 light verification via validity proofs | [Prior Art] Header + account proofs; optimistic confirmation + finality | [Prior Art] Header + state proofs | [Prior Art] Header + object proofs; DAG certificates | [Prior Art] Relay-chain headers + parachain proofs | [Prior Art] IBC light clients per zone | Header QC + domain proof + global proof (§7.5); Tier-2 proof as an *additional* check only (§5.6) | **Established Prior Art** — inclusion proofs and header QC verification are standard. The only MARWANTA addition is the two-level (domain + global) proof structure, which follows from the two-level state root (prior art, adapted). |
| Data availability | [Prior Art] Full replication at L1 + blobspace/DAS research | [Prior Art] Full replication (Turbine propagation) | [Prior Art] Full replication | [Prior Art] Full replication for consensus txs | [Prior Art] Relay-chain availability + erasure-coded parachain data (verify in Phase 1) | [Prior Art] Full replication per zone | Full replication + DA gate before finality vote (§5.8, §7.6); DAS as research candidate only | **Established Prior Art** — full replication is the default baseline; the DA gate (vote only if data held) is a policy enforcement of that baseline, not a new DA mechanism. |

### 17.2 What the matrix proves, and what it does not

- **What it proves (on current evidence):** every MARWANTA feature in §17.1 has a prior-art analogue, and every MARWANTA "difference" is a combination, adaptation, or policy choice over prior art. v0.2 therefore makes **no genuine-novelty claim**. That is not a failure of the design — combinations can be valuable — but it is a correction of v0.1's framing, in which five dossiers were presented as "innovations" without the combination-vs-invention distinction being applied strictly.
- **What it does not prove:** that no genuinely new mechanism exists in the design. A Phase 1 primary-source search could, in principle, find that a specific joint mechanism — the most promising candidate is the §6 joint semantics (all-or-none canonical-order lock acquisition + log-derived decide+apply in one block + epoch abort + reason-coded idempotent refunds, applied to domain settlement under one BFT finality rule) — has no equivalent in any deployed or published system. Until that search is done and cited, that candidate remains **a candidate for investigation, not a claim**. v0.4 must either cite the search and upgrade the candidate with evidence, or drop it.
- **What this comparison does NOT show:** it does not show MARWANTA outperforming any chain on any metric, because MARWANTA has no measurements yet. A table that showed MARWANTA "winning" on TPS or finality in v0.2 would be fabrication. The comparison's purpose is to locate MARWANTA's *structural* difference (domain isolation + tiered supplementary proofs + atomic settlement on one shared-security chain) and to name the chains whose mechanisms MARWANTA borrows, adapts, or deliberately rejects — so Phase 1 can check whether that structural difference is actually new, or whether an existing chain already occupies it.

### 17.3 Legacy comparison (retained from v0.1, with v0.2 corrections)

| Dimension | Ethereum (L1) | Solana | Aptos | Sui | Cosmos (SDK zones) | Polkadot (parachains) | Avalanche | MARWANTA v0.2 (proposed, corrected) |
|---|---|---|---|---|---|---|---|---|
| Execution model | [Prior Art] Sequential EVM (protocol order) | [Prior Art] Sealevel declared-set parallel | [Prior Art] Block-STM optimistic parallel | [Prior Art] Object model: owned-object fast path; shared objects via consensus | [Prior Art] Sovereign chains, each with its own execution | [Prior Art] Parachains execute independently, validated by relay chain | [Prior Art] C-Chain EVM (Snowman++), X-Chain UTXO DAG, P-Chain coordination | [Proposed MARWANTA] Domain-isolated deterministic WASM; parallel across domains, declared-set within domain (§4) |
| Fault isolation | [Prior Art] Shared global state; one contract's bug/congestion can affect others | [Prior Art] Shared state; hot programs congest shared fee/compute market | [Prior Art] Shared state; Block-STM contains conflicts by re-execution, not by fault boundary | [Prior Art] Owned objects structurally independent; shared objects still contend | [Prior Art] Strong isolation (separate chains) but no shared security | [Prior Art] Strong isolation (separate chains) + shared security via relay chain | [Prior Art] L1s/subnets give isolation per chain, with Primary Network coordination | [Proposed MARWANTA] Hard domain boundary **at execution only** + per-domain budgets/ceilings; shared layers are DEGRADED/CHAIN-WIDE (§4.9, §20) |
| Consensus | [Prior Art] Gasper | [Prior Art] Proof-of-History + Tower BFT | [Prior Art] AptosBFT (HotStuff lineage) | [Prior Art] Narwhal/Bullshark → Mysticeti (DAG, verify in Phase 1) | [Prior Art] CometBFT/Tendermint per zone | [Prior Art] Relay-chain BFT (BABE/GRANDPA lineage, verify in Phase 1) | [Prior Art] Snowman/Snowman++ probabilistic finality | [Proposed MARWANTA] HotStuff-2 lineage adaptation, deterministic BFT finality (§2) — NOT a new consensus |
| Cross-app / cross-chain atomicity | [Prior Art] Atomic within a block via shared state; cross-chain via bridges | [Prior Art] Atomic within a transaction via declared accounts; cross-chain via bridges | [Prior Art] Atomic within a block via serial-equivalence | [Prior Art] Shared-object txs via consensus; cross-chain via bridges/IBC-style | [Prior Art] IBC messaging (async, not atomic across chains by default) | [Prior Art] XCM messaging under shared security (async patterns; verify XCMP completeness in Phase 1) | [Prior Art] Cross-L1 via bridges / Teleporter-style messaging where adopted | [Proposed MARWANTA] Two-phase atomic settlement for cross-domain txs on one chain (§6, complete state machine); cross-chain via established patterns only, no native bridge at genesis |
| Proof / verifiability | [Prior Art] Full replay by validators; L2 validity proofs inherit L1 security | [Prior Art] Full replay; no native per-tx validity-proof layer at L1 | [Prior Art] Full replay; no native per-tx validity-proof layer at L1 | [Prior Art] Full replay; no native per-tx validity-proof layer at L1 | [Prior Art] Full replay per zone; IBC light-client proofs for messages | [Prior Art] Relay-chain validation proofs for parachain blocks | [Prior Art] Full replay; subsampling-based finality proofs | [Proposed MARWANTA] Tiered, **supplementary only**: receipts always + replay mandatory for finality, validity proofs only for settlement batches / light-client sync (§5) |
| State commitment | [Prior Art] Merkle Patricia Trie; Verkle researched, not yet adopted at L1 (verify in Phase 1) | [Prior Art] Merkle-based accounts state | [Prior Art] Merkle-based (Jellyfish lineage, verify in Phase 1) | [Prior Art] Object store with authenticated commitments (verify in Phase 1) | [Prior Art] IAVL Merkle tree per zone | [Prior Art] Relay + parachain state roots | [Prior Art] Merkle-based per chain | [Proposed MARWANTA] Per-domain Sparse Merkle roots → global Merkle root (§7); Verkle as future candidate only |
| Data availability | [Prior Art] Full replication at L1 + blobspace/DAS research | [Prior Art] Full replication (Turbine) | [Prior Art] Full replication | [Prior Art] Full replication for consensus txs | [Prior Art] Full replication per zone | [Prior Art] Relay-chain availability + erasure-coded parachain data (verify in Phase 1) | [Prior Art] Full replication per chain | [Proposed MARWANTA] Full replication baseline **+ DA gate before finality vote** (§5.8); DAS as research candidate only (§7.6) |
| Developer experience | [Prior Art] Solidity/EVM: largest tooling base | [Prior Art] Rust/Anchor, declared accounts (steeper learning curve) | [Prior Art] Move: resource-safety, smaller ecosystem | [Prior Art] Move (object variant): ownership model, smaller ecosystem | [Prior Art] Cosmos SDK/Go: appchain tooling, sovereignty complexity | [Prior Art] Substrate/Rust: powerful, high complexity | [Prior Art] EVM-compatible C-Chain (easy migration) + custom L1 tooling | [Proposed MARWANTA] Rust/WASM + manifest; "no consensus knowledge required" rule (§4.8) — untested until Phase 6 measures time-to-first-deployment |
| Decentralisation / security trade-off | [Prior Art] Large validator set, high decentralisation, lower throughput at L1 | [Prior Art] High throughput, higher validator hardware bar (centralisation pressure — debated, verify with current data in Phase 1) | [Prior Art] High throughput, HotStuff validator set (size/hardware to verify in Phase 1) | [Prior Art] DAG throughput, validator hardware/data demands to verify in Phase 1 | [Prior Art] Sovereignty = each zone must bootstrap its own security | [Prior Art] Shared security solves bootstrapping, relay-chain governance is central | [Prior Art] Subsampling scales validator count, probabilistic finality trade-off | [Proposed MARWANTA] TARGET (untested): ordinary-server validators (§7.7, §20) + shared security; decentralisation target is a founder decision, not a claim |

---

## 18. Novelty claims with evidence and limitations — REWRITTEN in v0.2 (founder issue 5)

**Scope rule (corrected):** No dossier below is claimed as a genuine invention in v0.2. Consensus is **not** in this list (it is an adaptation, §2). The WASM runtime is **not** in this list (it is prior art, §4.6). STARKs/SNARKs are **not** in this list (they are prior art, §5.4). The five v0.1 "innovations" are retained as *dossiers* — because their benefits, limitations, attack surfaces, and tests still need to be documented — but each is reclassified in §17.1 and here as **Engineering Combination** (or, for I5, Prior Art adapted), with the demotion recorded in Appendix C. If Phase 1 primary review finds a specific mechanism with no equivalent, that mechanism — and only that mechanism — may be upgraded to Genuinely New Candidate in v0.5, with the search cited.

**Template applied to every dossier:** prior art → proposed difference → technical explanation → expected benefit → known limitations → attack surface → test method → success criteria. **A dossier that fails its success criteria is demoted or narrowed (§21), not defended.**

### Dossier C1 (formerly I1) — Domain-isolated execution with enforceable capability manifests — ENGINEERING COMBINATION

- **Prior art:** [Prior Art] Solana declared accounts + Sealevel parallelism; Sui object ownership; Polkadot parachain isolation; Cosmos sovereign zones; OS-style capability systems and WASM sandboxing in general (not blockchain-specific).
- **Proposed difference (combination, not invention):** [Proposed MARWANTA] Isolation enforced *inside one chain* by a protocol-level manifest (state + call + resource capabilities) that the runtime enforces per execution, combined with per-domain state namespaces and per-domain resource ceilings. Unlike Solana, the boundary is a fault/congestion boundary *at execution*, not just a scheduling hint. Unlike Polkadot/Cosmos, there is no separate chain or validator set per domain. Unlike OS capabilities, the manifest is enforced by a BFT-replayed runtime, not by a kernel.
- **Technical explanation:** See §4.2–§4.5 and §4.9. A domain's code runs in a WASM sandbox against its own namespace; any access outside its manifest traps; any cross-domain effect goes through settlement (§6), never through a direct write. Shared layers are not isolated by this dossier (§4.9).
- **Expected benefit:** [Untested Hypothesis] A failing, congested, or malicious domain degrades itself at execution, not unrelated domains' execution, while still allowing atomic cross-domain work under shared security.
- **Known limitations:** Manifests add developer friction and audit surface; coarse manifests block legitimate composability, fine manifests become unauditable; isolation does not fix bugs *inside* a domain; shared consensus/state-tree/storage layers can still leak congestion (§4.9, §20); domain splitting can evade per-domain ceilings (§4.10, scenario A6).
- **Attack surface:** Manifest bypass via runtime bug; manifest confusion (two domains with overlapping grants); manifest upgrade rug-pull (mitigated by timelock, §4.3); griefing via manifest-legal but wasteful accesses within a domain's own budget.
- **Test method:** Phase 3 W5 (spam domain) + manifest-violation fuzzing (random unmanifested accesses must trap, never succeed) + Phase 6 developer study (can developers express five real app patterns in manifests without help?) + §4.9 containment measurements (which layers actually degraded in W5?).
- **Success criteria:** W5 shows unrelated-domain p99 latency degradation below the §21 isolation threshold *at execution*, and the §4.9 table's DEGRADED/CHAIN-WIDE rows are measured, not assumed; manifest fuzzing shows zero bypasses in the tested corpus; developer study shows ≥ 4/5 patterns expressible without founder contact. Failure of any criterion narrows C1 (see §21 K3).

### Dossier C2 (formerly I2) — Tiered proof-carrying: receipts always, validity proofs only where they earn their cost, supplementary only — ENGINEERING COMBINATION (policy)

- **Prior art:** [Prior Art] Starknet/SHARP validity proofs and recursive aggregation; zkSync/Polygon SNARK validity proofs; Ethereum receipts and state roots; light-client inclusion proofs; full replay as the L1 base on every chain in §17.
- **Proposed difference (combination + policy, not invention):** [Proposed MARWANTA] A *tiered* rule built into the protocol, not left to applications: Tier 1 receipts for every transaction, mandatory replay for finality (§5.1), Tier 2 validity proofs supplementary only for cross-domain settlement batches and (if proven) light-client fast sync, with an explicit non-use list (§5.5) where ZK is forbidden as wasteful. Most "ZK chains" either prove everything (expensive) or prove nothing at L1; MARWANTA's claim is the tiering *policy* and its cost discipline, not the proof system itself — and, in v0.2, the policy is explicitly *less* ambitious than a proof-based validation design, because it refuses to let proofs substitute for replay.
- **Technical explanation:** See §5.2–§5.8. Receipts are hash-chained and root-committed; validity proofs are batched and recursively aggregated where that measurably lowers verifier cost; replay remains the base (§5.1) and the fallback.
- **Expected benefit:** [Untested Hypothesis] Light clients and external verifiers can perform a supplementary fast check of settlement correctness without full replay, subject to proof soundness and quorum trust (§5.6A, Mode A/B), without paying prover costs on every transaction, and without any risk that a proof bug rewrites finality. They cannot independently prove private logic correctness without replay or a specified Mode B proof.
- **Known limitations:** Tiering adds protocol complexity (two verification paths to audit, plus proof-status tracking); receipt trust depends on quorum + replay availability; STARK prover cost may still exceed benefit for small batches; aggregation can hide constituent failures if not designed with attribution (§5.7); prover centralisation degrades light-client fast verification (§5.4).
- **Attack surface:** False receipt signed by Byzantine validator (mitigated by quorum + replay, not by receipt alone); proof-system bug (§10.2, corrected impact: light-client only, not finality); prover centralisation/censorship for Tier-2 (contained by §5.1); aggregation that obscures a failed batch (mitigated by per-constituent status commitment, §5.7).
- **Test method:** Phase 2 arithmetisation study; Phase 3 prover measurements by batch size (§14.2); light-client verification tests (can a light client verify a settlement batch from header + proof alone, and does it correctly reject a tampered proof? A pass here does NOT establish private-logic verification — see §5.6A); §5.1 validator-rule tests (does a validator that votes without replay get detected?).
- **Success criteria:** Prover + verifier costs below Phase 2 thresholds for the flagship settlement workload; light-client tests pass with zero false accepts in the tested corpus; prover decentralisation has a credible Phase 2 design (not just "provers will decentralise"). Otherwise Tier 2 is deferred (§5.4) — and finality is unaffected, which is the point of the §5.1 rule.

### Dossier C3 (formerly I3) — Two-phase atomic settlement over a BFT ordered log (deterministic coordinator, no trusted third party) — ENGINEERING COMBINATION, with a narrow candidate for Phase 1 search

- **Prior art:** [Prior Art] Two-phase commit in distributed databases (classic 2PC); Cosmos IBC packet acknowledgement (async, not atomic across chains); Polkadot XCM (messaging under shared security, async patterns); Ethereum atomicity via shared-state single-block execution.
- **Proposed difference (combination, not invention, on current evidence):** [Proposed MARWANTA] Atomicity for *cross-domain* work on *one* chain, where the coordinator is a deterministic state machine replicated by every validator from the ordered log — not a database coordinator, not a bridge multisig, and not shared-state atomicity by accident of being in the same block. Domains prepare against locked snapshots and the settlement decision itself is consensus-finalised. The v0.2 additions that make this a *complete* specification rather than a sketch are: all-or-none canonical-order lock acquisition (§6.3), decide+apply atomicity in one block (§6.5), deadline + epoch abort (§6.6), and reason-coded idempotent refunds (§6.4) — each of which is itself prior art in some form (2PC, deterministic state machines, epoch boundaries, idempotency keys), combined here.
- **Narrow candidate for Phase 1 search (NOT a claim):** the *joint* semantics — all-or-none canonical-order acquisition + log-derived decide+apply in one block + epoch abort + reason-coded idempotent refunds, applied to domain settlement under one BFT finality rule — may have no equivalent in a deployed or published system. Phase 1 must search for it explicitly. If an equivalent is found, C3 remains Engineering Combination. If none is found after a cited search, v0.4 may upgrade *this joint semantics only* (not "settlement" in general) to Genuinely New Candidate, with the search cited and the mechanism specified precisely enough to be falsified.
- **Technical explanation:** See §6.2–§6.8 in full. Prepare (locks + diff commitments) → Decide+Apply in one block (all prepared = COMMIT, else ABORT) → terminal state, with termination bounded only in finalised-block terms after quorum recovery (§6.7, as corrected in v0.3).
- **Expected benefit:** [Untested Hypothesis] Cross-domain workflows (e.g. the flagship in §18.6) can be atomic without giving up domain isolation, and without trusting a bridge or a coordinator server.
- **Known limitations:** Lock contention, abort rates under contention, and griefing (§6.5, §6.8); settlement latency is at least two consensus steps, so it will be slower than single-domain execution — atomicity is bought with latency; complex dependency graphs may be hard for developers to express correctly; commit liveness is not unconditionally bounded (§6.7).
- **Attack surface:** Lock-griefing; lock-table exhaustion; settlement-ID replay/splitting; decide-entry duplication/conflict; coordinator state-machine bug (a bug here breaks atomicity for all cross-domain work — this is the highest-severity code path in the design); timeout manipulation; epoch-boundary manipulation (mitigated by deterministic epoch abort, §6.6).
- **Test method:** Phase 2 formal state machine + model checking (all reachable states, no partial-commit state reachable, termination bound proven); Phase 3 W3/W4/W6 simulations (abort rates, lock-hold durations, griefing profitability under §6.8); Phase 4 prototype settlement tests including timeout, partition, epoch, and crash/restart cases.
- **Success criteria:** Model checking finds no reachable partial-commit state and proves the §6.7 termination bound; W3 settlement latency and abort rates meet §21 thresholds; W6 shows no invariant violation (§10.4, invariant 2) and bounded recovery time. Failure on any criterion narrows C3 to async messaging only (§21 K1).

### Dossier C4 (formerly I4) — Per-domain resource ceilings with independent compute / storage / bandwidth metering (congestion isolation) — ENGINEERING COMBINATION

- **Prior art:** [Prior Art] Ethereum gas (single-dimensional, shared fee market); Solana compute units + local fee markets (per-account congestion pricing, verify details in Phase 1); Sui storage fund / storage rebate concepts (verify in Phase 1); classic OS cgroups / resource quotas (non-blockchain); per-chain limits in Polkadot/Cosmos.
- **Proposed difference (combination, not invention):** [Proposed MARWANTA] Three *independent* resource dimensions, each with a per-domain per-block ceiling, enforced at the protocol level, *plus* a global scheduler (§20) that bounds aggregate load — so a domain's congestion cannot raise another domain's *execution-layer* fees or latency. Unlike a single gas market, a compute spike does not price out storage users in another domain, and vice versa, *at execution*.
- **Technical explanation:** See §4.5 and §20. Compute (WASM fuel), storage (write + growth/deposit), bandwidth (bytes) are metered separately; each domain's block share is capped; excess waits, it does not borrow; the global scheduler caps aggregate admission and redistributes unused capacity only within a capped bound.
- **Expected benefit:** [Untested Hypothesis] Predictable costs for unrelated domains during a viral event in one domain, and a fairer cost model (users pay for the resource they actually scarce).
- **Known limitations:** Three-dimensional pricing is more complex for wallets and developers to explain; ceiling parameters can be gamed (e.g. splitting a domain into many domains to evade ceilings — §4.10 scenario A6); shared layers (consensus, state-tree updates, disk, propagation) can still leak congestion (§4.9, §20) — ceilings alone do not solve them, which is why §20 exists.
- **Attack surface:** Ceiling evasion via domain splitting; metering mismatch (cheap-in-fee, expensive-in-reality operations, §10.2); fee-market manipulation via self-congestion to raise a domain's own multiplier (harms only that domain, but can be used to grief that domain's users); global-scheduler gaming (a domain that consistently underuses its share to accumulate redistribution credit — mitigated by non-accumulating fair-share accounting, §20).
- **Test method:** Phase 3 W5 (spam domain) measuring unrelated-domain latency/fees *and* §20 shared-layer metrics; metering calibration tests (fee cost vs. measured validator CPU/disk/bandwidth per operation); domain-splitting evasion analysis in Phase 2.
- **Success criteria:** W5 passes the §21 isolation gate; metering calibration shows fee-to-real-cost ratio within the Phase 2 tolerance band for the tested operations; no ceiling-evasion path is found in Phase 2 analysis that is not mitigated by §20's global cap. Otherwise ceilings are revised or the claim is narrowed (§21 K3/K4).

### Dossier C5 (formerly I5) — Per-domain state roots aggregated into a single global root (attributable, domain-provable state) — ESTABLISHED PRIOR ART, ADAPTED

- **Prior art:** [Prior Art] Merkle Patricia / Sparse Merkle / Jellyfish Merkle state commitments; Polkadot parachain state roots validated by the relay chain; Ethereum single global state root; sharded state designs with sub-roots aggregated into a global root.
- **Proposed difference (adaptation, not invention):** [Proposed MARWANTA] The global root is explicitly a Merkle root *over domain roots*, not a flat global trie, applied to domains inside one chain. This makes state faults attributable to a domain, allows domain-scoped inclusion proofs without revealing other domains, and allows a domain's state to be snapshotted, audited, or (in future) proven independently.
- **Technical explanation:** See §7.1–§7.2. Domain root per domain subtree; global root over domain roots in deterministic domain-ID order; block header commits to both (global root in header, domain-root list in block body or its root).
- **Expected benefit:** [Untested Hypothesis] Faster fault attribution, cleaner light-client proofs for domain-scoped queries, and a cleaner path to future domain-scoped validity proofs (C2) without restructuring state.
- **Known limitations:** Two-level proofs are slightly larger than flat proofs for global queries; domain-root list management adds block-body complexity; cross-domain queries need two proofs (domain + global) instead of one; root recomputation remains a shared-layer cost (§4.9, §20).
- **Attack surface:** Domain-root ordering confusion (mitigated by deterministic ordering); domain-root omission (mitigated by header/body validation — a block missing a domain root is invalid); snapshot forgery (mitigated by root verification, §7.3).
- **Test method:** Phase 2 state-model spec + proof-size measurements (domain proof + global proof vs. flat proof, by domain count); Phase 4 prototype state-root tests (tampered domain state must change exactly that domain's root and the global root, and must be detected by replay).
- **Success criteria:** Proof sizes within Phase 2 tolerance; tamper tests pass with zero missed detections; snapshot verification tests pass. Otherwise the two-level structure is simplified to a flat structure with domain namespacing only. **This dossier is not a novelty claim in v0.2, and its success or failure does not affect the thesis's novelty — because it never had any.**

### 18.6 Flagship application candidate — ONE, not a list of demos (unchanged in intent, clarified in v0.2)

**Candidate: MARWANTA Agent Escrow & Settlement (MAES) — autonomous-agent escrow across domains, with proof-carrying atomic settlement.**

- **What it is:** [Proposed MARWANTA] A settlement pattern (implemented as domains + a template, §12) where autonomous agents (e.g. a buyer agent, a seller agent, and an independent verifier agent) transact across three domains — payment, escrow, and verification/identity — in a single atomic settlement. The buyer agent's payment is locked in the payment domain, the escrow domain holds the release condition, and the verifier domain attests to delivery/quality. The settlement either releases payment + records verification + closes escrow together, or aborts all three together with a refund, with a Tier-1 receipt (and, for high-value settlements, a supplementary Tier-2 validity proof for light-client/external verification, where available) that a third party can check, in Mode A terms (§5.6A), for finalisation, receipts root, domain roots, and decide entry — while still trusting the validator quorum, and WITHOUT any claim of independent private-logic verification.
- **Why it genuinely needs MARWANTA's thesis (and why it is not an empty demo):** (a) *Fault isolation at execution:* if the verifier agent's domain is buggy, malicious, or congested, it must not drain the payment domain or halt unrelated domains' execution — the settlement aborts, funds return, and other domains continue *at execution* (shared-layer degradation, §4.9, still applies and must be measured). On a shared-state chain, a verifier bug that reenters or congests shared state can cascade. (b) *Proof-carrying (supplementary, Mode A only in v0.3):* an agent's counterparty (or a human auditor) needs to check, without trusting the executing agent alone, that a quorum finalised the settlement with matching receipts and roots — exactly the Tier-1 receipt + supplementary Tier-2 batch proof use case (§5.6, §5.6A). This does NOT verify the agent's private strategy code independently, and it does NOT prove any off-chain attestation true. A Mode B private-logic check is a future criterion only, after Phase 2 specifies the proof construction (§5.6A). (c) *Atomicity:* a payment released without verification, or verification recorded without payment, is a real financial loss, not a UI bug — so atomic settlement (§6) is load-bearing, not decorative.
- **Why it could fail (falsification conditions):** If Phase 3 shows cross-domain settlement latency or abort rates make agent escrow unusable for realistic agent workloads, or if agents can achieve the same guarantees more simply on an existing chain via a trusted escrow contract, MAES does not prove MARWANTA's advantage and must not be presented as proof. MAES is a *test* of the thesis, not evidence for it until it is measured. **In v0.2 terms: MAES tests C1 + C3 + C2 together; it does not test a genuine invention, because v0.2 claims none.**
- **What MAES is NOT:** It is not a DeFi demo, not a token, not a gaming demo, and not a claim of agent users or volume. No agent, user, or transaction numbers are claimed for MAES in v0.2.

- **Narrowed success criteria (v0.3 — replaces any earlier private-logic criterion):** MAES passes only if it shows (i) 0 partial settlements under fault injection, (ii) execution-layer isolation as in (a) above with shared-layer degradation measured separately (§4.9, §20), (iii) Mode A auditor checks (finalisation, receipts root, domain roots, decide entry) passing without trusting the executing agent alone, while still trusting the validator quorum, and (iv) refund correctness (aborted settlements return escrowed value in the same block as the abort decision, with no double refund on replay). MAES does NOT pass on private-logic verification, private execution from validators, or off-chain attestation correctness in v0.3, because none of those is available (see §5.6A). The earlier criterion requiring "verification without replaying private logic" is withdrawn and replaced by the Mode A check above, plus a separate, explicitly future criterion: Mode B private-logic verification becomes testable only after Phase 2 specifies the proof construction, at which point it is tested as a new criterion, not backdated as a v0.3 capability.


**Deliberately not chosen as flagship (to avoid empty-demo inflation):** a generic DEX, a generic NFT mint, or a generic "hello world" domain — all three can be built on any chain and would prove nothing about isolation or proofs, so building them as "ecosystem" would inflate numbers without testing the thesis.

---

## 19. Approval Gate — what the founder must approve, what remains undecided, what Phase 2/3 must resolve before any coding (REVISED in v0.2; updated in v0.3)

### 19.1 Founder approval required (no coding until ALL of these are explicitly approved)

1. **Thesis scope:** Proof-Carrying, Fault-Isolated Execution as defined in §0–§4, *as corrected by §4.9 and §20* (isolation at execution only; shared layers bounded, not eliminated), with the honesty constraints (no beating-Ethereum/Solana claim, no invented numbers, no unaudited mainnet, no genuine-novelty claim on current evidence).
2. **Canonical proof rule (§5.1):** Replay mandatory for finality; Tier-2 supplementary only; Tier-2 never substitutes for replay, never overrides replay disagreement, never cures data withholding. A validator that votes without replay is in protocol violation.
3. **Consensus choice:** HotStuff-2 lineage adaptation (§2) as the v0.2 base, explicitly NOT a new consensus protocol, with DAG and Avalanche variants deferred to Phase 3 simulation (§14.4 gates).
4. **Settlement model:** Complete §6 state machine (all-or-none canonical-order acquisition, decide+apply in one block, deadline + epoch abort in finalised-block terms, reason-coded idempotent refunds), including its latency cost, termination-after-recovery bounded only in finalised-block terms after quorum recovery (not bounded commit, and not termination during a quorum-loss partition — §6.6A, §6.7), and lock-griefing economics in abstract units (§6.8) — with machine-checked proof still required (§6.7).
5. **Domain model:** Per-domain namespaces, capability manifests, and per-domain resource ceilings (§4), plus the §4.9 containment table and the §20 global scheduler, including quarantine due process (§4.7) as a governance risk to be designed in Phase 2.
6. **Tokenomics posture:** Preliminary only (§11) — no token launch, no supply/price promise, no insider allocation proposed in v0.2. Lock/abort fee *levels* remain undecided; only their structure (§6.8) is approved, if at all, in v0.2.
7. **Roadmap and mainnet conditionality:** Phases 1–9 (§15) with mainnet conditional on Phase 7 audits + Phase 9 readiness checklist + §21 kill criteria not firing, not on a date.
8. **Flagship:** MAES (§18.6) as the single flagship candidate to be tested, not as a proven advantage, and not as evidence of novelty.
9. **Kill criteria (§21, §21.1):** The founder must confirm (or revise) the threshold values in §21, with the justification and classification for every threshold in §21.1. Until thresholds are founder-confirmed, Phase 3 cannot pass or fail a gate against them — it can only measure and report. No threshold may be changed after measurement to turn a fail into a pass without a v0.5 revision, founder re-approval, and a re-run (see §21.1).
10. **Finality rule (§2.2A):** TWO-CHAIN as formally defined in §2.2A (QC(B) + direct child B' in view v+1 with QC(B')), with voting and lock rules, consecutive-view requirement, and finality lag in finalised views/blocks — and the explicit acknowledgement that the HotStuff-2 proof does not automatically transfer to the adapted protocol.
11. **Slashing rule (§9.5):** ONE consistent rule — vote-without-replay is a violation regardless of outcome; slashing additionally requires qualifying evidence (E1/E2/E3); abstention for missing data or replay mismatch is correct behaviour, not a violation.
12. **Settlement partition rule (§6.6A, bullets C1–C4):** identical in §2.5, §3.5, §6.6, §6.7, §14.4 and §21 — no transition during quorum loss, wall-clock never aborts, abort only on a finalised-block event, termination bound only after recovery.
13. **Domain-isolation scope and §20.5 parameters:** isolation at execution only; shared layers bounded, not isolated; every §20.5 parameter value UNDECIDED / RESEARCH REQUIRED until Phase 3 measurement; no numeric isolation or degradation bound is claimed in v0.4.

### 19.2 Explicitly undecided (founder + Phase 2 must decide; v0.2 does not pretend otherwise)

- Token supply, issuance/inflation, minimum stake, slashing rates, fee split, burn fraction, treasury governance thresholds, unbonding period.
- Block time / view duration, epoch length, validator-count target, per-validator hardware spec (to be derived from Phase 3 measurements, §20).
- Exact proof system (STARK construction, arithmetisation path, aggregation depth, prover decentralisation design) — Tier-2 is supplementary, so this decision does not block finality, but it does block Tier-2 deployment.
- State-tree final choice (Sparse Merkle baseline vs. alternative), snapshot format/frequency, pruning window.
- Manifest language syntax, settlement parameters (prepare deadline D in finalised blocks, lock granularity/quota/budget, abort fee escalation, bond forfeiture attribution), VRF rotation construction, networking stack (libp2p vs. custom).
- Block time / view duration in finalised-block terms, epoch length in finalised blocks, and finality lag in finalised blocks (NOT seconds) — required to state any settlement latency bound (§6.6A).
- Global scheduler parameters (§20): fair-share weights, redistribution caps, admission thresholds, load-shedding policy.
- Whether delegation exists at genesis; whether a native bridge is ever built (v0.2 answer: not at genesis).
- Machine-checked proof results for §6 and §5.1 (not yet existent — see register, unresolved sub-item (a)).
- Slashing challenge parameters (bound in finalised blocks, challenger bond, repeat-failure count, replay-intermediate format, replay-evidence quorum threshold), penalty rates, jailing durations, and appeal window (§9.5) — UNDECIDED, Phase 2.
- Every §20.5 parameter value, per-resource alpha_r, fair-share weighting, and root-cost coefficients — UNDECIDED / RESEARCH REQUIRED, Phase 3 measurement.
- Finality lag in finalised views/blocks and its seconds equivalent (block/view duration undecided) — UNDECIDED, Phase 2.
- Equivalence between MARWANTA's consecutive-view two-chain formulation and HotStuff-2's double-certificate commit step, and a safety proof for the adapted protocol — UNRESOLVED, Phase 2.

### 19.3 What Phase 2 and Phase 3 must resolve before any coding (coding gate, strengthened in v0.2)

Phase 4 (prototype) must **not** start until **all** of the following are published and founder-approved:

- Phase 2 formal spec + **passing** model-checking results for consensus, settlement (§6, invariants S1–S5, termination-after-recovery bound), and the §5.1 validator rule. A model that has not been run, or that fails, blocks Phase 4 — it does not get "noted for later".
- Phase 3 published simulation results for §14 workloads W1–W6, including §20 shared-bottleneck measurements and §4.10 adversarial scenarios, measured against founder-confirmed §21 thresholds.
- A §21 decision for each criterion: PASS (proceed), NARROW (proceed in the narrowed scope stated in §21), or ABANDON (stop the thesis). "Proceed with more complexity to defend a failing criterion" is not an available outcome.

If any gate fails, the correct action is to revise the spec (v0.4) and re-simulate — not to start coding around a failed gate and hope the prototype fixes it.

**Phase 2 dependency gate (summary — full map in §15.1).** Phase 4 is blocked until: (A) the
machine-checked proof of S1–S5 and the termination-after-recovery bound passes; (B) D, epoch
length, and finality lag are fixed in finalised-block terms; (C) is done for any Tier-2 feature
(not required for a Tier-1/replay prototype); (D) manifest language is paper-prototyped; (E) and
(F) scheduler and lock parameters are stated; (G) primary-source verification is done before any
novelty claim; (H) thresholds in §21.1 are founder-confirmed before any Phase 3 gate judgement;
(I) validator hardware/cost is measured before any ordinary-validator claim; (J) state-tree,
snapshot, networking, and VRF choices are fixed before prototype code is written against them;
(K) quarantine due process is designed before any quarantine feature; and (L) MAES Mode B is
specified before any private-verification claim. Dependency order: proof (A) depends on finality
(B) and manifest (D); simulation depends on proof (A) + scheduler (E) + lock parameters (F) +
confirmed thresholds (H) for judgement; prototype depends on passing proof + passing simulation
gates + founder approval of the Phase 2/3 package. No item in this list is authorised by v0.3
itself; each requires its own published deliverable and, where stated, founder approval.


### 19.4 What this document authorises, and what it does not

- **Authorises:** founder review of this spec; Phase 1 primary-source research (including the §17 matrix verification and the §18 narrow-candidate search); Phase 2 formal specification work (on paper / in specification tooling, not production code) including model checking; Phase 3 simulation design.
- **Does NOT authorise:** production code, prototype code, a repository, a testnet, a token, a mainnet, a bridge, a partnership announcement, or any public claim that MARWANTA outperforms Ethereum, Solana, or any other chain, or that MARWANTA contains a genuine invention. Any such work requires a separate, explicit founder approval after the Phase 2/3 gate above.

---

## 20. Shared-bottleneck capacity and allocation model — NEW in v0.2 (founder issue 4)

**Purpose:** §4.5 per-domain ceilings bound a domain's *execution share*. This section models whether that is enough — and, in general, it is not — for the shared resources that every validator pays for every block, regardless of which domain caused the load. The model is symbolic: capacities are variables, not measured numbers, because Phase 3 has not measured them. A symbolic model that admits its unknowns is more honest than a numeric model with invented constants.

### 20.1 Definitions

For each resource `r` in {CPU, memory, disk IOPS, bandwidth, consensus capacity, global state-update capacity}:

- `G_r` = global capacity of one validator for resource `r` per block window (e.g. CPU-ms per block, IOPS per block, bytes per block). `G_r` is a validator property, measured in Phase 3, not a protocol constant — different validators have different `G_r`, and the binding `G_r` is that of the weakest validator that must still keep up, not the average.
- `C_{d,r}` = per-domain ceiling for domain `d` on resource `r` per block (§4.5). By design, `C_{d,r} ≤ G_r` for every `d`, but in general `Σ_d C_{d,r} >> G_r` (many domains, each with a generous ceiling, sum to far more than one validator can do). **This inequality is the whole problem: per-domain ceilings alone do not bound global load.**
- `A_{d,r}(block)` = actually admitted load from domain `d` on resource `r` in a block, after the global scheduler (§20.2).
- `U_r(block) = Σ_d A_{d,r}(block)` = total admitted load. The safety requirement is `U_r(block) ≤ α_r · G_r` for every `r`, where `α_r < 1` is a safety factor (headroom for replay variance, root computation, and bursts — Phase 2 sets `α_r`, e.g. by leaving headroom, not by using 100% of capacity).
- `F_{d,r}` = fair share of domain `d` on resource `r` per block (e.g. `G_r / N_active_domains`, or weighted by stake, deployment deposit, or recent legitimate use — weighting is a Phase 2 decision with its own gaming analysis, §20.3).

### 20.2 Global scheduler — what is required, in addition to per-domain ceilings

[Proposed MARWANTA] A block is valid only if, for every resource `r`, `U_r(block) ≤ α_r · G_r` *and* for every domain `d`, `A_{d,r}(block) ≤ C_{d,r}`. The leader (and, on replay, every validator) must enforce both constraints; a block that violates either is invalid, even if its transactions are individually valid. Enforcement is by the global scheduler, which operates in this order per block:

1. **Reserve:** reserve capacity for consensus-critical, non-domain work first: header/QC processing, root computation for the previous block's commitments, and epoch-transition work. This reserve is *not* available to domains, so domain load cannot starve consensus bookkeeping.
2. **Fair-share admission:** admit each domain's transactions up to `min(C_{d,r}, F_{d,r})` for every `r`, in consensus order, skipping (not reordering) transactions that would exceed either bound. Skipped transactions wait for a later block; they are not dropped silently (mempool retention rules, §8, apply).
3. **Capped redistribution:** if, after fair-share admission, unused capacity remains (`U_r < α_r · G_r`), redistribute it to domains with queued work, but cap any single domain's redistributed total at `min(C_{d,r}, k · F_{d,r})` for a cap factor `k` (Phase 2 sets `k`, symbolic here; `k` must be finite and small — unbounded redistribution recreates the single-domain-takes-all problem). Redistribution credit does **not** accumulate across blocks: a domain that underuses its share in one block does not bank credit for a later burst (accumulating credit is a gaming vector, §18 C4).
4. **Backpressure:** when a domain's mempool queue exceeds its per-domain cap (§8), the validator sheds load for that domain first: it stops gossiping that domain's new transactions, evicts that domain's lowest-fee queued transactions first, and signals backpressure to RPC peers for that domain. Backpressure is per-domain, not global — but see §20.3: backpressure signalling itself consumes bandwidth, so it is rate-limited.
5. **Load shedding (last resort):** if, despite (1)–(4), a block would exceed `α_r · G_r` (e.g. because a single domain's transactions are individually large, or because root computation for the block is unexpectedly expensive), the leader must truncate the block (omit the transactions that would exceed the bound, in consensus order, without reordering the remainder) rather than produce an oversized block. A validator that receives an oversized block rejects it. Load shedding degrades the omitted domains' latency for that block; it does not halt the chain, and it must be recorded (which domains were shed, and why) in the block's scheduler record for audit.

**Why the scheduler must be deterministic and replayable:** admission decisions affect which transactions are in a block and therefore affect the state root. If the leader's scheduler used local, non-deterministic state (e.g. its own mempool contents, which differ per validator), replay would diverge (§5.1). The scheduler therefore operates *only* on the ordered transaction list for the block and on protocol parameters (ceilings, fair shares, caps) that are themselves in the finalised log or in protocol constants — never on a validator's private mempool state. A transaction that is in the leader's mempool but not in the ordered list is not scheduled; a transaction in the ordered list is scheduled by the deterministic rule above, or skipped by that rule, identically by every validator on replay.

### 20.3 Per-resource table: global exposure, mitigation, and what remains global

| Resource `r` | How one domain can exhaust it despite ceilings | Global scheduler / mitigation in v0.2 | Remaining global exposure (stated plainly) |
|---|---|---|---|
| CPU (execution + replay) | Flood with compute-heavy txs up to its ceiling; WASM compilation / metering overhead per domain | Per-domain compute ceiling (§4.5) + global CPU cap `α_CPU · G_CPU` + fair-share admission (§20.2) + deterministic metering | **Residual DEGRADED:** every validator still replays every domain's txs (§5.1), so total CPU is the sum over all domains. One domain at its ceiling still consumes a large fraction of every validator's CPU in that block; other domains' txs in the same block compete for the remaining CPU. CPU is not domain-isolated. |
| CPU (global root computation) | Write many keys / deep trie paths, forcing expensive root recomputation for the whole block | Per-domain write ceiling + incremental root updates + domain-root caching (§7) + reserve for root work (§20.2 step 1) | **Residual GLOBAL:** root computation is a single global step per block. Its cost is driven by the *total* changed subtree, and a pathological write pattern from one domain inflates it for all validators. Root cost cannot be partitioned by domain without separate roots per domain *and* separate finality per domain — i.e. without separate chains. |
| Memory (mempool, lock table, state cache) | Flood mempool, create many locks, bloat state cache with hot keys | Per-domain mempool queue + cap, per-domain lock budget + global lock cap (§6.8, §20.2), state-cache eviction by domain | **Residual DEGRADED:** mempool, lock table, and cache live in shared validator memory. A domain at its caps still occupies memory that other domains' queues could use; under total memory pressure, eviction affects all domains' cache hit rates. |
| Disk IOPS (WAL, state DB writes) | High write rate, many small writes, state bloat forcing random I/O | Per-domain storage ceiling + write batching + global write scheduler (admit writes up to `α_IOPS · G_IOPS` per block window, queue the rest) | **Residual GLOBAL (queueing):** the WAL and state DB are single shared devices. IOPS queueing is shared: one domain's write burst raises write latency for all domains' commits in the same window, even if total IOPS are capped — capping bounds the *amount*, not the *queueing delay* for a validator with slow disk. |
| Bandwidth (gossip + block propagation) | Large txs, gossip amplification, large blocks (§4.10 A5) | Tx/block size limits, per-peer rate limits, per-domain gossip quota, hash-referenced payloads (§8) | **Residual GLOBAL:** block propagation is global. A block that is large because of one domain delays every validator's receipt of that block and therefore delays the next vote for all domains. Bandwidth per validator is a single pipe, not per-domain pipes. |
| Consensus capacity (ordering, voting, QC processing) | Fill blocks with its own txs, forcing other domains to wait; spam proposals/votes as a Byzantine validator | Per-domain tx-count share per block (enforced at ordering: a block violating a domain's share is invalid) + global block-size cap + QC aggregation (O(n) happy path, §2) | **Residual GLOBAL:** consensus processes one ordered log for all domains. Ordering capacity, vote processing, and finality latency are shared. A domain that fills its share still consumes consensus slots that could have gone to others in the same block; other domains wait for the next block (DEGRADED, bounded by share, not eliminated). |
| Global state-update capacity (root + snapshot + index) | Rapid state churn forcing frequent root updates, snapshot invalidation, indexer reprocessing | Incremental roots, epoch-boundary snapshots only (§7), indexer batching | **Residual GLOBAL:** the global root, the snapshot, and the indexer view are single global artefacts. Churn from one domain increases update work for all consumers of those artefacts. Indexer lag caused by one domain's churn delays explorer visibility for all domains (access degradation, not finality degradation — but user-visible). |

### 20.4 What the model proves, and what it does not

- **What it proves (as a design argument):** per-domain ceilings are *necessary but not sufficient* for global safety. Without a global scheduler enforcing `U_r ≤ α_r · G_r` for every `r`, a set of domains each within its ceiling can still exceed a validator's capacity (`Σ C_{d,r} >> G_r`). With a global scheduler, aggregate load is bounded, but *distribution* within the bound is still a policy choice (fair share vs. capped redistribution, §20.2), and that policy has its own gaming analysis (§20.3, §18 C4).
- **What it does not prove:** that any particular `G_r`, `C_{d,r}`, `F_{d,r}`, `α_r`, or `k` is correct, feasible, or sufficient — those are Phase 3 measurements (§14, §20.1). Until they are measured, §20 is a *structure* for measurement, not a measurement result. A later version that fills in numbers without Phase 3 data would be inventing benchmarks.
- **Plain statement of what remains global even after all mitigations in v0.2:** consensus ordering and finality, block propagation, global root computation, the write-ahead log / state DB queue, the settlement log, and epoch transitions. These cannot be made domain-isolated on a single chain without giving each domain its own chain and its own finality — i.e. without abandoning the shared-security thesis. The honest v0.4 claim is therefore **bounded global degradation, UNMEASURED, enforced (once parameterised) by the global scheduler and measured in Phase 3 using §20.5**, not isolation of shared layers. No numeric degradation bound is claimed in v0.4. If Phase 3 shows that bounded degradation still exceeds the §21 threshold, the §21 NARROW action (fewer domains, lower caps, async-only cross-domain work) applies — the response is not to add another ceiling layer and hope.

---

### 20.5 Parameter table — limits and measurable parameters (NEW in v0.4)

**Status.** This table is the canonical parameter list for shared-layer limits. Every current value is UNDECIDED / RESEARCH REQUIRED. No value in this table is a claim, a target measured in any test, or a number to be quoted as a MARWANTA limit until Phase 3 measures it. Where a parameter cannot yet be defined measurably, the row says so and states what Phase 2 definition work is required. A future version that fills in a value without Phase 3 data would be inventing a benchmark, and is forbidden by §14.

**How to read the table.** Unit = the unit in which the parameter will be stated once fixed. Current value = UNDECIDED for every row in v0.4 (Phase 2 may propose initial values for simulation, but a simulation input is not a protocol limit until founder-confirmed and measured). Measurement method = the Phase 3 workload(s) and metric that will fill the value in. Claim NOT made = the specific claim that must not be made until the value is measured.

| Parameter | Unit | Current value (v0.4) | Phase 3 measurement method (workload, metric) | Claim NOT made until measured |
|---|---|---|---|---|
| Global capacity G_CPU (execution + replay) | CPU-ms per finalised block window, per validator (weakest validator that must keep up, §20.1) | UNDECIDED / RESEARCH REQUIRED | W1–W6: validator CPU utilisation per block, median/p95/p99/max, by domain and total; replay CPU separated from consensus CPU | No claim that any TPS figure fits ordinary-validator CPU; no claim that replay cost is bounded by any number |
| Global capacity G_MEM (memory) | Bytes (mempool + lock table + state cache), per validator | UNDECIDED / RESEARCH REQUIRED | W5/W6: peak and p99 memory per validator, mempool queue depth per domain, lock-table size | No claim that mempool/lock-table pressure is bounded by any number |
| Global capacity G_IOPS (WAL / state DB) | IOPS per finalised block window, per validator | UNDECIDED / RESEARCH REQUIRED | W1–W6: WAL fsync latency and state-DB IOPS per block, p99/max, queueing delay | No claim that disk queueing delay for unrelated domains is bounded by any number |
| Global capacity G_BW (bandwidth) | Bytes per second, ingress + egress per validator | UNDECIDED / RESEARCH REQUIRED | W1–W6: gossip + block-propagation bytes per validator per second, block-propagation time | No claim that block propagation delay is bounded by any number |
| Global capacity G_CONS (consensus capacity) | Ordered transactions / votes processed per finalised block window; QC processing time per block | UNDECIDED / RESEARCH REQUIRED | W1–W6 at n = 4, 16, 64, 128 (§2.2): vote/QC processing time, finality lag in finalised views | No claim about consensus throughput or finality latency in seconds |
| Global capacity G_ROOT (global state-update capacity) | Root-computation CPU-ms per finalised block | UNDECIDED / RESEARCH REQUIRED | W1–W6: root time per block vs changed keys / changed subtrees / domain-root count (see root formula below) | No claim that root cost is bounded by any number |
| Per-domain ceiling C_{d,r} (each r: CPU, memory, IOPS, bandwidth, consensus share, state-update share) | Same units as G_r, per domain per finalised block | UNDECIDED / RESEARCH REQUIRED | W5: admitted load per domain vs ceiling, spillover to other domains' latency/fees | No claim that any ceiling value contains a domain's shared-layer impact |
| Fair share F_{d,r} and weighting rule | Same units as G_r, per domain per finalised block; weighting rule is a definition, not a number | UNDECIDED / RESEARCH REQUIRED — weighting (equal vs stake vs deposit vs recent use) is itself undecided, with gaming analysis required in Phase 2 | W5: admitted load under each candidate weighting, gaming scenarios (§18 C4) | No claim that any fair-share rule is fair or gaming-resistant |
| Safety factor alpha_r (each r) | Dimensionless fraction, 0 < alpha_r < 1 | UNDECIDED / RESEARCH REQUIRED (per-resource values required; a single alpha for all resources is not assumed) | W1–W6: utilisation U_r / G_r distribution; headroom needed to avoid timeouts/truncation at each candidate alpha | No claim that 80% or any other alpha is safe for any resource |
| Redistribution cap k | Dimensionless multiplier on fair share (cap = min(C_{d,r}, k · F_{d,r})) | UNDECIDED / RESEARCH REQUIRED | W5: single-domain share under redistribution vs k; spillover to other domains | No claim that redistribution is bounded by any number |
| Reserve for consensus / root / epoch work (step 1, §20.2) | Same units as G_r, per finalised block, reserved before domain admission | UNDECIDED / RESEARCH REQUIRED | W1–W6: consensus/root/epoch work per block, p99/max, vs reserve | No claim that consensus bookkeeping cannot be starved by domain load |
| WAL / DB IOPS cap (global write scheduler) | IOPS per finalised block window (alpha_IOPS · G_IOPS) | UNDECIDED / RESEARCH REQUIRED | W1–W6: write IOPS admitted vs queued, write latency p99 for unrelated domains | No claim that write queueing delay is bounded by any number |
| Write batching policy | Batch size (writes per batch) and batch window (finalised blocks) — definition UNDECIDED | UNDECIDED / RESEARCH REQUIRED — batching policy definition is Phase 2 work; no policy is assumed | W1–W6: IOPS and latency with vs without batching, by batch size | No claim that batching solves disk queueing |
| Snapshot frequency | Finalised blocks between snapshots (epoch-boundary only in v0.3 §7 — frequency in blocks UNDECIDED) | UNDECIDED / RESEARCH REQUIRED | Phase 3 sync test: new-validator sync time vs snapshot frequency and state size | No claim about sync time |
| Pruning window | Finalised blocks of history retained by a full validator (beyond snapshots) | UNDECIDED / RESEARCH REQUIRED | Phase 3: storage growth per day vs pruning window, replayability within window | No claim that replayability is preserved for any stated window until tested |
| State-root method: incremental vs full recomputation | Method choice (proposed: incremental + domain-root caching, §7/§20.3) | PROPOSED, not measured — method choice is Phase 2 work; incremental benefit is UNTESTED | W1–W6: root time incremental vs full, by changed keys and domain count | No claim that incremental roots reduce root cost by any factor |
| Domain-root caching policy | Cache size (domain roots retained) and eviction rule — definition UNDECIDED | UNDECIDED / RESEARCH REQUIRED | W1–W6: cache hit rate vs root time, by domain count and write pattern | No claim that caching bounds root cost |
| Root cost formula | Cost_root(block) = O(N_domain_roots + sum of changed-subtree nodes) — symbolic, not measured; full-recomputation cost = O(total state size) as the comparison baseline | SYMBOLIC ONLY — coefficients and the changed-subtree constant are UNDECIDED / RESEARCH REQUIRED | W1–W6: fit root time against N_domain_roots and changed-subtree size; report coefficients, not just the formula shape | No claim that root cost follows any numeric formula until coefficients are fitted |
| Block-size cap | Bytes per finalised block | UNDECIDED / RESEARCH REQUIRED | W1–W6: propagation time and validator CPU vs block size | No claim that any block size propagates within any time bound |
| Per-peer rate limit | Bytes per second and/or messages per second per peer (unit choice itself UNDECIDED in Phase 2) | UNDECIDED / RESEARCH REQUIRED | W6 gossip-amplification test: amplification multiplier vs rate limit | No claim that amplification is capped by any multiplier |
| Per-domain gossip quota | Bytes / messages per second per domain, per peer | UNDECIDED / RESEARCH REQUIRED | W5/W6: gossip share per domain vs quota, spillover to other domains | No claim that gossip is domain-isolated |
| Transaction-size limit | Bytes per transaction | UNDECIDED / RESEARCH REQUIRED | W1–W6: large-tx impact on propagation and replay vs limit | No claim that any tx size is safe |
| Per-domain mempool cap and global mempool cap | Transactions and/or bytes, per domain and globally, per validator | UNDECIDED / RESEARCH REQUIRED | W5: eviction and delay for unrelated domains vs caps | No claim that mempool pressure is bounded by any number |
| Global lock-table cap | Locks (domain,key) pairs, globally per finalised block window | UNDECIDED / RESEARCH REQUIRED | W4/W6: lock-table size vs contention, memory, and abort rate | No claim that lock-table exhaustion is prevented by any number |

**What §20.5 does NOT claim.** It does not claim that the global scheduler, once parameterised, will isolate shared layers. The scheduler bounds aggregate admission (§20.2); it does not partition consensus, propagation, root computation, the WAL/DB queue, the settlement log, or epoch transitions by domain. Those remain global by construction. The honest v0.4 claim is therefore: bounded global degradation, with bounds UNMEASURED and parameters UNDECIDED, to be measured in Phase 3 against §21. If Phase 3 shows bounded degradation still exceeds a founder-confirmed §21 threshold, the §21 NARROW action applies — the response is not to add another ceiling layer and hope.

**Parameters that cannot yet be defined measurably (UNRESOLVED, Phase 2 definition work required).**
- The unit for per-peer rate limits (bytes vs messages vs both) and for consensus capacity (transactions vs votes vs QC time) — Phase 2 must fix the unit before Phase 3 can measure it.
- The fair-share weighting rule and the root-cost coefficients — Phase 2 must define the rule/formula before Phase 3 can fit it.
- The replay-intermediate format for §9.5 challenges, which affects how scheduler/root costs are audited — Phase 2 definition work, linked to §9.5.


## 21. Kill criteria — REVISED in v0.3 (founder issue 6 + 2026-11-01 clarifications)

**How to use this section:** each criterion has a metric, a measurement method, a threshold, a gate/phase, and an action. Canonical partition rule for K1-T/P/C (NEW in v0.4, identical in §6.6A): C1 no transition during quorum loss; C2 wall-clock never aborts; C3 abort only on a finalised-block event; C4 termination bound only after recovery. Thresholds are **founder-set thresholds to be confirmed, NOT measured results** — they are labelled as such, and Phase 3 must measure against them, not against thresholds chosen after seeing results. The founder must confirm or revise every threshold in §21.1 before Phase 3 gates can pass or fail. A criterion that fires does not mean "work harder on the same design"; it means the action in its row (ABANDON or NARROW to the specified smaller scope, or REVISE with a specified change and re-test) — adding complexity to defend a failing criterion is explicitly forbidden by this section.

**General rule:** if two or more criteria fire at the same gate, the action is the *narrowest* (most restrictive) of the fired rows, not an average. If a criterion fires and its NARROW scope itself fails its own re-test, the action escalates to ABANDON.

**Post-hoc threshold rule (NEW in v0.3):** a threshold may be changed BEFORE Phase 3 measurement, with a changelog entry and founder confirmation. It may NOT be changed AFTER measurement to turn a fail into a pass without a v0.5 revision, founder re-approval, and a re-run of the affected workload. Post-hoc threshold shopping is forbidden.

| ID | Criterion (what is measured) | Metric + measurement method | Threshold — proposed value + classification (see §21.1 for full justification) | Gate / phase | Action if threshold is breached |
|---|---|---|---|---|---|
| K1-T | Settlement termination after recovery | Share of settlements whose termination window closed after quorum recovery that reach a terminal state (COMMITTED or ABORTED/EXPIRED) by min(B_f + D, next E_f) in finalised blocks, plus finality lag; plus model-checking result (no partial-commit state reachable) | **100% within bound, 0 partial-commit states — LOGICAL.** Not a tuned number: a single counterexample falsifies the state-machine claim. | Phase 2 (model, incl. partition-and-heal model) + Phase 3 (W6) | **NARROW to:** single-domain execution + asynchronous cross-domain messaging only. If async also fails, **ABANDON** the cross-domain thesis and retain only single-domain execution. |
| K1-P | Partition behaviour | Count, during a quorum-loss partition, of spurious commits, spurious aborts, partial diffs, and lock releases without a finalised log entry; plus, after heal, share of pre-partition finalised settlements reconstructed identically by replay alone | **0 spurious transitions during the partition; 100% replay reconstruction after heal — LOGICAL.** A spurious transition during a partition is a safety violation, not a performance miss. | Phase 3 (W6 partition test with frozen-state audit on heal) | **ABANDON** the current settlement state machine; do not patch it with a coordinator message or wall-clock timeout, because either would break replay determinism (§5.1, S5). |
| K1-C | Settlement commit usability (abort rate) | Abort rate for legitimate cross-domain settlements under W3 (normal) and W4 (contended), by reason code (§6.4), measured ONLY over settlements whose termination window closed after recovery; frozen settlements reported separately (frozen count, frozen wall-clock duration distribution, post-recovery outcome) | **W3 abort >5% fails; W4 abort >20% fails; minimum sample 1,000 completed settlements per workload, below which K1-C is INCONCLUSIVE — all ARBITRARY PROVISIONAL.** If a partition never recovers, K1-C is BLOCKED / INCONCLUSIVE, not passed. | Phase 3 (W3/W4) | Same NARROW / ABANDON action as K1-T. |
| K2 | Proof cost and prover centralisation | Prover time, prover memory, proof size, verifier time per settlement batch size (§14.2); plus number of independent provers able to prove the flagship workload at the measured cost, and prover cost as a fraction of settlement value | **Prover cost >10% of batch settlement value fails — ARBITRARY PROVISIONAL. Fewer than 3 independent provers able to run the flagship workload fails — ARBITRARY PROVISIONAL. No equivalence proof for a divergent provable VM fails — LOGICAL gate, not a number.** | Phase 2 (arithmetisation) + Phase 3 (prover measurements) | **NARROW to:** Tier 1 receipts + replay only (Tier-2 deferred indefinitely, thesis weakened to "proof-carrying receipts"). Finality is unaffected (§5.1). If the thesis *requires* Tier-2 to be valuable (founder judgement), then **ABANDON** the proof-carrying claim and re-scope as a domain-isolated chain without validity proofs. |
| K3 | Isolation failure (one domain degrading others) | W5: unrelated domains' p99 latency degradation and execution-layer fee change when one domain is flooded, measured per §14.2 (median, p95, p99, max, not mean only); plus §4.9 containment measurements (which layers degraded, by how much) | **Unrelated-domain p99 latency degradation >20% under W5 flood fails — ARBITRARY PROVISIONAL. Unrelated-domain execution fees rise >10% due to another domain's flood fails — ARBITRARY PROVISIONAL. Any §4.9 CONTAINED row measured as DEGRADED/CHAIN-WIDE in W5 fails — LOGICAL in the sense that the containment claim itself is falsified.** See §21.1 for the K3 companion note: a percentage p99 threshold alone is insufficient. | Phase 3 (W5) + Phase 5 (private testnet, real flood) | **NARROW to:** fewer domains per chain, lower per-domain ceilings, and async-only cross-domain work (reducing shared-layer coupling), with re-test. If narrowing does not bring degradation below threshold, **ABANDON** the domain-isolation thesis as a chain-level claim and retain only application-level sandboxing (a weaker, honest claim). |
| K4 | Shared-bottleneck exhaustion | §20 metrics under W1–W6: global scheduler utilisation per resource (`U_r / G_r`), root computation time per block, lock-table size, mempool queue depth per domain, disk IOPS utilisation, block propagation time; plus number of blocks rejected or truncated by the global scheduler (§20.2 step 5) | **Any resource's `U_r` over 80% of capacity `G_r` in >10% of blocks fails — ARBITRARY PROVISIONAL (80% as a concrete α_r value; per-resource α_r to be set in Phase 2 with reasons per resource). Root computation >500 ms per block at target workload fails — ARBITRARY PROVISIONAL (block time itself is undecided, so 500 ms cannot yet be justified as a fraction of block time). Scheduler truncation in >5% of blocks fails — ARBITRARY PROVISIONAL. Propagation time exceeding the finality budget fails — budget to be fixed in Phase 2 in finalised-block terms.** | Phase 3 (§20 measurements) + Phase 5 | **NARROW to:** lower per-block caps, fewer domains, smaller blocks, or a reduced target workload (the workload, not the measurement, changes). If no workload reduction brings utilisation within bounds on ordinary-server hardware (§7.7), **ABANDON** the ordinary-validator intent and either accept datacentre-only validation (with that centralisation disclosed as a thesis change requiring founder re-approval) or **ABANDON** the chain as specified. |
| K5 | Validator cost / decentralisation | Phase 3-derived validator hardware spec + operating cost vs. modelled fee + issuance revenue at realistic (not speculative) levels (§11.1); plus number of independent validators able to operate at that cost in Phase 5, and voting-power concentration (e.g. share held by top validators) | **Honest validator operating cost exceeds modelled sustainable revenue by >20% fails — ARBITRARY PROVISIONAL. Fewer than 50 independent validators able to operate fails — ARBITRARY PROVISIONAL (not a BFT requirement; BFT requires 3f+1, not 50). Top-3 validators hold >33% of voting power fails — BFT-DERIVED proxy (33% follows from the <1/3 Byzantine bound; using "top 3" as the proxy is provisional).** | Phase 3 (cost model) + Phase 5 (real cost survey) | **NARROW to:** lower hardware bar (reduced workload, smaller state, fewer validators at genesis with a published decentralisation plan and timeline), with re-test. If no parameter set closes the security budget without speculative price assumptions, **ABANDON** mainnet as specified (testnet may continue as research, but mainnet launch is blocked, §15 Phase 9). |
| K6 | Complexity / audit burden | Audit scope size and audit findings: number of critical/high findings in Phase 2 model checking and Phase 7 audits; plus number of distinct security-critical mechanisms that must all be correct for the thesis to hold (counted from §10.4 invariants and §6/§5/§20 mechanisms); plus time/cost to audit to the Phase 7 standard vs. available audit budget (founder-assessed, §16.1 risk 11) | **Audit scope exceeds the available independent-audit budget by >20% fails — ARBITRARY PROVISIONAL (no audit budget has been stated yet). More than 12 security-critical mechanisms that must all be correct fails — ARBITRARY PROVISIONAL, as a complexity proxy (count method must be fixed in Phase 2; the count changes with grouping). Any critical finding that cannot be fixed without redesigning a core mechanism (§5, §6, or §20) fails in the sense of triggering NARROW — LOGICAL gate, not a number.** | Phase 2 (model complexity) + Phase 7 (audit) | **NARROW to:** remove the most complex mechanism that is not load-bearing for the narrowed thesis (first candidate: Tier-2 proofs, §21 K2; second: atomic settlement, §21 K1 — in that order, because removing Tier-2 does not affect finality, while removing settlement changes the thesis). If narrowing to single-domain execution + receipts still exceeds the audit budget, **ABANDON** the project as a mainnet plan and retain it as research only. |

### 21.1 Threshold justification (NEW in v0.3, from the 2026-11-01 clarification register)

Classification key: **ARBITRARY PROVISIONAL** = a number chosen for discussion, with a stated rationale, but with no
measurement behind it; it is a proposal for the founder to confirm, revise, or reject, and must not be quoted
as a spec limit. **EVIDENCE-DERIVED** = a number derived from a measurement, a published result, or a formal
bound; in v0.3 almost no numeric threshold qualifies, because Phase 3 measurements do not exist yet.
**LOGICAL / BFT-DERIVED** = a standard that follows from the design's own invariants or from BFT theory, not
from tuning; failing it is a design failure, not a tuning miss.

- **K1-T (100%, 0 partial) — LOGICAL.** Rationale: the §6 state machine claims every settlement reaches a
  terminal state and no partial state is reachable; a single counterexample falsifies the claim, and a
  percentage tolerance would hide a safety bug. Baseline: §6 state machine as specified; finalised-block
  deadline/epoch definitions (§6.6A); chain resumes finalising after any partition. Sensitivity: none in the
  standard itself, but the bound's wall-clock duration is highly sensitive to partition duration and to D
  and epoch length. Evidence to change: none — this standard can only be changed by changing the state
  machine itself, with a new formal model, not by tuning a number.
- **K1-P (0 spurious, 100% replay reconstruction) — LOGICAL.** Rationale, assumptions, sensitivity, and
  change rule: same as K1-T. A spurious transition during a partition is a safety violation, not a
  performance miss.
- **K1-C (W3 >5%, W4 >20%, sample ≥1,000) — ARBITRARY PROVISIONAL for all three numbers.** Rationale for 5%:
  under normal load a correctly designed atomic settlement should rarely abort legitimate work; 5% is
  proposed as a usability signal above which users experience frequent, unexplained failures, while still
  allowing genuine contention and logic failures. It is not derived from any MARWANTA measurement, because
  none exists. Rationale for 20%: under deliberate contention a higher abort rate is expected, because
  first-PREPARED-wins forces losers to wait or abort; 20% is proposed as the point where contention handling
  is arguably unusable for the flagship workload, rather than merely slow. Rationale for 1,000: a smaller
  sample makes a 5% rate statistically meaningless (50 aborts in 1,000 is a usable signal; 5 in 100 is not);
  the exact sample size is a statistical convenience, not a workload-derived requirement. Baseline: W3 is
  2-, 3-, and 5-domain settlements (§14); W4 is hot-key contention (§14); D and epoch length are Phase 2
  values, not yet set; abort reasons are correctly coded. Sensitivity: HIGH — abort rate moves sharply with
  key popularity, D (short D = more spurious aborts), epoch length (short epochs = more epoch aborts), lock
  granularity (coarse locks = more false contention), and workload mix. A threshold set for W3/W4 cannot be
  transferred to a different workload without re-baselining. Evidence to change: Phase 3 abort-rate
  distributions by reason code, key popularity, and D/epoch setting, plus a founder statement of user
  tolerance for abort-and-retry in the flagship workload.
- **K2 (prover cost >10% of batch value) — ARBITRARY PROVISIONAL.** Rationale: Tier-2 is supplementary, so
  its cost should be a small fraction of the value it helps verify; 10% is proposed as a "not worth it" line.
  No batch-value distribution has been measured. Baseline: batch value measurable in the same units as prover
  cost (which requires a fee/cost model that is itself undecided in §11); cost reported by batch size (§14.2),
  not as a single size. Sensitivity: VERY HIGH — small-value batches fail a percentage test first even if
  absolute prover cost is low; large batches pass easily. Evidence to change: measured prover cost curve by
  batch size and by settlement-value decile, from Phase 3.
- **K2 (<3 independent provers) — ARBITRARY PROVISIONAL.** Rationale: 1 prover is a single point of failure
  and censorship for Tier-2 fast verification; 2 still allow collusion or correlated failure; 3 is proposed as
  the minimum for a non-trivial decentralisation claim. It is not derived from a prover market study, which
  does not exist. Baseline: "able to run" means measured prover time, memory, and cost within the Phase 3
  flagship workload, not a self-declaration. Sensitivity: sensitive to flagship workload size and prover
  hardware cost. Evidence to change: a prover market / cost survey in Phase 3, plus founder judgement on
  acceptable centralisation for a supplementary feature (lower-stakes than finality, because Tier-2 is not
  on the finality path).
- **K2 (no equivalence proof for a divergent provable VM) — LOGICAL gate, not a number.** Rationale: if the
  proving VM differs from the execution VM, a proof about the proving VM does not prove the execution VM's
  computation without an equivalence argument. This is a correctness requirement, not a tunable threshold.
- **K3 (p99 degradation >20%) — ARBITRARY PROVISIONAL.** Rationale: 20% is proposed as a noticeable-but-
  tolerable degradation line: below it a flood is arguably contained; above it users of unrelated domains feel
  the flood. No baseline latency distribution has been measured. Baseline: same workload without the flood, on
  the same hardware, measured as p99 (not mean), per §14.2. Sensitivity: HIGH, and percentage alone is
  insufficient — 20% of a 100 ms baseline is 20 ms (likely unnoticed); 20% of a 2 second baseline is 400 ms
  (likely noticed). **K3 companion note (NEW in v0.3):** a percentage p99 threshold alone is insufficient and
  v0.4 should pair it with an absolute p99 latency cap for the flagship workload, also founder-confirmed and
  also provisional until measured, once block time is fixed in Phase 2. Workload mix matters: W5 with one
  flooded domain vs. several flooded domains gives different leakage. Evidence to change: Phase 3 W5 p99
  distributions, with and without flood, by domain, plus founder judgement on user-visible latency tolerance.
- **K3 (execution fees rise >10%) — ARBITRARY PROVISIONAL.** Rationale: at the execution layer, per-domain
  ceilings are supposed to prevent one domain's congestion from raising another domain's fees; any rise above
  10% is proposed as evidence of leakage through a shared layer. The 10% figure itself has no measurement
  behind it; it is stricter than the latency figure because fee leakage is a more direct violation of the
  ceiling design. Baseline: fees measured per resource dimension (§4.5), not as a single blended fee, and
  excluding the flooded domain's own fees. Sensitivity: sensitive to fee model (undecided in §11), to baseline
  fee level (10% of a tiny fee is noise), and to whether the rise is transient (one block) or sustained.
  Evidence to change: Phase 3 W5 fee-by-dimension measurements, sustained over the flood window, not a single block.
- **K4 (utilisation >80% in >10% of blocks) — ARBITRARY PROVISIONAL, with a headroom rationale.** Rationale:
  α_r in §20 must be < 1 to leave headroom for replay variance, root computation, and bursts; 80% is proposed
  as a concrete α_r value, and 10% of blocks as the frequency above which high utilisation is sustained, not a
  spike. Neither number is measured; G_r itself is unmeasured. Baseline: G_r is the weakest validator that must
  keep up (§20.1), not the average validator; utilisation measured per resource, per block. Sensitivity: HIGH —
  different resources have different safe headrooms (CPU burst tolerance vs. disk IOPS queueing vs. bandwidth).
  A single 80% / 10% pair for all resources is a simplification for discussion; v0.4 should set α_r and frequency
  per resource, in Phase 2, with reasons per resource. Evidence to change: Phase 3 utilisation distributions
  per resource, plus queueing / timeout observations at different utilisation levels.
- **K4 (root computation >500 ms per block) — ARBITRARY PROVISIONAL.** Rationale: root time is a serial,
  global cost paid by every validator per block; 500 ms is proposed as a budget that leaves room for consensus,
  replay, and propagation within a plausible block window. Block time itself is undecided in v0.3, so 500 ms
  cannot be justified as a fraction of block time until block time is fixed in Phase 2. Baseline: target
  workload as defined in §14, state size as in the Phase 3 setup, trie depth as measured, not assumed.
  Sensitivity: sensitive to state size, write pattern, and trie implementation — all unmeasured. Evidence to
  change: Phase 3 root-time measurements versus block-time and finality budget, once block time is fixed.
- **K4 (scheduler truncation >5% of blocks) — ARBITRARY PROVISIONAL.** Rationale: occasional truncation is
  the scheduler working as designed (last resort, §20.2 step 5); frequent truncation means the admitted
  workload systematically exceeds capacity, so users experience systematic delay. 5% is proposed as the line
  between occasional and systematic. Baseline: truncation counted per block, with reason (which resource bound
  was hit), not as a single aggregate. Sensitivity: sensitive to block size, domain mix, and scheduler
  parameters (α_r, k), all Phase 2 values. Evidence to change: Phase 3 truncation logs by resource and domain.
- **K5 (validator cost exceeds sustainable revenue by >20%) — ARBITRARY PROVISIONAL.** Rationale: a small
  deficit might be closed by parameter tuning; a 20% deficit is proposed as a structural gap, not a rounding
  error. No cost or revenue model has been measured, and revenue depends on undecided fee and issuance
  parameters (§11), so this threshold cannot be applied until those parameters are modelled in Phase 2.
  Baseline: revenue at realistic, not speculative, levels; cost includes hardware, bandwidth, storage growth,
  and operations, not hardware purchase alone. Sensitivity: VERY HIGH — revenue is sensitive to token price
  assumptions, which must NOT be used speculatively; cost is sensitive to workload and to pruning/archival
  policy. Evidence to change: Phase 3 cost model plus Phase 5 real cost survey, with revenue modelled without
  speculative price.
- **K5 (<50 independent validators) — ARBITRARY PROVISIONAL.** Rationale: 50 is proposed as a minimum for a
  permissionless claim to be non-trivial, above a small committee but below a large public set. It is not
  derived from a validator survey, which does not exist, and it is not a BFT requirement (BFT requires 3f+1,
  not 50). Baseline: "independent" means distinct operators, distinct infrastructure, and distinct failure
  domains, not merely distinct keys. Sensitivity: sensitive to hardware bar (K4) and to cost (above); lowering
  the hardware bar mechanically raises the count. Evidence to change: Phase 5 validator survey, with
  independence criteria stated in advance.
- **K5 (top-3 >33% of voting power) — BFT-DERIVED proxy, with a provisional application.** Rationale: BFT
  safety fails if one-third or more of stake is Byzantine (§2, < 1/3 assumption). Top-3 share above 33%
  therefore means three colluding or correlated validators could, in principle, break safety, even if they are
  currently honest. The 33% figure itself follows from BFT theory, not from tuning. The provisional part is
  using "top 3" as the concentration proxy; a different proxy (top 5, Herfindahl index, geographic/hosting
  concentration) could be justified in Phase 2, with reasons. Baseline: voting power measured by stake or by
  the Phase 2 voting rule, not by key count. Sensitivity: sensitive to stake distribution and to delegation
  (undecided at genesis in v0.3). Evidence to change: a concentration metric study in Phase 2/5, plus founder
  judgement on acceptable concentration for a new chain.
- **K6 (audit scope exceeds budget by >20%) — ARBITRARY PROVISIONAL.** Rationale: 20% is proposed as a
  material overrun line, above which audit scope must be cut (by narrowing) rather than audit depth cut (by
  skipping checks). No audit budget has been stated by the founder, and no audit scope has been priced, so
  this threshold cannot be applied until both are stated in Phase 2/7. Baseline: budget is for independent
  audit to the Phase 7 standard, not for internal review. Sensitivity: sensitive to mechanism count, to code
  size (which does not exist yet), and to auditor rates. Evidence to change: a Phase 2 scope estimate and a
  founder-stated audit budget.
- **K6 (>12 security-critical mechanisms) — ARBITRARY PROVISIONAL, as a complexity proxy.** Rationale: 12 is
  proposed as a human-auditability signal: beyond roughly a dozen interlocking critical mechanisms, the chance
  that an auditor, a reviewer, and a future maintainer all hold the full correctness argument in mind falls
  sharply. This is a judgement about human cognition, not a measured failure rate. Baseline: "mechanism"
  counted as in §21 K6 (distinct mechanisms from §10.4 invariants and §6/§5/§20), counted by a stated method
  in Phase 2, not by ad-hoc grouping. Sensitivity: HIGH — the count changes with grouping (splitting one
  mechanism into two, or merging two into one, changes the count without changing the system). A count
  threshold is therefore only useful with a fixed counting method, stated in advance. Evidence to change: a
  Phase 2 mechanism inventory with a fixed counting method, plus audit findings showing whether complexity
  actually caused misses.
- **K6 (critical finding requiring redesign of §5, §6, or §20) — LOGICAL gate, not a number.** Rationale: if
  a core mechanism must be redesigned, the design that was audited is not the design that ships; re-audit and
  re-modelling are required. This is not a tunable number.

**What is NOT a kill criterion (and why):** "TPS below X" alone is not a kill criterion, because TPS without workload, hardware, and adversarial conditions is meaningless (§14). "No users yet" is not a kill criterion at Phase 3, because distribution (§13) is integration-first and is not measured until Phase 6/8. "A competitor launched a similar feature" is not a kill criterion, because the thesis is structural, not first-mover — but it *is* a reason to re-run the §17 matrix in Phase 1. Vague criteria like "if too slow", "if too complex", or "if not good enough" are forbidden by this section: every criterion above has a metric, a method, a founder-confirmed threshold, a gate, and a specified action. A criterion without all five is not a criterion, it is a sentiment, and it must not be used to justify continuing or stopping work.

 — Research notes and source types (v0.2, updated)

---

## Appendix A — Research notes and source types (v0.2, updated)

- Prior-art research for v0.1/v0.2 used public web text search (2026-10-31) across the topics listed in §0. Secondary summaries and documentation explainers were the dominant source type; primary papers (HotStuff/HotStuff-2, Narwhal/Bullshark, Block-STM, Avalanche Snow, STARK/SNARK constructions) were **not** fully reviewed for v0.1 or v0.2 and must be reviewed in Phase 1.
- Specific secondary claims that Phase 1 must verify against primary sources include: HotStuff-2 two-chain finality details; Aptos Raptr and Sui Mysticeti current versions and performance; Solana local fee-market mechanics; Sui storage-fund mechanics; Polkadot XCMP completeness; Ethereum Verkle status; and any TPS/latency figures cited in third-party comparisons (none are used as MARWANTA baselines in this document, per §14.3).
- **New in v0.2:** Phase 1 must additionally verify, cell by cell, the §17 matrix (including the demotions in Appendix C) and must conduct an explicit search for an equivalent to the §18 C3 narrow candidate (joint settlement semantics). Where a secondary-source summary is wrong, Phase 1 correction takes precedence over v0.2 text. The correction must be recorded in v0.4's changelog, not silently edited.

## Appendix B — Glossary (short, updated)

- **BFT:** Byzantine Fault Tolerance. **DAG:** Directed Acyclic Graph. **DAS:** Data Availability Sampling. **DA gate:** Data Availability gate (§5.8) — a validator must hold full block data before voting to finalise. **EVM:** Ethereum Virtual Machine. **GST:** Global Stabilisation Time (partial synchrony). **IBC:** Inter-Blockchain Communication (Cosmos). **QC:** Quorum Certificate. **SMT:** Sparse Merkle Tree. **STARK/SNARK:** see §5.4. **VRF:** Verifiable Random Function. **WASM:** WebAssembly. **SID:** Settlement ID (§6.2). **WAIT / PREPARED / COMMITTED / ABORTED / EXPIRED:** settlement states (§6.2). **Global scheduler:** deterministic per-block admission control enforcing `U_r ≤ α_r · G_r` (§20). **Kill criterion:** a measurable ABANDON/NARROW condition (§21).

## Appendix C — Changelog v0.1 → v0.2 (every contradiction fixed, claim demoted, and issue left unresolved)

### C.1 Contradictions fixed

1. **§1.3 / §5.1 / §5.7 / §9.1 proof-vs-replay contradiction — FIXED by decision (§5.1, Rule P0).** v0.1 §1.3 said a validator "does not need to re-execute every domain's private computation in the Tier-2 validity-proof case"; v0.1 §5.1 said replay is "not optional and not replaced by proofs"; v0.1 §5.7 said replay is a "fallback"; v0.1 §9.1 listed validators as executing but left the Tier-2 exception ambiguous. v0.2 withdraws the §1.3 exception, rewrites the §1 diagram (proof as a dashed sidecar, not the critical path), rewrites §5 as the canonical rule (replay mandatory, Tier-2 supplementary only, never sufficient for finality, never overriding replay, never curing data withholding), corrects §9.1 (validators MUST replay, provers do not vote), and adds the Tier-2 case table (§5.5) and the DA gate (§5.8). Any remaining passage that appears to contradict P0 is governed by P0 and must be corrected in v0.4.
2. **Proof-system threat impact — FIXED (§10.2).** v0.1 §10.2 asked whether a Tier-2 proof could ever override replay disagreement and left it as [Research Required]. v0.2 answers: **no, never.** A proof-system break degrades light-client fast verification only, not finality.
3. **Isolation scope — FIXED by narrowing (§4.1, §4.9, §20).** v0.1 could be read as claiming domain isolation prevents one domain degrading the whole network. v0.2 states plainly that isolation holds at execution only, and that shared layers are DEGRADED or CHAIN-WIDE, with a layer-by-layer table and a capacity model.
4. **Settlement sketch → complete state machine — FIXED as a specification (§6.2–§6.8).** v0.1 §6.2 was a "protocol sketch" with no complete state list, no epoch rule, no crash-recovery rule, and no idempotency rule. v0.2 specifies states, transitions, guards, effects, lock ordering, deadline, epoch abort, conflicting settlements, crash recovery, re-proposal, and idempotency. Machine-checked proof remains outstanding (see C.3).
5. **Settlement liveness claim — CORRECTED (§6.7).** v0.1 implied settlement liveness could be achieved by deadlines and ordering rules. v0.2 distinguishes bounded *termination* (guaranteed, by deadline/epoch) from bounded *commit* (not unconditionally guaranteed, requires honest leaders + available locks + passing prepares + no epoch abort). A spec that promised bounded commit under adversarial contention would be false.
6. **Light-client security statement — CORRECTED (§7.5, §5.6).** v0.1 said a Tier-2 proof "may additionally verify" for light clients without stating that proof reliance adds a trust assumption weaker than full validation. v0.2 states it: light clients trust quorum honesty, plus proof soundness if they use Tier-2, and are never equivalent to full validators.

### C.2 Claims demoted or removed

1. **I1 (domain-isolated execution with manifests) — DEMOTED from "innovation" to Engineering Combination (C1, §17, §18).** Reason: WASM sandboxing, namespaces, capability systems, Solana declarations, Sui capabilities, and parachain isolation are all prior art; the MARWANTA proposal is their combination inside one chain. No new isolation primitive is named.
2. **I2 (tiered proof-carrying) — DEMOTED from "innovation" to Engineering Combination, policy (C2).** Reason: validity proofs, receipts, and replay are all prior art; tiering is a policy for when to use each. v0.2's tiering is *less* novel than v0.1's ambiguous tiering, because it explicitly forbids proof-substitutes-for-replay.
3. **I3 (two-phase atomic settlement) — DEMOTED from "innovation" to Engineering Combination (C3).** Reason: two-phase commit, BFT ordering, and locks are all prior art. The joint semantics in §6 are retained as a *narrow candidate for Phase 1 search*, not as a claim.
4. **I4 (per-domain resource ceilings, three dimensions) — DEMOTED from "innovation" to Engineering Combination (C4).** Reason: OS quotas, Solana local fee markets, and per-chain limits are prior art; three-dimensional metering + ceilings + a global scheduler is their combination.
5. **I5 (per-domain roots → global root) — DEMOTED from "innovation" to Established Prior Art, adapted (C5).** Reason: two-level Merkle roots over sub-roots are prior art (Polkadot relay/parachain roots, sharded state designs).
6. **Overall novelty claim — REMOVED.** v0.1 presented five "innovations" and implied a novel thesis. v0.2 claims **no genuine novelty** on current evidence. The thesis is now presented as a *novel composition whose value is untested*, not as an invention. If Phase 1 finds a genuine mechanism, v0.4 may claim it — with evidence, and only that mechanism.
7. **"Isolation prevents whole-network degradation" — REMOVED as a general claim.** Replaced by §4.9 (bounded degradation) and §20 (global scheduler + residual globals).
8. **No other v0.1 claims were removed.** Consensus (HotStuff-2 adaptation, not new), WASM runtime (prior art), STARK/SNARK (prior art), tokenomics (preliminary, undecided), and the Phases 1–9 roadmap are retained, with v0.2 updates noted in their sections.

### C.3 Issues and sub-issues left unresolved (not hidden — see also the front register)

1. **Machine-checked proof of §5.1, §6 (S1–S5), and §6.7 termination — UNRESOLVED.** §6.7 is a hand analysis only. Phase 2 must produce a TLA+ (or equivalent) model and passing results. Until then, issue 3 is PARTIALLY RESOLVED, not RESOLVED.
2. **Quantitative isolation leakage, proof cost, validator hardware, and §20 capacities — UNRESOLVED.** §20 is symbolic; §4.9 is qualitative. Phase 3 must measure them against founder-confirmed §21 thresholds. Until then, issues 2 and 4 are PARTIALLY RESOLVED.
3. **Exact proof system, arithmetisation path, and provable-VM equivalence — UNRESOLVED.** Tier-2 is supplementary, so this does not block finality, but it does block Tier-2 deployment. Phase 2 research required.
4. **Primary-source verification of §17 — UNRESOLVED.** The matrix is built from secondary sources. Phase 1 must verify every cell and conduct the C3 narrow-candidate search. Any cell overturned must be corrected in v0.4.
5. **Founder confirmation of §21 thresholds — UNRESOLVED (awaiting founder).** Thresholds in §21 are labelled "to be confirmed" and are not measured results. Phase 3 gates cannot pass or fail against unconfirmed thresholds; they can only measure and report until the founder confirms them.
6. **Exact token, fee, lock-fee, bond, and scheduler parameters — UNDECIDED.** §6.8 uses abstract units only; §11 remains preliminary. No numbers in v0.2 should be read as tokenomics.

---


## Appendix D — Changelog v0.2 → v0.3 (2026-11-01 clarifications merged into the body)

This appendix lists every section changed in v0.3, every claim withdrawn or narrowed, and every item
still unresolved. v0.3 adds no new mechanism, claims no approval, and authorises no coding, prototype,
testnet, or token work. v0.1 (924 lines) and v0.2 (1,274 lines) are preserved untouched; v0.3 is a new
file created by copying v0.2 and editing that copy.

### D.1 Sections changed

- Header, title, version, and front Issue Resolution Register: v0.3 status and 2026-11-01 clarification
  rows 7–9 added; unresolved list extended with block time, D, epoch length, and finality lag.
- §0 (labelling / evidence limits): forward correction references updated from v0.3 to v0.4, because
  primary-source verification is still not done in v0.3.
- §2.5, §3.5: epoch boundary and settlement failure taxonomy rewritten in finalised-block terms, with
  partition freezing stated explicitly.
- §5.3, §5.6: receipt-check wording qualified; Tier-2 settlement-batch use qualified as a supplementary
  fast check subject to proof soundness and quorum trust, not as independent private-logic proof.
- §5.6A (NEW): Mode A (validator replay only, the only mode in v0.3) and Mode B (future Tier-2 only,
  not available) defined with exact proved statements, direct auditor checks, remaining trust, and the
  plain statement that private execution from full validators is NOT supported under Rule P0.
- §6.2: D redefined as finalised blocks from finalised block B_f (deadline finalised block = B_f + D);
  E redefined as the next finalised epoch-transition block E_f; transition guards rewritten to finalised
  blocks.
- §6.6: validator-failure row corrected (D does not advance during a partition; abort-after-recovery in
  finalised-block terms); epoch row corrected to finalised epoch-transition block.
- §6.6A (NEW): quorum-loss partition rule — no transition can be finalised during a partition, settlements
  freeze with no spurious commit/abort/partial state, wall-clock termination is unbounded, termination is
  bounded only in finalised-block terms after quorum recovery, and finality lag is still unspecified in
  finalised blocks.
- §6.7: bounded-liveness analysis rewritten as termination-after-recovery; the unqualified phrase
  "v0.2 guarantees bounded termination" is replaced by "v0.3 guarantees bounded termination-after-recovery,
  in finalised-block terms, not bounded commit, and not termination during a quorum-loss partition"; worst
  case restated in finalised blocks excluding partition wall-clock time.
- §10.4 (invariant 10): settlement terminality qualified as evaluated over finalised blocks, after the
  chain resumes finalising; freezing during a partition is not a violation.
- §14.4: settlement gate rewritten to K1-T / K1-P / K1-C, with partition results BLOCKED / INCONCLUSIVE
  rather than passed.
- §15.1 (NEW): full Phase 2 dependency map, items A–L, with deliverable, dependencies, prototype-blocking
  status, and other blocked items, plus dependency order.
- §16.1 (risk 1): "bounded termination" qualified as termination-after-recovery in finalised blocks.
- §17.2, §18 scope, §18 C3: forward novelty-upgrade references updated from v0.3 to v0.4, because Phase 1
  primary-source verification and the C3 search are still not done in v0.3.
- §18 C2: expected benefit and light-client test method qualified (§5.6A); a pass on light-client tests
  does NOT establish private-logic verification. §18 C3 technical explanation qualified for termination.
- §18.6 (MAES): private-logic check sentence withdrawn and replaced with Mode A wording; proof-carrying
  bullet rewritten to Mode A only; narrowed success criteria added (atomicity, execution isolation, Mode A
  auditability, refund correctness); private-logic verification, private execution from validators, and
  off-chain attestation correctness explicitly listed as NOT testable in v0.3.
- §19.1, §19.2, §19.3: settlement model corrected to finalised-block termination-after-recovery; kill
  criteria item corrected to §21/§21.1 with the post-hoc threshold rule; block time, epoch length, and
  finality lag in finalised blocks added to undecided items; Phase 2 dependency gate summary added to §19.3.
- §20.4, §14.4, §15 Phase 1 exit, §19.3: forward "v0.3" adoption/correction references updated to a later
  version / v0.4, because v0.3 does not adopt a DAG, does not fill in measured numbers, and does not correct
  the §17 matrix.
- §21: K1 replaced by K1-T / K1-P / K1-C with proposed values and classifications; K2–K6 threshold cells
  expanded from symbolic placeholders (X, Y, Z, L, F, B, R, T, α_r, C, N, S, A, M) to the proposed values in
  §21.1 with classifications; §21.1 threshold justification added for every numeric threshold; post-hoc
  threshold rule added; K3 companion note added (percentage p99 threshold alone is insufficient; v0.4 should
  pair it with an absolute p99 cap once block time is fixed).

### D.2 Claims withdrawn or narrowed in v0.3

- WITHDRAWN: any unqualified "bounded termination" guarantee for settlements. Replaced by: bounded
  termination-after-recovery in finalised-block terms, conditional on the chain resuming finalisation;
  no termination guarantee during a quorum-loss partition, in wall-clock time or otherwise.
- WITHDRAWN: the claim that a third party can verify MAES / private agent logic without replaying it.
  Replaced by Mode A (finalisation + receipts/root/decide-entry checks, still trusting the validator
  quorum) and a future, unavailable Mode B.
- WITHDRAWN: any implication that private execution from full validators is supported. Stated plainly:
  it is NOT supported in v0.3 under Rule P0; a proof-instead-of-replay redesign would change P0 and
  finality trust and needs separate founder approval.
- NARROWED: MAES success criteria, to atomicity, execution isolation, Mode A receipt auditability, and
  refund correctness only.
- NARROWED: K1, from a single liveness/abort criterion to K1-T / K1-P / K1-C, with partition-frozen
  settlements excluded from the abort-rate denominator and reported separately.
- NARROWED (as a statement of status, not of design): every K1–K6 numeric threshold is now explicitly
  ARBITRARY PROVISIONAL except the logical / BFT-derived standards marked as such in §21.1. No numeric
  threshold in v0.3 is evidence-derived and none is final until the founder confirms it.

### D.3 Still unresolved in v0.3 (not hidden)

- Machine-checked proof of §5.1, §6 invariants S1–S5, and the revised §6.7 termination-after-recovery
  bound — UNRESOLVED, Phase 2 required. §6.7 remains a hand analysis.
- Quantitative isolation leakage, proof cost, validator hardware, and §20 capacities — UNRESOLVED,
  Phase 3 measurement required. §20 remains symbolic.
- Exact proof system, arithmetisation path, provable-VM equivalence, and Mode B construction —
  UNRESOLVED, Phase 2 required. Tier-2 deployment and any Mode B claim remain blocked.
- Primary-source verification of the §17 matrix and the C3 narrow-candidate search — UNRESOLVED,
  Phase 1 required. Any cell overturned must be corrected in v0.4, not defended.
- Founder confirmation or revision of every §21.1 threshold — UNRESOLVED, awaiting founder. Phase 3
  gates cannot pass or fail against unconfirmed thresholds.
- Block time, prepare deadline D, epoch length, and finality lag, all in finalised-block terms —
  UNDECIDED, Phase 2 must fix them. Until then, no wall-clock settlement latency claim can be made
  from this document.
- Exact token, fee, lock-fee, bond, and scheduler parameters — UNDECIDED, not invented. §6.8 uses
  abstract units only; §11 remains preliminary.
- Manifest language syntax, state-tree final choice, snapshot/pruning details, networking stack, and
  VRF rotation construction — UNDECIDED, Phase 2 decisions (see §15.1, items D and J).

## Appendix E — Changelog v0.3 → v0.4 (2026-11-01 founder corrections: four issues, none silently removed or downgraded)

**Status of this appendix:** every v0.3 issue named by the founder in the 2026-11-01 11:07 IST review, every correction made in v0.4, and every remaining gap is listed here with status RESOLVED / PARTIALLY RESOLVED / UNRESOLVED and a reason. Nothing in this appendix is approval, and nothing here authorises coding, prototype, testnet, or token work. Where v0.4 and v0.3 conflict on the four issues below, v0.4 governs; where they conflict on anything else, the more restrictive reading governs until v0.5.

### E.1 Corrections made in v0.4

| # | Founder issue (2026-11-01 11:07 IST) | What changed in v0.4 | Sections changed | Status | Reason |
|---|---|---|---|---|---|
| 10 | Finality definition — §2.2 two-chain vs three-chain ambiguity; B extended by a certified child and that child by a certified grandchild was a three-chain description mislabelled as two-chain | Formal TWO-CHAIN rule adopted: B in view v is final iff QC(B) exists AND a direct child B' with parent = B, view(B') = v+1 (consecutive views), has QC(B'). No grandchild required. Voting rule, lock rule, non-consecutive-view behaviour, finality lag in finalised views/blocks (not seconds), and "one confirmation / receipt / optimistic execution / Tier-2 proof is NOT finality" all stated. MARWANTA additions (P0 replay + DA gate before a finality vote) marked as MARWANTA's, not original HotStuff-2. Reference: HotStuff-2 (Malkhi & Nayak, Cryptology ePrint Archive 2023/397, two-phase responsive BFT, 2-chain commit rule). | §1.3 (finality pointer), §2.2 (finality + safety rows), §2.2A (NEW, canonical formal rule), §19.1(10), front register row 10 | PARTIALLY RESOLVED | The rule is now formally stated and internally consistent, but it is a specification decision, not a proof. Phase 2 must reconcile MARWANTA's strict consecutive-view formulation with HotStuff-2's double-certificate / commit-ancestor step and prove the adapted, stake-weighted, P0/DA-gated, pipelined protocol. The HotStuff-2 safety proof does NOT automatically transfer. Until that proof exists, finality safety is UNPROVEN for the adapted protocol. |
| 11 | Slashing consistency — §1.3, §2.2, §9, §11 said vote-without-replay is slashable IF it contributes to a wrong finalisation, while §10.4 invariant 8 said it is a violation regardless of outcome | ONE consistent rule in every listed passage: violation = signing a vote that can contribute to finalising B without first completing P0 (full-data download/hash verification; deterministic replay reproducing claimed roots; settlement-decision verification; receipts/manifest/budget verification). Violation status does NOT depend on outcome. Slashing additionally requires qualifying evidence (E1 self-evident, E2 challenge-based, E3 attributable outcome). Attribution is per-validator, stake-weighted, no collective punishment; abstention when data is missing or replay mismatches is CORRECT and is never slashed. Penalty categories in proportion only (downtime < incorrect vote < vote-without-replay with qualifying evidence < equivocation < provable state-corruption attempt); rates UNDECIDED, Phase 2. Appeal / false-positive safeguards stated; repeated challenge failures escalate warning → jailing → slashing only under the stated evidence rule. | §1.3, §2.2, §9.2, §9.4, §9.5 (NEW, canonical), §10.2 (Byzantine row), §10.4 inv. 8 (pointer to §9.5), §11.1, §11.3, §19.1(11), front register row 11 | PARTIALLY RESOLVED | The textual inconsistency is resolved and the enforcement gap is stated honestly, but enforcement is not fully specified: challenge bound, bond, repeat count, intermediate format, replay-evidence quorum threshold, penalty rates, jailing durations, and appeal window are all UNDECIDED (Phase 2). Perfect detection of a validator that votes correctly without replaying, without a challenge, is NOT detectable from the vote alone — that claim is withdrawn, not fixed. |
| 12 | Settlement partition consistency — §2.5, §3.5, §6.6, §6.6A did not enforce one rule everywhere | Identical canonical rule C1–C4 in every listed section, with §6.6A as canonical: C1 no settlement transition is finalised during a quorum-loss partition; C2 a wall-clock epoch end or timeout NEVER automatically aborts; C3 abort ONLY on a finalised-block event (finalised deadline block B_f + D or finalised epoch-transition block); C4 the termination bound applies ONLY after quorum recovery, in finalised-block terms plus finality lag. Unqualified "timeout", "epoch-end", and "deadline" wording in §6.2, §6.4, §6.6, §6.7 was qualified to finalised-block events. §2.5, §3.5, §6.6, §6.7, §14.4 and §21 K1-T/P/C now point to §6.6A with identical wording. | §2.5, §3.5, §6.2 (state table), §6.4, §6.6, §6.6A (canonical C1–C4), §6.7, §14.4 (settlement gate), §21 (K1 intro pointer), §19.1(12), front register row 12 | PARTIALLY RESOLVED | The rule is now identical in every listed section, but the rule's parameters are still UNDECIDED: D, epoch length, and finality lag in finalised blocks must be fixed by Phase 2, and K1-T/K1-P must be model-checked under a partition-and-heal model. The bound is therefore a bound in finalised blocks plus an unspecified finality lag, not a wall-clock latency promise. |
| 13 | Domain isolation limits and measurable parameters — §4.1, §4.9, §20 | Isolation restated as execution-only. §4.1 definition and §4.9 table rewritten so no row claims CONTAINED for a shared layer's finality, latency, or throughput (each CONTAINED row's scope is stated in that row). §20.4 conclusion restated as bounded degradation, UNMEASURED, not isolation. NEW §20.5 parameter table covering global scheduler (G_r, C_{d,r}, F_{d,r}, alpha_r, redistribution cap k, reserve for consensus/root work, G_CONS), shared storage (WAL/DB IOPS cap, write batching policy, snapshot frequency, pruning window), state-root computation (incremental vs full recomputation, domain-root caching, cost formula in changed subtrees + domain roots), and network (block-size cap, per-peer rate limit, per-domain gossip quota, tx-size limit) — every value UNDECIDED / RESEARCH REQUIRED, with unit, Phase 3 measurement method (workload W1–W6 + metric), and the claim NOT made until measured. | §4.1, §4.9, §20.4, §20.5 (NEW), §19.1(13), front register row 13 | PARTIALLY RESOLVED | Scope and parameters are now honestly stated, but every numeric value is still UNDECIDED and no degradation bound is measured. Some parameters (e.g. fair-share weighting, root-cost coefficients, per-peer rate-limit unit, consensus-capacity unit) cannot even be fully defined measurably yet — those rows are marked UNRESOLVED in §20.5 with the Phase 2 definition work required. No isolation or degradation claim beyond execution is made until Phase 3 measurement. |

### E.2 Issues carried over from v0.3, NOT silently removed or downgraded

| # | Carried-over issue | Status in v0.4 | Reason |
|---|---|---|---|
| (a) | Machine-checked proof of §5.1, §6 invariants S1–S5, and §6.7 termination-after-recovery bound | UNRESOLVED | Phase 2 required. §6.7 remains a hand analysis; v0.4 does not present it as a proof. |
| (b) | Quantitative isolation leakage, proof cost, validator hardware, §20 capacities | UNRESOLVED | Phase 3 measurement required; §20.5 parameters are all UNDECIDED. |
| (c) | Exact proof system, arithmetisation path, provable-VM equivalence, MAES Mode B construction | UNRESOLVED | Phase 2 required. Tier-2 deployment and any Mode B claim remain blocked. |
| (d) | Primary-source verification of the §17 matrix and the C3 narrow-candidate search | UNRESOLVED | Phase 1 required. Historical forward references in Appendices C/D that named v0.4 as the correction version are now stale for this item (v0.4 did not complete primary verification); the correction version for this item is v0.5. This is recorded here, not hidden. |
| (e) | Founder confirmation or revision of every §21.1 threshold | UNRESOLVED | Awaiting founder. Phase 3 gates cannot pass or fail against unconfirmed thresholds. |
| (f) | Block time, prepare deadline D, epoch length, finality lag in finalised blocks | UNDECIDED | Phase 2 must fix them in finalised-block terms. No wall-clock settlement latency claim can be made from v0.4. |
| (g) | Exact token, fee, lock-fee, bond, scheduler parameters; §9.5 challenge parameters, penalty rates, jailing durations, appeal window | UNDECIDED | Phase 2 tokenomics / protocol work. §11 remains preliminary; no supply, price, or rate is invented in v0.4. |
| (h) | Manifest language syntax, state-tree final choice, snapshot/pruning details, networking stack, VRF rotation construction | UNDECIDED | Phase 2 decisions (see §15.1, items D and J). |
| (i) | Equivalence of MARWANTA's strict consecutive-view two-chain formulation to HotStuff-2's double-certificate commit step; ancestor-finality consequence when a certified child is in a non-consecutive view | UNRESOLVED | Phase 2 reconciliation required (§2.2A). v0.4 adopts the strict reading as a specification decision and forbids silently relaxing it to "any certified descendant" without new founder approval. |
| (j) | Whether a replay-audit challenge mechanism can be made spam-resistant and timely at target validator counts | UNRESOLVED | Phase 3 simulation required (§9.5). No spam-resistance or timeliness claim is made in v0.4. |
| (k) | Historical forward references in §§17–18 and Appendices C/D that named v0.4 as the version in which a matrix cell, a novelty upgrade, or a P0 contradiction would be corrected | PARTIALLY RESOLVED | Where the v0.4 body itself contained such a forward reference, it was updated to v0.5 in v0.4. Where the reference sits inside a historical changelog (Appendices C/D, describing what was expected at the time), the original wording is preserved as history and this appendix records the updated target (v0.5) for any item still open. No open item was silently closed by this treatment. |

### E.3 What v0.4 does NOT do

- v0.4 does NOT approve the architecture, does NOT authorise coding, prototype, testnet, mainnet, bridge, partnership announcement, or token launch, and does NOT claim MARWANTA outperforms Ethereum or Solana or contains a genuine invention.
- v0.4 does NOT present any hand argument as a proof, does NOT invent any benchmark, user, TVL, partnership, or audit result, and does NOT fix any token supply, price, or penalty rate.
- v0.4 does NOT change v0.1 (924 lines), v0.2 (1,274 lines), or v0.3 (1,676 lines). Those files are preserved untouched; v0.4 is a new file created by copying v0.3 and editing the copy.

*End of MARWANTA Genesis Architecture Specification v0.4 — DRAFT FOR FOUNDER REVIEW — NOT APPROVED FOR IMPLEMENTATION. Approval remains withheld. No coding, prototype, testnet, or token decisions are authorised by this document.*
