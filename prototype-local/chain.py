"""Local chain for the MARWANTA minimum local prototype.

TEST implementation of Alternative A (path-gated, test configuration
only — D11 remains OPEN at protocol level). Finalisation rule (test):
a block B finalises iff ALL of the following hold at finalisation time:
  (a) QC(B): >= 3 distinct test validators voted for B;
  (b) a direct child C exists with parent_hash == B.hash, QC(C), and
      either C.view == B.view + 1, or C.view > B.view + 1 with a gap
      certificate covering every skipped view between B.view and C.view
      (gap certificate = >= 3 distinct test attestations "no vote in
      view v" for each skipped view v — test attestations only);
  (c) path gate: walking parent links from B to genesis gives exact
      parent hashes (by construction in this local chain, checked
      explicitly so a broken link cannot finalise).

State rule (protocol rule implemented, not invented here): state
changes apply ONLY when a block finalises. A proposed block that does
not finalise is a CANDIDATE: its effects never touch applied state,
and discarding it (removing it from the tip, if it is the tip) leaves
applied state unchanged. That is demonstration D-7's mechanism.

Gap-certificate branch note (honest limitation): D-1..D-8 traces use
consecutive views only, so the gap-certificate branch below is
implemented but NOT exercised by the demonstration run. Gap
accountability is therefore NOT claimed demonstrated by this prototype.
"""

import threading

from proof import block_hash, tx_hash
from validator import qc_reached


class Block:
    def __init__(self, height, view, parent_hash, txs, votes=None, gap_cert=None):
        self.height = int(height)
        self.view = int(view)
        self.parent_hash = parent_hash
        self.txs = list(txs)
        self.votes = list(votes or [])
        self.gap_cert = gap_cert or {}  # skipped_view -> list of attester ids
        self.hash = block_hash(
            self.height, self.view, self.parent_hash,
            [tx_hash(t) for t in self.txs],
        )

    def qc(self) -> bool:
        return qc_reached(self.votes)


class Chain:
    def __init__(self, engine, genesis_state: dict):
        self.engine = engine
        self.lock = threading.RLock()  # local lock only; NOT a distributed lock
        self.blocks = [Block(0, 0, "genesis", [])]
        self.applied_state = {d: dict(s) for d, s in genesis_state.items()}
        self.finalised = set()
        self.version = 0  # local version counter, incremented on finalisation

    @property
    def tip(self) -> Block:
        return self.blocks[-1]

    def propose(self, txs, votes, view_skip: int = 0, gap_cert=None) -> Block:
        """Append a candidate block. Appending is NOT finalisation."""
        parent = self.tip
        block = Block(
            height=parent.height + 1,
            view=parent.view + 1 + int(view_skip),
            parent_hash=parent.hash,
            txs=txs,
            votes=votes,
            gap_cert=gap_cert,
        )
        self.blocks.append(block)
        return block

    def discard_tip(self, block: Block) -> bool:
        """Discard a non-finalised candidate tip block. Returns True iff discarded."""
        if block.hash in self.finalised:
            return False
        if self.tip.hash != block.hash:
            return False
        self.blocks.pop()
        return True

    def _path_gate_ok(self, block: Block) -> bool:
        """Walk parent links from block to genesis; every link must be exact."""
        by_hash = {b.hash: b for b in self.blocks}
        cur = block
        seen = set()
        while cur.height > 0:
            if cur.hash in seen:
                return False
            seen.add(cur.hash)
            parent = by_hash.get(cur.parent_hash)
            if parent is None or parent.height != cur.height - 1:
                return False
            cur = parent
        return cur.hash == self.blocks[0].hash

    def _child_gate_ok(self, block: Block):
        """Find a qualifying direct child; return (ok, child_or_None)."""
        for child in self.blocks:
            if child.parent_hash != block.hash or not child.qc():
                continue
            if child.view == block.view + 1:
                return True, child
            if child.view > block.view + 1:
                skipped = range(block.view + 1, child.view)
                if all(len(set(child.gap_cert.get(v, []))) >= 3 for v in skipped):
                    return True, child
        return False, None

    def try_finalise(self, block: Block):
        """Attempt finalisation under the test rule. Returns (ok, reason).

        On success, block txs are applied to applied_state in order
        (re-executed deterministically; any application failure blocks
        finalisation instead of partially applying). Version increments
        exactly once per finalised block.
        """
        if block.hash in self.finalised:
            return False, "already finalised"
        if not block.qc():
            return False, "no QC for block"
        if not self._path_gate_ok(block):
            return False, "path gate failed"
        child_ok, _ = self._child_gate_ok(block)
        if not child_ok:
            return False, "no qualifying direct child with QC"
        working = {d: dict(s) for d, s in self.applied_state.items()}
        try:
            for tx in block.txs:
                working, _ = self.engine.execute(tx, working)
        except Exception as e:  # noqa: BLE001 - any application failure blocks finalisation
            return False, f"finalisation application failed: {e}"
        with self.lock:
            if block.hash in self.finalised:
                return False, "already finalised"
            self.applied_state = working
            self.finalised.add(block.hash)
            self.version += 1
        return True, "finalised"

    def recheck_version(self) -> int:
        """Local version re-read (for D-8 local TOCTOU demonstration)."""
        return self.version

    def commit_with_version(self, recheck_version: int, action):
        """Local conditional commit: re-read version under lock, compare,
        run action only on match. Returns (committed, current_version).

        Local lock serializes LOCAL actions only. It does NOT serialize
        against external/global updates (global TOCTOU remains UNRESOLVED
        at protocol level and is excluded from this local prototype).
        """
        with self.lock:
            current = self.version
            if current != recheck_version:
                return False, current
            action()
            return True, self.version
