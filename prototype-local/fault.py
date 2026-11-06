"""Fault injector for the MARWANTA minimum local prototype.

Every fault below is INJECTED and labelled as injected in demo traces.
Injected faults are test inputs, not real faults, and never claim
real-world fault behaviour.
"""

from engine import Transaction


def crash_domain(engine, domain: str):
    engine.crashed.add(domain)


def restore_domain(engine, domain: str):
    engine.crashed.discard(domain)


def tamper_post_root(tx: Transaction) -> Transaction:
    """Return a copy whose proof post_root is wrong (invalid execution)."""
    proof = tx.proof
    bad = type(proof)(
        pre_root=proof.pre_root,
        post_root="0" * 64 if proof.post_root != "0" * 64 else "1" * 64,
        trace=proof.trace,
    )
    return Transaction(
        domain=tx.domain, key=tx.key, delta=tx.delta, units=tx.units,
        data_available=tx.data_available, proof=bad,
    )


def exhausting_tx(domain: str, key: str, cap_units: int) -> Transaction:
    """A transaction whose units exceed the test metering cap."""
    return Transaction(domain=domain, key=key, delta=1,
                       units=int(cap_units) + 1)


def missing_da_tx(engine, state, domain: str, key: str, delta: int) -> Transaction:
    """A correctly-proved transaction with DA data marked missing."""
    raw = Transaction(domain=domain, key=key, delta=delta, units=1000)
    tx = engine.propose(raw, state)
    tx.data_available = False
    return tx
