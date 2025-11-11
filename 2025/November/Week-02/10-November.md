# Daily Log - 10-November.md
Strict Consistency: At time t’ > t, all writes written at t must be visible iff:
	→ write operation happens at t
→ this is the latest write operation
Regardless of number of replicas, all Processes must receive response in real time which is consistent with real time.

Due to the nonzero latency of the messages, strict consistency is not implementable on distributed hardware


Linearizability → Cares about time
Sequential Consistency → Cares about order


Linearizability (slightly weaker than strong consistency due to real time ordering while strict consistency is instantaneous):
Behavior of a single copy
Read returns most recent write
All subsequent return same operation until next write
Global Total order (order of internal reads by processes and external order of processes)
The ordering should give an illusion that it has a single copy. 

Sequential Consistency (weaker than Linearizability as no respect the external ordering of the processes).
All processes should see all the write operations in the same order
All subsequent read ops should return the same result until the next write, regardless of the clients.
Respect Internal Ordering, no need for external ordering of processes.

Linearizability vs. sequential consistency
– With sequential consistency, the system has freedom as to
how to interleave operations coming from different clients,
as long as the ordering from each client is preserved.
– With linearizability, the interleaving across all clients is pretty
much determined already based on time.


Sequential consistency = “Each process’s story stays in order — but everyone can tell the story differently, as long as the final timeline makes sense.”

![Sequential Diagram](https://raw.githubusercontent.com/minhalmanjee/Research-Journal/main/2025/November/Week-02/sequential.png)

A Satisfies Linearizability, Sequential consistency, B satisfies neither as Read of  y =1 happens at 23 and Write of y =1 happens at 32. So read before write is incorrect.


Causal Consistency:
1. Every process must see all writes that are causally related.
2. Read order must be consistent with causal order.

![Causal Diagram](https://raw.githubusercontent.com/minhalmanjee/Research-Journal/main/2025/November/Week-02/Causal.png)

The two writes (W(x=10) and W(x=20)) are concurrent. There is no causal (“happens-before”) relationship between them. Process C is free to see them in the order W(20) then W(10),
so its reads return 20 → 10. Process D is free to see them in the order W(10) then W(20),
so its reads return 10 → 20. Violates: All processes should see all the write operations in the same order.

Eventual Consistency:
if no new write operations are invoked on the object, eventually all reads will return the same value
 

