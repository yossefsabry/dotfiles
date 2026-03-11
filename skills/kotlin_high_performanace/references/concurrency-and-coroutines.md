# Concurrency And Coroutines

## Goal

Use concurrency to remove wall-clock time only when the workload is independent enough to justify the added coordination, synchronization, and correctness cost.

## What the local sources show

- `reference/Chapter09/Bakery.kt` compares sequential work, thread-pool work, reactive work, coroutine-based work, producer-style work, and suspending sequence patterns.
- `reference/Chapter09/Benchmarks.kt` compares `order()` and `fastOrder()` under JMH.
- `reference/Chapter09/Baker.kt` models CPU-heavy independent work, which is the kind of task that can benefit from parallel execution on multiple cores.
- `reference/Chapter09/NumberOfAvailableProcessors.kt` reminds you to size CPU parallelism around hardware limits.
- `reference/Chapter09/Lock.kt` shows manual synchronization with `wait()` and `notify()`, which is powerful but easy to misuse.
- `reference/Chapter10/actors/Actors.kt` shows actor-style state ownership to avoid racy shared mutation.

## Core rules

- Prefer sequential code first. Parallelize only when the work is heavy and independent.
- Bound parallelism. Task count is not the same thing as safe thread count.
- Do not call something "faster" if it introduces races or incorrect shared state.
- Prefer state ownership and message passing over broad shared mutable state.
- Coroutines are a coordination model, not automatic speed.

## What to look for in parallel work

- Is the work CPU-bound, I/O-bound, or mostly waiting?
- Are tasks independent, or do they serialize on shared state anyway?
- Is there a bounded dispatcher or thread pool?
- Does the code accumulate results in a thread-safe or ownership-safe way?
- Is cancellation defined, or do orphaned jobs keep running?

## Important caution from the local sources

`Bakery.fastOrder()` adds results to a shared `MutableList` from multiple threads. That is a useful reminder: a benchmark that ignores thread safety can suggest a speedup that is not valid for production code.

Treat correctness as part of performance engineering:

- unsafe shared writes invalidate the result
- lock contention can erase theoretical gains
- retry storms, fan-out, or unbounded launch patterns can make the system slower

## Coroutines

Use coroutines when they simplify structured concurrency, async composition, or bounded parallel work.

Do not use coroutines just to wrap trivial CPU work. Each `async`, channel send, or context hop adds overhead. For CPU-bound work:

- keep parallelism bounded
- respect available processors
- avoid crossing reactive and coroutine boundaries unless integration requires it

## Actors and owned state

The actor example in `reference/Chapter10/actors/Actors.kt` shows a safer pattern for shared counters and serialized state mutation:

- one owner of mutable state
- messages instead of free-for-all writes
- predictable contention behavior

Prefer this style when:

- multiple workers need to update shared state
- lock contention or race risk is otherwise high
- throughput matters more than unrestricted direct mutation

## Manual synchronization

`wait()` and `notify()` work, but they are low-level and brittle. Prefer higher-level primitives unless the lower-level control is necessary and measured.

If you use locks or coordination primitives:

- document the ownership model
- keep critical sections minimal
- avoid blocking calls while holding locks
- measure contention, not just raw happy-path latency

## Version note

The local examples use `kotlinx.coroutines.experimental`, which is obsolete. Keep the performance principles, but translate the API usage to modern coroutines libraries and structured concurrency patterns.
