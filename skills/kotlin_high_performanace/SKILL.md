---
name: kotlin_high_performanace
description: Use when building, reviewing, refactoring, or optimizing Kotlin/JVM applications where throughput, latency, allocation rate, memory use, GC pressure, startup cost, or concurrency efficiency matters. Trigger on requests about hot paths, benchmarks, coroutines, sequences, collections, memory leaks, reducing overhead, or making Kotlin code faster.
---

# Kotlin High Performanace

## Overview

Use this skill for Kotlin/JVM performance work. Favor measurement over intuition, remove work before adding complexity, and treat lower-level loops, sequences, coroutines, and parallelism as conditional tools rather than default upgrades.

This skill is grounded in the local `reference/` material from *Mastering High Performance with Kotlin*. Extract the durable principles from those examples; do not copy their older APIs blindly.

## When to Use

- the user wants to make Kotlin code faster or lighter
- the task involves a hot path, repeated allocation, GC pressure, or memory growth
- the user is comparing loops, collection pipelines, sequences, threads, coroutines, or actors
- the user wants a performance-focused code review of Kotlin/JVM code
- the user is designing a new Kotlin component with explicit performance constraints

Do not use this as general Kotlin style guidance when performance is not part of the problem.

## Workflow

1. Classify the task: new implementation, review, or targeted optimization.
2. Define the budget: latency, throughput, memory use, allocation rate, startup time, or concurrency cost.
3. Measure the current behavior before changing code.
   Open `references/benchmarking.md`.
4. Read only the topic references that match the bottleneck:
   - memory, leaks, allocation churn, object lifetime: `references/memory-and-allocation.md`
   - loops, collections, sequences, intermediate pipelines: `references/collections-and-pipelines.md`
   - coroutines, actors, synchronization, bounded parallelism: `references/concurrency-and-coroutines.md`
   - final review pass: `references/review-checklist.md`
5. Change one thing at a time and keep the correctness model explicit.
6. Re-measure and report the result, including tradeoffs in readability, safety, or maintenance cost.

## Core Rules

- Do not optimize unmeasured code if you can measure it.
- Do not assume the most idiomatic Kotlin version is the fastest in a hot path.
- Do not assume manual loops or lower-level code are faster without evidence.
- Prefer reducing allocations and intermediate work before adding concurrency.
- Use sequences only when laziness or early termination removes meaningful work.
- Use coroutines or parallelism only when the workload is independent enough to repay coordination cost.
- Keep shared mutable state narrow; prefer immutable data or owned state per worker/actor.

## Implementation Mode

When writing new code:

- start with the simplest correct implementation
- identify whether the code is actually on a hot path before specializing it
- specialize only the measured bottleneck
- preserve cancellation, backpressure, and thread-safety when adding concurrency
- keep benchmarks or reproduction steps close to the change

## Review Mode

When reviewing existing code:

- look for unnecessary allocation, copying, boxing, or intermediate collections
- check whether sequence usage is justified by workload shape
- look for accidental blocking, unbounded fan-out, or unsafe shared mutable state
- verify that "fast" code is still correct under contention and cancellation
- ask for measurement evidence if the change claims a performance benefit

Use `references/review-checklist.md` to structure the findings.

## Reference Map

- `references/benchmarking.md`: how to measure Kotlin/JVM code without lying to yourself
- `references/memory-and-allocation.md`: object lifetime, cleanup, leaks, string behavior, immutable keys
- `references/collections-and-pipelines.md`: loops, eager collections, lazy sequences, inline hot-path tradeoffs
- `references/concurrency-and-coroutines.md`: bounded parallelism, actor-style state ownership, synchronization costs
- `references/review-checklist.md`: a concise audit list for performance-oriented Kotlin review

## Output Expectations

If you are implementing:

- state the suspected hot path
- explain why the chosen approach fits the workload
- note what should be measured after the change

If you are reviewing:

- present findings ordered by impact
- separate measured issues from inferred risks
- call out missing benchmarks explicitly

## Local Source Basis

The main source examples in this repository are:

- `reference/Chapter01/*` for memory, cleanup, and string behavior
- `reference/Chapter02/benchmarking/*` and benchmark files in later chapters for measurement patterns
- `reference/Chapter05/*` and `reference/Chapter08/*` for loops, ranges, collections, and sequences
- `reference/Chapter09/*` and `reference/Chapter10/*` for concurrency, actors, and immutability
