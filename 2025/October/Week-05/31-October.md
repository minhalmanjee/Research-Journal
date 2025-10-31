# Daily Log - 31-October.md
# Section 3 - Paper 01

consistency models for systems where operations happen one at a time, rather than in multi-step transactions. These are called non-transactional consistency semantics.

Keep Consistency (sacrifice Availability):

The system refuses to answer requests until all nodes agree (waits for the partition to heal).

This maintains linearizability (everyone sees the same order of operations),
but the system might appear unavailable during the partition.

Keep Availability (sacrifice Consistency):

Each partition keeps serving requests independently.

The system stays up, but replicas might temporarily disagree — breaking linearizability.

Later, updates are reconciled (this leads to eventual consistency).

Linearizability = all operations happened instantly, one after another, in real time

Everyone agrees on one global order (SINGLEORDER),

That order respects real-time events (REALTIME),

And all reads return correct values based on that order (RVAL(F)).

a. EVENTUALVISIBILITY
If one operation finishes (a), then any later operations (b) will eventually be able to see it.

“Eventually visible” means that after some time, all later operations will see the effect of a.

But temporary delays are okay — it doesn’t have to happen immediately.

So, even if updates take time to propagate, they’ll eventually reach everyone.




b. NOCIRCULARCAUSALITY
The happens-before relation (hb) must not form loops.

So there can’t be circular dependencies like “A depends on B, and B depends on A.”
This ensures the system’s history makes logical sense.

c. RVAL(F)

Same as before — the return values of operations must match what’s expected based on the visible writes.

Eventual consistency means that operations might not see each other’s effects immediately, but given enough time (and no failures), all replicas will end up agreeing on the same data and results.

Quiescent Consistency
If the system stops getting updates (becomes “quiet”), it should look as if all operations happened in some sequential (one-at-a-time) order. So, if the system keeps receiving writes forever, it might never stabilize.

PRAM: All processes see the writes from any one process in the same order they were issued.

But: Writes from different processes can appear in different orders to different observers.

The session order (so) — the order of operations by the same process — must be part of the visibility relation (vis).
So everyone must respect how each process ordered its own writes.

SEQUENTIALCONSISTENCY(F)=SINGLEORDER∧PRAM∧RVAL(F)

That means:

SINGLEORDER: there is one common total order of all operations.

PRAM: each process’s local order is respected.

RVAL(F): return values make sense given that order.



Linearizability is like sequential consistency plus real-time order:

If one operation finishes before another starts in real time, it must appear before it in the global order.

So:

Everyone sees the same total order (like sequential consistency).

That order must also match real-time causality.

Session Guarantees:
1. Monotonic Reads (MR)

Once you’ve seen an update, you’ll never read an older version afterward.

2. Read Your Writes (RYW)

After you write something, you should always be able to read it.

3. Monotonic Writes (MW)

Writes from the same process must be applied in the same order everywhere.

4. Writes Follow Reads (WFR)

A write must happen after any writes whose effects you’ve already read.

CAUSALVISIBILITY: every operation must see all operations that causally happened before it.
→ formally: hb ⊆ vis

CAUSALARBITRATION: causally related operations must appear in the same order everywhere.
→ formally: hb ⊆ ar

PRAM ensures that each process’s own writes are seen in order, but it doesn’t connect reads and writes across processes.



Causal+ consistency:
Adds strong convergence, meaning all replicas that see the same writes will eventually agree on the final state (even if they apply them in different orders).

Real-time causal consistency:
Adds real-time order — if two writes don’t overlap in real time, everyone must apply them in that order.

Observable causal consistency:
Makes sure that if two operations are concurrent, processes can tell that they were concurrent.

Two Ways to Measure Staleness

Time-based:
How much real time has passed since the latest write.

Version-based:
How many newer writes have occurred since the value you read.


1. Delta Consistency
A write must become visible to everyone within Δ (delta) time units.

Writes from the same process keep their order, but writes from different processes may appear in different orders.

2. Timed Consistency
If a write happens at time t, every read after time t + τ must see it.

“τ” is the maximum time a read is allowed to be stale

3. Bounded Staleness: adds a periodic update signal to help nodes stay up-to-date.

4. Timed Causal Consistency

Combines causal consistency (operations respect causal order) amd timed visibility (writes visible within Δ).



5. Timed Serial Consistency (or Δ-Atomicity)

Adds a global order like linearizability, but allows Δ delay.

If Δ = 0 → system is linearizable.

If Δ > 0 → reads can lag behind by Δ time units.

Model	Read Behavior
Linearizable (Δ = 0)	Must always see the latest committed value.
Delta (e.g., Δ = 3s)	Reads may be outdated for up to 3s, then must see the new value.
Eventually Consistent: 	No guarantee when the new value becomes visible.

6. Prefix Consistency
Prefix Sequential Consistency: Order of writes respected, but not real-time.

Prefix Linearizable: Adds real-time ordering.

7. . K-Linearizability (Version-Based)

Reads may return one of the last K written values.

K = 1 → perfect linearizability.

K > 1 → allows up to K–1 older versions.

So instead of “within Δ time,” this one bounds staleness by “how many updates behind.”

8. Probabilistic Bounded Staleness (PBS)
PBS k-staleness: A read returns one of the last k versions with high probability.

PBS t-visibility: A write becomes visible within t time units with high probability.

PBS k,t-staleness: Combines both.

“Most reads are fresh, but occasionally a stale one might appear.”

