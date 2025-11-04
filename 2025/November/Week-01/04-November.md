# Daily Log - 04-November.md
# 3.7 - 3.8 Paper 01

In fork-based consistency models, a join happens when two clients who were previously forked (saw different histories) later see a common operation again — meaning their views merge back together.
Fork-Based Models:

They are used when data is stored on an untrusted or faulty server (like a malicious cloud).

The goal is to detect or limit the damage when the server lies or misbehaves.

When the server is honest → everything works like linearizability (strong consistency).

When the server is dishonest → the system “forks” into separate views (histories).

Fork-Linearizability

The strongest of the fork-based models.

If the server misbehaves and makes two clients see different data →
→ those clients’ views are split forever (they never see each other’s updates again).

But if the clients later compare notes (e.g., talk directly), they can detect that the server cheated.

Preserves session order (PRAM) and real-time order.

Good:

Strong guarantees.

Misbehavior can be detected.

Bad:

Harder to achieve; less performant.

Fork* Consistency

A relaxed version of fork-linearizability.

After the server forks two clients’ views, they are allowed to share at most one common operation again.

Easier to implement and allows better performance.

Doesn’t always preserve “monotonic reads” (a client may see older data after newer).



Good:

Better performance.

Allows limited merging of views.
Bad:

Weaker guarantees; not fully PRAM-consistent.

Fork-Sequential Consistency

The weakest model in this family.

Similar idea to sequential consistency (operations appear in some order, not necessarily real-time).

If one client reads another’s data, they must share the same view of everything that happened before that write.

Once forked, clients still cannot rejoin.

Weaker than both fork-linearizable and fork*.

“sharing the same view” means

If B reads a value written by A, then A and B must agree on everything that happened before that write.
They must have the same history of previous operations — they can’t disagree about earlier writes.

Time	Client	Operation	Explanation
1	A	write(x = 1)	A writes 1 to x
2	A	write(x = 2)	A updates x to 2
3	B	read(x) → 2	B reads A’s latest value

Here, since B saw x = 2 (A’s write), fork-sequential consistency says:

B must share the same view of all operations before A’s write(x=2).

So, both A and B agree that:

x was first 1, then 2

They have the same history up to that point.

Summary for join:
Fork → when clients’ histories diverge

Join → when they later overlap or merge again

1. NOJOIN (Fork-Linearizability)

Once two clients’ histories diverge, they can never join again.

Their future operations remain completely separate.

2. ATMOSTONEJOIN (Fork*)

Clients can be forked, but they are allowed to join at most once — that is, share one common operation after diverging.

This gives more flexibility and better performance in practice.

3. NOJOIN (Fork-Sequential)

Same as fork-linearizability:
once forked, clients never rejoin again.

1. Fork-Linearizability

Formal:
FORKLINEARIZABILITY(F) = PRAM ∧ REALTIME ∧ NOJOIN ∧ RVAL(F)

Meaning:
A system is fork-linearizable if:
Each client sees its own operations in the order issued (PRAM).
Operations respect real-time order across clients (REALTIME).
Once two clients’ views diverge, they never merge again (NOJOIN).
All read operations return values allowed by the specification F (RVAL).
This model provides linearizability when the server is correct and ensures that forks are permanent if faults occur.

2. Fork* Consistency
Formal:
FORK*(F) = READYOURWRITES ∧ REALTIME ∧ ATMOSTONEJOIN ∧ RVAL(F)
Meaning:
A system is fork* consistent if:
Each client always sees its own previous writes (READYOURWRITES).
Real-time order is preserved (REALTIME).
Forked clients can share at most one common operation afterward (ATMOSTONEJOIN).
Reads return valid values according to F (RVAL).
This model relaxes fork-linearizability by allowing a single rejoin, improving performance but weakening guarantees.

3. Fork-Sequential Consistency
Formal:
FORKSEQUENTIAL(F) = PRAM ∧ NOJOIN ∧ RVAL(F)
Meaning:
A system is fork-sequentially consistent if:
Each client observes its operations in program order (PRAM).
Once clients diverge, they never rejoin (NOJOIN).
Reads return valid results according to F (RVAL).
It is weaker than fork-linearizability, similar to sequential consistency but with permanent fork separation.

1. Fork-Join Causal Consistency (FJC)

Idea:
Defined by Mahajan et al. (2010), FJC is a weaker form of causal consistency that tolerates Byzantine faults while maintaining safety and availability.

Meaning:

If a correct process performs a write op that depends on another write op′, then every correct process must see op′ before op.

Causal consistency is guaranteed only among correct processes.

Groups of processes that were partitioned (forked) can later merge their histories through reconciliation.

Writes from a faulty (Byzantine) process are treated as concurrent writes from multiple “virtual” processes, so their effects can be merged later.

Extension – Bounded Fork-Join Causal Consistency (BFJC):
Mahajan et al. (2011) extended FJC by limiting how many forks a faulty node can cause, thereby bounding the number of virtual processes needed to model it.


2. Weak Fork-Linearizability

Formal definition:

WEAKFORKLIN(F) =PRAM ∧ 𝐾 - REALTIME(2) ∧ ATMOSTONEJOIN ∧ RVAL(F) 

Meaning:
A system is weakly fork-linearizable if:

PRAM: Each process observes its own operations in order.

K-REALTIME(2): A relaxed real-time order; only limited real-time constraints must hold (not full global real-time).

ATMOSTONEJOIN: Two processes that have diverged (been forked) may share at most one common operation afterward.

RVAL(F): Each read returns a valid value according to the specification F.

This model weakens fork-linearizability in two ways:

It allows one rejoin (like fork* consistency).

It relaxes strict real-time order.

The relaxation enables higher liveness (better progress properties such as wait-freedom).

Comparison:
Weak fork-linearizability and fork* consistency are incomparable—each relaxes different aspects of fork-linearizability.

Fork constraint → same (ATMOSTONEJOIN)

Time constraint → different strength (REALTIME vs K-REALTIME(2))
→ Hence, the two models are incomparable — neither strictly contains the other.

3.8 Composite and Tunable Semantics
1. Hybrid Consistency (Attiya & Friedman, 1992)

Mixes strong and weak operations.

Strong operations: behave like sequential consistency — all processes see them in the same total order.

Weak operations: are faster, may be temporarily inconsistent, but eventually become visible to all.

The order between a process’s own strong and weak operations is preserved.
→important writes = strong, background updates = weak.

2. Eventual Serializability (Fekete et al., 1996)

Description: Operations start with a partial order that eventually stabilizes to a total order. Strict operations have fixed order once completed; non-strict operations can be reordered later.

Example: In a shared calendar app, two users add meetings simultaneously. Initially, different replicas may show different orders, but after synchronization, all replicas agree on a single total order.

3. Eventual Linearizability (Serafini et al., 2010)

Description: Strong operations appear immediately linearized. Weak operations may temporarily violate linearizability but eventually respect real-time order.

Example: A shopping cart allows users to add/remove items even when the server is slow. Actions may appear out of order temporarily, but eventually, all users see the same cart state.

4. QoS / RedBlue Tunable Consistency

Description: Applications specify desired consistency levels per operation. Red operations require coordination (strong consistency), blue operations can execute locally (eventual consistency).

Example: In a social media app: “Like” actions are blue (eventually consistent), while “Send payment” actions are red (strong consistency). The system applies the right consistency automatically.

5. Continuous Consistency (Yu & Vahdat, 2002)

Description: Consistency is measured along three metrics: staleness (time delay), order error (writes applied out of order), and numerical error (writes not yet propagated). Together, these form a continuous describing divergence from linearizability.

Example: In a collaborative document editor, a replica is 2 seconds behind (staleness), missing 1 write (numerical error), and has no reorders (order error). This defines a “consistent enough” state.



Feature
Linearizability
Continuous Consistency
Real-time order
Strictly preserved
May be violated temporarily
Read-your-writes
Always guaranteed
May be delayed (staleness)
Divergence across replicas
None
Allowed, bounded by θ, σ, ν
Performance / availability
Slower, blocking possible
Higher, wait-free operations
Convergence
Immediate
Eventually converges


6. Vector-Field Consistency (Santos et al., 2007)

Description: Each object has a vector [θ, σ, ν] bounding time divergence, update count difference, and value difference. Allows locality-aware consistency in distributed systems.
Vector-Field Consistency ([θ, σ, ν])

θ (theta) – Time divergence:
Maximum allowed delay between replicas for the same object.

Example: In a multiplayer game, a nearby player must see another player’s movement within 100 ms.

σ (sigma) – Update count difference:
Maximum number of updates that can be applied on one replica but not yet on another.

Example: If a player fires three bullets, another replica may see only two for a short time.

ν (nu) – Value difference:
Maximum difference in the actual value of the object across replicas.

Example: Player health may differ by at most 5 points temporarily between replicas.

Key idea:

These three values bound how much replicas can diverge, giving a “local consistency guarantee.”

Allows tight consistency for nearby objects (e.g., close players in a game) and looser consistency for distant objects, optimizing performance without breaking the game.


7. Tunable Consistency in Cloud Storage

Description: Systems dynamically adjust consistency based on client requirements, cost, or performance.

Example: A cloud database uses strong consistency for bank account balances and eventual consistency for product recommendations. Consistency can be adjusted automatically.

8. Explicit Consistency (Balegas et al., 2015)

Description: Combines eventual consistency with application-specific invariants, ensuring user-defined rules are always respected.

Example: A banking app ensures “account balance cannot go negative,” even if replicas update asynchronously.

9. Consistency Anchoring / Hardening (Bessani et al., 2014)

Description: Strengthens weakly consistent data by keeping small metadata in a linearizable store to enforce correctness.

Example: A distributed file service stores large files eventually consistently, but version numbers and metadata are stored in a strongly consistent store to ensure correctness.


