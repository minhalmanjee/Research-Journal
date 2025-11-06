# Daily Log - 05-November.md
# Discussion for practical application, literature review sections and gap analysis - rescheduled to Friday
# 3.9 Per-Object Semantics

Idea:

Instead of enforcing consistency across all objects globally, per-object semantics enforce ordering rules for each object separately (or per key).

This allows more efficient implementations, e.g., by sharding data or partitioning state, because operations on different objects don’t have to wait for each other.

Each process must see the writes from another process in order, but only for the same object.

There is no guarantee about how writes to different objects are ordered relative to each other.

1. Slow Memory (Hutto & Ahamad, 1990)

Description: Weaker version of PRAM consistency applied per object.

Rule: All processes see writes by a single process to a specific object in the same order.

Example: If Alice updates her profile picture twice, every server sees those two updates in the order she made them, but updates to Bob’s profile can appear independently.

2. Per-Object (Single Order / Sequential Consistency)

This is a stronger per-object model — it builds on “slow memory” but adds more rules.

Let’s look at two variants from the paper:

a. Per-Object Single Order (or Per-Record Timeline Consistency):

For each object (or key), all processes agree on the same total order of operations.

In other words, every object has its own timeline that everyone sees the same way.

Example:
If P1 writes x=1, P2 writes x=2,
then all processes agree on either x=1 → x=2 or x=2 → x=1.

So, per object, everyone sees the same sequence — even if it differs for different objects.

b. Per-Object Sequential Consistency:

Combines:

Per-object single order (agreement on each object’s timeline)

Per-object PRAM (writer’s order respected)

And correct return values (RVAL(F))

That means:

Each object behaves as if it has its own sequentially consistent history,

But there’s no global sequence across all objects.
3. Per-Object Sequential Consistency

Description: Combines:

Per-object single order (coherence)

PEROBJECTPRAM (writes by a process per object seen in order)

Valid return values (RVAL)

Example: Updates to a document paragraph are seen in the same order by all users, but updates to another paragraph can proceed independently.


Model
What it guarantees
What it doesn’t
PRAM
Order of writes from each process is seen consistently by all (for all objects).
Global order between different processes’ writes.
Slow Memory
Order of writes from each process to each object is seen consistently.
Order between different objects’ writes.


4. Processor Consistency (Goodman, 1989)

Description:

Writes by a process must be observed in the order issued (PRAM).

Writes to the same object must be observed in the same order by all processes (per-object single order).

Example: A CPU’s cache ensures that all writes to a memory cell are observed in order, but writes to other memory cells can be reordered.

5. Per-Object Linearizability

Description: Linearizability applied per object; operations on each object appear instantaneous in real-time order.

Example: Each bank account (key) behaves as if operations happen atomically, but operations on other accounts can proceed independently.

6. Per-Object Causal Consistency

Description: Restriction of causal consistency to individual objects. Operations on one object respect causal ordering, but operations on different objects are independent.

Example: If a user edits a blog post title and then the content, all replicas see the title edit before the content edit, but edits to another post can occur in parallel.



