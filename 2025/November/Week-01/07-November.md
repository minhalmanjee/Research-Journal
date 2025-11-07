# Model Summary

| **Model**                                | **Core Idea**                                                                | **Example**                                                                                                                                               |
| ---------------------------------------- | ---------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| **Linearizability**                      | Global single order of all operations that respects real time.               | Every operation appears to take effect instantaneously between its start and end time. For example, in ZooKeeper or Chubby, once a write returns, all later reads see it. |
| **Sequential Consistency**               | All operations appear in some total order consistent with program order.     | Two clients may see operations in different real-time order but same sequence logic. Think of a multi-core CPU where each thread sees its own writes in order.            |
| **Causal Consistency**                   | Operations that are causally related are seen in the same order by everyone. | If Alice posts a message and Bob replies, everyone sees Alice’s post before Bob’s reply. Unrelated updates may be seen in different orders.                               |
| **Causal+**                              | Causal consistency + strong convergence (identical states).                  | Ensures replicas eventually reach identical states once all causal updates are seen. Used in COPS and Eiger.                                                              |
| **Eventual Consistency**                 | Replicas eventually converge if no new updates occur.                        | Temporary divergence allowed; all replicas sync later. Used in Dynamo, Cassandra, Riak.                                                                                   |
| **Strong Eventual Consistency (SEC)**    | Eventual + commutative updates → replicas converge automatically.            | Used in CRDT systems like AntidoteDB. All replicas reach the same state without coordination.                                                                             |
| **PRAM (FIFO)**                          | Each process’s writes are seen in order by all.                              | If Alice writes `x=1` then `x=2`, everyone sees them in that order. Independent processes may interleave differently.                                                     |
| **Processor Consistency**                | Per-object single order + PRAM across all variables.                         | Combines PRAM with consistent view for each variable. Common in shared memory multiprocessors.                                                                            |
| **Prefix Consistency**                   | Reads return a prefix of the global history.                                 | Like sequential consistency but clients may see “shorter” histories. Often used in timeline consistency systems.                                                          |
| **Fork Consistency (Fork-linearizable)** | Malicious replicas can diverge but never re-merge.                           | Clients that see different forks never see each other’s updates again. Used in SUNDR.                                                                                     |
| **Timed Linearizability**                | Operations must appear within fixed time δ after real-time.                  | Guarantees bounded staleness — e.g., Google Spanner ensures external consistency within a few ms.                                                                         |
| **K-Linearizability**                    | Allows up to K stale reads before being consistent.                          | Reads may be up to K versions old. Implemented in systems like Cosmos DB’s bounded staleness.                                                                             |
| **Eventual Serializability**             | Eventual form of serializable transactions.                                  | Once replicas synchronize, all transactions appear serializable.                                                                                                          |
| **RedBlue Consistency**                  | Operations labeled “red” (strong) or “blue” (weak).                          | Red ops require global coordination; blue ops can execute independently. Used in RedBlue systems (Li et al., 2012).                                                       |


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
