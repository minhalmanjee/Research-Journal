# Model Summary

# Consistency Models — Categorized Summary (Viotti & Vukolić 2016)

---

##  1. Classic Models

| **Model** | **Definition** | **Example** | **Formal Relation / Predicate** |
|------------|----------------|------------------------------|---------------------------------|
| **Linearizability** | Operations appear instantaneous in real-time order. | A read that starts after a write finishes must return that written value. It is the strongest form of consistency. | `LINEARIZABILITY(F) = SINGLEORDER ∧ REALTIME ∧ RVAL(F)` |
| **Sequential Consistency** | All operations appear in a single global sequence that respects process order but not necessarily real-time. | Two clients see operations in the same order even if timestamps differ. | `SEQUENTIALCONSISTENCY(F) = SINGLEORDER ∧ PRAM ∧ RVAL(F)` |
| **PRAM Consistency** | Writes by each process are seen in the same order by all others. | Everyone observes Alice’s writes in order but Bob’s writes may interleave differently. | `so ⊆ vis` |
| **Processor Consistency** | PRAM + per-object single order. | Writes to each variable appear in a consistent order, but no global total order is required. | `PEROBJECTSINGLEORDER ∧ PRAM ∧ RVAL(F)` |
| **Safe Consistency** | Reads may return the last completed write or any value during concurrent writes. | If a read overlaps a write, it may return old or new data. | `SINGLEORDER ∧ REALTIMEWRITES ∧ SEQRVAL(F)` |
| **Regular Consistency** | Reads return last completed write unless concurrent writes exist. | A read after completion of one write always returns that write’s value. | `SINGLEORDER ∧ REALTIMEWRITES ∧ RVAL(F)` |
| **Quiescent Consistency** | When the system becomes idle, history appears sequentially consistent. | When no operations are in flight, all replicas show the same consistent state. | — |

---

##  2. Causal and Session Models

| **Model** | **Definition** | **Example** | **Formal Relation / Predicate** |
|------------|----------------|--------------|---------------------------------|
| **Causal Consistency** | Preserves happens-before order across processes. | If Alice posts and Bob replies, everyone sees the post before the reply. | `hb ⊆ vis, hb ⊆ ar` |
| **Causal+ Consistency** | Causal + convergence (identical final state). | Servers may apply updates in different orders but end with same result. | `CAUSALITY(F) ∧ STRONGCONVERGENCE` |
| **Real-Time Causal** | Adds real-time order to causal consistency. | Non-overlapping updates respect actual wall-clock order. | `CAUSALITY(F) ∧ REALTIME` |
| **Session (Monotonic Reads/Writes, RYW, WFR)** | Guarantees consistent client session view. | Each client sees its own writes and monotonic reads, even if replicas lag. | `MONOTONICREADS`, `READYOURWRITES`, `MONOTONICWRITES`, `WRITESFOLLOWREADS` |
| **Eventual Consistency** | All replicas converge if no new updates occur. | Short-term divergence is allowed; replicas synchronize eventually. | `EVENTUALVISIBILITY ∧ NOCIRCULARCAUSALITY ∧ RVAL(F)` |
| **Strong Eventual Consistency (SEC)** | Eventual consistency + strong convergence. | Used in CRDTs where concurrent updates deterministically merge. | `EVENTUALCONSISTENCY(F) ∧ STRONGCONVERGENCE` |

---

##  3. Timed / Bounded-Staleness Models

| **Model** | **Definition** | **Example** | **Formal Relation / Predicate** |
|------------|----------------|--------------|---------------------------------|
| **Timed Consistency (Δ-Consistency)** | Each write visible within Δ time. | A database guarantees new values visible within 3 seconds. | `∀a,b. a.rtime + Δ ≤ b.stime ⇒ a vis → b` |
| **Timed Causal Consistency** | Combines causal and Δ-visibility. | A causal chain propagates within a fixed delay. | `CAUSALITY(F) ∧ TIMEDVISIBILITY()` |
| **Timed Linearizability** | Linearizability with time bound δ. | Reads reflect writes within δ ms, maintaining real-time order. | `SINGLEORDER ∧ TIMEDVISIBILITY() ∧ RVAL(F)` |
| **Δ-Atomicity (Timed Serial)** | Reads can return data up to Δ old. | A sensor may show a reading up to 1 second stale. | — |
| **Bounded Staleness / K-Linearizability** | Reads are within K versions or Δ time of latest. | A system ensures users see one of the two newest updates. | `K-LINEARIZABLE(F,K)` |
| **PBS (Probabilistic Bounded Staleness)** | Reads are fresh within Δ with probability p. | 99% of reads show a value ≤ 3 versions old. | — |

---

##  4. Fork-Based Models

| **Model** | **Definition** | **Example** | **Formal Relation / Predicate** |
|------------|----------------|--------------|---------------------------------|
| **Fork-Linearizability** | Misbehaving server causes clients to fork permanently. | If server hides Alice’s write from Bob, they never see each other’s later ops. | `PRAM ∧ REALTIME ∧ NOJOIN ∧ RVAL(F)` |
| **Fork\*** | Allows at most one merge after divergence. | Clients may temporarily rejoin views once. | `READYOURWRITES ∧ REALTIME ∧ ATMOSTONEJOIN ∧ RVAL(F)` |
| **Fork-Sequential Consistency** | Each client sees a sequential history; forks are permanent. | Diverging clients maintain internal consistency. | `PRAM ∧ NOJOIN ∧ RVAL(F)` |
| **Weak Fork-Linearizability** | Fork\* with relaxed real-time (K-REALTIME(2)). | One merge allowed and limited timing constraint. | `PRAM ∧ K-REALTIME(2) ∧ ATMOSTONEJOIN ∧ RVAL(F)` |
| **Fork-Join Causal (FJC)** | Fork consistency under causal ordering. | Byzantine-tolerant model allowing forked yet causally safe views. | — |
| **Bounded Fork-Join Causal** | Limits fork depth to bounded divergence. | Detects and bounds malicious forks. | — |

---

##  5. Hybrid / Eventual Variants

| **Model** | **Definition** | **Example** | **Formal Relation / Predicate** |
|------------|----------------|--------------|---------------------------------|
| **Hybrid Consistency** | Combines strong (synchronous) and weak (async) ops. | Banking uses strong for transfers, weak for logging. | — |
| **Eventual Serializability** | Operations converge to a serial order over time. | Temporary divergence resolves to one consistent history. | — |
| **Eventual Linearizability** | Linearizable view emerges eventually. | Clients may see temporary reordering but settle to real-time order. | — |
| **RedBlue / QoS Consistency** | Tunable mix of strong (“red”) and weak (“blue”) ops. | Payment = red, “like” = blue. | — |
| **Continuous / Vector-Field Consistency** | Quantifies deviation via time/order/value metrics. | Game objects update within thresholds [θ, σ, ν]. | — |
| **Tunable Consistency** | Runtime-adjustable per operation. | App uses strong for auth, weak for analytics. | — |

---

## 6. Per-Object Models

| **Model** | **Definition** | **Example** | **Formal Relation / Predicate** |
|------------|----------------|--------------|---------------------------------|
| **Per-Object PRAM** | PRAM applied per object. | Each key’s writes by a process appear in order. | `(so ∩ ob) ⊆ vis` |
| **Per-Object Single Order** | Agreement on write order per object. | All replicas agree on order of updates to same item. | `ar ∩ ob = vis ∩ ob \ (H⊥ × H)` |
| **Per-Object Sequential** | Per-object single order + PRAM. | Each object behaves sequentially consistent. | `PEROBJECTSINGLEORDER ∧ PEROBJECTPRAM ∧ RVAL(F)` |
| **Per-Object Causal** | Causal consistency per object. | Post title precedes content update on all replicas. | — |
| **Per-Object Linearizability** | Linearizability applied independently per object. | Each account balance updated atomically, separate from others. | — |

---

## 7. Synchronized (Memory) Models

| **Model** | **Definition** | **Example** | **Formal Relation / Predicate** |
|------------|----------------|--------------|---------------------------------|
| **Weak Ordering** | Only synchronized accesses are ordered. | Threads reorder independent writes but respect locks. | — |
| **Release Consistency** | Writes become visible at synchronization release. | Data written before a release is visible after acquire. | — |
| **Entry / Scope Consistency** | Synchronization defines variable scope visibility. | Variables bound to specific locks propagate updates. | — |

---

> 📖 **References:**  
> Viotti, P., & Vukolić, M. (2016). *Consistency in Non-Transactional Distributed Storage Systems.* ACM Computing Surveys 49 (1).  
> All formal predicates from Tables I–II and Section 3 (Preliminaries to Synchronized Models).



# Model Implementations - Appendix

| **Consistency Model**                     | **Seminal Definition / Paper**            | **Implementations **                   |
| ----------------------------------------- | ----------------------------------------- | -------------------------------------------------- |
| **Linearizability**                       | Herlihy & Wing (1990)                     | Chubby, Bigtable, GFS, Spanner, ZooKeeper          |
| **Sequential Consistency**                | Lamport (1979)                            | TreadMarks, Memory Coherence protocols             |
| **Causal Consistency**                    | Ahamad et al. (1995), Lamport (1978)      | Causal Store, Bayou, Lazy Replication, COPS, Eiger |
| **Causal+**                               | Lloyd et al. (2011)                       | COPS-GP, Eiger, GentleRain                         |
| **Eventual Consistency**                  | Terry et al. (1994), Vogels (2008)        | Dynamo, Cassandra, Riak, PNUTS, Azure Storage      |
| **Strong Eventual Consistency**           | Shapiro et al. (2011)                     | CRDT systems (AntidoteDB, Riak DT)                 |
| **Fork-Linearizability**                  | Mazières & Shasha (2002)                  | SUNDR, Depot                                       |
| **Fork***                                 | Li & Mazières (2007)                      | SPORC, Depot                                       |
| **Eventual Serializability**              | Fekete et al. (1996)                      | Bayou-like replicated DBs                          |
| **RedBlue Consistency**                   | Li et al. (2012)                          | RedBlue systems, AntidoteDB                        |
| **K-Linearizability / Bounded Staleness** | Aiyer et al. (2005); Bailis et al. (2012) | Cosmos DB, PNUTS                                   |
| **Timed Linearizability**                 | Torres-Rojas & Meneses (2005)             | Google Spanner                                     |
| **PRAM (FIFO)**                           | Lipton & Sandberg (1988)                  | Shared memory systems                              |
| **Processor Consistency**                 | Goodman (1989)                            | Early multiprocessor architectures                 |
| **Release Consistency**                   | Gharachorloo et al. (1990)                | Lazy Release Consistency (Keleher et al. 1992)     |
| **Weak Ordering**                         | Dubois et al. (1986)                      | Multiprocessor hardware memory models              |
