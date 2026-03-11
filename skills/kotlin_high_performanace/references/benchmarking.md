# Benchmarking Kotlin/JVM Code

## Goal

Measure before optimizing. A performance claim without a reproducible measurement is speculation.

## What the local sources show

- `reference/Chapter02/benchmarking/example1/MyBenchmark.java` shows the minimal JMH benchmark shape.
- `reference/Chapter02/benchmarking/example2/MyBenchmark.java` and `example6/MyBenchmark.java` show benchmark state and returning observable results.
- `reference/Chapter02/benchmarking/example3/MyBenchmark.java` contrasts measuring real state mutation with measuring throwaway local work.
- `reference/Chapter02/benchmarking/example4/MyBenchmark.java` shows how helper loops and `@OperationsPerInvocation` can mislead if they no longer resemble the real workload.
- `reference/Chapter02/benchmarking/example5/MyBenchmark.java` shows baseline comparison and `Blackhole` usage to keep work visible.
- `reference/Chapter08/Benchmarks1.kt` uses `Blackhole` to consume loop values instead of letting work disappear.
- `reference/Chapter08/Benchmarks3.kt` uses JMH `@State` to separate benchmark state from the measured method.
- `reference/Chapter05/Benchmarks.kt`, `reference/Chapter08/Benchmarks2.kt`, and `reference/Chapter09/Benchmarks.kt` compare alternative implementations under the same framework.
- `reference/README.md` documents the Maven flow for packaging and running the benchmark jar.

## Practical rules

- Use JMH for microbenchmarks. It handles warmup, forking, and repeatability better than ad hoc timers.
- Use simple wall-clock timers only for coarse smoke checks or end-to-end flows.
- Benchmark realistic alternatives side by side under the same inputs.
- Keep setup outside the measured body when possible.
- Consume results so dead-code elimination does not fake a speedup.
- Return or consume the real computed value; do not benchmark local throwaway work that an optimizer can erase.
- Avoid `println`, logging, disk I/O, or unrelated allocation inside the measured body unless that overhead is part of the workload you care about.

## Minimum workflow

1. Define the exact question.
   Example: "Is this eager collection pipeline faster or slower than a sequence for this access pattern?"
2. Build two or more implementations that only differ in the behavior you want to compare.
3. Run them under JMH with the same input size and data shape.
4. Inspect both runtime and allocation implications.
5. Keep the faster version only if the gain matters relative to the added complexity.

## What to compare

- simple loops vs collection pipelines
- eager collections vs `asSequence()`
- sequential execution vs bounded parallel execution
- different ownership strategies for shared state
- current code vs proposed optimization

## Anti-patterns

- timing one run and calling it proof
- comparing different input sizes or different work
- benchmarking cold startup when the question is steady-state throughput
- mixing setup cost into only one side of the comparison
- hiding extra work inside helper loops and then "fixing" it with per-invocation math
- benchmarking code whose result is never observed
- claiming an optimization based on a profiler screenshot without a reproducible benchmark

## Hot-path questions to ask

- Is this code called once or millions of times?
- Is the cost CPU, allocation, synchronization, blocking, or I/O?
- Does the pipeline short-circuit early, or does it always process everything?
- Is the benchmark measuring useful work or benchmark scaffolding?

## Notes about the local sources

The local repository uses old Kotlin and JMH versions. The principles still hold:

- prefer reproducible harnesses over manual timing
- isolate state
- consume outputs
- compare equivalent work

Translate the syntax to modern tooling as needed instead of copying the exact build or coroutine versions.
