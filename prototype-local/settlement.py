"""Shared local settlement for the MARWANTA minimum local prototype.

TEST implementation, local only. Rules:
- A cross-domain operation involves >= 2 domains.
- Locks are taken in canonical order (domain_id, key_id), sorted —
  the proposer order never decides lock order.
- Decide + apply are ONE candidate: a settlement candidate contains
  both its decide contents and its apply contents together. There is
  no decide-only or apply-only committable candidate (block atomicity,
  local form). The candidate becomes effective ONLY if its block
  finalises (chain.py); otherwise it is discarded with no effect.
  That is the local form of "candidate state unfinalised until the
  block finalises; non-finalised candidate discarded".
"""

from engine import Transaction


def canonical_lock_order(legs):
    """Sort settlement legs by (domain_id, key_id)."""
    return sorted(legs, key=lambda leg: (leg["domain"], leg["key"]))


class SettlementCandidate:
    def __init__(self, legs):
        ordered = canonical_lock_order(legs)
        self.legs = ordered
        self.locks = [(leg["domain"], leg["key"]) for leg in ordered]
        # Decide + apply together: the same legs are both the decide
        # contents and the apply contents of this candidate.
        self.decide = list(ordered)
        self.apply = list(ordered)

    def domains(self):
        return sorted({leg["domain"] for leg in self.legs})

    def is_cross_domain(self) -> bool:
        return len(self.domains()) >= 2

    def to_transactions(self, engine, state):
        """Build proof-carrying transactions for each leg, in lock order.

        Proposer runs execution once per leg (in lock order, on a
        working copy) to attach proofs. Validators still replay
        independently before voting (validator.py).
        """
        working = {d: dict(s) for d, s in state.items()}
        txs = []
        for leg in self.legs:
            raw = Transaction(
                domain=leg["domain"], key=leg["key"],
                delta=int(leg["delta"]), units=int(leg.get("units", 1000)),
            )
            tx = engine.propose(raw, working)
            working, _ = engine.execute(raw, working)
            txs.append(tx)
        return txs
