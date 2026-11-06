---- MODULE Marwanta_TTrace_1793873661 ----
EXTENDS Sequences, TLCExt, Toolbox, Marwanta, Naturals, TLC

_expression ==
    LET Marwanta_TEExpression == INSTANCE Marwanta_TEExpression
    IN Marwanta_TEExpression!expression
----

_trace ==
    LET Marwanta_TETrace == INSTANCE Marwanta_TETrace
    IN Marwanta_TETrace!trace
----

_inv ==
    ~(
        TLCGet("level") = Len(_TETrace)
        /\
        st = ([blocks |-> {[id |-> [h |-> 0, fork |-> FALSE], view |-> 0, gapSkipped |-> FALSE, aggValid |-> TRUE, parent |-> [h |-> 0, fork |-> FALSE]]}, votes |-> {}, invalidated |-> {}, gapCerts |-> {}, s7Rec |-> [verifiable |-> TRUE, partition |-> FALSE, epoch |-> 0], s7Chain |-> [partition |-> FALSE, epoch |-> 0], epoch |-> 0, forkProposed |-> FALSE, lastView |-> <<-1, -1, -1, -1>>, lock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sState |-> "OK", hVotes |-> {}, hState |-> "COMPLETE", attestations |-> {}, candidateFinal |-> {}, finalSet |-> {[h |-> 0, fork |-> FALSE]}, finalJust |-> {}, finalQC |-> {}, safeMode |-> FALSE, smReasons |-> {}, exitedSafeMode |-> TRUE, opApproval |-> TRUE, quorumLost |-> FALSE, freeze |-> FALSE, finalisedCounter |-> 0, partitionCounter |-> 0, causeExplained |-> TRUE, epochCounter |-> 0, invGen |-> 0, aggInvalid |-> {}, settlement |-> [state |-> "NONE", bf |-> 0, decideCounter |-> 0], version |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckVer |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckOk |-> FALSE, recheckPresent |-> FALSE, diagnostics |-> {"S7-CONTRADICTORY"}, crashed |-> FALSE, preCrashLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], known |-> FALSE, recovered |-> FALSE, recoveryLockOK |-> TRUE, lockViolated |-> {}, viewViolated |-> {}, safeModeVoted |-> FALSE, freezeViolation |-> FALSE, settledTerminal |-> FALSE, steps |-> 6])
    )
----

_init ==
    /\ st = _TETrace[1].st
----

_next ==
    /\ \E i,j \in DOMAIN _TETrace:
        /\ \/ /\ j = i + 1
              /\ i = TLCGet("level")
        /\ st  = _TETrace[i].st
        /\ st' = _TETrace[j].st

\* Uncomment the ASSUME below to write the states of the error trace
\* to the given file in Json format. Note that you can pass any tuple
\* to `JsonSerialize`. For example, a sub-sequence of _TETrace.
    \* ASSUME
    \*     LET J == INSTANCE Json
    \*         IN J!JsonSerialize("Marwanta_TTrace_1793873661.json", _TETrace)

=============================================================================

 Note that you can extract this module `Marwanta_TEExpression`
  to a dedicated file to reuse `expression` (the module in the 
  dedicated `Marwanta_TEExpression.tla` file takes precedence 
  over the module `Marwanta_TEExpression` below).

---- MODULE Marwanta_TEExpression ----
EXTENDS Sequences, TLCExt, Toolbox, Marwanta, Naturals, TLC

expression == 
    [
        \* To hide variables of the `Marwanta` spec from the error trace,
        \* remove the variables below.  The trace will be written in the order
        \* of the fields of this record.
        st |-> st
        
        \* Put additional constant-, state-, and action-level expressions here:
        \* ,_stateNumber |-> _TEPosition
        \* ,_stUnchanged |-> st = st'
        
        \* Format the `st` variable as Json value.
        \* ,_stJson |->
        \*     LET J == INSTANCE Json
        \*     IN J!ToJson(st)
        
        \* Lastly, you may build expressions over arbitrary sets of states by
        \* leveraging the _TETrace operator.  For example, this is how to
        \* count the number of times a spec variable changed up to the current
        \* state in the trace.
        \* ,_stModCount |->
        \*     LET F[s \in DOMAIN _TETrace] ==
        \*         IF s = 1 THEN 0
        \*         ELSE IF _TETrace[s].st # _TETrace[s-1].st
        \*             THEN 1 + F[s-1] ELSE F[s-1]
        \*     IN F[_TEPosition - 1]
    ]

=============================================================================



Parsing and semantic processing can take forever if the trace below is long.
 In this case, it is advised to uncomment the module below to deserialize the
 trace from a generated binary file.

\*
\*---- MODULE Marwanta_TETrace ----
\*EXTENDS IOUtils, Marwanta, TLC
\*
\*trace == IODeserialize("Marwanta_TTrace_1793873661.bin", TRUE)
\*
\*=============================================================================
\*

---- MODULE Marwanta_TETrace ----
EXTENDS Marwanta, TLC

trace == 
    <<
    ([st |-> [blocks |-> {[id |-> [h |-> 0, fork |-> FALSE], view |-> 0, gapSkipped |-> FALSE, aggValid |-> TRUE, parent |-> [h |-> 0, fork |-> FALSE]]}, votes |-> {}, invalidated |-> {}, gapCerts |-> {}, s7Rec |-> [verifiable |-> TRUE, partition |-> FALSE, epoch |-> 0], s7Chain |-> [partition |-> FALSE, epoch |-> 0], epoch |-> 0, forkProposed |-> FALSE, lastView |-> <<-1, -1, -1, -1>>, lock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sState |-> "OK", hVotes |-> {}, hState |-> "COMPLETE", attestations |-> {}, candidateFinal |-> {}, finalSet |-> {[h |-> 0, fork |-> FALSE]}, finalJust |-> {}, finalQC |-> {}, safeMode |-> FALSE, smReasons |-> {}, exitedSafeMode |-> FALSE, opApproval |-> FALSE, quorumLost |-> FALSE, freeze |-> FALSE, finalisedCounter |-> 0, partitionCounter |-> 0, causeExplained |-> FALSE, epochCounter |-> 0, invGen |-> 0, aggInvalid |-> {}, settlement |-> [state |-> "NONE", bf |-> 0, decideCounter |-> 0], version |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckVer |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckOk |-> FALSE, recheckPresent |-> FALSE, diagnostics |-> {}, crashed |-> FALSE, preCrashLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], known |-> FALSE, recovered |-> FALSE, recoveryLockOK |-> TRUE, lockViolated |-> {}, viewViolated |-> {}, safeModeVoted |-> FALSE, freezeViolation |-> FALSE, settledTerminal |-> FALSE, steps |-> 0]]),
    ([st |-> [blocks |-> {[id |-> [h |-> 0, fork |-> FALSE], view |-> 0, gapSkipped |-> FALSE, aggValid |-> TRUE, parent |-> [h |-> 0, fork |-> FALSE]]}, votes |-> {}, invalidated |-> {}, gapCerts |-> {}, s7Rec |-> [verifiable |-> TRUE, partition |-> FALSE, epoch |-> 0], s7Chain |-> [partition |-> FALSE, epoch |-> 0], epoch |-> 0, forkProposed |-> FALSE, lastView |-> <<-1, -1, -1, -1>>, lock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sState |-> "OK", hVotes |-> {}, hState |-> "COMPLETE", attestations |-> {}, candidateFinal |-> {}, finalSet |-> {[h |-> 0, fork |-> FALSE]}, finalJust |-> {}, finalQC |-> {}, safeMode |-> FALSE, smReasons |-> {}, exitedSafeMode |-> FALSE, opApproval |-> TRUE, quorumLost |-> FALSE, freeze |-> FALSE, finalisedCounter |-> 0, partitionCounter |-> 0, causeExplained |-> FALSE, epochCounter |-> 0, invGen |-> 0, aggInvalid |-> {}, settlement |-> [state |-> "NONE", bf |-> 0, decideCounter |-> 0], version |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckVer |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckOk |-> FALSE, recheckPresent |-> FALSE, diagnostics |-> {}, crashed |-> FALSE, preCrashLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], known |-> FALSE, recovered |-> FALSE, recoveryLockOK |-> TRUE, lockViolated |-> {}, viewViolated |-> {}, safeModeVoted |-> FALSE, freezeViolation |-> FALSE, settledTerminal |-> FALSE, steps |-> 1]]),
    ([st |-> [blocks |-> {[id |-> [h |-> 0, fork |-> FALSE], view |-> 0, gapSkipped |-> FALSE, aggValid |-> TRUE, parent |-> [h |-> 0, fork |-> FALSE]]}, votes |-> {}, invalidated |-> {}, gapCerts |-> {}, s7Rec |-> [verifiable |-> TRUE, partition |-> TRUE, epoch |-> 0], s7Chain |-> [partition |-> FALSE, epoch |-> 0], epoch |-> 0, forkProposed |-> FALSE, lastView |-> <<-1, -1, -1, -1>>, lock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sState |-> "OK", hVotes |-> {}, hState |-> "COMPLETE", attestations |-> {}, candidateFinal |-> {}, finalSet |-> {[h |-> 0, fork |-> FALSE]}, finalJust |-> {}, finalQC |-> {}, safeMode |-> FALSE, smReasons |-> {}, exitedSafeMode |-> FALSE, opApproval |-> TRUE, quorumLost |-> FALSE, freeze |-> FALSE, finalisedCounter |-> 0, partitionCounter |-> 0, causeExplained |-> FALSE, epochCounter |-> 0, invGen |-> 0, aggInvalid |-> {}, settlement |-> [state |-> "NONE", bf |-> 0, decideCounter |-> 0], version |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckVer |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckOk |-> FALSE, recheckPresent |-> FALSE, diagnostics |-> {}, crashed |-> FALSE, preCrashLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], known |-> FALSE, recovered |-> FALSE, recoveryLockOK |-> TRUE, lockViolated |-> {}, viewViolated |-> {}, safeModeVoted |-> FALSE, freezeViolation |-> FALSE, settledTerminal |-> FALSE, steps |-> 2]]),
    ([st |-> [blocks |-> {[id |-> [h |-> 0, fork |-> FALSE], view |-> 0, gapSkipped |-> FALSE, aggValid |-> TRUE, parent |-> [h |-> 0, fork |-> FALSE]]}, votes |-> {}, invalidated |-> {}, gapCerts |-> {}, s7Rec |-> [verifiable |-> TRUE, partition |-> TRUE, epoch |-> 0], s7Chain |-> [partition |-> FALSE, epoch |-> 0], epoch |-> 0, forkProposed |-> FALSE, lastView |-> <<-1, -1, -1, -1>>, lock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sState |-> "OK", hVotes |-> {}, hState |-> "COMPLETE", attestations |-> {}, candidateFinal |-> {}, finalSet |-> {[h |-> 0, fork |-> FALSE]}, finalJust |-> {}, finalQC |-> {}, safeMode |-> TRUE, smReasons |-> {"S7-CONTRADICTORY"}, exitedSafeMode |-> FALSE, opApproval |-> TRUE, quorumLost |-> FALSE, freeze |-> FALSE, finalisedCounter |-> 0, partitionCounter |-> 0, causeExplained |-> FALSE, epochCounter |-> 0, invGen |-> 0, aggInvalid |-> {}, settlement |-> [state |-> "NONE", bf |-> 0, decideCounter |-> 0], version |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckVer |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckOk |-> FALSE, recheckPresent |-> FALSE, diagnostics |-> {"S7-CONTRADICTORY"}, crashed |-> FALSE, preCrashLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], known |-> FALSE, recovered |-> FALSE, recoveryLockOK |-> TRUE, lockViolated |-> {}, viewViolated |-> {}, safeModeVoted |-> FALSE, freezeViolation |-> FALSE, settledTerminal |-> FALSE, steps |-> 3]]),
    ([st |-> [blocks |-> {[id |-> [h |-> 0, fork |-> FALSE], view |-> 0, gapSkipped |-> FALSE, aggValid |-> TRUE, parent |-> [h |-> 0, fork |-> FALSE]]}, votes |-> {}, invalidated |-> {}, gapCerts |-> {}, s7Rec |-> [verifiable |-> TRUE, partition |-> FALSE, epoch |-> 0], s7Chain |-> [partition |-> FALSE, epoch |-> 0], epoch |-> 0, forkProposed |-> FALSE, lastView |-> <<-1, -1, -1, -1>>, lock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sState |-> "OK", hVotes |-> {}, hState |-> "COMPLETE", attestations |-> {}, candidateFinal |-> {}, finalSet |-> {[h |-> 0, fork |-> FALSE]}, finalJust |-> {}, finalQC |-> {}, safeMode |-> TRUE, smReasons |-> {"S7-CONTRADICTORY"}, exitedSafeMode |-> FALSE, opApproval |-> TRUE, quorumLost |-> FALSE, freeze |-> FALSE, finalisedCounter |-> 0, partitionCounter |-> 0, causeExplained |-> FALSE, epochCounter |-> 0, invGen |-> 0, aggInvalid |-> {}, settlement |-> [state |-> "NONE", bf |-> 0, decideCounter |-> 0], version |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckVer |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckOk |-> FALSE, recheckPresent |-> FALSE, diagnostics |-> {"S7-CONTRADICTORY"}, crashed |-> FALSE, preCrashLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], known |-> FALSE, recovered |-> FALSE, recoveryLockOK |-> TRUE, lockViolated |-> {}, viewViolated |-> {}, safeModeVoted |-> FALSE, freezeViolation |-> FALSE, settledTerminal |-> FALSE, steps |-> 4]]),
    ([st |-> [blocks |-> {[id |-> [h |-> 0, fork |-> FALSE], view |-> 0, gapSkipped |-> FALSE, aggValid |-> TRUE, parent |-> [h |-> 0, fork |-> FALSE]]}, votes |-> {}, invalidated |-> {}, gapCerts |-> {}, s7Rec |-> [verifiable |-> TRUE, partition |-> FALSE, epoch |-> 0], s7Chain |-> [partition |-> FALSE, epoch |-> 0], epoch |-> 0, forkProposed |-> FALSE, lastView |-> <<-1, -1, -1, -1>>, lock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sState |-> "OK", hVotes |-> {}, hState |-> "COMPLETE", attestations |-> {}, candidateFinal |-> {}, finalSet |-> {[h |-> 0, fork |-> FALSE]}, finalJust |-> {}, finalQC |-> {}, safeMode |-> TRUE, smReasons |-> {"S7-CONTRADICTORY"}, exitedSafeMode |-> FALSE, opApproval |-> TRUE, quorumLost |-> FALSE, freeze |-> FALSE, finalisedCounter |-> 0, partitionCounter |-> 0, causeExplained |-> TRUE, epochCounter |-> 0, invGen |-> 0, aggInvalid |-> {}, settlement |-> [state |-> "NONE", bf |-> 0, decideCounter |-> 0], version |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckVer |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckOk |-> FALSE, recheckPresent |-> FALSE, diagnostics |-> {"S7-CONTRADICTORY"}, crashed |-> FALSE, preCrashLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], known |-> FALSE, recovered |-> FALSE, recoveryLockOK |-> TRUE, lockViolated |-> {}, viewViolated |-> {}, safeModeVoted |-> FALSE, freezeViolation |-> FALSE, settledTerminal |-> FALSE, steps |-> 5]]),
    ([st |-> [blocks |-> {[id |-> [h |-> 0, fork |-> FALSE], view |-> 0, gapSkipped |-> FALSE, aggValid |-> TRUE, parent |-> [h |-> 0, fork |-> FALSE]]}, votes |-> {}, invalidated |-> {}, gapCerts |-> {}, s7Rec |-> [verifiable |-> TRUE, partition |-> FALSE, epoch |-> 0], s7Chain |-> [partition |-> FALSE, epoch |-> 0], epoch |-> 0, forkProposed |-> FALSE, lastView |-> <<-1, -1, -1, -1>>, lock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], sState |-> "OK", hVotes |-> {}, hState |-> "COMPLETE", attestations |-> {}, candidateFinal |-> {}, finalSet |-> {[h |-> 0, fork |-> FALSE]}, finalJust |-> {}, finalQC |-> {}, safeMode |-> FALSE, smReasons |-> {}, exitedSafeMode |-> TRUE, opApproval |-> TRUE, quorumLost |-> FALSE, freeze |-> FALSE, finalisedCounter |-> 0, partitionCounter |-> 0, causeExplained |-> TRUE, epochCounter |-> 0, invGen |-> 0, aggInvalid |-> {}, settlement |-> [state |-> "NONE", bf |-> 0, decideCounter |-> 0], version |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckVer |-> [chain |-> 0, part |-> 0, settle |-> 0], recheckOk |-> FALSE, recheckPresent |-> FALSE, diagnostics |-> {"S7-CONTRADICTORY"}, crashed |-> FALSE, preCrashLock |-> [id |-> [h |-> -1, fork |-> FALSE], v |-> -1], known |-> FALSE, recovered |-> FALSE, recoveryLockOK |-> TRUE, lockViolated |-> {}, viewViolated |-> {}, safeModeVoted |-> FALSE, freezeViolation |-> FALSE, settledTerminal |-> FALSE, steps |-> 6]])
    >>
----


=============================================================================

---- CONFIG Marwanta_TTrace_1793873661 ----
CONSTANTS
    MaxH = 4
    MaxV = 5
    DeadlineD = 10
    Quorum = 3
    MaxSteps = 10
    EnableAdversarial = TRUE
    EnableCrash = FALSE
    EnablePartition = FALSE
    E3Missing = TRUE
    E4Missing = TRUE
    E5Missing = TRUE

INVARIANT
    _inv

CHECK_DEADLOCK
    \* CHECK_DEADLOCK off because of PROPERTY or INVARIANT above.
    FALSE

INIT
    _init

NEXT
    _next

CONSTANT
    _TETrace <- _trace

ALIAS
    _expression
=============================================================================
\* Generated on Thu Nov 05 15:49:05 IST 2026