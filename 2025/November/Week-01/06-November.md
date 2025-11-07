# 3.10. Synchronized Models

Early multiprocessor systems had:

Multiple processors and shared memory.

Caching/buffering to improve performance.

But they needed to make sure all processors see a consistent view of memory.

To manage this, systems used synchronization variables
Acquire (to enter a critical section)

Release (to leave it)

Key Models
1. Weak Ordering (Dubois et al., 1986)

Goal: Improve performance by relaxing global ordering rules.

Rules:

All synchronization accesses (acquire/release) are strongly ordered.

A process must complete all previous reads before touching a synchronization variable.

Reads/writes to data cannot happen before the next synchronization.

Effect:
Only synchronization operations guarantee order; normal reads/writes can be reordered.

Example:
Two threads can read/write local data independently, but must synchronize before sharing results.

2. Release Consistency (Gharachorloo et al., 1990)

Extension of Weak Ordering.

Distinguishes between:

Acquire: before entering a critical section.

Release: after leaving a critical section.

Operations labeled as:

Strong: must appear in order (like sequential consistency).

Weak: can be delayed or reordered.

Idea: Use synchronization points to decide when memory must be consistent.

Example:
Thread updates data, then does a release(). Another thread calls acquire(), and sees all previous updates.

3. Lazy Release Consistency (Keleher et al., 1992)

Optimization of Release Consistency.

Updates are not propagated on release, but delayed until the next acquire.

Reduces communication overhead.

Example:
Instead of broadcasting every write immediately, send them when another thread actually needs the data.

4. Entry Consistency (Bershad & Zekauskas, 1991)

Strengthens the link between synchronization variables and data.

Each data object is explicitly associated with a synchronization variable.

Improves parallelism: threads can safely access unrelated data concurrently.

Example:
Each shared variable (like x, y) has its own lock  threads working on x and y don’t block each other.

5. Scope Consistency (Iftode et al., 1996)

Simplifies Entry Consistency.

Introduces “scopes”, automatically inferred from how synchronization variables are used.

No need for programmers to manually bind each variable to a lock.

Example:
The system infers that all data accessed between acquire() and release() belong to the same “scope”.

6. Location Consistency (Gao & Sarkar, 2000)

Drops the assumption that all writes to the same variable must be seen in the same order.

Allows partial orders of writes → better performance with less synchronization.

Each object is still linked to a synchronization variable.

Example:
If two threads write to disjoint fields of a shared structure, their updates can be seen in different orders without breaking correctness.



| **Predicate / Term**    | **Formal Summary**                                                                 | **Intuitive Example (2-3 sentences)**                                                  |
| ----------------------- | ---------------------------------------------------------------------------------- | -------------------------------------------------------------------------------------- |
| **SINGLEORDER**         | ∃ total order (`ar`) for all operations.                                           | All operations can be lined up in a single sequence, as if executed one after another. |
| **REALTIME**            | Real-time (`rb`) order respected: if `a` finishes before `b` starts, then `a → b`. | If you write before I read, I must see your write.                                     |
| **RVAL(F)**             | Return value consistent with function F on context C.                              | Each read must return a value allowed by the object’s spec.                            |
| **REALTIMEWRITES**      | Only write→operation real-time edges must hold.                                    | Writes respect real-time order, reads may lag.                                         |
| **SEQRVAL(F)**          | Sequential read values consistent only when no concurrency.                        | If no overlapping ops, reads return the latest write.                                  |
| **EVENTUALVISIBILITY**  | Every op eventually becomes visible to all others.                                 | After some time, everyone sees the same updates.                                       |
| **NOCIRCULARCAUSALITY** | Happens-before relation must be acyclic.                                           | You can’t have circular dependencies like `a → b → a`.                                 |
| **STRONGCONVERGENCE**   | Same visible writes ⇒ same read value.                                             | Two replicas that have applied the same writes must return the same result.            |
| **PRAM**                | Session order (`so`) ⊆ visibility (`vis`).                                         | Each client’s operations appear in its issue order.                                    |
| **MONOTONICREADS**      | If a read sees a value, later reads see that or newer.                             | Your own timeline never moves backward.                                                |
| **READYOURWRITES**      | Each client’s writes are visible to its future reads.                              | You always see your own writes immediately.                                            |
| **MONOTONICWRITES**     | Writes by a process occur in order.                                                | Later writes from the same client never appear before earlier ones.                    |
| **WRITESFOLLOWREADS**   | Writes depend on what was read.                                                    | If you write after reading, your write reflects that knowledge.                        |
| **CAUSALVISIBILITY**    | hb ⊆ vis (happens-before visible).                                                 | Visibility respects causal order.                                                      |
| **CAUSALARBITRATION**   | hb ⊆ ar (arbitration respects causality).                                          | The global order never violates causal order.                                          |
| **NOJOIN**              | Diverged views never merge again.                                                  | Forked clients stay isolated forever.                                                  |
| **ATMOSTONEJOIN**       | At most one reconciliation allowed.                                                | Forked branches can merge at most once.                                                |
| **PEROBJECTPRAM**       | Per-object session order respected.                                                | Each key behaves as PRAM-consistent separately.                                        |

