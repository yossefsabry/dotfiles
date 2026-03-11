# Collections And Pipelines

## Goal

Choose between loops, eager collection operators, and sequences based on workload shape instead of habit.

## What the local sources show

- `reference/Chapter05/Benchmarks.kt` compares iterator-based traversal, a custom while-based traversal, eager list pipelines, and sequence pipelines.
- `reference/Chapter05/CollectionsEx.kt` shows a custom inline `while` loop used to reduce iterator overhead in tight traversal.
- `reference/Chapter08/Benchmarks1.kt` compares direct looping over ranges and arrays with sequence-based iteration.
- `reference/Chapter08/Benchmarks2.kt` compares eager `map().first(...)` against sequence-based lazy processing where early termination can matter.
- `reference/Chapter08/Benchmarks3.kt` shows that even tiny repeated constructs such as reusable ranges or state setup should be measured instead of guessed about.

## Decision rules

### Use a plain loop when

- the code is a measured hot path
- you only need a simple traversal or aggregation
- avoiding iterator or intermediate object overhead matters
- the optimized version is still readable enough for the team

### Use eager collection operators when

- clarity is more important than micro-optimization
- the result needs to be fully materialized anyway
- the input size is modest or the path is not hot

### Use `Sequence` when

- the pipeline has multiple stages and would otherwise allocate intermediate collections
- the data set is large enough for laziness to matter
- the computation can terminate early with `first`, `take`, `any`, or similar

### Avoid `Sequence` when

- the pipeline is short and processes everything anyway
- the path is small enough that sequence overhead dominates
- the code becomes harder to reason about without a measured gain

## Practical rules

- Do not convert every collection pipeline to `asSequence()` by default.
- Do not replace every collection operator with manual indexing unless measurement justifies it.
- Do not use index-based traversal on non-random-access collections just because it won one benchmark on an array-backed list.
- Prefer removing whole stages of work over shaving nanoseconds off a stage you still do not need.
- If you hand-optimize a loop, keep the scope tight and document why it exists.

## Inline and higher-order functions

The local sources in Chapter 04, Chapter 05, and Chapter 10 show that higher-order abstractions are useful but not free in every context.

- Inline helpers can reduce call overhead in small hot abstractions.
- Crossinline or lambda-heavy APIs are fine until measurement says they are the bottleneck.
- Keep specialized traversal helpers narrow; broad custom collection frameworks often cost more maintenance than they save.

## Review questions

- Is this path hot enough to justify avoiding standard collection operators?
- Does `Sequence` actually remove work here, or just add indirection?
- Are we creating intermediate lists that are immediately discarded?
- Would a direct loop make the critical path simpler and cheaper?
- Are repeated constants or ranges recreated inside an inner loop?

## Default stance

Start with readable Kotlin collections code. Move to sequences for lazy, multi-stage, or short-circuiting workloads. Move to manual loops only for measured hotspots.
