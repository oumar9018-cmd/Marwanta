"""Deterministic execution engine for the MARWANTA minimum local prototype.

TEST-ONLY implementation, under the approved authorization sheet:
- 2 test domains (any domain names work; tests use "A" and "B").
- Capability rule (test): a transaction may only touch a key belonging
  to its own domain. Key format is "<domain>:<name>", e.g. "A:balance".
- Metering rule (test): 1,000,000 test units per transaction per domain.
  This is a TEST VALUE ONLY, not a protocol metering value (section 20.5
  remains OPEN at protocol level).
- State changes apply ONLY when a block finalises (chain.py). Execution
  here computes a candidate result; it never finalises anything by itself.

Fault model (test): a domain in `crashed` raises DomainCrashed for any
transaction in that domain. That is the fault injector's mechanism
(fault.py), not a real crash.
"""

from dataclasses import dataclass, field

from proof import domain_root, trace_hash

METERING_CAP_TEST_UNITS = 1_000_000


class CapabilityError(ValueError):
    pass


class MeteringError(ValueError):
    pass


class DomainCrashed(RuntimeError):
    pass


@dataclass
class Proof:
    pre_root: str
    post_root: str
    trace: str

    def to_dict(self):
        return {"pre_root": self.pre_root, "post_root": self.post_root, "trace": self.trace}


@dataclass
class Transaction:
    domain: str
    key: str
    delta: int
    units: int
    data_available: bool = True
    proof: Proof | None = None

    def to_dict(self):
        return {
            "domain": self.domain,
            "key": self.key,
            "delta": int(self.delta),
            "units": int(self.units),
            "data_available": bool(self.data_available),
            "proof": self.proof.to_dict() if self.proof else None,
        }


def key_domain(key: str) -> str:
    if ":" not in key:
        raise CapabilityError(f"key {key!r} has no domain prefix")
    return key.split(":", 1)[0]


class Engine:
    """Deterministic, single-domain-step execution. No network, no I/O."""

    def __init__(self, cap_units: int = METERING_CAP_TEST_UNITS):
        self.cap_units = int(cap_units)
        self.crashed: set[str] = set()

    def execute(self, tx: Transaction, state: dict):
        """Execute one tx against a COPY of `state`, return (new_state, proof).

        Raises CapabilityError / MeteringError / DomainCrashed on any
        rule violation. The caller's state is never mutated on failure:
        execution works on a deep-enough copy (domain dicts are copied).
        """
        if tx.domain in self.crashed:
            raise DomainCrashed(f"domain {tx.domain} is crashed (injected fault)")
        if key_domain(tx.key) != tx.domain:
            raise CapabilityError(
                f"tx domain {tx.domain} may not touch key {tx.key!r} "
                f"(belongs to {key_domain(tx.key)})"
            )
        if not isinstance(tx.units, int) or tx.units <= 0 or tx.units > self.cap_units:
            raise MeteringError(
                f"tx units {tx.units} outside test cap 1..{self.cap_units}"
            )
        new_state = {d: dict(s) for d, s in state.items()}
        domain_state = new_state.setdefault(tx.domain, {})
        pre_root = domain_root(domain_state)
        domain_state[tx.key] = int(domain_state.get(tx.key, 0)) + int(tx.delta)
        post_root = domain_root(domain_state)
        proof = Proof(
            pre_root=pre_root,
            post_root=post_root,
            trace=trace_hash(tx.domain, tx.key, tx.delta, pre_root),
        )
        return new_state, proof

    def propose(self, tx: Transaction, state: dict) -> Transaction:
        """Proposer side: run execution once to attach a proof to the tx.

        The attached proof is a CLAIM. Validators must still replay
        independently (validator.py); a proof alone never causes a vote.
        Returns a new Transaction carrying the computed proof.
        """
        _, proof = self.execute(tx, state)
        return Transaction(
            domain=tx.domain,
            key=tx.key,
            delta=tx.delta,
            units=tx.units,
            data_available=tx.data_available,
            proof=proof,
        )
