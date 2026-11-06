"""Deterministic hashing helpers for the MARWANTA minimum local prototype.

TEST-ONLY. These are test helpers, not protocol cryptography.
Hashes here are SHA-256 over a canonical, sorted encoding so that
replay is deterministic in this local prototype. They do NOT decide
any protocol proof format, aggregation construction, or signature
scheme (all remain OPEN at protocol level).
"""

import hashlib
import json


def canonical(obj) -> bytes:
    """Canonical JSON encoding: sorted keys, no whitespace."""
    return json.dumps(obj, sort_keys=True, separators=(",", ":")).encode("utf-8")


def sha256_hex(data: bytes) -> str:
    return hashlib.sha256(data).hexdigest()


def domain_root(domain_state: dict) -> str:
    """Deterministic root of one domain's state (sorted key order)."""
    items = [[str(k), int(v)] for k, v in sorted(domain_state.items())]
    return sha256_hex(canonical(items))


def trace_hash(domain: str, key: str, delta: int, pre_root: str) -> str:
    """Deterministic trace hash for one execution step."""
    return sha256_hex(canonical({
        "domain": domain,
        "key": key,
        "delta": int(delta),
        "pre_root": pre_root,
    }))


def block_hash(height: int, view: int, parent_hash: str, tx_hashes) -> str:
    return sha256_hex(canonical({
        "height": int(height),
        "view": int(view),
        "parent_hash": parent_hash,
        "tx_hashes": list(tx_hashes),
    }))


def tx_hash(tx) -> str:
    """Hash of a transaction's content (proof fields included)."""
    return sha256_hex(canonical(tx.to_dict()))
