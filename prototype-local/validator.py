"""Local validators for the MARWANTA minimum local prototype.

TEST-ONLY. Rules implemented here, all local:
- P0 (local form): a validator votes for a block ONLY if, for every
  transaction in the block, in order: DA data is present, replay
  reproduces the claimed proof exactly, capability holds, and metering
  holds. Any failure -> abstain with a recorded reason. There is NO
  "proof-only" voting path: vote() always replays. A well-formed proof
  with a failing replay still abstains (demonstration D-3).
- DA gate (local form): data_available == False -> abstain DA_MISSING,
  even if a proof is attached.
- QC (test): distinct validator ids, threshold 3 of 4 test validators
  (equal test stake, > 2/3). Test signatures are deterministic strings
  "test-sig:<validator>:<block_hash>" — they are TEST markers, NOT
  cryptographic signatures and NOT the protocol aggregation construction
  (D10 remains OPEN at protocol level).
"""

from dataclasses import dataclass

from engine import DomainCrashed, CapabilityError, MeteringError

QC_THRESHOLD_TEST = 3  # of 4 test validators, equal test stake


@dataclass
class Vote:
    validator_id: str
    block_hash: str
    signature: str  # TEST marker only, see module docstring


@dataclass
class Abstention:
    validator_id: str
    reason: str
    detail: str = ""


class Validator:
    def __init__(self, validator_id: str, engine):
        self.validator_id = validator_id
        self.engine = engine

    def vote_for_block(self, block, state: dict):
        """Replay every tx in block order against a working copy of state.

        Returns Vote on full success, else Abstention (first failure).
        The input `state` is never mutated.
        """
        working = {d: dict(s) for d, s in state.items()}
        for tx in block.txs:
            if not tx.data_available:
                return Abstention(self.validator_id, "DA_MISSING",
                                  f"tx {tx.domain}:{tx.key} has no DA data")
            if tx.proof is None:
                return Abstention(self.validator_id, "REPLAY_MISMATCH",
                                  "tx carries no proof to replay against")
            try:
                working, computed = self.engine.execute(tx, working)
            except DomainCrashed as e:
                return Abstention(self.validator_id, "DOMAIN_CRASHED", str(e))
            except CapabilityError as e:
                return Abstention(self.validator_id, "CAPABILITY", str(e))
            except MeteringError as e:
                return Abstention(self.validator_id, "METERING", str(e))
            if (computed.pre_root != tx.proof.pre_root
                    or computed.post_root != tx.proof.post_root
                    or computed.trace != tx.proof.trace):
                return Abstention(
                    self.validator_id, "REPLAY_MISMATCH",
                    f"replay proof differs for tx {tx.domain}:{tx.key}")
        return Vote(
            validator_id=self.validator_id,
            block_hash=block.hash,
            signature=f"test-sig:{self.validator_id}:{block.hash}",
        )


def qc_reached(votes) -> bool:
    """QC reached iff >= QC_THRESHOLD_TEST distinct validators voted."""
    distinct = {v.validator_id for v in votes}
    return len(distinct) >= QC_THRESHOLD_TEST
