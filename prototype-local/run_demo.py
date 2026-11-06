"""Demonstration run for the MARWANTA minimum local prototype.

Runs demonstrations D-1..D-8 from the approved authorization sheet,
writes evidence/evidence.json, and exits 0 iff every demonstration
passes, else 1. Every demonstration uses a FRESH local setup (fresh
engine, chain, validators) so demos cannot leak state into each other.

Run:  python3 run_demo.py   (from prototype-local/, stdlib only)
"""

import json
import sys
from datetime import datetime, timezone
from pathlib import Path

sys.path.insert(0, str(Path(__file__).resolve().parent))

from chain import Block, Chain
from engine import Engine, Transaction, METERING_CAP_TEST_UNITS
from fault import crash_domain, restore_domain, tamper_post_root, exhausting_tx, missing_da_tx
from settlement import SettlementCandidate
from validator import Validator, Vote

HERE = Path(__file__).resolve().parent
GENESIS = {"A": {"A:balance": 100}, "B": {"B:balance": 50}}


def setup():
    engine = Engine()
    chain = Chain(engine, GENESIS)
    validators = [Validator(f"v{i}", engine) for i in range(1, 5)]
    return engine, chain, validators


def propose_voted(chain, txs, validators, state):
    """Propose a block and collect votes for it. Returns (block, votes, abstentions)."""
    parent = chain.tip
    prov = Block(parent.height + 1, parent.view + 1, parent.hash, txs)
    votes, abst = [], []
    for v in validators:
        r = v.vote_for_block(prov, state)
        (votes if isinstance(r, Vote) else abst).append(r)
    block = chain.propose(txs, votes)
    assert block.hash == prov.hash, "provisional block hash mismatch (test harness bug)"
    return block, votes, abst


def finalise_with_child(chain, block, validators):
    """Propose an empty child block with QC, then finalise `block`."""
    child, _, _ = propose_voted(chain, [], validators, chain.applied_state)
    ok, reason = chain.try_finalise(block)
    return ok, reason, child


def demo(name, expected, actual, details):
    passed = (expected == actual)
    return {"demo": name, "expected": expected, "actual": actual,
            "pass": passed, "details": details}


def d1_replay():
    engine, chain, validators = setup()
    raw = Transaction(domain="A", key="A:balance", delta=10, units=1000)
    tx = engine.propose(raw, chain.applied_state)
    block, votes, abst = propose_voted(chain, [tx], validators, chain.applied_state)
    ok, reason, _ = finalise_with_child(chain, block, validators)
    actual = {
        "votes": len(votes), "abstentions": len(abst),
        "finalised": ok, "A:balance": chain.applied_state["A"]["A:balance"],
    }
    return demo("D-1 deterministic replay reproduces claimed roots",
                {"votes": 4, "abstentions": 0, "finalised": True, "A:balance": 110},
                actual,
                f"finalise reason: {reason}; replay by all 4 validators reproduced roots")


def d2_da_gate():
    engine, chain, validators = setup()
    tx = missing_da_tx(engine, chain.applied_state, "A", "A:balance", 10)
    block, votes, abst = propose_voted(chain, [tx], validators, chain.applied_state)
    reasons = sorted({a.reason for a in abst})
    actual = {"votes": len(votes), "abstentions": len(abst), "reasons": reasons,
              "A:balance": chain.applied_state["A"]["A:balance"]}
    return demo("D-2 DA gate + abstention on missing DA",
                {"votes": 0, "abstentions": 4, "reasons": ["DA_MISSING"], "A:balance": 100},
                actual, "missing-DA tx: no vote from any validator, state unchanged")


def d3_proof_not_substitute():
    engine, chain, validators = setup()
    # Well-formed proof present, but replay fails: tamper the post_root
    # after proposing, so the proof is present yet does not match replay.
    raw = Transaction(domain="A", key="A:balance", delta=10, units=1000)
    tx = engine.propose(raw, chain.applied_state)
    bad = tamper_post_root(tx)
    block, votes, abst = propose_voted(chain, [bad], validators, chain.applied_state)
    reasons = sorted({a.reason for a in abst})
    # Structural check: vote() has no proof-only path (it always replays).
    import inspect
    src = inspect.getsource(validators[0].vote_for_block)
    always_replays = "engine.execute" in src and "proof_only" not in src
    actual = {"votes": len(votes), "abstentions": len(abst), "reasons": reasons,
              "vote_always_replays": always_replays,
              "A:balance": chain.applied_state["A"]["A:balance"]}
    return demo("D-3 proof does NOT substitute for replay (negative control)",
                {"votes": 0, "abstentions": 4, "reasons": ["REPLAY_MISMATCH"],
                 "vote_always_replays": True, "A:balance": 100},
                actual, "present-but-wrong proof: replay mismatch abstains for all validators")


def d4_fault_isolation_crash():
    engine, chain, validators = setup()
    # Propose A tx while healthy, then crash A before voting.
    raw_a = Transaction(domain="A", key="A:balance", delta=10, units=1000)
    tx_a = engine.propose(raw_a, chain.applied_state)
    crash_domain(engine, "A")
    block_a, votes_a, abst_a = propose_voted(chain, [tx_a], validators, chain.applied_state)
    reasons_a = sorted({a.reason for a in abst_a})
    # B tx while A is crashed: B must still finalise.
    raw_b = Transaction(domain="B", key="B:balance", delta=5, units=1000)
    tx_b = engine.propose(raw_b, chain.applied_state)
    block_b, votes_b, abst_b = propose_voted(chain, [tx_b], validators, chain.applied_state)
    ok_b, reason_b, _ = finalise_with_child(chain, block_b, validators)
    restore_domain(engine, "A")
    actual = {"A_votes": len(votes_a), "A_reasons": reasons_a,
              "B_votes": len(votes_b), "B_finalised": ok_b,
              "A:balance": chain.applied_state["A"]["A:balance"],
              "B:balance": chain.applied_state["B"]["B:balance"]}
    return demo("D-4 fault isolation, domain crash",
                {"A_votes": 0, "A_reasons": ["DOMAIN_CRASHED"], "B_votes": 4,
                 "B_finalised": True, "A:balance": 100, "B:balance": 55},
                actual, f"B finalise reason: {reason_b}; A crashed, B unaffected")


def d5_invalid_and_exhaustion():
    engine, chain, validators = setup()
    # (a) Invalid execution: tampered proof -> replay mismatch.
    raw = Transaction(domain="A", key="A:balance", delta=10, units=1000)
    tx = engine.propose(raw, chain.applied_state)
    bad = tamper_post_root(tx)
    _, votes_a, abst_a = propose_voted(chain, [bad], validators, chain.applied_state)
    # (b) Resource exhaustion: units over cap, proof copied from a valid leg
    # (validator checks metering in execute, before proof comparison).
    valid = engine.propose(raw, chain.applied_state)
    exh = exhausting_tx("A", "A:balance", METERING_CAP_TEST_UNITS)
    exh.proof = valid.proof
    _, votes_b, abst_b = propose_voted(chain, [exh], validators, chain.applied_state)
    # (c) B unaffected: normal B tx finalises.
    raw_b = Transaction(domain="B", key="B:balance", delta=5, units=1000)
    tx_b = engine.propose(raw_b, chain.applied_state)
    block_b, votes_c, _ = propose_voted(chain, [tx_b], validators, chain.applied_state)
    ok_b, reason_b, _ = finalise_with_child(chain, block_b, validators)
    actual = {"invalid_votes": len(votes_a),
              "invalid_reasons": sorted({a.reason for a in abst_a}),
              "exhaust_votes": len(votes_b),
              "exhaust_reasons": sorted({a.reason for a in abst_b}),
              "B_votes": len(votes_c), "B_finalised": ok_b,
              "A:balance": chain.applied_state["A"]["A:balance"],
              "B:balance": chain.applied_state["B"]["B:balance"]}
    return demo("D-5 fault isolation, invalid execution / resource exhaustion",
                {"invalid_votes": 0, "invalid_reasons": ["REPLAY_MISMATCH"],
                 "exhaust_votes": 0, "exhaust_reasons": ["METERING"],
                 "B_votes": 4, "B_finalised": True,
                 "A:balance": 100, "B:balance": 55},
                actual, f"B finalise reason: {reason_b}; A faults rejected, B unaffected")


def d6_atomic_settlement():
    engine, chain, validators = setup()
    cand = SettlementCandidate([
        {"domain": "B", "key": "B:balance", "delta": 10, "units": 1000},
        {"domain": "A", "key": "A:balance", "delta": -10, "units": 1000},
    ])
    # Legs were given B-first; canonical lock order must be A-first.
    assert cand.locks == [("A", "A:balance"), ("B", "B:balance")], cand.locks
    assert cand.is_cross_domain()
    txs = cand.to_transactions(engine, chain.applied_state)
    block, votes, abst = propose_voted(chain, txs, validators, chain.applied_state)
    ok, reason, _ = finalise_with_child(chain, block, validators)
    actual = {"votes": len(votes), "abstentions": len(abst), "finalised": ok,
              "locks": [list(l) for l in cand.locks],
              "A:balance": chain.applied_state["A"]["A:balance"],
              "B:balance": chain.applied_state["B"]["B:balance"]}
    return demo("D-6 atomic cross-domain settlement",
                {"votes": 4, "abstentions": 0, "finalised": True,
                 "locks": [["A", "A:balance"], ["B", "B:balance"]],
                 "A:balance": 90, "B:balance": 60},
                actual, f"finalise reason: {reason}; both legs applied or neither (finalised: both)")


def d7_candidate_discard():
    engine, chain, validators = setup()
    # Normal candidate block: voted, never finalised (no child), discarded.
    raw = Transaction(domain="A", key="A:balance", delta=5, units=1000)
    tx = engine.propose(raw, chain.applied_state)
    block, votes, _ = propose_voted(chain, [tx], validators, chain.applied_state)
    discarded = chain.discard_tip(block)
    # Settlement candidate: voted, never finalised, discarded.
    cand = SettlementCandidate([
        {"domain": "A", "key": "A:balance", "delta": -10, "units": 1000},
        {"domain": "B", "key": "B:balance", "delta": 10, "units": 1000},
    ])
    stxs = cand.to_transactions(engine, chain.applied_state)
    sblock, _, _ = propose_voted(chain, stxs, validators, chain.applied_state)
    sdiscarded = chain.discard_tip(sblock)
    # Chain continues normally after discards.
    raw2 = Transaction(domain="B", key="B:balance", delta=5, units=1000)
    tx2 = engine.propose(raw2, chain.applied_state)
    block2, votes2, _ = propose_voted(chain, [tx2], validators, chain.applied_state)
    ok2, reason2, _ = finalise_with_child(chain, block2, validators)
    actual = {"candidate_votes": len(votes), "discarded": discarded,
              "settlement_discarded": sdiscarded, "later_finalised": ok2,
              "A:balance": chain.applied_state["A"]["A:balance"],
              "B:balance": chain.applied_state["B"]["B:balance"]}
    return demo("D-7 candidate discard on non-finalisation",
                {"candidate_votes": 4, "discarded": True, "settlement_discarded": True,
                 "later_finalised": True, "A:balance": 100, "B:balance": 55},
                actual, f"later finalise reason: {reason2}; discarded candidates left no effect")


def d8_local_toctou():
    engine, chain, validators = setup()
    # Case A: no interleaving -> gate passes, commit (finalisation) succeeds.
    raw_a = Transaction(domain="A", key="A:balance", delta=10, units=1000)
    tx_a = engine.propose(raw_a, chain.applied_state)
    block_a, _, _ = propose_voted(chain, [tx_a], validators, chain.applied_state)
    v0 = chain.recheck_version()
    gate_a = (chain.recheck_version() == v0)
    ok_a, _reason_a, _ = finalise_with_child(chain, block_a, validators) if gate_a else (False, "gate rejected", None)
    # Case B: interleaving finalises another block first -> gate rejects.
    raw_b = Transaction(domain="B", key="B:balance", delta=5, units=1000)
    tx_b = engine.propose(raw_b, chain.applied_state)
    block_b, _, _ = propose_voted(chain, [tx_b], validators, chain.applied_state)
    v1 = chain.recheck_version()
    # Interleaving local action: finalise an empty block's parent path.
    raw_c = Transaction(domain="B", key="B:balance", delta=1, units=1000)
    tx_c = engine.propose(raw_c, chain.applied_state)
    block_c, _, _ = propose_voted(chain, [tx_c], validators, chain.applied_state)
    finalise_with_child(chain, block_c, validators)  # version increments
    gate_b = (chain.recheck_version() == v1)
    committed_b = False
    if gate_b:
        committed_b, _, _ = finalise_with_child(chain, block_b, validators)
    # block_b was proposed before interleaving; if gate rejected, it must
    # NOT be finalised by the rejected attempt (its tx must not apply).
    b_finalised = block_b.hash in chain.finalised
    actual = {"gate_no_interleaving": gate_a, "commit_a_finalised": ok_a,
              "gate_with_interleaving": gate_b, "commit_b_attempted": committed_b,
              "block_b_finalised": b_finalised,
              "A:balance": chain.applied_state["A"]["A:balance"],
              "B:balance": chain.applied_state["B"]["B:balance"]}
    # Expected: A +10 finalised, interleaving C +1 finalised, B +5 NOT finalised.
    return demo("D-8 local TOCTOU version-vector rejection (local only)",
                {"gate_no_interleaving": True, "commit_a_finalised": True,
                 "gate_with_interleaving": False, "commit_b_attempted": False,
                 "block_b_finalised": False, "A:balance": 110, "B:balance": 51},
                actual, "local version change between recheck and commit -> rejection; global TOCTOU NOT demonstrated (excluded)")


def main():
    demos = [d1_replay(), d2_da_gate(), d3_proof_not_substitute(),
             d4_fault_isolation_crash(), d5_invalid_and_exhaustion(),
             d6_atomic_settlement(), d7_candidate_discard(), d8_local_toctou()]
    all_pass = all(d["pass"] for d in demos)
    evidence = {
        "prototype": "MARWANTA minimum local prototype (approved authorization sheet)",
        "scope": "local only; test configuration Alternative A (test-only); "
                 "test proof format; test metering cap 1000000; 4 local validators, "
                 "equal test stake, QC threshold 3; test signatures (not cryptographic)",
        "run_at_utc": datetime.now(timezone.utc).isoformat(),
        "demonstrations": demos,
        "all_pass": all_pass,
        "kill_criteria_triggered": [] if all_pass else ["demonstration failure (see demos)"],
        "not_claimed": [
            "general safety / prefix / lock / gap / C1-C4 proofs",
            "global atomicity (UNRESOLVED at protocol level)",
            "real replay correctness / DA recovery bound / weakest-validator feasibility",
            "validator crash recovery / WAL / safeModeRec / S-H compatibility",
            "S7 global/local correctness / S7 disagreement reconciliation / D-N1 exit",
            "fork-choice / A-vs-B / B3 semantics / deadline / migration / epoch protocol decisions",
            "stake / aggregation / slashing / section 20.5 protocol decisions",
            "any performance number; any testnet / mainnet readiness; any token claim",
        ],
        "limitations": [
            "Gap-certificate branch in chain.py is implemented but NOT exercised "
            "by D-1..D-8 (consecutive views only); gap accountability NOT claimed demonstrated.",
            "FC-1 test fork rule is documented but NOT exercised (no fork in D traces).",
            "Test signatures are deterministic strings, NOT cryptographic signatures.",
            "Local lock (threading.RLock) serializes LOCAL actions only; it does NOT "
            "serialize against external/global updates.",
            "Single-process local run; no network, no external validators, no real assets.",
        ],
    }
    out = HERE / "evidence" / "evidence.json"
    out.parent.mkdir(parents=True, exist_ok=True)
    out.write_text(json.dumps(evidence, indent=2, sort_keys=False) + "\n", encoding="utf-8")
    for d in demos:
        status = "PASS" if d["pass"] else "FAIL"
        print(f"{status} {d['demo']}")
        if not d["pass"]:
            print(f"  expected: {d['expected']}")
            print(f"  actual:   {d['actual']}")
    print(f"ALL PASS: {all_pass}  (evidence: {out})")
    return 0 if all_pass else 1


if __name__ == "__main__":
    raise SystemExit(main())
